unit uOttoArticleUpdate;

interface

uses
  Classes, SysUtils, pFIBDatabase;

procedure OttoUpdateArticle(aArticleCode: string; aTransaction: TpFIBTransaction);

implementation

uses
  udmOtto, IdHTTP, NativeXml, GvFile, GvStr, pFIBStoredProc, pFIBQuery,
  FIBQuery;

procedure UpdateArticle(ArticleCodeId: Integer; ndArticle: TXmlNode);
var
  id, i: Integer;
  attr_name, attr_value: String;

begin
  with dmOtto.spTemp do
  begin
    StoredProcName:= 'ARTICLE_GOC';
    Params.ClearValues;
    ParamByName('I_ARTICLECODE_ID').AsInteger:= ArticleCodeId;
    ParamByName('I_DIMENSION').AsString:= ndArticle.ReadAttributeString('dimension');
    try
      ExecProc;
      id:= ParamValue('O_ARTICLE_ID');
      for i:= 0 to ndArticle.AttributeCount - 1 do
      begin
        StoredProcName:= 'ATTR_PUT';
        Params.ClearValues;
        ParamByName('I_OBJECT_SIGN').AsString:= 'ARTICLE';
        ParamByName('I_OBJECT_ID').AsInteger:= id;
        attr_name:= ndArticle.AttributeName[i];
        ParamByName('I_ATTR_SIGN').AsString:= attr_name;
        attr_value:= ndArticle.AttributeValue[i];
        ParamByName('I_ATTR_VALUE').AsString:= attr_value;
        ExecProc;
      end;
    except
      raise;
    end;
  end;
end;

procedure UpdateArticleCode(ArticleSignId: Integer; ndArticleCode: TXmlNode);
var
  id, i: Integer;
begin
  id:= 0;
  with dmOtto.spTemp do
  begin
    StoredProcName:= 'ARTICLECODE_GOC';
    Params.ClearValues;
    ParamByName('I_ARTICLESIGN_ID').AsInteger:= ArticleSignId;
    ParamByName('I_ARTICLE_CODE').AsString:= ndArticleCode.ReadAttributeString('article_code');
    try
      ExecProc;
      id:= ParamValue('O_ARTICLECODE_ID');
      for i:= 0 to ndArticleCode.AttributeCount - 1 do
      begin
        StoredProcName:= 'ATTR_PUT';
        Params.ClearValues;
        ParamByName('I_OBJECT_SIGN').AsString:= 'ARTICLECODE';
        ParamByName('I_OBJECT_ID').AsInteger:= id;
        ParamByName('I_ATTR_SIGN').AsString:= ndArticleCode.AttributeName[i];
        ParamByName('I_ATTR_VALUE').AsString:= ndArticleCode.AttributeValue[i];
        ExecProc;
      end;
    except
      raise;
    end;
  end;
  if id > 0 then
    for i:= 0 to ndArticleCode.NodeCount - 1 do
      UpdateArticle(id, ndArticleCode.Nodes[i]);
end;

procedure UpdateArticleSign(ndArticleSign: TXmlNode);
var
  id, i: Integer;
  v: variant;
begin
  id:= 0;
  with dmOtto.spTemp do
  begin
    StoredProcName:= 'ARTICLESIGN_GOC';
    Params.ClearValues;
    ParamByName('I_SKU').AsString:= ndArticleSign.ReadAttributeString('sku');
    try
      ExecProc;
      id:= ParamValue('O_ARTICLESIGN_ID');
    except
      raise;
    end;
  end;
  if id > 0 then
    for i:= 0 to ndArticleSign.NodeCount - 1 do
      UpdateArticleCode(id, ndArticleSign.Nodes[i]);
end;

procedure OttoUpdateArticle(aArticleCode: string; aTransaction: TpFIBTransaction);
var
  Http: TIdHTTP;
  Xml: TNativeXml;
  St: string;
  nl: TXmlNodeList;
begin
  Http:= TIdHTTP.Create;
  Xml:= TNativeXml.CreateName('ArticleSign');
  try
    aTransaction.StartTransaction;
    try
      repeat
//        St:= LoadFileAsString('article.xml');
        St:= Http.Get('http://otto.by/otto_get_article.php?article_code='+aArticleCode);
        SaveStringAsFile(St, 'article.xml');
        St:= CopyBE(St, '<ArticleSign ', '</ArticleSign>');
      until St <> '';
      Xml.ReadFromString(St);
      UpdateArticleSign(Xml.Root);
      aTransaction.Commit;
    except
      aTransaction.Rollback;
    end;
  finally
    Xml.Free;
    Http.Free;
  end;

end;

end.
