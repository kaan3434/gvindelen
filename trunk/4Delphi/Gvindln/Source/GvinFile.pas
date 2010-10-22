unit GvinFile;

interface

uses
  Windows, Classes, Controls, ComCtrls;

procedure ListFileName(List: TStringList; FileMask: String;
                       Recurce: Boolean; StatusBar: TStatusBar = nil);

procedure ListDirName(List: TStringList; DirMask: String;
                      Recurce: Integer=-1; StatusBar: TStatusBar = nil);

function FolderSize(FileMask: String;
                    Recurce: Boolean; StatusBar: TStatusBar = nil): Integer;

function ExtractFileNameOnly(FileName: String): String;

function UniqueFileName(NameMask,Ext: String): String;

function CopyFile(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar=nil;
  IgnoreCopyOnError: Boolean=false): Boolean;

function CopyFiles(const FileMask, DestPath: String;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar=nil;
  IgnoreCopyOnError: Boolean=false): Boolean;

function CopyFileIfNotExists(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar = nil;
  IgnoreCopyOnError: Boolean=false): Boolean;

function CopyFileIfExists(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar = nil;
  IgnoreCopyOnError: Boolean=false; ElseName: String=''): Boolean;

function CopyFileIfDestOlder(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar = nil): Boolean;

function MoveFile(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar = nil): Boolean;

function DeleteFiles(FileMask: string): Boolean;

function ForceDirectories(Dir: string): Boolean;

procedure PackDirs(Dir: string);

function ProjectIniFileName: String;

Function GetUserFromWindows: string;

function GetComputerNetName: string;

function NetFileExists(FileName: String): boolean;

function NetFileAge(FileName: String): Integer;

function LoadFileAsString(FileName: String): String;

function SaveStringAsFile(St, FileName: String; AppendMode:Boolean=false): Boolean;

procedure CopyFileDate(DestFileName, SourceFileName: string;
  DeltaTimeSec: integer=0; ElseSourceFileName: String='');

procedure SetFileAge(FileName: string; DateTime: TDateTime);

function ReadIniSection(IniFileName, SectionName: String;
  Notes: Boolean=false; BlankRow: Boolean=false): String;


implementation

uses
  GvinStr, SysUtils, Dialogs, Consts, FileCtrl, DateUtils;

function FileCopyEx(const FileName, DestName: string;
  OverwriteReadOnly: Boolean; ProgressControl: TProgressBar;
  IgnoreCopyOnError: boolean = false): Boolean;
var
  CopyBuffer: Pointer;
  Source, Dest: Integer;
  Destination: TFileName;
  FSize, BytesCopied, TotalCopied: Longint;
  Attr: Integer;
  mrResult: Word;
const
  ChunkSize: Longint = 8192;
begin
  result:= false;
  Destination := DestName;
  if LastChar(Destination)='\' then
    Destination := Destination + ExtractFileName(FileName);
  GetMem(CopyBuffer, ChunkSize);
  try
    TotalCopied := 0;
    repeat
      Source := FileOpen(FileName, fmShareDenyNone);
      if Source < 0 then
      begin
        mrResult:= MessageDlg(Format('File open error or using another user %s',[FileName]),
          mtError, [mbRetry,mbAbort],0);
        if mrResult=mrAbort then
          raise EFOpenError.CreateFmt('File open error or using another user %s', [FileName]);
      end
    until Source>0;
    FSize := FileSeek(Source, 0, 2);
    FileSeek(Source, 0, 0);
    try
      if ProgressControl <> nil then
      begin
        ProgressControl.Max:= FSize;
        ProgressControl.Min:= 0;
        ProgressControl.Position:= 0;
      end;
      ForceDirectories(ExtractFilePath(Destination));
      if OverwriteReadOnly then begin
        Attr := FileGetAttr(Destination);
        if (Attr >= 0) and ((Attr and faReadOnly) <> 0) then
          FileSetAttr(Destination, Attr and not faReadOnly);
      end;
      repeat
        Dest := FileCreate(Destination);
        if Dest < 0 then
        begin
          if IgnoreCopyOnError then Exit;
          mrResult:= MessageDlg(Format('Can''t create file %s',[Destination]),
                     mtWarning, [mbRetry,mbAbort,mbIgnore],0);
          if mrResult=mrAbort then
            raise EFCreateError.CreateFmt('Can''t create file %s', [Destination])
          else
          if mrResult=mrIgnore then Exit;
        end;
      until Dest>0;
      try
        repeat
          BytesCopied := FileRead(Source, CopyBuffer^, ChunkSize);
          if BytesCopied = -1 then
            raise EReadError.Create('Can''t read data from file');
          TotalCopied := TotalCopied + BytesCopied;
          if BytesCopied > 0 then begin
            if FileWrite(Dest, CopyBuffer^, BytesCopied) = -1 then
              raise EWriteError.Create('Can''t write data to file');
          end;
          if (ProgressControl <> nil) and (FSize>0) then
            ProgressControl.Position:= TotalCopied;
        until BytesCopied < ChunkSize;
        FileSetDate(Dest, FileGetDate(Source));
        result:= true;
      finally
        FileClose(Dest);
      end;
    finally
      FileClose(Source);
    end;
  finally
    FreeMem(CopyBuffer, ChunkSize);
    if ProgressControl <> nil then
      ProgressControl.Position:= 0;
  end;
