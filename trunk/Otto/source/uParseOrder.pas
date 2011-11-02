unit uParseOrder;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ParseFileOrder(aFileName: string; ndOrder: TXmlNode; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, pFIBStoredProc, Variants, GvNativeXml,
  Dialogs, Controls;

function ToFloat(aStr: string): Double;
begin
  if DecimalSeparator = ',' then
    result:= StrToFloat(ReplaceAll(aStr, '.', DecimalSeparator))
  else
    result:= StrToFloat(ReplaceAll(aStr, ',', DecimalSeparator));
end;


procedure ParseOrderHeaderXml(aLine: string; ndOrder: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  strStream: TStringStream;
  St: string;
  ndClient, ndAdress, ndPlace: TXmlNode;
begin
  sl:= TStringList.Create;
  ndAdress:= ndOrder.NodeFindOrCreate('ADRESS');
  ndClient:= ndOrder.NodeFindOrCreate('CLIENT');
  ndPlace:= ndAdress.NodeFindOrCreate('PLACE');

  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    st:= UpCaseFirst(EscapeString(sl[0]));
    SetXmlAttr(ndClient, 'LAST_NAME', st);
    st:= UpCaseFirst(EscapeString(sl[1]));
    SetXmlAttr(ndClient, 'FIRST_NAME', st);
    st:= UpCaseFirst(EscapeString(sl[2]));
    SetXmlAttr(ndClient, 'MID_NAME', st);
    SetXmlAttr(ndClient, 'EMAIL', EscapeString(sl[3]));
    SetXmlAttr(ndClient, 'STATIC_PHONE', EscapeString(DeleteChars(sl[11], ' -()')));
    SetXmlAttr(ndClient, 'MOBILE_PHONE', EscapeString(DeleteChars(sl[13]+sl[12], ' -()')));

    if WordCount(sl[4]) = 1 then
    begin
      SetXmlAttr(ndAdress, 'STREETTYPE_NAME', 'ул');
      SetXmlAttr(ndAdress, 'STREET_NAME', UpCaseFirst(EscapeString(sl[4])));
    end
    else
    begin
      St:= sl[4];
      SetXmlAttr(ndAdress, 'STREETTYPE_NAME',TakeFront5(st));
      SetXmlAttr(ndAdress, 'STREET_NAME', UpCaseFirst(EscapeString(st)));
    end;
    SetXmlAttr(ndAdress, 'HOUSE', EscapeString(sl[5]));
    SetXmlAttr(ndAdress, 'BUILDING', EscapeString(sl[6]));
    SetXmlAttr(ndAdress, 'FLAT', EscapeString(sl[7]));
    SetXmlAttr(ndAdress, 'POSTINDEX', EscapeString(sl[8]));

    if WordCount(sl[9]) = 1 then
    begin
      SetXmlAttr(ndPlace, 'PLACETYPE_NAME', 'г');
      SetXmlAttr(ndPlace, 'PLACE_NAME', UpCaseFirst(EscapeString(sl[9])));
    end
    else
    begin
      St:= sl[9];
      SetXmlAttr(ndPlace, 'PLACETYPE_NAME', takefront5(st));
      SetXmlAttr(ndPlace, 'PLACE_NAME', UpCaseFirst(EscapeString(st)));
    end;

    // разбираем ќбласть, район
    if WordCount(sl[10]) = 2 then
    begin
      SetXmlAttr(ndPlace, 'REGION_NAME', UpCaseFirst(EscapeString(sl[10])));
      SetXmlAttr(ndPlace, 'AREA_NAME', UpCaseFirst(EscapeString(sl[10])));
    end
    else
    if WordCount(sl[10]) = 1 then
    begin
      SetXmlAttr(ndPlace, 'REGION_NAME', UpCaseFirst(EscapeString(sl[10])));
    end;
    SetXmlAttr(ndOrder, 'PRODUCT_NAME', EscapeString(sl[14]));
  finally
    sl.Free;
  end;
end;

procedure ParseOrderItemXml(aLine: string; ndOrderItems: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  st: string;
  strStream: TStringStream;
  OrderItemId: Integer;
  ndOrderItem: TXmlNode;
  CatalogId, CatalogName, MagazineId: variant;
  ArticleCode, ArticleCodeId, ArticleId: Variant;
  ndMagazine: TXmlNode;
  StatusId: Integer;

function CatalogDetect(aCatalogName: string): Variant;
begin
  Result:= aTransaction.DefaultDatabase.QueryValue(
      'select catalog_id from catalogs where upper(catalog_name)=upper(:catalog_name)',
      0, [aCatalogName]);
end;

function MagazineDetect(aCatalogId: Integer): variant;
begin
  Result:= aTransaction.DefaultDatabase.QueryValue(
      'select first 1 magazine_id from magazines '+
      'where catalog_id = :catalog_id '+
      ' and valid_date > current_date '+
      'order by valid_date', 0,
      [aCatalogId]);
end;

begin
  sl:= TStringList.Create;
  ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    st:= FilterString(sl[1], '0123456789');
    if st='' then
      CatalogId:= CatalogDetect('Internet');
    SetXmlAttr(ndOrderItem, 'PAGE_NO', st);
    st:= FilterString(sl[2], '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    SetXmlAttr(ndOrderItem, 'POSITION_SIGN', st);
    st:= FilterString(UpperCase(sl[3]), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    SetXmlAttr(ndOrderItem, 'ARTICLE_CODE', st);
    st:= FilterString(UpperCase(sl[4]), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    SetXmlAttr(ndOrderItem, 'DIMENSION', st);
    SetXmlAttr(ndOrderItem, 'PRICE_EUR', ToFloat(EscapeString(sl[5])));
    st:= sl[6];
    SetXmlAttr(ndOrderItem, 'NAME_RUS', EscapeString(TakeFront5(st)));
    SetXmlAttr(ndOrderItem, 'KIND_RUS', EscapeString(st));

    // Validate OrderItem

    if VarIsNull(CatalogId) then
    begin
      CatalogName:= sl[0];
      // пытаемс€ определить группу каталогов по имени
      CatalogId:= CatalogDetect(CatalogName);
      if VarIsNull(CatalogId) then
      begin
        // пытаемс€ пропустить им€ группы каталогов через перекодировщик
        CatalogName:= aTransaction.DefaultDatabase.QueryValue(
          'select recoded_value from recodes '+
          'where object_sign=:ObjectSign and attr_sign=:AttrSign and original_value=:OriginalValue',
          0, ['CATALOG', 'NAME', CatalogName]);
        if VarIsNull(CatalogName) then
          CatalogId:= CatalogDetect('Internet')
        else
          CatalogId:= CatalogDetect(CatalogName);
      end;
    end;
    // »щем действующий каталог
    MagazineId:= MagazineDetect(CatalogId);
    if VarIsNull(MagazineId) then
    begin
      MagazineId:= MagazineDetect(CatalogDetect('Internet'));
    end;
    SetXmlAttr(ndOrderItem, 'MAGAZINE_ID', MagazineId);
    ndMagazine:= ndOrderItem.NodeFindOrCreate('MAGAZINE');
    dmOtto.MagazineRead(ndMagazine, MagazineId, aTransaction);

    // »щем артикул

    ArticleCode:= GetXmlAttrValue(ndOrderItem, 'ARTICLE_CODE');
    ArticleId:= null;
    if GetXmlAttrValue(ndMagazine, 'STATUS_SIGN') = 'LOADED' then
    begin
      ArticleCodeId:= aTransaction.DefaultDatabase.QueryValue(
        'select articlecode_id from articlecodes where article_code = :article_code',
        0, [ArticleCode], aTransaction);
      if ArticleCodeId = null then
      begin
        MagazineId:= MagazineDetect(CatalogDetect('Internet'));
        SetXmlAttr(ndOrderItem, 'MAGAZINE_ID', MagazineId);
        ndMagazine.AttributesClear;
        dmOtto.MagazineRead(ndMagazine, MagazineId, aTransaction);
      end
      else
      begin
        ArticleId:= aTransaction.DefaultDatabase.QueryValue(
          'select article_id from articles '+
          'where articlecode_id = :articlecode_id and dimension = :dimension',
          0, [ArticleCodeId, GetXmlAttrValue(ndOrderItem, 'DIMENSION')],
          aTransaction);
      end;
      if ArticleId = null then
        SetXmlAttr(ndOrderItem, 'STATUS_ID', dmOtto.GetStatusBySign(ndOrderItem, 'ERROR'))
      else
      begin
        SetXmlAttr(ndOrderItem, 'ARTICLE_ID', ArticleId);
        SetXmlAttr(ndOrderItem, 'STATUS_ID', dmOtto.GetStatusBySign(ndOrderItem, 'NEW'));
      end
    end
    else
    begin
      if ArticleId = null then
        ArticleId:= dmOtto.ArticleGoC(MagazineId, ArticleCode,
          GetXmlAttrValue(ndOrderItem, 'DIMENSION'),
          GetXmlAttrValue(ndOrderItem, 'PRICE_EUR'), null,
          GetXmlAttrValue(ndOrderItem, 'NAME_RUS'), '', aTransaction);
      SetXmlAttr(ndOrderItem, 'ARTICLE_ID', ArticleId);
      SetXmlAttr(ndOrderItem, 'STATUS_ID', dmOtto.GetStatusBySign(ndOrderItem, 'NEW'));
    end;
  finally
    sl.Free;
  end;
end;

procedure ParseFileOrder(aFileName: string; ndOrder: TXmlNode; aTransaction: TpFIBTransaction);
var
  Lines: TStringList;
  i: Integer;
  ndOrderItems: TXmlNode;
begin
  // загружаем файл
  Lines:= TStringList.Create;
  try
    Lines.LoadFromFile(aFileName);
    ParseOrderHeaderXml(Lines[0], ndOrder, aTransaction);
    ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');
    for i:= 1 to lines.count-1 do
      ParseOrderItemXml(Lines[i], ndOrderItems, aTransaction);
  finally
    Lines.Free;
  end;
end;

end.
