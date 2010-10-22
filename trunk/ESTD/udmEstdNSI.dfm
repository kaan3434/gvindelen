object dmEstdNSI: TdmEstdNSI
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 663
  Top = 330
  Height = 342
  Width = 602
  object memKEIGroups: TMemTableEh
    Params = <>
    Left = 40
    Top = 16
    object fldiKEIGroups_groupkei_code: TIntegerField
      FieldName = 'groupkei_code'
    end
    object wsfldKEIGroups_groupkei_name: TWideStringField
      FieldName = 'groupkei_name'
      Size = 255
    end
  end
  object memKEIs: TMemTableEh
    Params = <>
    Left = 112
    Top = 16
    object fldiKEIs_kei: TIntegerField
      FieldName = 'kei'
    end
    object fldiKEIs_groupkei_code: TIntegerField
      FieldName = 'groupkei_code'
    end
    object wsfldKEIs_kei_name: TWideStringField
      FieldName = 'kei_name'
      Size = 255
    end
    object wsfldKEIs_kei_short: TWideStringField
      FieldName = 'kei_short'
      Size = 255
    end
    object fldiKEIs_master_kei: TIntegerField
      FieldName = 'master_kei'
    end
    object wsfldKEIs_groupkei_name: TWideStringField
      FieldKind = fkLookup
      FieldName = 'groupkei_name'
      LookupDataSet = memKEIGroups
      LookupKeyFields = 'groupkei_code'
      LookupResultField = 'groupkei_name'
      KeyFields = 'groupkei_code'
      Size = 255
      Lookup = True
    end
  end
  object dsKEIGroups: TDataSource
    AutoEdit = False
    DataSet = memKEIGroups
    Left = 40
    Top = 64
  end
  object dsKEIs: TDataSource
    AutoEdit = False
    DataSet = memKEIs
    Left = 112
    Top = 64
  end
  object memObjTypes: TMemTableEh
    Params = <>
    Left = 176
    Top = 16
    object wsfldObjTypes_objtype: TWideStringField
      FieldName = 'objtype'
      Size = 10
    end
    object wsfldObjTypes_objtype_name: TWideStringField
      FieldName = 'objtype_name'
      Required = True
      Size = 50
    end
  end
  object dsObjTypes: TDataSource
    AutoEdit = False
    DataSet = memObjTypes
    Left = 176
    Top = 64
  end
end
