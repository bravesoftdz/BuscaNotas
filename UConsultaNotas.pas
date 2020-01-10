unit UConsultaNotas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ToolEdit, IdBaseComponent, IdCoder,
  IdCoder3to4, IdCoderMIME, CurrEdit, NxCollection, UDMConsultaNotas, SqlExpr;

type
  TfrmConsultaNotas = class(TForm)
    IdDecoderMIME: TIdDecoderMIME;
    Memo1: TMemo;
    NxPanel1: TNxPanel;
    NxButton1: TNxButton;
    NxButton2: TNxButton;
    NxButton3: TNxButton;
    NxPanel2: TNxPanel;
    Label36: TLabel;
    Label39: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtCNPJContabil: TEdit;
    edtCNPJBaixarXML: TEdit;
    DirectoryEdit1: TDirectoryEdit;
    ComboBox1: TComboBox;
    Label4: TLabel;
    btnConsultar: TNxButton;
    CurrencyEdit1: TCurrencyEdit;
    btnContinua: TNxButton;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    procedure btnConsultarClick(Sender: TObject);
    procedure NxButton2Click(Sender: TObject);
    procedure NxButton1Click(Sender: TObject);
    procedure NxButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure edtCNPJBaixarXMLKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCNPJBaixarXMLExit(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure edtCNPJContabilExit(Sender: TObject);
  private
    { Private declarations }
    fDMConsultaNotas: TDMConsultaNotas;
    vUltNSU, vUltNSURet : String;

    procedure prc_Ult_NSU;
    procedure prc_Gravar_Filial;

    function fnc_Monta_Pasta(Diretorio : String) : String;

  public
    { Public declarations }
  end;

var
  frmConsultaNotas: TfrmConsultaNotas;

implementation

uses uNFeComandos, StrUtils, uCadContador, UCadFilial, UCadParametros,
  rsDBUtils, uUtilPadrao, USel_Filial, DB, DmdDatabase;

{$R *.dfm}

procedure TfrmConsultaNotas.btnConsultarClick(Sender: TObject);
var
  memStream, toMem, fromMem: TMemoryStream;
  Str: String;
  StrStream: TStringStream;
  i,f : integer;
  vModelo : String;
  vArq : String;
  vCNPJEmit : String;
  vContinuar : Boolean;
  vLocalNFeConfig : String;
  vAux : String;

begin
  if trim(DirectoryEdit1.Text) = '' then
  begin
    ShowMessage('Pasta para salvar o arquivo não foi informada!');
    exit;
  end;

  vAux := Monta_Numero(edtCNPJContabil.Text,0);
  if (vAux <> '40372766072') and (vAux <> '94705836049') and (vAux <> '25527096053')
  and (vAux <> '47698594068') and (vAux <> '38938588068') and (vAux <> '81428650091')
  and (vAux <> '40941345068') and (vAux <> '25024337034') and (vAux <> '99310031620')
  and (vAux <> '61670812049') and (vAux <> '39379230044') and (vAux <> '59239972072')
  and (vAux <> '20584067020') and (vAux <> '58575375091') and (vAux <> '29712165000')
  and (vAux <> '09312127000110') and (vAux <> '26873010006') and (vAux <> '94247358049')
  and (vAux <> '40136051049') and (vAux <> '39206041053') then
  begin
    ShowMessage('CPF não entrontrado, favor entrar em contato com a Servisoft pelo fone 51-3598-6584!');
    exit;
  end;

  Label5.Visible := True;
  btnContinua.Enabled := False;
  Refresh;

  vContinuar := False;
  vUltNSU    := '';
  vUltNSURet := '';

  case ComboBox1.ItemIndex of
    0 : vModelo := '55';
    1 : vModelo := '65';
  end;

  if trim(CurrencyEdit1.Text) = '' then
    CurrencyEdit1.Text := '0';

  fDMConsultaNotas.qParametros.Close;
  fDMConsultaNotas.qParametros.Open;
  vLocalNFeConfig := 'localhost';
  if trim(fDMConsultaNotas.qParametrosLOCALNFECONFIG.AsString) <> '' then
    vLocalNFeConfig := fDMConsultaNotas.qParametrosLOCALNFECONFIG.AsString;

  memStream := TMemoryStream.Create;
  try
    NFeIntegracaoContab(vLocalNFeConfig,
                        Monta_Numero(edtCNPJContabil.Text,0),
                        Monta_Numero(edtCNPJBaixarXML.Text,0),
                        vModelo,
                        1,
                        1,
                        1,
                        StrToInt64(CurrencyEdit1.Text),
                        memStream);

    StrStream := TStringStream.Create('');
    try
      memStream.Position := 0;
      memStream.SaveToStream(StrStream);
      Str := StrStream.DataString;
    finally
      FreeAndNil(StrStream);
    end;
    i := PosEx('<ultNSU>', Str);
    f := PosEx('</ultNSU>', Str);
    vUltNSU := copy(Str,i+8,f-(i+8));

    i := PosEx('<ultNSURet>', Str);
    f := PosEx('</ultNSURet>', Str);
    vUltNSURet := copy(Str,i+11,f-(i+11));

    i := PosEx('<loteDistComp>', Str) + 14;
    f := PosEx('</loteDistComp>', Str, i);
    Str := Copy(Str, i, f - i);
    Str := IdDecoderMIME.DecodeString(Str);
    Str := ZDecompressString(Str);

    vArq := DirectoryEdit1.Text;
    if copy(vArq,Length(vArq),1) = '\' then
      delete(varq,Length(vArq),1);

    NFeIntegracaoContabToFiles(Str,vArq);

    //xtrloteDistNFeRS.TransformRead.SourceXml := StrStream.DataString;
    //xtrloteDistNFeRS.TransformRead.TransformationFile := ExtractFilePath(Application.ExeName) + 'xtr\loteDistNFeRS_v1.00.xsd.xtr';

    if copy(DirectoryEdit1.Text,Length(DirectoryEdit1.Text),1) <> '\' then
      DirectoryEdit1.Text := DirectoryEdit1.Text + '\';
    if FileExists(DirectoryEdit1.Text+ Monta_Numero(edtCNPJBaixarXML.Text,0)+'.xml') then
      DeleteFile(DirectoryEdit1.Text+Monta_Numero(edtCNPJBaixarXML.Text,0)+'.xml');
    memStream.Position := 0;
    memStream.SaveToFile(DirectoryEdit1.Text+Monta_Numero(edtCNPJBaixarXML.Text,0)+'_Compactado.xml');

    prc_Gravar_Filial;

    if CurrencyEdit1.Text <> vUltNSURet then
    begin
      btnContinua.Enabled := True;
      CurrencyEdit1.Text  := vUltNSURet;
      vContinuar := CheckBox1.Checked;
    end
    else
    begin
      btnContinua.Enabled := False;
      vContinuar          := False;
    end;

  finally
    FreeAndNil(memStream);
  end;

  i := PosEx('<loteDistComp>', Str) + 14;
  f := PosEx('</loteDistComp>', Str, i);
  Str := Copy(Str, i, f - i);
  Str := IdDecoderMIME.DecodeString(Str);
  Str := ZDecompressString(Str);
  Memo1.Lines.Text := Str;
  Memo1.Lines.SaveToFile(DirectoryEdit1.Text+Monta_Numero(edtCNPJBaixarXML.Text,0)+'.xml');

  if vContinuar then
    btnConsultarClick(Sender)
  else
  begin
    Label5.Visible := False;
    ShowMessage('Arquivo Salvo na pasta informada!');
  end;
end;

procedure TfrmConsultaNotas.NxButton2Click(Sender: TObject);
var
  ffrmCadContador: TfrmCadContador;
begin
  ffrmCadContador := TfrmCadContador.Create(self);
  ffrmCadContador.ShowModal;
  FreeAndNil(ffrmCadContador);
end;

procedure TfrmConsultaNotas.NxButton1Click(Sender: TObject);
var
  ffrmCadFilial: TfrmCadFilial;
begin
  ffrmCadFilial := TfrmCadFilial.Create(self);
  ffrmCadFilial.ShowModal;
  FreeAndNil(ffrmCadFilial);
end;

procedure TfrmConsultaNotas.NxButton3Click(Sender: TObject);
var
  ffrmCadParametros: TfrmCadParametros;
begin
  ffrmCadParametros := TfrmCadParametros.Create(self);
  ffrmCadParametros.ShowModal;
  FreeAndNil(ffrmCadParametros);
end;

procedure TfrmConsultaNotas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := Cafree;
end;

procedure TfrmConsultaNotas.FormShow(Sender: TObject);
begin
  fDMConsultaNotas := TDMConsultaNotas.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMConsultaNotas);

  edtCNPJContabil.Text := Monta_Numero(fDMConsultaNotas.cdsContadorCPF.AsString,0);
  DirectoryEdit1.Text  := fDMConsultaNotas.qParametrosENDTXT.AsString;
