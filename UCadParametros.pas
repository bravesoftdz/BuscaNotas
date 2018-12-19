unit UCadParametros;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Buttons, UDMCadParametros,
  ExtCtrls, StdCtrls, DB, RzTabs, DBCtrls, ToolEdit, RzPanel, RXDBCtrl, RxDBComb, Mask;

type
  TfrmCadParametros = class(TForm)
    RzPageControl1: TRzPageControl;
    TS_Cadastro: TRzTabSheet;
    Panel1: TPanel;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnAlterar: TBitBtn;
    pnlNFe: TPanel;
    Label30: TLabel;
    Dir_EndTxt: TDirectoryEdit;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fDMCadParametros: TDMCadParametros;

    procedure prc_Gravar_Registro;
    procedure prc_Consultar;
  public
    { Public declarations }
  end;

var
  frmCadParametros: TfrmCadParametros;

implementation

uses DmdDatabase, rsDBUtils, uUtilPadrao;

{$R *.dfm}

procedure TfrmCadParametros.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin                       
  Action := Cafree;
end;

procedure TfrmCadParametros.prc_Gravar_Registro;
begin
  fDMCadParametros.cdsParametrosENDTXT.Value := Dir_EndTxt.Text;

  fDMCadParametros.prc_Gravar;
  if fDMCadParametros.cdsParametros.State in [dsEdit,dsInsert] then
  begin
    MessageDlg(fDMCadParametros.vMsgErro, mtError, [mbOk], 0);
    exit;
  end;
  pnlNFe.Enabled := not(pnlNFe.Enabled);
  btnConfirmar.Enabled       := not(btnConfirmar.Enabled);
  btnAlterar.Enabled         := not(btnAlterar.Enabled);
end;

procedure TfrmCadParametros.FormShow(Sender: TObject);
begin
  fDMCadParametros := TDMCadParametros.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMCadParametros);

  prc_Consultar;

  Dir_EndTxt.Text := fDMCadParametros.cdsParametrosENDTXT.Value;
end;

procedure TfrmCadParametros.prc_Consultar;
begin
  fDMCadParametros.cdsParametros.Close;
  fDMCadParametros.sdsParametros.CommandText := fDMCadParametros.ctCommand
                                             + ' WHERE ID = 1 ';
  fDMCadParametros.cdsParametros.Open;
  if fDMCadParametros.cdsParametros.IsEmpty then
  begin
    fDMCadParametros.cdsParametros.Insert;
    fDMCadParametros.cdsParametrosID.AsInteger := 1;
    btnAlterarClick(nil);
  end;
end;

procedure TfrmCadParametros.btnCancelarClick(Sender: TObject);
begin
  if (fDMCadParametros.cdsParametros.State in [dsBrowse]) or not(fDMCadParametros.cdsParametros.Active) then
    exit;

  if MessageDlg('Deseja cancelar alteração/inclusão do registro?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
    exit;
  pnlNFe.Enabled := not(pnlNFe.Enabled);
  btnConfirmar.Enabled       := not(btnConfirmar.Enabled);
  btnAlterar.Enabled         := not(btnAlterar.Enabled);
  fDMCadParametros.cdsParametros.CancelUpdates;
end;

procedure TfrmCadParametros.btnAlterarClick(Sender: TObject);
begin
  if (fDMCadParametros.cdsParametros.IsEmpty) or not(fDMCadParametros.cdsParametros.Active) or (fDMCadParametros.cdsParametrosID.AsInteger < 1) then
    exit;

  fDMCadParametros.cdsParametros.Edit;

  pnlNFe.Enabled := not(pnlNFe.Enabled);

  btnAlterar.Enabled   := False;
  btnConfirmar.Enabled := True;
end;

procedure TfrmCadParametros.btnConfirmarClick(Sender: TObject);
begin
  prc_Gravar_Registro;
end;

procedure TfrmCadParametros.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fDMCadParametros);
end;

end.
