unit GvHtml2Xml;

interface

uses
  NativeXML;


procedure TableHtmlToXML(Html: String; Xml: TXmlNode);

implementation

uses
  SysUtils, StrUtils, GvStr;


procedure TableHtmlToXML(Html: String; Xml: TXmlNode);
var
  tr, td, td2: TXmlNode;
  Row, Cell, AttName, AttValue: String;
  i, r, c, l, AttIndex, ColSpan, RowSpan: Integer;

begin
  // Патчим начало-конец строки
  Html:= ReplaceAll(Html, '</table>', '</tr></table>');
  i:= Pos('</table>', AnsiLowerCase(html));
  if i>0 then
    Html:= Copy(Html, 1, i-1);
  Html:= DeleteAllBE(Html, '<table ', '>');
  Html:= DeleteAll(Html, '<table>');
  Html:= DeleteAll(Html, '</table>');
  Html:= DeleteAllBE(Html, '<tbody ', '>');
  Html:= DeleteAll(Html, '<tbody>');
  Html:= DeleteAll(Html, '</tbody>');
  Html:= ReplaceAll(Html, '</tr></tr>', '</tr>');

  Html:= ReplaceAll(Html, '<tr>', '</tr><tr>');
  Html:= ReplaceAll(Html, '<tr ', '</tr><tr ');
  Html:= ReplaceAll(Html, '</tr></tr>', '</tr>');

  Row:= TakeBE(Html,'<tr', '</tr>');
  While Row<>'' do
  begin
    Row:= ReplaceAll(Row, '<th', '<td');
    Row:= DeleteAllBE(Row, '<tr ', '>');
    Row:= DeleteAll(Row, '<tr>');
    Row:= DeleteAll(Row, '</tr>');
    Row:= DeleteAll(Row, '</th>');
    Row:= DeleteAll(Row, '</td>');
    tr:= Xml.NodeNew('tr');
    Row:= trim(Row);
    while Row<>'' do
    begin
      td:= tr.NodeNew('td');
      Cell:= TakeFront5(Row, '>');
      td.ValueAsString:= TakeFront4(Row, '<');
      Cell:= trim(DeleteAll(Cell, '<td'));
      while Cell<>'' do
      begin
        AttName:= LowerCase(TakeAttName(Cell));
        AttValue:= TakeAttValue(Cell);
        td.WriteAttributeString(AttName, AttValue);
      end;
    end;
    Row:= TakeBE(Html,'<tr', '</tr>');
  end;
  For r:= 0 to Xml.NodeCount-1 do
  begin
    tr:= Xml.Nodes[r];
    For c:= tr.NodeCount-1 downto 0 do
    begin
      td:= tr.Nodes[c];
      ColSpan:= td.ReadAttributeInteger('colspan', 0);
      if ColSpan>1 then
      begin
        AttIndex:= td.AttributeIndexByname('colspan');
        td.AttributeDelete(AttIndex);
        while ColSpan>1 do
        begin
          td2:= tr.NodeNewAtIndex(c+1,'td');
          td2.ValueAsString:= td.ValueAsString;
          For i:= 0 to td.AttributeCount-1 do
          begin
            AttName:= td.AttributeName[i];
            td2.WriteAttributeString(AttName, td.AttributeValue[i]);
          end;
          Dec(ColSpan);
        end;
      end;
    end;
  end;
  For r:= 0 to Xml.NodeCount-1 do
  begin
    tr:= Xml.Nodes[r];
    For c:= 0 to tr.NodeCount-1 do
    begin
      td:= tr.Nodes[c];
      RowSpan:= td.ReadAttributeInteger('rowspan', 0);
      if RowSpan>1 then
      begin
        AttIndex:= td.AttributeIndexByname('rowspan');
        td.AttributeDelete(AttIndex);
        For l:= 1 to RowSpan-1 do
        begin
          if r+l<Xml.NodeCount then
          begin
            td2:= Xml.Nodes[r+l].NodeNewAtIndex(c, 'td');
            td2.ValueAsString:= td.ValueAsString;
            For i:= 0 to td.AttributeCount-1 do
            begin
              AttName:= td.AttributeName[i];
              td2.WriteAttributeString(AttName, td.AttributeValue[i]);
            end;
          end;
        end;
      end;
    end;
  end;
end;



end.
