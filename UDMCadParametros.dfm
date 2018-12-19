object DMCadParametros: TDMCadParametros
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 460
  Top = 240
  Height = 352
  Width = 528
  object sdsParametros: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 'SELECT *'#13#10'FROM PARAMETROS'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.scoDados
    Left = 120
    Top = 32
    object sdsParametrosID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object sdsParametrosENDTXT: TStringField
      FieldName = 'ENDTXT'
      Size = 250
    end
    object sdsParametrosVERSAO_BANCO: TIntegerField
      FieldName = 'VERSAO_BANCO'
    end
    object sdsParametrosTIPOLOGONFE: TStringField
      FieldName = 'TIPOLOGONFE'
      Size = 1
    end
    object sdsParametrosAJUSTELOGONFEAUTOMATICO: TStringField
      FieldName = 'AJUSTELOGONFEAUTOMATICO'
      Size = 1
    end
    object sdsParametrosLOCALNFECONFIG: TStringField
      FieldName = 'LOCALNFECONFIG'
      Size = 50
    end
  end
  object dspParametros: TDataSetProvider
    DataSet = sdsParametros
    UpdateMode = upWhereKeyOnly
    OnUpdateError = dspParametrosUpdateError
    Left = 192
    Top = 32
  end
  object cdsParametros: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID'
    Params = <>
    ProviderName = 'dspParametros'
    Left = 256
    Top = 32
    object cdsParametrosID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsParametrosENDTXT: TStringField
      FieldName = 'ENDTXT'
      Size = 250
    end
    object cdsParametrosVERSAO_BANCO: TIntegerField
      FieldName = 'VERSAO_BANCO'
    end
    object cdsParametrosAJUSTELOGONFEAUTOMATICO: TStringField
      FieldName = 'AJUSTELOGONFEAUTOMATICO'
      Size = 1
    end
    object cdsParametrosTIPOLOGONFE: TStringField
      FieldName = 'TIPOLOGONFE'
      Size = 1
    end
    object cdsParametrosLOCALNFECONFIG: TStringField
      FieldName = 'LOCALNFECONFIG'
      Size = 50
    end
  end
  object dsParametros: TDataSource
    DataSet = cdsParametros
    Left = 328
    Top = 32
  end
end
