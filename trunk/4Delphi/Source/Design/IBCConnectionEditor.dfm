inherited IBCConnectionEditorForm: TIBCConnectionEditorForm
  Caption = 'IBCConnectionEditorForm'
  ClientHeight = 311
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnPanel: TPanel
    Top = 270
  end
  inherited PageControl: TPageControl
    Height = 262
    inherited shConnect: TTabSheet
      inherited shRed: TShape
        Top = 205
      end
      inherited shYellow: TShape
        Top = 205
      end
      inherited shGreen: TShape
        Top = 205
      end
      inherited Panel: TPanel
        Height = 180
        object lbDatabase: TLabel [3]
          Left = 16
          Top = 152
          Width = 46
          Height = 13
          Caption = 'Database'
        end
        object lbProtocol: TLabel [4]
          Left = 16
          Top = 119
          Width = 39
          Height = 13
          Caption = 'Protocol'
        end
        object edDatabase: TComboBox
          Left = 104
          Top = 148
          Width = 153
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          OnChange = edDatabaseChange
          OnDropDown = edDatabaseDropDown
        end
        object edProtocol: TComboBox
          Left = 104
          Top = 115
          Width = 153
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
          OnChange = edProtocolChange
        end
      end
      inherited btConnect: TButton
        Top = 200
      end
      inherited btDisconnect: TButton
        Top = 200
      end
    end
    object shOptions: TTabSheet [1]
      Caption = 'Options'
      ImageIndex = 3
      object lbClientLibrary: TLabel
        Left = 16
        Top = 82
        Width = 56
        Height = 13
        Caption = 'Client library'
      end
      object lbCharset: TLabel
        Left = 16
        Top = 51
        Width = 36
        Height = 13
        Caption = 'Charset'
      end
      object lbRole: TLabel
        Left = 16
        Top = 20
        Width = 22
        Height = 13
        Caption = 'Role'
      end
      object edClientLibrary: TEdit
        Left = 104
        Top = 80
        Width = 293
        Height = 21
        TabOrder = 2
        OnChange = edClientLibraryChange
      end
      object btClientLibrary: TBitBtn
        Left = 399
        Top = 80
        Width = 17
        Height = 21
        TabOrder = 3
        OnClick = btClientLibraryClick
        Glyph.Data = {
          FE000000424DFE0000000000000076000000280000000D000000110000000100
          0400000000008800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFF0FF0FF0FF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000}
      end
      object edCharset: TComboBox
        Left = 104
        Top = 48
        Width = 313
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        OnChange = edCharsetChange
        OnDropDown = edCharsetDropDown
      end
      object edRole: TEdit
        Left = 105
        Top = 16
        Width = 312
        Height = 21
        TabOrder = 0
        OnChange = edRoleChange
      end
      object gbParams: TGroupBox
        Left = 8
        Top = 104
        Width = 409
        Height = 124
        Caption = 'Params '
        TabOrder = 4
        object meParams: TMemo
          Left = 10
          Top = 22
          Width = 388
          Height = 92
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          OnExit = meParamsExit
        end
      end
    end
    inherited shInfo: TTabSheet
      inherited meInfo: TMemo
        Height = 215
      end
    end
    inherited shAbout: TTabSheet
      inherited Label1: TLabel
        Width = 338
        Caption = 'InterBase Data Access Components'
      end
      inherited lbWeb: TLabel
        Width = 104
        Caption = 'www.devart.com/ibdac'
      end
      inherited lbMail: TLabel
        Width = 83
        Caption = 'ibdac@devart.com'
      end
    end
  end
  inherited btClose: TButton
    Top = 279
  end
end