end;

procedure TfrmConsultaNotas.edtCNPJBaixarXMLKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  ffrmSel_Filial: TfrmSel_Filial;
begin
  if (Key = Vk_F2) then
  begin
    vCNPJ_Filial_Pos := edtCNPJBaixarXML.Text;
    ffrmSel_Filial := TfrmSel_Filial.Create(Self);
    ffrmSel_Filial.ShowModal;
    FreeAndNil(ffrmSel_Filial);
    edtCNPJBaixarXML.Text := vCNPJ_Filial_Pos;
  end;
end;

procedure TfrmConsultaNotas.edtCNPJBaixarXMLExit(Sender: TObject);
var
  vCNPJAux : String;
begin
  vCNPJAux := Monta_Numero(edtCNPJBaixarXML.Text,0);
  if trim(vCNPJAux) = '' then
    exit;
  vCNPJAux := copy(vCNPJAux,1,2) + '.' + copy(vCNPJAux,3,3) + '.' + copy(vCNPJAux,6,3) + '/' + copy(vCNPJAux,9,4) + '-' + copy(vCNPJAux,13,2);
  fDMConsultaNotas.qFilial.Close;
  fDMConsultaNotas.qFilial.ParamByName('CNPJ_CPF').AsString := vCNPJAux;
  fDMConsultaNotas.qFilial.Open;
  if fDMConsultaNotas.qFilial.IsEmpty then
  begin
    MessageDlg('*** CNPJ não encontrado no cadastro de Empresa!', mtInformation, [mbOk], 0);
    exit;
  end;
  prc_Ult_NSU;
