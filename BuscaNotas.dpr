program BuscaNotas;

uses
  Forms,
  UConsultaNotas in 'UConsultaNotas.pas' {frmConsultaNotas},
  DmdDatabase in 'DmdDatabase.pas' {dmDatabase: TDataModule},
  UDMCadFilial in 'UDMCadFilial.pas' {DMCadFilial: TDataModule},
  UCadFilial in 'uCadFilial.pas' {frmCadFilial},
  UDMCadParametros in 'UDMCadParametros.pas' {DMCadParametros: TDataModule},
  UCadParametros in 'UCadParametros.pas' {frmCadParametros},
  rsDBUtils in '..\rslib\nova\rsDBUtils.pas',
  uCadContador in 'uCadContador.pas' {frmCadContador},
  UDMCadContador in 'UDMCadContador.pas' {DMCadContador: TDataModule},
  UDMConsultaNotas in 'UDMConsultaNotas.pas' {DMConsultaNotas: TDataModule},
  USel_Filial in 'USel_Filial.pas' {frmSel_Filial},
  uUtilPadrao in 'uUtilPadrao.pas',
  uNFeComandos in '..\ssfacil\uNFeComandos.pas',
  uNFeConsts in '..\ssfacil\uNFeConsts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmDatabase, dmDatabase);
  Application.CreateForm(TfrmConsultaNotas, frmConsultaNotas);
  Application.Run;
end.
