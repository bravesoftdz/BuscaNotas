unit UDMCadFilial;

interface

uses
  SysUtils, Classes, FMTBcd, DB, DBClient, Provider, SqlExpr;

type
  TDMCadFilial = class(TDataModule)
    sdsFilial: TSQLDataSet;
    dspFilial: TDataSetProvider;
    cdsFilial: TClientDataSet;
    dsFilial: TDataSource;
    sdsCidade: TSQLDataSet;
    dspCidade: TDataSetProvider;
    cdsCidade: TClientDataSet;
    dsCidade: TDataSource;
    sdsUF: TSQLDataSet;
    dspUF: TDataSetProvider;
    cdsUF: TClientDataSet;
    dsUF: TDataSource;
    cdsUFUF: TStringField;
    cdsUFPERC_ICMS: TFloatField;
    cdsUFIDPAIS: TIntegerField;
    cdsUFCODUF: TStringField;
    cdsUFPERC_ICMS_INTERNO: TFloatField;
    cdsCidadeID: TIntegerField;
    cdsCidadeNOME: TStringField;
    cdsCidadeUF: TStringField;
    cdsCidadeID_PROVEDOR: TIntegerField;
    sdsFilialID: TIntegerField;
    sdsFilialNOME: TStringField;
    sdsFilialNOME_INTERNO: TStringField;
    sdsFilialENDERECO: TStringField;
    sdsFilialCOMPLEMENTO_END: TStringField;
    sdsFilialNUM_END: TStringField;
    sdsFilialBAIRRO: TStringField;
    sdsFilialCEP: TStringField;
    sdsFilialID_CIDADE: TIntegerField;
    sdsFilialCIDADE: TStringField;
    sdsFilialUF: TStringField;
    sdsFilialDDD1: TIntegerField;
    sdsFilialFONE1: TStringField;
    sdsFilialDDD2: TIntegerField;
    sdsFilialFONE: TStringField;
    sdsFilialDDDFAX: TIntegerField;
    sdsFilialFAX: TStringField;
    sdsFilialPESSOA: TStringField;
    sdsFilialCNPJ_CPF: TStringField;
    sdsFilialINSCR_EST: TStringField;
    sdsFilialSIMPLES: TStringField;
    sdsFilialENDLOGO: TStringField;
    sdsFilialINATIVO: TStringField;
    sdsFilialINSCMUNICIPAL: TStringField;
    sdsFilialHOMEPAGE: TStringField;
    sdsFilialEMAIL_NFE: TStringField;
    sdsFilialPRINCIPAL: TStringField;
    sdsFilialLIBERADO_ATE: TStringField;
    sdsFilialULTIMO_ACESSO: TStringField;
    sdsFilialEMAIL: TStringField;
    sdsFilialLOCALSERVIDORNFE: TStringField;
    sdsFilialENDXMLNFE: TStringField;
    sdsFilialENDPDFNFE: TStringField;
    sdsFilialENDTXT: TStringField;
    sdsFilialENDTXT_COPIADO: TStringField;
    cdsFilialID: TIntegerField;
    cdsFilialNOME: TStringField;
    cdsFilialNOME_INTERNO: TStringField;
    cdsFilialENDERECO: TStringField;
    cdsFilialCOMPLEMENTO_END: TStringField;
    cdsFilialNUM_END: TStringField;
    cdsFilialBAIRRO: TStringField;
    cdsFilialCEP: TStringField;
    cdsFilialID_CIDADE: TIntegerField;
    cdsFilialCIDADE: TStringField;
    cdsFilialUF: TStringField;
    cdsFilialDDD1: TIntegerField;
    cdsFilialFONE1: TStringField;
    cdsFilialDDD2: TIntegerField;
    cdsFilialFONE: TStringField;
    cdsFilialDDDFAX: TIntegerField;
    cdsFilialFAX: TStringField;
    cdsFilialPESSOA: TStringField;
    cdsFilialCNPJ_CPF: TStringField;
    cdsFilialINSCR_EST: TStringField;
    cdsFilialSIMPLES: TStringField;
    cdsFilialENDLOGO: TStringField;
    cdsFilialINATIVO: TStringField;
    cdsFilialINSCMUNICIPAL: TStringField;
    cdsFilialHOMEPAGE: TStringField;
    cdsFilialEMAIL_NFE: TStringField;
    cdsFilialPRINCIPAL: TStringField;
    cdsFilialLIBERADO_ATE: TStringField;
    cdsFilialULTIMO_ACESSO: TStringField;
    cdsFilialEMAIL: TStringField;
    cdsFilialLOCALSERVIDORNFE: TStringField;
    cdsFilialENDXMLNFE: TStringField;
    cdsFilialENDPDFNFE: TStringField;
    cdsFilialENDTXT: TStringField;
    cdsFilialENDTXT_COPIADO: TStringField;
    sdsFilialULTNSU_NFE: TStringField;
    sdsFilialULTNSU_NFCE: TStringField;
    cdsFilialULTNSU_NFE: TStringField;
    cdsFilialULTNSU_NFCE: TStringField;
    sdsFilialIND_NAT_PJ: TSmallintField;
    sdsFilialIND_ATIV_PISCOFINS: TSmallintField;
    cdsFilialIND_NAT_PJ: TSmallintField;
    cdsFilialIND_ATIV_PISCOFINS: TSmallintField;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsFilialNewRecord(DataSet: TDataSet);
    procedure dspFilialUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError;
      UpdateKind: TUpdateKind; var Response: TResolverResponse);
  private
    { Private declarations }

  public
    { Public declarations }
    vMsgFilial : String;
    ctCommand : String;

    procedure prc_Localizar(ID : Integer); //-1 = Inclusão
    procedure prc_Inserir;
    procedure prc_Gravar;
    procedure prc_Excluir;

  end;

