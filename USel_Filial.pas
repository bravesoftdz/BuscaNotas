unit USel_Filial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, Grids,
  DBGrids, SMDBGrid, FMTBcd, DB, Provider, DBClient, SqlExpr, RxLookup,
  DBCtrls, NxCollection;

type
  TfrmSel_Filial = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    SMDBGrid1: TSMDBGrid;
    sdsFilial: TSQLDataSet;
    cdsFilial: TClientDataSet;
    dspFilial: TDataSetProvider;
    dsFilial: TDataSource;
    StaticText1: TStaticText;
    btnConsultar: TNxButton;
    cdsFilialID: TIntegerField;
    cdsFilialNOME: TStringField;
    cdsFilialPESSOA: TStringField;
    cdsFilialCNPJ_CPF: TStringField;
    cdsFilialINSCR_EST: TStringField;
    procedure SMDBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMDBGrid1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure SMDBGrid1TitleClick(Column: TColumn);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnConsultarClick(Sender: TObject);
  private
    { Private declarations }
    ctFilialLocal : String;
    procedure prc_Consultar;

  public
    { Public declarations }

  end;

var
  frmSel_Filial: TfrmSel_Filial;

implementation

uses DmdDatabase, uUtilPadrao;

{$R *.dfm}

procedure TfrmSel_Filial.prc_Consultar;
begin
  cdsFilial.Close;
  sdsFilial.CommandText := ctFilialLocal + ' WHERE 0 = 0 ';
  if trim(Edit1.Text) <> '' then
    sdsFilial.CommandText := sdsFilial.CommandText + ' AND NOME LIKE ' + QuotedStr('%'+Edit1.Text+'%');
  cdsFilial.Open;
end;

procedure TfrmSel_Filial.SMDBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = Vk_Return then
  begin
    vCNPJ_Filial_Pos := cdsFilialCNPJ_CPF.AsString;
    Close;
  end;
end;

procedure TfrmSel_Filial.SMDBGrid1DblClick(Sender: TObject);
begin
  vCNPJ_Filial_Pos :=cdsFilialCNPJ_CPF.AsString;
  Close;
end;

procedure TfrmSel_Filial.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := Cafree;
end;

procedure TfrmSel_Filial.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then
    Close;
end;

procedure TfrmSel_Filial.FormShow(Sender: TObject);
var
  i : Integer;
begin
  ctFilialLocal := sdsFilial.CommandText;
  Edit1.SetFocus;
end;

procedure TfrmSel_Filial.SMDBGrid1TitleClick(Column: TColumn);
var
  i : Integer;
  ColunaOrdenada : String;
begin
  ColunaOrdenada := Column.FieldName;
  cdsFilial.IndexFieldNames := Column.FieldName;
  Column.Title.Color := clBtnShadow;
  for i := 0 to SMDBGrid1.Columns.Count - 1 do
    if not (SMDBGrid1.Columns.Items[I] = Column) then
      SMDBGrid1.Columns.Items[I].Title.Color := clBtnFace;
end;

procedure TfrmSel_Filial.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = Vk_Return then
    btnConsultarClick(Sender);
end;

procedure TfrmSel_Filial.btnConsultarClick(Sender: TObject);
begin
  prc_Consultar;
  if cdsFilial.RecordCount > 0 then
    SMDBGrid1.SetFocus;
end;

end.
