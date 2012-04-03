object FormMain: TFormMain
  Left = 192
  Top = 114
  Width = 602
  Height = 444
  Caption = 'Backup/Restore Example'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 594
    Height = 39
    Align = alTop
    TabOrder = 0
    object BExit: TButton
      Left = 9
      Top = 8
      Width = 75
      Height = 22
      Caption = 'Exit'
      TabOrder = 0
      OnClick = BExitClick
    end
    object BBackup: TButton
      Left = 100
      Top = 8
      Width = 75
      Height = 22
      Caption = 'Backup'
      TabOrder = 1
      OnClick = BBackupClick
    end
    object BRestore: TButton
      Left = 175
      Top = 8
      Width = 75
      Height = 22
      Caption = 'Restore'
      TabOrder = 2
      OnClick = BRestoreClick
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 39
    Width = 594
    Height = 371
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object BackupService1: TpFIBBackupService
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey')
    LoginPrompt = False
    Verbose = True
    BlockingFactor = 0
    Options = []
    Left = 352
    Top = 8
  end
  object RestoreService1: TpFIBRestoreService
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey')
    LoginPrompt = False
    Verbose = True
    PageSize = 0
    PageBuffers = 0
    Options = [Replace, CreateNewDB]
    Left = 392
    Top = 8
  end
  object OpenDialogBackup: TOpenDialog
    DefaultExt = 'gbk'
    Filter = 'Backup files (*.gbk)|*.gbk|All files (*.*)|*.*'
    Title = 'Open backup file(s)'
    Left = 432
    Top = 8
  end
  object OpenDialogDatabase: TOpenDialog
    DefaultExt = 'gdb'
    Filter = 'Database file (*.gdb)|*.gdb|All files (*.*)|*.*'
    Title = 'Open database file(s)'
    Left = 472
    Top = 8
  end
end