var
  DMCadFilial: TDMCadFilial;

implementation

uses DmdDatabase, uUtilPadrao, Variants;

{$R *.dfm}

{ TDMCadPais }

procedure TDMCadFilial.prc_Inserir;
var
  vAux : Integer;
begin
  if not cdsFilial.Active then
    prc_Localizar(-1);
  vAux := dmDatabase.ProximaSequencia('FILIAL',0);

  cdsFilial.Insert;
  cdsFilialID.AsInteger     := vAux;
  cdsFilialINATIVO.AsString := 'N';
  cdsFilialPESSOA.AsString  := 'J';
end;

procedure TDMCadFilial.prc_Excluir;
begin
  if not(cdsFilial.Active) or (cdsFilial.IsEmpty) then
    exit;
  cdsFilial.Delete;
  cdsFilial.ApplyUpdates(0);
end;

procedure TDMCadFilial.prc_Gravar;
var
  vTipo_Aux : array[1..5] of Integer;
  i : Integer;
begin
  vMsgFilial := '';
  if trim(cdsFilialNOME.AsString) = '' then
    vMsgFilial := '*** Nome não informado!';
  if (trim(cdsFilialCNPJ_CPF.AsString) = '')  then
    vMsgFilial := vMsgFilial + #13 + '*** CNPJ ou CPF não informado!';
  for i := 1 to 5 do
    vTipo_Aux[i] := 0;
  if vMsgFilial <> '' then
    exit;

  cdsFilial.Post;
  cdsFilial.ApplyUpdates(0);
end;

procedure TDMCadFilial.prc_Localizar(ID: Integer);
begin
  cdsFilial.Close;
  sdsFilial.CommandText := ctCommand;
  if ID <> 0 then
    sdsFilial.CommandText := sdsFilial.CommandText
                         + ' WHERE ID = ' + IntToStr(ID);
  cdsFilial.Open;
end;

procedure TDMCadFilial.DataModuleCreate(Sender: TObject);
begin
  ctCommand     := sdsFilial.CommandText;

  cdsCidade.Open;
  cdsUF.Open;
end;

procedure TDMCadFilial.cdsFilialNewRecord(DataSet: TDataSet);
begin
  cdsFilialINATIVO.AsString := 'N';
end;

procedure TDMCadFilial.dspFilialUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  dmDatabase.prc_UpdateError(DataSet.Name,UpdateKind,E);
end;

end.
