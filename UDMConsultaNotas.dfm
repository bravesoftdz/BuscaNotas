object DMConsultaNotas: TDMConsultaNotas
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 290
  Top = 212
  Height = 325
  Width = 952
  object sdsContador: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 'SELECT*'#13#10'FROM CONTADOR'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.scoDados
    Left = 64
    Top = 32
  end
  object dspContador: TDataSetProvider
    DataSet = sdsContador
    Left = 112
    Top = 32
  end
  object cdsContador: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspContador'
    Left = 152
    Top = 32
    object cdsContadorID: TIntegerField
      FieldName = 'ID'
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
    Left = 192
    Top = 32
  end
  object qFilial: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftString
        Name = 'CNPJ_CPF'
        ParamType = ptInput
      end>
    SQL.Strings = (
      'SELECT F.*'
      'FROM FILIAL F'
      'WHERE F.CNPJ_CPF = :CNPJ_CPF')
    SQLConnection = dmDatabase.scoDados
    Left = 320
    Top = 32
    object qFilialID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object qFilialNOME: TStringField
      FieldName = 'NOME'
      Size = 60
    end
    object qFilialULTNSU_NFE: TStringField
      FieldName = 'ULTNSU_NFE'
      Size = 25
    end
    object qFilialULTNSU_NFCE: TStringField
      FieldName = 'ULTNSU_NFCE'
      Size = 25
    end
  end
  object qParametros: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT *'
      'FROM PARAMETROS')
    SQLConnection = dmDatabase.scoDados
    Left = 320
    Top = 96
    object qParametrosID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object qParametrosENDTXT: TStringField
      FieldName = 'ENDTXT'
      Size = 250
    end
    object qParametrosVERSAO_BANCO: TIntegerField
      FieldName = 'VERSAO_BANCO'
    end
    object qParametrosTIPOLOGONFE: TStringField
      FieldName = 'TIPOLOGONFE'
      Size = 1
    end
    object qParametrosAJUSTELOGONFEAUTOMATICO: TStringField
      FieldName = 'AJUSTELOGONFEAUTOMATICO'
      Size = 1
    end
    object qParametrosLOCALNFECONFIG: TStringField
      FieldName = 'LOCALNFECONFIG'
      Size = 50
    end
  end
end
