unit UDMConsultaNotas;

interface

uses
  SysUtils, Classes, FMTBcd, DB, DBClient, Provider, SqlExpr;

type
  TDMConsultaNotas = class(TDataModule)
    sdsContador: TSQLDataSet;
    dspContador: TDataSetProvider;
    cdsContador: TClientDataSet;
    cdsContadorID: TIntegerField;
    cdsContadorNOME: TStringField;
    cdsContadorCPF: TStringField;
    dsContador: TDataSource;
    qFilial: TSQLQuery;
    qFilialID: TIntegerField;
    qFilialNOME: TStringField;
    qFilialULTNSU_NFE: TStringField;
    qFilialULTNSU_NFCE: TStringField;
    qParametros: TSQLQuery;
    qParametrosID: TIntegerField;
    qParametrosENDTXT: TStringField;
    qParametrosVERSAO_BANCO: TIntegerField;
    qParametrosTIPOLOGONFE: TStringField;
    qParametrosAJUSTELOGONFEAUTOMATICO: TStringField;
    qParametrosLOCALNFECONFIG: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMConsultaNotas: TDMConsultaNotas;

implementation

uses DmdDatabase;

{$R *.dfm}

procedure TDMConsultaNotas.DataModuleCreate(Sender: TObject);
begin
  cdsContador.Open;
  qParametros.Open;
end;

end.