end;

procedure SetFileAge(FileName: string; DateTime: TDateTime);
var
  Dest: Integer;
begin
  Dest:= FileOpen(FileName, fmOpenReadWrite);
  FileSetDate(Dest, DateTimeToFileDate(DateTime));
  FileClose(Dest);
end;

procedure CopyFileDate(DestFileName, SourceFileName: string;
  DeltaTimeSec: integer=0; ElseSourceFileName: String='');
var
  FileDateTime: TDateTime;
  Age: Integer;
begin
  Age:= FileAge(SourceFileName);
  if Age<0 then
    Age:= FileAge(ElseSourceFileName);
  if Age>=0 then
  begin
    FileDateTime:= FileDateToDateTime(Age);
    SetFileAge(DestFileName, IncSecond(FileDateTime, DeltaTimeSec));
  end;
end;



function CopyFile(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar=nil;
  IgnoreCopyOnError: Boolean=false): Boolean;
var
  OldStatusBarText: String;
  OldPBMax, OldPBPos: Integer;
  OldSimplePanel: Boolean;
begin
  if StatusBar<>nil then
  begin
    OldStatusBarText:= StatusBar.SimpleText;
    OldSimplePanel:= StatusBar.SimplePanel;
    StatusBar.SimplePanel:= true;
    StatusBar.SimpleText:= Format('Copying file %s to %s',[FileName,DestName]);
    StatusBar.Refresh;
  end;
  if ProgressControl<>nil then
  begin
    OldPBMax:= ProgressControl.Max;
    OldPBPos:= ProgressControl.Position;
  end;
  try
    result:= FileCopyEx(FileName, DestName, False, ProgressControl, IgnoreCopyOnError);
  finally
    if ProgressControl<>nil then
    begin
      ProgressControl.Max:= OldPBMax;
      ProgressControl.Position:= OldPBPos;
    end;
    if StatusBar<>nil then
    begin
      StatusBar.SimpleText:= OldStatusBarText;
      StatusBar.SimplePanel:= OldSimplePanel;
    end;
  end;
end;

function CopyFiles(const FileMask, DestPath: String;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar=nil;
  IgnoreCopyOnError: Boolean=false): Boolean;
var
  sl: TStringList;
  i: Integer;
begin
  sl:= TStringList.Create;
  ListFileName(sl, FileMask, false);
  for i:= 0 to sl.Count-1 do
    CopyFile(sl[i], DestPath, ProgressControl, StatusBar, IgnoreCopyOnError);
  sl.Free;
end;

function CopyFileIfNotExists(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar = nil;
  IgnoreCopyOnError: Boolean=false): Boolean;
begin
  result:= Not NetFileExists(DestName);
  if result then
    result:= CopyFile(FileName, DestName, ProgressControl, StatusBar);
end;

function CopyFileIfExists(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar = nil;
  IgnoreCopyOnError: Boolean=false; ElseName: String=''): Boolean;
begin
  result:= NetFileExists(FileName);
  if result then
    result:= CopyFile(FileName, DestName, ProgressControl, StatusBar, IgnoreCopyOnError)
  else if ElseName<>'' then
    result:= CopyFileIfExists(ElseName, DestName, ProgressControl, StatusBar, IgnoreCopyOnError);
end;

function CopyFileIfDestOlder(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar = nil): Boolean;
begin
  if NetFileAge(DestName) < NetFileAge(FileName) then
    result:= CopyFile(FileName, DestName, ProgressControl, StatusBar);
end;

function MoveFile(const FileName, DestName: string;
  ProgressControl: TProgressBar=nil; StatusBar: TStatusBar = nil): Boolean;
var
  OldStatusBarText: String;
  OldPBMax, OldPBPos: Integer;
begin
  if StatusBar<>nil then
  begin
    OldStatusBarText:= StatusBar.SimpleText;
    StatusBar.SimpleText:= Format('Moving file %s to %s',[FileName,DestName]);
  end;
  if ProgressControl<>nil then
  begin
    OldPBMax:= ProgressControl.Max;
    OldPBPos:= ProgressControl.Position;
  end;
  try
    result:= FileCopyEx(FileName, DestName, False, ProgressControl);
    if result then DeleteFile(FileName);
  finally
    if ProgressControl<>nil then
    begin
      ProgressControl.Max:= OldPBMax;
      ProgressControl.Position:= OldPBPos;
    end;
    if StatusBar<>nil then
      StatusBar.SimpleText:= OldStatusBarText;
  end;
