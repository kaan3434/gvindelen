unit uParseMagazine;

interface

uses
  Classes, NativeXml, JvProgressDialog, udmOtto, pFIBDatabase;

procedure ParseArticles(aTransaction: TpFIBTransaction; aLines: TStringList; ndMagazine: TXmlNode);

implementation

uses
  GvNativeXml, GvStr, SysUtils, pFIBStoredProc, Dialogs, Controls;

procedure ParseLine(aTransaction: TpFIBTransaction; aLine: string; ndMagazine: TXmlNode);
var
  sl: TStringList;
  ndArticles, ndArticle: TXmlNode;
  ndArticleCodes, ndArticleCode: TXmlNode;
  ArticleCode: string;
begin
  sl:= TStringList.Create;
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, #$09, '";"')+'"';

    ArticleCode:= aTransaction.DefaultDatabase.QueryValue(
      'INSERT INTO TMP_OTTO_ARTICLE (MAGAZINE_ID, ARTICLE_CODE, DIMENSION, PRICE_EUR, WEIGHT, DESCRIPTION) '+
      'VALUES (:MAGAZINE_ID, :ARTICLE_CODE, :DIMENSION, :PRICE_EUR, :WEIGHT, :DESCRIPTION) '+
      'RETURNING ARTICLE_CODE',
      0, [GetXmlAttrValue(ndMagazine, 'ID'),
          UnEscapeString(sl[0]+sl[1]),
          UnEscapeString(sl[2]),
          ToFloat(sl[3]),
          UnEscapeString(sl[9]),
          UnEscapeString(trim(sl[8]))], aTransaction);
  finally
    sl.Free;
  end;
end;

procedure ParseArticles(aTransaction: TpFIBTransaction; aLines: TStringList; ndMagazine: TXmlNode);
var
  i: Integer;
  aProgress: TJvProgressDialog;
begin
  aProgress:= TJvProgressDialog.Create(nil);
  try
    aProgress.InitValues(0, aLines.Count, 200, 0, 'Импорт каталога', '');
    aProgress.ShowCancel := False;
    aProgress.Show;
    for i:= 0 to aLines.Count - 1 do
    begin
      try
        ParseLine(aTransaction, aLines[i], ndMagazine);
      except
        on E: Exception do
          if MessageDlg(Format('Ошибка импорта на %u-й строке', [i]), mtWarning, mbAbortIgnore, 0) = mrAbort then
            raise;
      end;
      if i mod 10 = 0 then
      begin
        aProgress.Position:= i;
        aProgress.Text:= Format('Чтение файла %u/%u', [i, aLines.count]);
      end;
    end;
    aProgress.Hide;
  finally
    aProgress.Free;
  end;
end;

end.