end;

procedure TfrmConsultaNotas.prc_Ult_NSU;
begin
   if (trim(edtCNPJBaixarXML.Text) = '') or (ComboBox1.ItemIndex < 0) then
     exit;
   case ComboBox1.ItemIndex of
     0 : CurrencyEdit1.Text := fDMConsultaNotas.qFilialULTNSU_NFE.AsString;
     1 : CurrencyEdit1.Text := fDMConsultaNotas.qFilialULTNSU_NFCE.AsString;
   end;
  fDMConsultaNotas.qParametros.Close;
  fDMConsultaNotas.qParametros.Open;
  DirectoryEdit1.Text := fDMConsultaNotas.qParametrosENDTXT.Text;
  DirectoryEdit1.Text := fnc_Monta_Pasta(DirectoryEdit1.Text);
end;

procedure TfrmConsultaNotas.ComboBox1Exit(Sender: TObject);
begin
  if trim(edtCNPJBaixarXML.Text) <> '' then
    edtCNPJBaixarXMLExit(Sender);
end;

function TfrmConsultaNotas.fnc_Monta_Pasta(Diretorio: String): String;
var
  vAux : String;
begin
  Result := '';
  vAux := Monta_Numero(edtCNPJBaixarXML.Text,14);
  if copy(Diretorio,Length(Diretorio),1) <> '\' then
    Diretorio := Diretorio + '\';
  if not DirectoryExists(Diretorio) then
  begin
    ShowMessage('Pasta não ' + Diretorio + ' existe!');
    exit;
  end;
  Diretorio := Diretorio + vAux;
  CreateDir(Diretorio);
  case ComboBox1.ItemIndex of
   0 : Diretorio := Diretorio + '\NFe';
   1 : Diretorio := Diretorio + '\NFCe';
  end;
  CreateDir(Diretorio);
  Result := Diretorio;
end;

procedure TfrmConsultaNotas.prc_Gravar_Filial;
var
  sds: TSQLDataSet;
begin
  sds := TSQLDataSet.Create(nil);
  try
    sds.SQLConnection := dmDatabase.scoDados;
    sds.NoMetadata    := True;
    sds.GetMetadata   := False;
    if ComboBox1.ItemIndex = 0 then
      sds.CommandText := 'UPDATE FILIAL SET ULTNSU_NFE = ' + QuotedStr(vUltNSURet) + ' WHERE ID = ' + IntToStr(fDMConsultaNotas.qFilialID.AsInteger)
    else
      sds.CommandText := 'UPDATE FILIAL SET ULTNSU_NFCE = ' + QuotedStr(vUltNSURet) + ' WHERE ID = ' + IntToStr(fDMConsultaNotas.qFilialID.AsInteger);
    sds.ExecSQL;
  finally
    FreeAndNil(sds);
  end;
end;

procedure TfrmConsultaNotas.edtCNPJContabilExit(Sender: TObject);
var
  vAux : String;
begin
  if trim(edtCNPJContabil.Text) = '' then
    exit; 
  vAux := Monta_Numero(edtCNPJContabil.Text,0);
  if (vAux <> '40372766072') and (vAux <> '94705836049') and (vAux <> '25527096053')
   and (vAux <> '47698594068') and (vAux <> '38938588068') and (vAux <> '81428650091')
   and (vAux <> '40941345068') and (vAux <> '25024337034') and (vAux <> '99310031620')
   and (vAux <> '61670812049') and (vAux <> '39379230044') and (vAux <> '59239972072')
   and (vAux <> '20584067020') and (vAux <> '58575375091') and (vAux <> '29712165000')
   and (vAux <> '09312127000110') and (vAux <> '26873010006') and (vAux <> '94247358049')
   and (vAux <> '40136051049') and (vAux <> '39206041053') then
  begin
    ShowMessage('CPF não encontrado, favor entrar em contato com a Servisoft pelo fone 51-3598-6584!');
    edtCNPJContabil.Clear;
    edtCNPJContabil.SetFocus;
    exit;
  end;
end;

end.
