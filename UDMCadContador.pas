unit UDMCadContador;

interface

uses
  SysUtils, Classes, FMTBcd, DB, DBClient, Provider, SqlExpr;

type
  TDMCadContador = class(TDataModule)
    sdsContador: TSQLDataSet;
    dspContador: TDataSetProvider;
    cdsContador: TClientDataSet;
    dsContador: TDataSource;
    sdsContadorID: TIntegerField;
    sdsContadorNOME: TStringField;
    sdsContadorCPF: TStringField;
    cdsContadorID: TIntegerField;
    cdsContadorNOME: TStringField;
    cdsContadorCPF: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure dspContadorUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError;
      UpdateKind: TUpdateKind; var Response: TResolverResponse);
  private
    { Private declarations }

  public
    { Public declarations }
    vMsgErro : String;
    ctCommand : String;

    procedure prc_Localizar(ID : Integer); //-1 = Inclusão
    procedure prc_Inserir;
    procedure prc_Gravar;
    procedure prc_Excluir;

  end;

var
  DMCadContador: TDMCadContador;

implementation

uses DmdDatabase, uUtilPadrao, Variants;

{$R *.dfm}

{ TDMCadPais }

procedure TDMCadContador.prc_Inserir;
var
  vAux : Integer;
begin
  if not cdsContador.Active then
    prc_Localizar(-1);
  vAux := dmDatabase.ProximaSequencia('CONTADOR',0);

  cdsContador.Insert;
  cdsContadorID.AsInteger := vAux;
end;

procedure TDMCadContador.prc_Excluir;
begin
  if not(cdsContador.Active) or (cdsContador.IsEmpty) then
    exit;
  cdsContador.Delete;
  cdsContador.ApplyUpdates(0);
end;

procedure TDMCadContador.prc_Gravar;
var
  vTipo_Aux : array[1..5] of Integer;
  i : Integer;
begin
  vMsgErro := '';
  if trim(cdsContadorNOME.AsString) = '' then
    vMsgErro := '*** Nome não informado!';
  if (trim(cdsContadorCPF.AsString) = '')  then
    vMsgErro := '*** CPF não informado!';
  if vMsgErro <> '' then
    exit;

  cdsContador.Post;
  cdsContador.ApplyUpdates(0);
end;

procedure TDMCadContador.prc_Localizar(ID: Integer);
begin
  cdsContador.Close;
  sdsContador.CommandText := ctCommand;
  if ID <> 0 then
    sdsContador.CommandText := sdsContador.CommandText + ' WHERE ID = ' + IntToStr(ID);
  cdsContador.Open;
end;

procedure TDMCadContador.DataModuleCreate(Sender: TObject);
begin
  ctCommand     := sdsContador.CommandText;
end;

procedure TDMCadContador.dspContadorUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  dmDatabase.prc_UpdateError(DataSet.Name,UpdateKind,E);
end;

end.
