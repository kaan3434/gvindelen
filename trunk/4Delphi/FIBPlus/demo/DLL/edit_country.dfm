object frmEditCountry: TfrmEditCountry
  Left = 318
  Top = 204
  BorderStyle = bsDialog
  Caption = 'frmEditCountry'
  ClientHeight = 213
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 176
    Width = 342
    Height = 4
    Shape = bsTopLine
  end
  object Label1: TLabel
    Left = 4
    Top = 4
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 132
    Top = 4
    Width = 32
    Height = 13
    Caption = 'Capital'
  end
  object Label3: TLabel
    Left = 132
    Top = 84
    Width = 50
    Height = 13
    Caption = 'Population'
  end
  object Label4: TLabel
    Left = 4
    Top = 84
    Width = 22
    Height = 13
    Caption = 'Area'
  end
  object Label5: TLabel
    Left = 4
    Top = 44
    Width = 45
    Height = 13
    Caption = 'Continent'
  end
  object btnOK: TButton
    Left = 185
    Top = 183
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object btnCancel: TButton
    Left = 265
    Top = 183
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object DBEdit1: TDBEdit
    Left = 4
    Top = 20
    Width = 121
    Height = 21
    DataField = 'NAME'
    DataSource = dmMain.dsCountry
    TabOrder = 0
  end
  object DBEdit2: TDBEdit
    Left = 132
    Top = 20
    Width = 121
    Height = 21
    DataField = 'CAPITAL'
    DataSource = dmMain.dsCountry
    TabOrder = 1
  end
  object DBEdit3: TDBEdit
    Left = 4
    Top = 60
    Width = 121
    Height = 21
    DataField = 'CONTINENT'
    DataSource = dmMain.dsCountry
    TabOrder = 2
  end
  object DBEdit4: TDBEdit
    Left = 4
    Top = 100
    Width = 121
    Height = 21
    DataField = 'AREA'
    DataSource = dmMain.dsCountry
    TabOrder = 3
  end
  object DBEdit5: TDBEdit
    Left = 132
    Top = 100
    Width = 121
    Height = 21
    DataField = 'POPULATION'
    DataSource = dmMain.dsCountry
    TabOrder = 4
  end
end
