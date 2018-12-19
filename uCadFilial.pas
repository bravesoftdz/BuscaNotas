unit UCadFilial;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Buttons, Grids, SMDBGrid, UDMCadFilial, DBGrids,
  ExtCtrls, StdCtrls, DB, RzTabs, DBCtrls, ToolEdit, UCBase, RxLookup, Mask, RXDBCtrl, RxDBComb, ExtDlgs, NxCollection,
  RzPanel;

type
  TfrmCadFilial = class(TForm)
    RzPageControl1: TRzPageControl;
    TS_Consulta: TRzTabSheet;
    TS_Cadastro: TRzTabSheet;
    SMDBGrid1: TSMDBGrid;
    Panel2: TPanel;
    Panel1: TPanel;
    StaticText1: TStaticText;
    pnlPesquisa: TPanel;
    Label6: TLabel;
    Edit4: TEdit;
    RzPageControl2: TRzPageControl;
    TS_Dados: TRzTabSheet;
    Label1: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    DBEdit7: TDBEdit;
    RxDBLookupCombo1: TRxDBLookupCombo;
    DBEdit1: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit8: TDBEdit;
    RxDBLookupCombo2: TRxDBLookupCombo;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    Label14: TLabel;
    RxDBComboBox2: TRxDBComboBox;
    Label15: TLabel;
    DBEdit16: TDBEdit;
    RxDBComboBox8: TRxDBComboBox;
    btnInserir: TNxButton;
    btnExcluir: TNxButton;
    btnPesquisar: TNxButton;
    btnConsultar: TNxButton;
    btnAlterar: TNxButton;
    btnConfirmar: TNxButton;
    btnCancelar: TNxButton;
    Label65: TLabel;
    DBEdit42: TDBEdit;
    Label66: TLabel;
    DBEdit43: TDBEdit;
    Label13: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    DBEdit15: TDBEdit;
    Label20: TLabel;
    DBEdit17: TDBEdit;
    TS_SPED: TRzTabSheet;
    Label21: TLabel;
    RxDBComboBox1: TRxDBComboBox;
    Label22: TLabel;
    RxDBComboBox3: TRxDBComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure SMDBGrid1DblClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure RxDBLookupCombo2Exit(Sender: TObject);
    procedure DBEdit2Exit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Edit4KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RxDBComboBox8Change(Sender: TObject);
    procedure RzPageControl1Change(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
    fDMCadFilial: TDMCadFilial;

    procedure prc_Inserir_Registro;
    procedure prc_Excluir_Registro;
    procedure prc_Gravar_Registro;
    procedure prc_Consultar;
    procedure prc_Limpar_Edit_Consulta;
    procedure prc_Habilitar_Campos;

  public
    { Public declarations }
  end;

var
  frmCadFilial: TfrmCadFilial;

implementation

uses DateUtils, DmdDatabase, rsDBUtils, uUtilPadrao;

{$R *.dfm}

procedure TfrmCadFilial.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := Cafree;
end;

procedure TfrmCadFilial.btnExcluirClick(Sender: TObject);
begin
  if fDMCadFilial.cdsFilial.IsEmpty then
    exit;

  if MessageDlg('Deseja excluir este registro?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
    exit;

  prc_Excluir_Registro;
end;

procedure TfrmCadFilial.prc_Excluir_Registro;
begin
  fDMCadFilial.prc_Excluir;
end;

procedure TfrmCadFilial.prc_Gravar_Registro;
begin
  fDMCadFilial.prc_Gravar;
  if fDMCadFilial.cdsFilial.State in [dsEdit,dsInsert] then
  begin
    MessageDlg(fDMCadFilial.vMsgFilial, mtError, [mbOk], 0);
    exit;
  end;
  prc_Habilitar_Campos;
  RzPageControl1.ActivePage := TS_Consulta;
end;

procedure TfrmCadFilial.prc_Inserir_Registro;
begin
  fDMCadFilial.prc_Inserir;
  if fDMCadFilial.cdsFilial.State in [dsBrowse] then
    exit;
  prc_Habilitar_Campos;
  RzPageControl1.ActivePage := TS_Cadastro;
  RzPageControl2.ActivePage := TS_Dados;
  DBEdit7.SetFocus;
end;

procedure TfrmCadFilial.FormShow(Sender: TObject);
begin
  fDMCadFilial := TDMCadFilial.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMCadFilial);
  fDMCadFilial.cdsFilial.Open;
end;

procedure TfrmCadFilial.prc_Consultar;
begin
  fDMCadFilial.cdsFilial.Close;
  fDMCadFilial.sdsFilial.CommandText := fDMCadFilial.ctCommand;
  if Trim(Edit4.Text) <> '' then
    fDMCadFilial.sdsFilial.CommandText := fDMCadFilial.sdsFilial.CommandText +
                                          ' WHERE NOME LIKE ' + QuotedStr('%'+Edit4.Text+'%');
  fDMCadFilial.cdsFilial.Open;
end;

procedure TfrmCadFilial.btnConsultarClick(Sender: TObject);
begin
  prc_Consultar;
end;

procedure TfrmCadFilial.btnCancelarClick(Sender: TObject);
begin
  if (fDMCadFilial.cdsFilial.State in [dsBrowse]) or not(fDMCadFilial.cdsFilial.Active) then
  begin
    RzPageControl1.ActivePage := TS_Consulta;
    exit;
  end;
  if MessageDlg('Deseja cancelar alteração/inclusão do registro?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
    exit;
  fDMCadFilial.cdsFilial.CancelUpdates;
  prc_Habilitar_Campos;
  RzPageControl1.ActivePage := TS_Consulta;
end;

procedure TfrmCadFilial.SMDBGrid1DblClick(Sender: TObject);
begin
  RzPageControl1.ActivePage := TS_Cadastro;
end;

procedure TfrmCadFilial.btnAlterarClick(Sender: TObject);
begin
  if (fDMCadFilial.cdsFilial.IsEmpty) or not(fDMCadFilial.cdsFilial.Active) or (fDMCadFilial.cdsFilialID.AsInteger < 1) then
    Exit;
  fDMCadFilial.cdsFilial.Edit;
  prc_Habilitar_Campos;
end;

procedure TfrmCadFilial.btnConfirmarClick(Sender: TObject);
begin
  prc_Gravar_Registro;
end;

procedure TfrmCadFilial.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fDMCadFilial);
end;

procedure TfrmCadFilial.btnInserirClick(Sender: TObject);
begin
  prc_Inserir_Registro;
end;

procedure TfrmCadFilial.RxDBLookupCombo2Exit(Sender: TObject);
begin
  fdmCadFilial.cdsFilialCIDADE.AsString := RxDBLookupCombo2.Text;
  fDMCadFilial.cdsFilialUF.AsString     := fDMCadFilial.cdsCidadeUF.AsString;
end;

procedure TfrmCadFilial.DBEdit2Exit(Sender: TObject);
var
  vNomeAux: String;
  vAux: String;
begin
  vAux := Monta_Numero(DBEdit2.Text,0);
  if (trim(vAux) = '') or (copy(vAux,1,9) = '000000000') then
    exit;
  if fDMCadFilial.cdsFilialPESSOA.AsString = 'J' then
  begin
    if not ValidaCNPJ(DBEdit2.Text) then
    begin
      ShowMessage('CNPJ incorreto!');
      fDMCadFilial.cdsFilialCNPJ_CPF.Clear;
      DBEdit2.SetFocus;
    end;
  end
  else
  if not ValidaCPF(DBEdit2.Text) then
  begin
    ShowMessage('CPF incorreto!');
    fDMCadFilial.cdsFilialCNPJ_CPF.Clear;
    DBEdit2.SetFocus;
  end;

  if not(fDMCadFilial.cdsFilialCNPJ_CPF.IsNull) then
  begin
    vNomeAux := VerificaDuplicidade(DBEdit2.Text,'F',fDMCadFilial.cdsFilialID.AsInteger);
    if trim(vNomeAux) <> '' then
    begin
      ShowMessage('CNPJ ou CPF já utilizado para ' + vNomeAux + '!');
      fDMCadFilial.cdsFilialCNPJ_CPF.Clear;
      DBEdit2.SetFocus;
    end;
  end;
end;

procedure TfrmCadFilial.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := fnc_Encerrar_Tela(fDMCadFilial.cdsFilial);
end;

procedure TfrmCadFilial.Edit4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = Vk_Return then
    btnConsultarClick(Sender);
end;

procedure TfrmCadFilial.RxDBComboBox8Change(Sender: TObject);
begin
  fdmCadFilial.cdsFilialCNPJ_CPF.EditMask := '00.000.000/0000-00';
  if fdmCadFilial.cdsFilialPessoa.AsString = 'F' then
    fdmCadFilial.cdsFilialCNPJ_CPF.EditMask := '000.000.000-00';
end;

procedure TfrmCadFilial.RzPageControl1Change(Sender: TObject);
begin
  if RzPageControl1.ActivePage = TS_Cadastro then
  begin
    if (not(fDMCadFilial.cdsFilial.Active) or (fDMCadFilial.cdsFilialID.AsInteger <= 0)) then
      exit;
    RzPageControl2.ActivePage := TS_Dados;
  end;
end;

procedure TfrmCadFilial.btnPesquisarClick(Sender: TObject);
begin
  pnlPesquisa.Visible := not(pnlPesquisa.Visible);
  if pnlPesquisa.Visible then
    Edit4.SetFocus
  else
    prc_Limpar_Edit_Consulta;
end;

procedure TfrmCadFilial.prc_Limpar_Edit_Consulta;
begin
  Edit4.Clear;
end;

procedure TfrmCadFilial.prc_Habilitar_Campos;
begin
  TS_Dados.Enabled       := not(TS_Dados.Enabled);
  TS_SPED.Enabled        := not(TS_SPED.Enabled);
  TS_Consulta.TabEnabled := not(TS_Consulta.TabEnabled);
  btnConfirmar.Enabled   := not(btnConfirmar.Enabled);
  btnAlterar.Enabled     := not(btnAlterar.Enabled);
end;

end.
