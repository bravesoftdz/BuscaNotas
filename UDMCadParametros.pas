unit UDMCadParametros;

interface

uses
  SysUtils, Classes, FMTBcd, DB, DBClient, Provider, SqlExpr;

type
  TDMCadParametros = class(TDataModule)
    sdsParametros: TSQLDataSet;
    dspParametros: TDataSetProvider;
    cdsParametros: TClientDataSet;
    dsParametros: TDataSource;
    sdsParametrosID: TIntegerField;
    sdsParametrosENDTXT: TStringField;
    sdsParametrosVERSAO_BANCO: TIntegerField;
    cdsParametrosID: TIntegerField;
    cdsParametrosENDTXT: TStringField;
    cdsParametrosVERSAO_BANCO: TIntegerField;
    sdsParametrosTIPOLOGONFE: TStringField;
    sdsParametrosAJUSTELOGONFEAUTOMATICO: TStringField;
    cdsParametrosAJUSTELOGONFEAUTOMATICO: TStringField;
    cdsParametrosTIPOLOGONFE: TStringField;
    sdsParametrosLOCALNFECONFIG: TStringField;
    cdsParametrosLOCALNFECONFIG: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure dspParametrosUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError;
      UpdateKind: TUpdateKind; var Response: TResolverResponse);
  private
    { Private declarations }
  public
    { Public declarations }
    vMsgErro : String;
    ctCommand : String;

    procedure prc_Localizar(ID : Integer); //-1 = Inclusão
    procedure prc_Gravar;

  end;

var
  DMCadParametros: TDMCadParametros;

implementation

uses DmdDatabase, uUtilPadrao;

{$R *.dfm}

{ TDMCadPais }

procedure TDMCadParametros.prc_Gravar;
begin
  vMsgErro := '';
  if trim(cdsParametrosENDTXT.AsString) = '' then
    vMsgErro := vMsgErro + #13 + '*** Endereço onde esta localizado os arquivos textos das Notas não foi informado!';
  if vMsgErro <> '' then
    exit;

  cdsParametros.Post;
  cdsParametros.ApplyUpdates(0);
end;

procedure TDMCadParametros.prc_Localizar(ID : Integer);
begin
  cdsParametros.Close;
  sdsParametros.CommandText := ctCommand;
  if ID <> 0 then
    sdsParametros.CommandText := sdsParametros.CommandText
                         + ' WHERE ID = ' + IntToStr(ID);
  cdsParametros.Open;
end;

procedure TDMCadParametros.DataModuleCreate(Sender: TObject);
begin
  ctCommand := sdsParametros.CommandText;
end;

procedure TDMCadParametros.dspParametrosUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  dmDatabase.prc_UpdateError(DataSet.Name,UpdateKind,E);
end;

end.