end;

procedure ListFileName(List: TStringList; FileMask: String;
                       Recurce: Boolean; StatusBar: TStatusBar = nil);
var
  SearchRec: TSearchRec;
  FPath: String;
begin
  FPath:= ExtractFileDir(FileMask);
  FileMask:= ExtractFileName(FileMask);
  if FPath = '' then FPath:= GetCurrentDir;
  if StatusBar<>nil then StatusBar.SimpleText:= FPath;
  if LastChar(FPath) <> '\' then FPath:= FPath+'\';
  if Recurce then
  begin
    if FindFirst(FPath+'*.*', faDirectory, SearchRec) = 0 then
    repeat
      if FirstChar(SearchRec.Name) <> '.' then
      begin
        if Assigned(StatusBar) then StatusBar.SimpleText:= FPath+SearchRec.Name;
        ListFileName(List, FPath+SearchRec.Name+'\'+FileMask, Recurce, StatusBar);
      end;
    until FindNext(SearchRec) <> 0;
  end;
  if FindFirst(FPath+FileMask, faArchive+faReadOnly+faHidden, SearchRec) = 0 then
  repeat
    if FirstChar(SearchRec.Name) <> '.' then
      List.Add(FPath+SearchRec.Name);
  until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);
end;

procedure ListDirName(List: TStringList; DirMask: String;
                      Recurce: Integer=-1; StatusBar: TStatusBar = nil);
var
  SearchRec: TSearchRec;
begin
  if DirMask = '' then DirMask:= GetCurrentDir;
  if LastChar(DirMask) <> '\' then DirMask:= DirMask+'\';
  if FindFirst(DirMask+'*.*', faDirectory, SearchRec) = 0 then
  repeat
    if (FirstChar(SearchRec.Name) <> '.') and
      (FileGetAttr(DirMask+SearchRec.Name) and faDirectory <> 0) then
    begin
      List.Add(DirMask+SearchRec.Name);
      if Assigned(StatusBar) then StatusBar.SimpleText:= DirMask+SearchRec.Name;
      if Recurce>0 then
        ListDirName(List, DirMask+SearchRec.Name+'\', Recurce-1, StatusBar);
    end;
  until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);
end;

function FolderSize(FileMask: String; Recurce: Boolean;
                    StatusBar: TStatusBar = nil): Integer;
var
  SearchRec : TSearchRec;
  FPath: String;
