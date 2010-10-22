object dmEstd: TdmEstd
  OldCreateOrder = False
  Left = 938
  Top = 304
  Height = 459
  Width = 596
  object memDocuments: TMemTableEh
    Params = <>
    Left = 16
    Top = 56
    object fldiDocuments_document_id: TIntegerField
      FieldName = 'document_id'
    end
    object fldiDocumentsrefdoc_id: TIntegerField
      FieldName = 'refdoc_id'
    end
  end
  object memDocOpers: TMemTableEh
    DetailFields = 'document_id'
    MasterFields = 'document_id'
    MasterSource = dsDocuments
    Params = <>
    Left = 152
    Top = 56
    object fldiOpersdocoper_id: TIntegerField
      FieldName = 'docoper_id'
    end
    object fldiDocOpersdocument_id: TIntegerField
      FieldName = 'document_id'
    end
    object fldiDocOpersoper_num: TIntegerField
      FieldName = 'oper_num'
    end
    object wsfldDocOpersoper_name: TWideStringField
      FieldName = 'oper_name'
      Size = 4000
    end
  end
  object dsDocuments: TDataSource
    AutoEdit = False
    DataSet = memDocuments
    Left = 80
    Top = 56
  end
  object dsDocOpers: TDataSource
    AutoEdit = False
    DataSet = memDocOpers
    Left = 208
    Top = 56
  end
  object memDocSets: TMemTableEh
    Params = <>
    Left = 280
    Top = 56
    object fldiDocSetsDocSet_Id: TIntegerField
      FieldName = 'docset_id'
    end
    object fldiDocSetsdocument_id: TIntegerField
      FieldName = 'document_id'
    end
    object wsfldDocSetsdocset_name: TWideStringField
      FieldName = 'docset_name'
      Size = 255
    end
  end
  object dsDocSets: TDataSource
    AutoEdit = False
    DataSet = memDocSets
    Left = 344
    Top = 56
  end
  object dsObjects: TDataSource
    AutoEdit = False
    DataSet = memObjects
    Left = 80
    Top = 8
  end
  object memObjects: TMemTableEh
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'memObjectsIndex1'
        CaseInsFields = 'obj_label'
        Fields = 'obj_label'
        Options = [ixUnique, ixCaseInsensitive]
      end>
    Params = <>
    StoreDefs = True
    Left = 16
    Top = 8
    object fldiObjectsobj_id: TIntegerField
      FieldName = 'obj_id'
    end
    object wsfldObjects_objtype: TWideStringField
      FieldName = 'objtype'
      Size = 10
    end
    object fldiObjects_kei: TIntegerField
      FieldName = 'kei'
    end
    object wsfldObjectsobj_label: TWideStringField
      FieldName = 'obj_label'
      Size = 25
    end
    object wsfldObjects_obj_code: TWideStringField
      FieldName = 'obj_code'
      Size = 18
    end
    object wsfldObjectsobj_name: TWideStringField
      FieldName = 'obj_name'
      Size = 255
    end
    object wsfldObjects_obj_gost: TWideStringField
      FieldName = 'obj_gost'
      Size = 255
    end
    object wsfldObjectsobjtype_name: TWideStringField
      FieldKind = fkLookup
      FieldName = 'objtype_name'
      LookupDataSet = dmEstdNSI.memObjTypes
      LookupKeyFields = 'objtype'
      LookupResultField = 'objtype_name'
      KeyFields = 'objtype'
      Size = 50
      Lookup = True
    end
  end
  object memDetIsSet: TMemTableEh
    MasterSource = dsDocSets
    Params = <>
    Left = 152
    Top = 112
    object fldiDetIsSet_docset_id: TIntegerField
      FieldName = 'docset_id'
    end
    object fldiDetIsSet_detail_id: TIntegerField
      FieldName = 'detail_id'
    end
    object wsfldDetIsSetdetail_label: TWideStringField
      FieldKind = fkLookup
      FieldName = 'detail_label'
      LookupDataSet = memObjects
      LookupKeyFields = 'obj_id'
      LookupResultField = 'obj_label'
      KeyFields = 'detail_id'
      Size = 25
      Lookup = True
    end
    object wsfldDetIsSet_detail_name: TWideStringField
      FieldKind = fkLookup
      FieldName = 'detail_name'
      LookupDataSet = memObjects
      LookupKeyFields = 'obj_id'
      LookupResultField = 'obj_name'
      KeyFields = 'detail_id'
      Size = 255
      Lookup = True
    end
  end
  object dsDetInSet: TDataSource
    AutoEdit = False
    DataSet = memDetIsSet
    Left = 208
    Top = 112
  end
  object dsDetails: TDataSource
    AutoEdit = False
    DataSet = memDetails
    Left = 80
    Top = 112
  end
  object dsMaterials: TDataSource
    AutoEdit = False
    DataSet = memMaterials
    Left = 80
    Top = 208
  end
  object dsEquips: TDataSource
    AutoEdit = False
    DataSet = memEquips
    Left = 80
    Top = 256
  end
  object memDetails: TMemTableEh
    Params = <>
    Left = 16
    Top = 112
    object fldiDetails_detail_id: TIntegerField
      FieldName = 'detail_id'
    end
  end
  object memMaterials: TMemTableEh
    Params = <>
    Left = 16
    Top = 208
    object fldiMaterials_material_id: TIntegerField
      FieldName = 'material_id'
    end
  end
  object memEquips: TMemTableEh
    Params = <>
    Left = 16
    Top = 256
    object fldiEquips_equip_id: TIntegerField
      FieldName = 'equip_id'
    end
    object fldiEquips_orgunit_id: TIntegerField
      FieldName = 'orgunit_id'
    end
  end
  object memInstrs: TMemTableEh
    Params = <>
    Left = 16
    Top = 304
    object fldiInstrs_instr_id: TIntegerField
      FieldName = 'instr_id'
    end
  end
  object memProfs: TMemTableEh
    Params = <>
    Left = 16
    Top = 352
    object fldiProfs_prof_id: TIntegerField
      FieldName = 'prof_id'
    end
    object fldiProfs_prof_code: TIntegerField
      FieldName = 'prof_code'
    end
    object wsfldProfs_prof_name: TWideStringField
      FieldName = 'prof_name'
      Size = 255
    end
    object fldiProfs_prof_okr_code: TIntegerField
      FieldName = 'prof_okr_code'
    end
  end
  object dsInstrs: TDataSource
    DataSet = memInstrs
    Left = 80
    Top = 304
  end
  object dsProfs: TDataSource
    AutoEdit = False
    DataSet = memProfs
    Left = 80
    Top = 352
  end
  object dsHalfs: TDataSource
    AutoEdit = False
    DataSet = memHalfs
    Left = 80
    Top = 160
  end
  object memHalfs: TMemTableEh
    Params = <>
    Left = 16
    Top = 160
  end
end
