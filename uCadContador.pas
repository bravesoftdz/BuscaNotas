unit UCadContador;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Buttons, Grids, SMDBGrid, UDMCadContador, DBGrids,
  ExtCtrls, StdCtrls, DB, RzTabs, DBCtrls, ToolEdit, UCBase, RxLookup, Mask, RXDBCtrl, RxDBComb, ExtDlgs, NxCollection,
  RzPanel;

type
  TfrmCadContador = class(TForm)
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
    Label8: TLabel;
    Label3: TLabel;
    DBEdit7: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit2: TDBEdit;
    btnInserir: TNxButton;
    btnExcluir: TNxButton;
    btnPesquisar: TNxButton;
    btnConsultar: TNxButton;
    btnAlterar: TNxButton;
    btnConfirmar: TNxButton;
    btnCancelar: TNxButton;
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
    procedure DBEdit2Exit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Edit4KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RxDBComboBox8Change(Sender: TObject);
    procedure RzPageControl1Change(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
    fDMCadContador: TDMCadContador;

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
  frmCadContador: TfrmCadContador;

implementation

uses DateUtils, DmdDatabase, rsDBUtils, uUtilPadrao;

{$R *.dfm}

procedure TfrmCadContador.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := Cafree;
end;

procedure TfrmCadContador.btnExcluirClick(Sender: TObject);
begin
  if fDMCadContador.cdsContador.IsEmpty then
    exit;

  if MessageDlg('Deseja excluir este registro?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
    exit;

  prc_Excluir_Registro;
end;

procedure TfrmCadContador.prc_Excluir_Registro;
begin
  fDMCadContador.prc_Excluir;
end;

procedure TfrmCadContador.prc_Gravar_Registro;
begin
  fDMCadContador.prc_Gravar;
  if fDMCadContador.cdsContador.State in [dsEdit,dsInsert] then
  begin
    MessageDlg(fDMCadContador.vMsgErro, mtError, [mbOk], 0);
    exit;
  end;
  prc_Habilitar_Campos;
  RzPageControl1.ActivePage := TS_Consulta;
end;

procedure TfrmCadContador.prc_Inserir_Registro;
begin
  fDMCadContador.prc_Inserir;
  if fDMCadContador.cdsContador.State in [dsBrowse] then
    exit;
  prc_Habilitar_Campos;
  RzPageControl1.ActivePage := TS_Cadastro;
  RzPageControl2.ActivePage := TS_Dados;
  DBEdit7.SetFocus;
end;

procedure TfrmCadContador.FormShow(Sender: TObject);
begin
  fDMCadContador := TDMCadContador.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMCadContador);
  fDMCadContador.cdsContador.Open;
end;

procedure TfrmCadContador.prc_Consultar;
begin
  fDMCadContador.cdsContador.Close;
  fDMCadContador.sdsContador.CommandText := fDMCadContador.ctCommand;
  if Trim(Edit4.Text) <> '' then
    fDMCadContador.sdsContador.CommandText := fDMCadContador.sdsContador.CommandText +
                                          ' WHERE NOME LIKE ' + QuotedStr('%'+Edit4.Text+'%');
  fDMCadContador.cdsContador.Open;
end;

procedure TfrmCadContador.btnConsultarClick(Sender: TObject);
begin
  prc_Consultar;
end;

procedure TfrmCadContador.btnCancelarClick(Sender: TObject);
begin
  if (fDMCadContador.cdsContador.State in [dsBrowse]) or not(fDMCadContador.cdsContador.Active) then
  begin
    RzPageControl1.ActivePage := TS_Consulta;
    exit;
  end;
  if MessageDlg('Deseja cancelar alteração/inclusão do registro?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
    exit;
  fDMCadContador.cdsContador.CancelUpdates;
  prc_Habilitar_Campos;
  RzPageControl1.ActivePage := TS_Consulta;
end;

procedure TfrmCadContador.SMDBGrid1DblClick(Sender: TObject);
begin
  RzPageControl1.ActivePage := TS_Cadastro;
end;

procedure TfrmCadContador.btnAlterarClick(Sender: TObject);
begin
  if (fDMCadContador.cdsContador.IsEmpty) or not(fDMCadContador.cdsContador.Active) or (fDMCadContador.cdsContadorID.AsInteger < 1) then
    Exit;
  fDMCadContador.cdsContador.Edit;
  prc_Habilitar_Campos;
end;

procedure TfrmCadContador.btnConfirmarClick(Sender: TObject);
begin
  prc_Gravar_Registro;
end;

procedure TfrmCadContador.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fDMCadContador);
end;

procedure TfrmCadContador.btnInserirClick(Sender: TObject);
begin
  prc_Inserir_Registro;
end;

procedure TfrmCadContador.DBEdit2Exit(Sender: TObject);
var
  vNomeAux: String;
  vAux: String;
begin
  vAux := Monta_Numero(DBEdit2.Text,0);
  if (trim(vAux) = '') or (copy(vAux,1,9) = '000000000') then
    exit;
  if not ValidaCPF(DBEdit2.Text) then
  begin
    ShowMessage('CPF incorreto!');
    fDMCadContador.cdsContadorCPF.Clear;
    DBEdit2.SetFocus;
  end;

  if not(fDMCadContador.cdsContadorCPF.IsNull) then
  begin
    vNomeAux := VerificaDuplicidade(DBEdit2.Text,'F',fDMCadContador.cdsContadorID.AsInteger);
    if trim(vNomeAux) <> '' then
    begin
      ShowMessage('CPF já utilizado para ' + vNomeAux + '!');
      fDMCadContador.cdsContadorCPF.Clear;
      DBEdit2.SetFocus;
    end;
  end;
end;

procedure TfrmCadContador.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := fnc_Encerrar_Tela(fDMCadContador.cdsContador);
end;

procedure TfrmCadContador.Edit4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = Vk_Return then
    btnConsultarClick(Sender);
end;

procedure TfrmCadContador.RxDBComboBox8Change(Sender: TObject);
begin
  fDMCadContador.cdsContadorCPF.EditMask := '000.000.000-00';
end;

procedure TfrmCadContador.RzPageControl1Change(Sender: TObject);
begin
  if RzPageControl1.ActivePage = TS_Cadastro then
  begin
    if (not(fDMCadContador.cdsContador.Active) or (fDMCadContador.cdsContadorID.AsInteger <= 0)) then
      exit;
    RzPageControl2.ActivePage := TS_Dados;
  end;
end;

procedure TfrmCadContador.btnPesquisarClick(Sender: TObject);
begin
  pnlPesquisa.Visible := not(pnlPesquisa.Visible);
  if pnlPesquisa.Visible then
    Edit4.SetFocus
  else
    prc_Limpar_Edit_Consulta;
end;

procedure TfrmCadContador.prc_Limpar_Edit_Consulta;
begin
  Edit4.Clear;
end;

procedure TfrmCadContador.prc_Habilitar_Campos;
begin
  TS_Dados.Enabled            := not(TS_Dados.Enabled);
  TS_Consulta.TabEnabled      := not(TS_Consulta.TabEnabled);
  btnConfirmar.Enabled        := not(btnConfirmar.Enabled);
  btnAlterar.Enabled          := not(btnAlterar.Enabled);
end;

end.
