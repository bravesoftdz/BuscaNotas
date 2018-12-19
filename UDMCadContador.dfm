object DMCadContador: TDMCadContador
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 416
  Top = 145
  Height = 308
  Width = 576
  object sdsContador: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 'SELECT *'#13#10'FROM CONTADOR'#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.scoDados
    Left = 72
    Top = 32
    object sdsContadorID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object sdsContadorNOME: TStringField
      FieldName = 'NOME'
      Size = 70
    end
    object sdsContadorCPF: TStringField
      FieldName = 'CPF'
      Size = 14
    end
  end
  object dspContador: TDataSetProvider
    DataSet = sdsContador
    UpdateMode = upWhereKeyOnly
    OnUpdateError = dspContadorUpdateError
    Left = 144
    Top = 32
  end
  object cdsContador: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID'
    Params = <>
    ProviderName = 'dspContador'
    Left = 208
    Top = 32
    object cdsContadorID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsContadorNOME: TStringField
      FieldName = 'NOME'
      Size = 70
    end
    object cdsContadorCPF: TStringField
      FieldName = 'CPF'
      Size = 14
    end
  end
  object dsContador: TDataSource
    DataSet = cdsContador
    Left = 272
    Top = 32
  end
end