begin
  Result:=0;
  FPath:= ExtractFileDir(FileMask);
  FileMask:= ExtractFileName(FileMask);
  if FPath = '' then FPath:= GetCurrentDir;
  if StatusBar<>nil then StatusBar.SimpleText:= FPath;
  if LastChar(FPath) <> '\' then FPath:= FPath+'\';
  if Recurce then
  begin
    if FindFirst(FPath+'*.*', faDirectory, SearchRec) = 0 then
    repeat
      if FirstChar(SearchRec.Name) <> '.' then
      begin
        if Assigned(StatusBar) then StatusBar.SimpleText:= FPath+SearchRec.Name;
        Inc(Result, FolderSize(FPath+SearchRec.Name+'\'+FileMask, Recurce, StatusBar));
      end;
    until FindNext(SearchRec) <> 0;
  end;
  if FindFirst(FPath+FileMask, faArchive+faReadOnly+faHidden, SearchRec) = 0 then
  repeat
    if FirstChar(SearchRec.Name) <> '.' then
      Inc(Result, SearchRec.Size);
  until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);
end;

function DeleteFiles(FileMask: string): Boolean;
var
  SearchRec: TSearchRec;
begin
  Result := FindFirst(ExpandFileName(FileMask), faAnyFile, SearchRec) = 0;
  try
    if Result then
      repeat
        if (SearchRec.Name[1] <> '.') and
          (SearchRec.Attr and faVolumeID <> faVolumeID) and
          (SearchRec.Attr and faDirectory <> faDirectory) then
        begin
          Result := DeleteFile(ExtractFilePath(FileMask) + SearchRec.Name);
          if not Result then Break;
        end;
      until FindNext(SearchRec) <> 0;
  finally
    FindClose(SearchRec);
  end;
end;

function UniqueFileName(NameMask, Ext: String): String;
var
  Value: String;
  Pth: String;
begin
  Pth:= ExtractFilePath(NameMask);
  NameMask:= ExtractFileName(NameMask);
  repeat
    Value:= NameMask+Format('%5.5u', [Random(99999)]);
  until Not FileExists(Pth+Value+Ext);
  result:= Pth+Value+Ext;
end;

function ForceDirectories(Dir: string): Boolean;
begin
  result:= true;
  if Dir<>'' then
    result:= FileCtrl.ForceDirectories(Dir);
end;

procedure PackDirs(Dir: string);
var
  dl, fl: TStringList;
  i: integer;
begin
  dl:= TStringList.Create;
  fl:= TstringList.Create;
  ListDirName(dl, Dir, -1);
  for i:= dl.Count-1 downto 0 do
  begin
    fl.Clear;
    ListFileName(fl, dl[i], false);
    if fl.Count=0 then
      RemoveDir(dl[i]);
  end;
  fl.Free;
  dl.Free;
end;

function ExtractFileNameOnly(FileName: String): String;
begin
  Result:= ExtractFileName(FileName);
  TakeLast(Result, Length(ExtractFileExt(Result)));
end;

function ProjectIniFileName: String;
var
  FileName: String;
begin
  FileName:= ExtractFileName(ParamStr(0));
  TakeLast(FileName, Length(ExtractFileExt(FileName)));
  Result:= ExtractFilePath(ParamStr(0))+FileName+'.ini';
end;

Function GetUserFromWindows: string;
Var
  UserName    : string;
  UserNameLen : Dword;
Begin
  UserNameLen := 255;
  SetLength(userName, UserNameLen);
  If GetUserName(PChar(UserName), UserNameLen) Then
    Result := Copy(UserName,1,UserNameLen - 1)
  Else
    Result := 'Unknown';
End;

function GetComputerNetName: string;
var
 buffer: array[0..255] of char;
 size: dword;
begin
 size := 256;
 if GetComputerName(buffer, size) then
   Result := buffer
 else
   Result := ''
end;

function NetFileExists(FileName: String):Boolean;
var
  FileHandle : Integer;
begin
  result:= FileExists(FileName);
  if not result then
  begin
    FileHandle := FileOpen(FileName, fmOpenRead or fmShareDenyNone);
    result:= FileHandle > 0;
    if result then
      FileClose(FileHandle);
  end;
end;

function NetFileAge(FileName: String): Integer;
var
  FileHandle: Integer;
begin
  result:= FileAge(FileName);
  if result=-1 then
  begin
    FileHandle := FileOpen(FileName, fmOpenRead or fmShareDenyNone);
    if FileHandle=-1 then
      result:= -1
    else
    begin
      result:= FileGetDate(FileHandle);
      FileClose(FileHandle);
    end;
  end;
end;

function LoadFileAsString(FileName: String): String;
var
  FileHandle, FSize: Integer;
begin
  result:= '';
  FileHandle:= FileOpen(FileName, fmOpenRead or fmShareDenyNone);
  if FileHandle=-1 then Exit;
  try
    FSize:= FileSeek(FileHandle, 0, 2);
    FileSeek(FileHandle, 0, 0);
    SetLength(result, FSize);
    FileRead(FileHandle, result[1], FSize);
  finally
    FileClose(FileHandle);
  end
end;

function SaveStringAsFile(St, FileName: String; AppendMode:Boolean=false): Boolean;
var
  FileHandle: Integer;
  FLen: Integer;
begin
  if FileExists(FileName) and AppendMode then
  begin
    FileHandle:= FileOpen(FileName, fmOpenReadWrite);
    FileSeek(FileHandle, 0, 2);
  end
  else
    FileHandle:= FileCreate(FileName);
  if FileHandle=-1 then Exit;
  try
    FLen:= Length(St);
    FileWrite(FileHandle, St[1], FLen);
  finally
    FileClose(FileHandle);
  end
end;

function ReadIniSection(IniFileName, SectionName: String;
  Notes: Boolean=false; BlankRow: Boolean=false): String;
var
  sl: TStringList;
  St: String;
  i: Integer;
begin
  result:= '';
  sl:= TStringList.Create;
  try
    sl.LoadFromFile(IniFileName);
    St:= #$D#$A+sl.Text;
    i:= Pos(#$D#$A'['+UpperCase(SectionName)+']', UpperCase(St));
    If i=0 then Exit;
    Delete(St, 1, i+Length(SectionName)+3);
    St:= TrimLeft(St);
    i:= Pos(#$D#$A'[', St);
    if i>0 then
      Delete(St, i+2, Length(St));
    sl.Text:= St;
    For i:= sl.Count-1 downto 0 do
    begin
      St:= trim(sl[i]);
      if St='' then
        if BlankRow then
          continue
        else
          sl.Delete(i)
      else
      if St[1]=';' then
        if Notes then
          continue
        else
          sl.Delete(i);
    end;
    result:= sl.Text;
  finally
    sl.Free;
  end;
end;

end.
