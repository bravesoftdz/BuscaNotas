unit DmdDatabase;

interface

uses
  SysUtils, Classes, DBXpress, DB, SqlExpr, Forms, IniFiles, IdCoder, IdCoder3to4, IdCoderMIME, FMTBcd, IdBaseComponent,
  DBClient, Provider, Dialogs, MidasLib, RLFilters, RLRichFilter, RLXLSFilter, RLPDFFilter, RLPreviewForm;

type
  TdmDatabase = class(TDataModule)
    scoDados: TSQLConnection;
    Decoder64: TIdDecoderMIME;
    sdsExec: TSQLDataSet;
    scoAtualiza: TSQLConnection;
    sdsVersao: TSQLDataSet;                                                   
    dspVersao: TDataSetProvider;
    cdsVersao: TClientDataSet;
    sdsVersaoID: TIntegerField;
    sdsVersaoSCRIPT: TBlobField;
    cdsVersaoID: TIntegerField;
    cdsVersaoSCRIPT: TBlobField;
    sqVersaoAtual: TSQLQuery;
    sqVersaoAtualVERSAO_BANCO: TIntegerField;
    scoLiberacao: TSQLConnection;
    sqEmpresa: TSQLQuery;
    sqDataLiberacao: TSQLQuery;
    sqEmpresaCNPJ_CPF: TStringField;
    sqDataLiberacaoDT_LIBERADO: TStringField;
    sqEmpresaLIBERADO_ATE: TStringField;
    Encoder64: TIdEncoderMIME;
    sdsExecRemoto: TSQLDataSet;
    sdsModuloRemoto: TSQLDataSet;
    dspModuloRemoto: TDataSetProvider;
    cdsModuloRemoto: TClientDataSet;
    sdsModuloRemotoID: TIntegerField;
    sdsModuloRemotoMODULO_ID: TIntegerField;
    sdsModuloRemotoLIBERADO: TStringField;
    cdsModuloRemotoID: TIntegerField;
    cdsModuloRemotoMODULO_ID: TIntegerField;
    cdsModuloRemotoLIBERADO: TStringField;
    sdsModuloRemotoMODULO_NOME: TStringField;
    cdsModuloRemotoMODULO_NOME: TStringField;
    sqEmpresaID: TIntegerField;
    sqDataLiberacaoCODVENDEDOR: TIntegerField;
    sqEmpresaULTIMO_ACESSO: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    function Fnc_ArquivoConfiguracao: string;

  public
    function ProximaSequencia(NomeTabela: string; Filial: Integer): Integer;
    function Registro_Max(NomeTabela: string; Campo: String): Integer;

    procedure prc_UpdateError(Tabela: String; ukTipo: TUpdateKind; Emsg: EUpdateError);
  end;

var
  dmDatabase: TdmDatabase;

implementation

uses StrUtils;

{$R *.dfm}

const
  cArquivoConfiguracao = 'Config.ini';

function TdmDatabase.Fnc_ArquivoConfiguracao: string;
begin
  Result := ExtractFilePath(Application.ExeName) + cArquivoConfiguracao;
end;

function TdmDatabase.ProximaSequencia(NomeTabela: string; Filial: Integer): Integer;
var
  sds: TSQLDataSet;
  iSeq: Integer;
  ID: TTransactionDesc;
  Flag: Boolean;
