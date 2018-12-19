object DMCadFilial: TDMCadFilial
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 244
  Top = 31
  Height = 663
  Width = 1045
  object sdsFilial: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 'SELECT *'#13#10'FROM FILIAL '#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.scoDados
    Left = 72
    Top = 32
    object sdsFilialID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object sdsFilialNOME: TStringField
      FieldName = 'NOME'
      Size = 60
    end
    object sdsFilialNOME_INTERNO: TStringField
      FieldName = 'NOME_INTERNO'
      Size = 30
    end
    object sdsFilialENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 60
    end
    object sdsFilialCOMPLEMENTO_END: TStringField
      FieldName = 'COMPLEMENTO_END'
      Size = 60
    end
    object sdsFilialNUM_END: TStringField
      FieldName = 'NUM_END'
      Size = 15
    end
    object sdsFilialBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 30
    end
    object sdsFilialCEP: TStringField
      FieldName = 'CEP'
      Size = 9
    end
    object sdsFilialID_CIDADE: TIntegerField
      FieldName = 'ID_CIDADE'
    end
    object sdsFilialCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 40
    end
    object sdsFilialUF: TStringField
      FieldName = 'UF'
      Size = 2
    end
    object sdsFilialDDD1: TIntegerField
      FieldName = 'DDD1'
    end
    object sdsFilialFONE1: TStringField
      FieldName = 'FONE1'
      Size = 15
    end
    object sdsFilialDDD2: TIntegerField
      FieldName = 'DDD2'
    end
    object sdsFilialFONE: TStringField
      FieldName = 'FONE'
      Size = 15
    end
    object sdsFilialDDDFAX: TIntegerField
      FieldName = 'DDDFAX'
    end
    object sdsFilialFAX: TStringField
      FieldName = 'FAX'
      Size = 15
    end
    object sdsFilialPESSOA: TStringField
      FieldName = 'PESSOA'
      FixedChar = True
      Size = 1
    end
    object sdsFilialCNPJ_CPF: TStringField
      FieldName = 'CNPJ_CPF'
      Size = 18
    end
    object sdsFilialINSCR_EST: TStringField
      FieldName = 'INSCR_EST'
      Size = 18
    end
    object sdsFilialSIMPLES: TStringField
      FieldName = 'SIMPLES'
      FixedChar = True
      Size = 1
    end
    object sdsFilialENDLOGO: TStringField
      FieldName = 'ENDLOGO'
      Size = 250
    end
    object sdsFilialINATIVO: TStringField
      FieldName = 'INATIVO'
      FixedChar = True
      Size = 1
    end
    object sdsFilialINSCMUNICIPAL: TStringField
      FieldName = 'INSCMUNICIPAL'
      Size = 18
    end
    object sdsFilialHOMEPAGE: TStringField
      FieldName = 'HOMEPAGE'
      Size = 250
    end
    object sdsFilialEMAIL_NFE: TStringField
      FieldName = 'EMAIL_NFE'
      Size = 200
    end
    object sdsFilialPRINCIPAL: TStringField
      FieldName = 'PRINCIPAL'
      FixedChar = True
      Size = 1
    end
    object sdsFilialLIBERADO_ATE: TStringField
      FieldName = 'LIBERADO_ATE'
      Size = 18
    end
    object sdsFilialULTIMO_ACESSO: TStringField
      FieldName = 'ULTIMO_ACESSO'
      Size = 18
    end
    object sdsFilialEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 150
    end
    object sdsFilialLOCALSERVIDORNFE: TStringField
      FieldName = 'LOCALSERVIDORNFE'
      Size = 100
    end
    object sdsFilialENDXMLNFE: TStringField
      FieldName = 'ENDXMLNFE'
      Size = 250
    end
    object sdsFilialENDPDFNFE: TStringField
      FieldName = 'ENDPDFNFE'
      Size = 250
    end
    object sdsFilialENDTXT: TStringField
      FieldName = 'ENDTXT'
      Size = 250
    end
    object sdsFilialENDTXT_COPIADO: TStringField
      FieldName = 'ENDTXT_COPIADO'
      Size = 250
    end
    object sdsFilialULTNSU_NFE: TStringField
      FieldName = 'ULTNSU_NFE'
      Size = 25
    end
    object sdsFilialULTNSU_NFCE: TStringField
      FieldName = 'ULTNSU_NFCE'
      Size = 25
    end
    object sdsFilialIND_NAT_PJ: TSmallintField
      FieldName = 'IND_NAT_PJ'
    end
    object sdsFilialIND_ATIV_PISCOFINS: TSmallintField
      FieldName = 'IND_ATIV_PISCOFINS'
    end
  end
  object dspFilial: TDataSetProvider
    DataSet = sdsFilial
    UpdateMode = upWhereKeyOnly
    OnUpdateError = dspFilialUpdateError
    Left = 144
    Top = 32
  end
  object cdsFilial: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ID'
    Params = <>
    ProviderName = 'dspFilial'
    OnNewRecord = cdsFilialNewRecord
    Left = 208
    Top = 32
    object cdsFilialID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsFilialNOME: TStringField
      FieldName = 'NOME'
      Size = 60
    end
    object cdsFilialNOME_INTERNO: TStringField
      FieldName = 'NOME_INTERNO'
      Size = 30
    end
    object cdsFilialENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 60
    end
    object cdsFilialCOMPLEMENTO_END: TStringField
      FieldName = 'COMPLEMENTO_END'
      Size = 60
    end
    object cdsFilialNUM_END: TStringField
      FieldName = 'NUM_END'
      Size = 15
    end
    object cdsFilialBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 30
    end
    object cdsFilialCEP: TStringField
      FieldName = 'CEP'
      Size = 9
    end
    object cdsFilialID_CIDADE: TIntegerField
      FieldName = 'ID_CIDADE'
    end
    object cdsFilialCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 40
    end
    object cdsFilialUF: TStringField
      FieldName = 'UF'
      Size = 2
    end
    object cdsFilialDDD1: TIntegerField
      FieldName = 'DDD1'
    end
    object cdsFilialFONE1: TStringField
      FieldName = 'FONE1'
      Size = 15
    end
    object cdsFilialDDD2: TIntegerField
      FieldName = 'DDD2'
    end
    object cdsFilialFONE: TStringField
      FieldName = 'FONE'
      Size = 15
    end
    object cdsFilialDDDFAX: TIntegerField
      FieldName = 'DDDFAX'
    end
    object cdsFilialFAX: TStringField
      FieldName = 'FAX'
      Size = 15
    end
    object cdsFilialPESSOA: TStringField
      FieldName = 'PESSOA'
      FixedChar = True
      Size = 1
    end
    object cdsFilialCNPJ_CPF: TStringField
      FieldName = 'CNPJ_CPF'
      Size = 18
    end
    object cdsFilialINSCR_EST: TStringField
      FieldName = 'INSCR_EST'
      Size = 18
    end
    object cdsFilialSIMPLES: TStringField
      FieldName = 'SIMPLES'
      FixedChar = True
      Size = 1
    end
    object cdsFilialENDLOGO: TStringField
      FieldName = 'ENDLOGO'
      Size = 250
    end
    object cdsFilialINATIVO: TStringField
      FieldName = 'INATIVO'
      FixedChar = True
      Size = 1
    end
    object cdsFilialINSCMUNICIPAL: TStringField
      FieldName = 'INSCMUNICIPAL'
      Size = 18
    end
    object cdsFilialHOMEPAGE: TStringField
      FieldName = 'HOMEPAGE'
      Size = 250
    end
    object cdsFilialEMAIL_NFE: TStringField
      FieldName = 'EMAIL_NFE'
      Size = 200
    end
    object cdsFilialPRINCIPAL: TStringField
      FieldName = 'PRINCIPAL'
      FixedChar = True
      Size = 1
    end
    object cdsFilialLIBERADO_ATE: TStringField
      FieldName = 'LIBERADO_ATE'
      Size = 18
    end
    object cdsFilialULTIMO_ACESSO: TStringField
      FieldName = 'ULTIMO_ACESSO'
      Size = 18
    end
    object cdsFilialEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 150
    end
    object cdsFilialLOCALSERVIDORNFE: TStringField
      FieldName = 'LOCALSERVIDORNFE'
      Size = 100
    end
    object cdsFilialENDXMLNFE: TStringField
      FieldName = 'ENDXMLNFE'
      Size = 250
    end
    object cdsFilialENDPDFNFE: TStringField
      FieldName = 'ENDPDFNFE'
      Size = 250
    end
    object cdsFilialENDTXT: TStringField
      FieldName = 'ENDTXT'
      Size = 250
    end
    object cdsFilialENDTXT_COPIADO: TStringField
      FieldName = 'ENDTXT_COPIADO'
      Size = 250
    end
    object cdsFilialULTNSU_NFE: TStringField
      FieldName = 'ULTNSU_NFE'
      Size = 25
    end
    object cdsFilialULTNSU_NFCE: TStringField
      FieldName = 'ULTNSU_NFCE'
      Size = 25
    end
    object cdsFilialIND_NAT_PJ: TSmallintField
      FieldName = 'IND_NAT_PJ'
    end
    object cdsFilialIND_ATIV_PISCOFINS: TSmallintField
      FieldName = 'IND_ATIV_PISCOFINS'
    end
  end
  object dsFilial: TDataSource
    DataSet = cdsFilial
    Left = 272
    Top = 32
  end
  object sdsCidade: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 
      'SELECT CID.ID, CID.NOME, CID.UF,  CID.ID_PROVEDOR '#13#10' FROM CIDADE' +
      ' CID'#13#10#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.scoDados
    Left = 456
    Top = 154
  end
  object dspCidade: TDataSetProvider
    DataSet = sdsCidade
    Left = 520
    Top = 154
  end
  object cdsCidade: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'NOME'
    Params = <>
    ProviderName = 'dspCidade'
    Left = 576
    Top = 154
    object cdsCidadeID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsCidadeNOME: TStringField
      FieldName = 'NOME'
      Size = 40
    end
    object cdsCidadeUF: TStringField
      FieldName = 'UF'
      Size = 2
    end
    object cdsCidadeID_PROVEDOR: TIntegerField
      FieldName = 'ID_PROVEDOR'
    end
  end
  object dsCidade: TDataSource
    DataSet = cdsCidade
    Left = 632
    Top = 154
  end
  object sdsUF: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 'SELECT *'#13#10'FROM UF'#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.scoDados
    Left = 434
    Top = 270
  end
  object dspUF: TDataSetProvider
    DataSet = sdsUF
    Left = 498
    Top = 270
  end
  object cdsUF: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'UF'
    Params = <>
    ProviderName = 'dspUF'
    Left = 554
    Top = 270
    object cdsUFUF: TStringField
      FieldName = 'UF'
      Required = True
      Size = 2
    end
    object cdsUFPERC_ICMS: TFloatField
      FieldName = 'PERC_ICMS'
    end
    object cdsUFIDPAIS: TIntegerField
      FieldName = 'IDPAIS'
    end
    object cdsUFCODUF: TStringField
      FieldName = 'CODUF'
      Size = 2
    end
    object cdsUFPERC_ICMS_INTERNO: TFloatField
      FieldName = 'PERC_ICMS_INTERNO'
    end
  end
  object dsUF: TDataSource
    DataSet = cdsUF
    Left = 610
    Top = 270
  end
end