begin
  Result := 0;
  iSeq   := 0;

  sds := TSQLDataSet.Create(nil);
  try
    ID.TransactionID := 999;
    ID.IsolationLevel := xilREADCOMMITTED;

    scoDados.StartTransaction(ID);
    try
      sds.SQLConnection := scoDados;
      sds.NoMetadata  := True;
      sds.GetMetadata := False;
      sds.CommandText := 'SELECT NUMREGISTRO FROM SEQUENCIAL WHERE TABELA = :TABELA AND FILIAL = :FILIAL';
      sds.ParamByName('TABELA').AsString := NomeTabela;
      sds.ParamByName('FILIAL').AsInteger    := Filial;
      sds.Open;

      //iSeq := sds.FieldByName('NUMREGISTRO').AsInteger + 1;
      iSeq := sds.FieldByName('NUMREGISTRO').AsInteger;

      if (iSeq = 0) and (sds.IsEmpty) then
        scoDados.ExecuteDirect('INSERT INTO SEQUENCIAL(TABELA,FILIAL,NUMREGISTRO) VALUES(''' + NomeTabela +
                              ''', ''' + IntToStr(Filial) + ''', ''' + IntToStr(0) + ''' )');
      scoDados.Commit(ID);
    except
      scoDados.Rollback(ID);
      raise;
    end;
  finally
    FreeAndNil(sds);
  end;

  sds := TSQLDataSet.Create(nil);
  try
    ID.TransactionID  := 999;
    ID.IsolationLevel := xilREADCOMMITTED;

    dmDatabase.scoDados.StartTransaction(ID);
    try //--
      sds.SQLConnection := dmDatabase.scoDados;

      sds.NoMetadata  := True;
      sds.GetMetadata := False;

      sds.CommandText := 'UPDATE SEQUENCIAL SET NUMREGISTRO = (SELECT MAX(COALESCE(NUMREGISTRO,0)) + 1 ' +
                         'FROM SEQUENCIAL ' +
                         'WHERE TABELA = :TABELA' +
                         ' AND FILIAL = :FILIAL) ' +
                         'WHERE TABELA = :TABELA' +
                         ' AND FILIAL = :FILIAL';

      sds.ParamByName('TABELA').AsString  := NomeTabela;
      sds.ParamByName('FILIAL').AsInteger := Filial;

      Flag := False;
      while not Flag do
      begin
        try
          sds.Close;
          sds.ExecSQL;
          Flag := True;
        except
          on E: Exception do
            Flag := False;
        end;
      end;

      sds.Close;
      sds.CommandText := 'SELECT MAX(COALESCE(NUMREGISTRO,0)) NUMREGISTRO  ' +
                         'FROM SEQUENCIAL ' +
                         'WHERE TABELA = :TABELA ' +
                         'AND FILIAL = :FILIAL';

      sds.ParamByName('TABELA').AsString  := NomeTabela;
      sds.ParamByName('FILIAL').AsInteger := Filial;
      sds.Open;

      iSeq := sds.FieldByName('NUMREGISTRO').AsInteger;

      dmDatabase.scoDados.Commit(ID);

      Result := iSeq;

    except
      dmDatabase.scoDados.Rollback(ID);
      raise;
    end;

  finally
    FreeAndNil(sds);
  end;
end;

function TdmDatabase.Registro_Max(NomeTabela: string; Campo: String): Integer;
var                                                                                                             
  sds: TSQLDataSet;
  iSeq: Integer;
begin
  Result := 0;
  sds := TSQLDataSet.Create(nil);
  try
    sds.SQLConnection := dmDatabase.scoDados;

    sds.NoMetadata := True;
    sds.GetMetadata := False;

    sds.Close;
    sds.CommandText := ' SELECT MAX(' +CAMPO+ ')' + ' ID FROM ' + NomeTabela;
    sds.Open;

    iSeq := sds.FieldByName('ID').AsInteger;

    Result := iSeq;

  finally
    FreeAndNil(sds);
  end;
end;

procedure TdmDatabase.prc_UpdateError(Tabela: String;
  ukTipo: TUpdateKind; Emsg: EUpdateError);
begin
  if ukTipo = ukDelete  then
    //raise Exception.Create('Erro ao tentar excluir: ' + ' Tabela: ' + '(' + Tabela + ')'  + #13 + Emsg.Message)
    raise Exception.Create('Erro ao tentar excluir: ' + #13 + Emsg.Message)
  else
  if ukTipo = ukModify then
    //raise Exception.Create('Erro ao tentar gravar: ' + ' Tabela: ' + '(' + Tabela + ')'  + #13 + Emsg.Message);
    raise Exception.Create('Erro ao tentar gravar: ' + #13 + Emsg.Message);
end;

procedure TdmDatabase.DataModuleCreate(Sender: TObject);
var
  Config: TIniFile;
  vTexto : String;
begin
  scoDados.Connected      := False;
  scoDados.KeepConnection := True;
  if not FileExists(Fnc_ArquivoConfiguracao) then
    Exit;

  Config := TIniFile.Create(Fnc_ArquivoConfiguracao);
  scoDados.LoadParamsFromIniFile(Fnc_ArquivoConfiguracao);

  try
//////////////////CONECTA AO BANCO DE DADOS DA APLICAÇÃO
    try
      scoDados.Params.Values['DRIVERNAME'] := 'INTERBASE';
      scoDados.Params.Values['SQLDIALECT'] := '3';
      scoDados.Params.Values['DATABASE']   := Config.ReadString('NFeConfig', 'DATABASE', '');
      scoDados.Params.Values['USER_NAME']  := Config.ReadString('NFeConfig', 'USERNAME', '');
      scoDados.Params.Values['PASSWORD']   := Decoder64.DecodeString(Config.ReadString('NFeConfig', 'PASSWORD', ''));
      scoDados.Connected := True;
    except
      on E: exception do
      begin
        raise Exception.Create('Erro ao conectar ao banco de dados:' + #13 +
                               'Mensagem: ' + E.Message + #13 +
                               'Classe: ' + E.ClassName + #13 + #13 +
                               'Dados da Conexao SSFacil' + #13 +
                               'Banco de Dados: '  + scoDados.Params.Values['Database'] + #13 +
                               'Usuário: '         + scoDados.Params.Values['User_Name']);
      end;
    end;
  finally
    FreeAndNil(Config);

  end;

end;

end.

