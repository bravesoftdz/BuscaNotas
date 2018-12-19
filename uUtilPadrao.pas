unit uUtilPadrao;

interface

uses
  Classes, SysUtils, DB, Dialogs, Variants, Forms, ShellApi, Windows, StrUtils, SqlExpr, DmdDatabase,
  DBClient, Controls, SMDBGrid, UEscolhe_Filial;

  function Monta_Numero(Campo: String; Tamanho: Integer): String;
  function TirarAcento(texto: string): string;
  function Monta_Texto(Campo: String; Tamanho: Integer): String;
  procedure AbreArquivo(arquivo: string);
  function ValidaCNPJ(numCNPJ: string): Boolean;
  function ValidaCPF(numCPF: string): Boolean;
  function VerificaDuplicidade(vCnpj, vTipo: String; ID: Integer ; ID_Filial : Integer = 0): String;
  function fnc_Encerrar_Tela(Tabela: TClientDataSet): Boolean;
  function Formatar_Campo(Campo: String; Tamanho: Integer): String;
  function fnc_Calcular_Hora(Hora_Ini, Hora_Fin: TDateTime): Real;
  function fnc_Montar_Campo(Separador: String = ';'; vReg: String = ''): String;
  function fnc_Montar_Valor(Campo: String): String;
  function Replace(Str, Ant, Novo: string): string;
  function PegaTimeZone: string;
  function fnc_verifica_Arquivo(NomeArquivo, Le_Grava: String): String;
  function fnc_HorarioVerao: Boolean;
  function fnc_Verifica_Numero(Campo : String) : Boolean;

  procedure prc_ShellExecute(MSG: String);

  procedure prc_Escolhe_Filial;

  function Criptografar(ABase: integer; AChave, AValue: string): string;
  { Criptografa o valor informado
    - Parâmetros -
    ABase  -> Número da base utilizada para gerar o serial
    AChave -> Chave utilizada para gerar o serial
    AValue -> Valor que ser criptografado
  }

  function Descriptografar(ABase: integer; AChave, AValue: string): string;
  { Descriptografa o valor informado
    - Parâmetros -
    ABase  -> Número da base utilizada para gerar o serial
    AChave -> Chave utilizada para gerar o serial
    AValue -> Valor que ser descriptografado
  }
  function GerarSerial(ABase: Integer; AChave: string): string;
  { Gera serial
    - Parâmetros -
    ABase  -> Número da base utilizada para gerar o serial
    AChave -> Chave utilizada para gerar o serial
  }
var
  //Serve para o envio da NFe
  vTipo_Emissao_NFe : String;
  vTipo_Ambiente_NFe : String;
  vFinalidade_NFe : String;
  vProcesso_Emissao_NFe : String;
  vChave_XML : String;

  vFilial: Integer;
  vFilial_Nome: String;
  vEmail_Fortes, vEmail_Assunto_Fortes: String;
  vEmail_Fortes_Corpo: String;
  vTipo_Config_Email: Integer;
  vPreco_Pos: Real;
  vRegistro_CSV: String;
  vRegistro_CSV2: String;
  vSenha: String;
  vUsuario: String;
  vTerminal: Integer; //terminal PDV Cupom
  vPorta: String;
  vVelocidade: String;
  vRefazer_Cons: Boolean;
  vCNPJ_Filial_Pos : String;

implementation

uses DateUtils, JvSerialMaker, JvXorCipher, JvComponent, JvVigenereCipher, IdCoder, IdCoder3to4, IdCoderMIME, IdBaseComponent;

function fnc_verifica_Arquivo(NomeArquivo, Le_Grava: String): String;
begin
  if copy(NomeArquivo,1,1) = '"' then
    delete(NomeArquivo,1,1);
  if copy(NomeArquivo,Length(NomeArquivo),1) = '"' then
    delete(NomeArquivo,Length(NomeArquivo),1);
  if (Le_Grava = 'G') and (copy(NomeArquivo,Length(NomeArquivo),1) = '\') then
    delete(NomeArquivo,Length(NomeArquivo),1);
  Result := NomeArquivo;
end;

function Replace(Str, Ant, Novo: string): string;
var
  iPos: Integer;
begin
  while Pos(Ant, Str) > 0 do
  begin
    iPos := Pos(Ant, Str);
    Str  := copy(Str, 1, iPos - 1) + Novo + copy(Str, iPos + 1, Length(Str) - iPos);
  end;
  Result := Str;
end;

function Monta_Numero(Campo: String; Tamanho: Integer): String;
var
  texto2: String;
  i: Integer;
begin
  texto2 := '';
  for i := 1 to Length(Campo) do
    if Campo[i] in ['0','1','2','3','4','5','6','7','8','9'] then
      Texto2 := Texto2 + Copy(Campo,i,1);
  for i := 1 to Tamanho - Length(texto2) do
    texto2 := '0' + texto2;
  Result := texto2;
end;

function TirarAcento(Texto: string): string;
var
  i: Integer;
begin
  Texto := Trim(AnsiUpperCase(Texto));
  for i := 1 to Length(texto) do
  begin
    if Pos(Texto[i],' 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`~''"!@#$%^&*()_-+=|/\{}[]:;,.<>') = 0 then
    begin
      case Texto[i] of
        'Á', 'À', 'Â', 'Ä', 'Ã': Texto[i] := 'A';
        'É', 'È', 'Ê', 'Ë': Texto[i] := 'E';
        'Í', 'Ì', 'Î', 'Ï': Texto[i] := 'I';
        'Ó', 'Ò', 'Ô', 'Ö', 'Õ': Texto[i] := 'O';
        'Ú', 'Ù', 'Û', 'Ü': Texto[i] := 'U';
        'Ç': Texto[i] := 'C';
        'Ñ': Texto[i] := 'N';
      else
        Texto[i] := ' ';
      end;
    end;
  end;
  Texto := StringReplace(Texto, '&', 'e',[rfReplaceAll, rfIgnoreCase]);
  Result := AnsiUpperCase(Texto);
end;

procedure AbreArquivo(arquivo: string);
begin
  if FileExists(arquivo) then
  begin
    arquivo := '"' + arquivo + '"';
      //fonte: http://www.mail-archive.com/delphi-br@yahoogrupos.com.br/msg58385.html
      //declar no uses ShellApi
    ShellExecute(Application.Handle, 'open', PChar(arquivo), nil, nil, SW_SHOWMAXIMIZED);
  end
  else
    ShowMessage('Arquivo não encontrado!');
end;

function Monta_Texto(Campo: String; Tamanho: Integer): String;
var
  texto2: String;
  i: Integer;
begin
  texto2 := '';
  for i := 1 to Length(Campo) do
    if Campo[i] in ['0','1','2','3','4','5','6','7','8','9'] then
      Texto2 := Texto2 + Copy(Campo,i,1);
  for i := 1 to Tamanho - Length(texto2) do
    texto2 := '0' + texto2;
  Result := texto2;
end;

function ValidaCNPJ(numCNPJ: string): Boolean;
var
  cnpj: string;
  dg1, dg2: integer;
  x, total: integer;
  ret: boolean;
begin
  ret  := False;
  cnpj := '';
//Analisa os formatos
  if trim(copy(numCNPJ,1,2)) = '' then
    exit;
  if Length(numCNPJ) = 18 then
    if (Copy(numCNPJ,3,1) + Copy(numCNPJ,7,1) + Copy(numCNPJ,11,1) + Copy(numCNPJ,16,1) = '../-') then
    begin
      cnpj := Copy(numCNPJ,1,2) + Copy(numCNPJ,4,3) + Copy(numCNPJ,8,3) + Copy(numCNPJ,12,4) + Copy(numCNPJ,17,2);
      ret  := True;
    end;
    if (copy(cnpj,1,6) = '000000') or (trim(copy(cnpj,1,6)) = '') then
    begin
      Result := True;
      exit;
    end;
    if Length(numCNPJ) = 14 then
    begin
      cnpj := numCNPJ;
      ret  := True;
    end;
    //Verifica
    if ret then
    begin
      try
        //1° digito
        total := 0;
        for x := 1 to 12 do
        begin
          if x < 5 then
            Inc(total, StrToInt(Copy(cnpj, x, 1)) * (6 - x))
          else
             Inc(total, StrToInt(Copy(cnpj, x, 1)) * (14 - x));
        end;
        dg1 := 11 - (total mod 11);
        if dg1 > 9 then
          dg1 := 0;

        //2° digito
        total := 0;
        for x := 1 to 13 do
        begin
          if x < 6 then
            Inc(total, StrToInt(Copy(cnpj, x, 1)) * (7 - x))
          else
            Inc(total, StrToInt(Copy(cnpj, x, 1)) * (15 - x));
        end;

        dg2 := 11 - (total mod 11);
        if dg2 > 9 then
          dg2 := 0;
        //Validação final
        if (dg1 = StrToInt(Copy(cnpj, 13, 1))) and (dg2 = StrToInt(Copy(cnpj, 14, 1))) then
          ret := True
        else
          ret := False;
      except
        ret := False;
      end;
        //Inválidos
      case AnsiIndexStr(cnpj,['11111111111111','22222222222222','33333333333333','44444444444444',
                              '55555555555555','66666666666666','77777777777777','88888888888888','99999999999999']) of
        0..9: ret := False;
      end;
    end;
  ValidaCNPJ := ret;
end;

function ValidaCPF(numCPF: string): Boolean;
var
  cpf: string;
  x, total, dg1, dg2: Integer;
  ret: boolean;
begin
  ret := True;
  for x := 1 to Length(numCPF) do
    if not (numCPF[x] in ['0'..'9', '-', '.', ' ']) then
      ret := False;

  if ret then
  begin
    ret := True;
    cpf := '';
    for x:=1 to Length(numCPF) do
      if numCPF[x] in ['0'..'9'] then
        cpf := cpf + numCPF[x];
    if Length(cpf) <> 11 then
      ret := False;

    if ret then
    begin
      //1° dígito
      total := 0;
      for x := 1 to 9 do
        total := total + (StrToInt(cpf[x]) * x);
      dg1 := total mod 11;
      if dg1 = 10 then
        dg1 := 0;

      //2° dígito
      total := 0;
      for x := 1 to 8 do
        total := total + (StrToInt(cpf[x + 1]) * (x));
      total := total + (dg1 * 9);
      dg2 := total mod 11;
      if dg2 = 10 then
        dg2 := 0;

      //Validação final
      ret := False;
      if dg1 = StrToInt(cpf[10]) then
        if dg2 = StrToInt(cpf[11]) then
          ret := True;
      //Inválidos
      case AnsiIndexStr(cpf,['11111111111','22222222222','33333333333','44444444444',
                             '55555555555','66666666666','77777777777','88888888888','99999999999']) of
        0..9: ret := False;
      end;
    end
    else
    begin
    //Se não informado deixa passar
      if cpf = '' then
        ret := True;
    end;
  end;
  ValidaCPF := ret;
end;

function VerificaDuplicidade(vCnpj, vTipo: String; ID: Integer ; ID_Filial : Integer = 0): String;
var
  sds: TSQLDataSet;
begin
  Result := '';
  sds := TSQLDataSet.Create(nil);
  sds.SQLConnection := dmDatabase.scoDados;
  sds.NoMetadata    := True;
  sds.GetMetadata   := False;
  if vTipo = 'P' then
  begin
    sds.CommandText := 'SELECT CODIGO, NOME FROM PESSOA WHERE ORGAO_PUBLICO <> ' + QuotedStr('S') + ' AND CNPJ_CPF = ' + QuotedStr(vCNPJ);
    if ID_Filial > 0 then
      sds.CommandText := sds.CommandText + ' AND FILIAL = ' + IntToStr(ID_Filial);
    sds.Open;
    if sds.FieldByName('CODIGO').AsInteger <> ID then
      if not sds.FieldByName('NOME').IsNull then
        Result := sds.FieldByName('NOME').AsString;
  end
  else
  if vTipo = 'F' then
  begin
    sds.CommandText := 'SELECT ID, NOME FROM FILIAL WHERE CNPJ_CPF = ' + QuotedStr(vCNPJ);
    sds.Open;
    if sds.FieldByName('ID').AsInteger <> ID then
      if not sds.FieldByName('NOME').IsNull then
        Result := sds.FieldByName('NOME').AsString;
  end;
  FreeAndNil(sds);
end;

function fnc_Encerrar_Tela(Tabela: TClientDataSet): Boolean;
begin
  Result := True;
  if Tabela.State in [dsEdit,dsInsert] then
  begin
    if MessageDlg('Fechar esta tela sem confirmar?',mtConfirmation,[mbOk,mbNo],0) = mrNo then
      Result := False
    else
      Result := True;
  end;
end;

function Formatar_Campo(Campo: String; Tamanho: Integer): String;
var
  i: Integer;
  texto2: String;
  vAux: Integer;
begin
  if Tamanho <= 0 then
    vAux := Length(Campo)
  else
    vAux := Tamanho;
  Result := '';
  texto2 := Campo;
  for i := 1 to vAux - Length(texto2) do
    texto2 := texto2 + ' ';
  Result := Texto2;
end;

function fnc_Calcular_Hora(Hora_Ini, Hora_Fin: TDateTime): Real;
var
  vQtdHoras: Currency;
  vAux: Currency;
begin
  vQtdHoras   := 0;
  if (Hora_Ini > 0) and (Hora_Fin > 0) then
  begin
    vQtdHoras := (Hora_Fin - Hora_Ini) * 24;
    vAux := vQtdHoras - Int(vQtdHoras);
    vAux := (vAux * 60) / 100;
    vQtdHoras := Int(vQtdHoras) + vAux;
  end;
  Result := StrToFloat(FormatFloat('0.00', vQtdHoras));

  Result := (Hora_Fin - Hora_Ini) * 24;
end;

function fnc_Montar_Campo(Separador: String = ';'; vReg: String = ''): String;
var
  i, X: Integer;
  vTexto: String;
  vRegAux: String;
begin
  Result := '';
  if trim(vReg) = '' then
    vRegAux := vRegistro_CSV
  else
    vRegAux := vRegistro_CSV2;
  i := pos(Separador,vRegAux);
  if i = 0 then
    i := Length(vRegAux) + 1;
  Result := Copy(vRegAux,1,i-1);
  vTexto := Result;
  Delete(vRegAux,1,i);
  for x := 1 to Length(vTexto) do
  begin
    if Pos(vTexto[x],'''"') > 0 then
    begin
      vTexto[x] := ' ';
    end;
  end;
  if trim(copy(vTexto,1,1)) = '' then
    Delete(vTexto,1,1);
  if trim(copy(vTexto,Length(vTexto),1)) = '' then
    Delete(vTexto,Length(vTexto),1);
  Result := vTexto;
  if trim(vReg) = '' then
    vRegistro_CSV := vRegAux
  else
    vRegistro_CSV2 := vRegAux;
end;

function fnc_Montar_Valor(Campo: String): String;
var
  vTexto: String;
  i: Integer;
begin
  Result := '';
  vTexto := '';
  for i := 1 to Length(Campo) do
  begin
    if (copy(Campo,i,1) = '0')
      or (copy(Campo,i,1) = '1')
      or (copy(Campo,i,1) = '2')
      or (copy(Campo,i,1) = '3')
      or (copy(Campo,i,1) = '4')
      or (copy(Campo,i,1) = '5')
      or (copy(Campo,i,1) = '6')
      or (copy(Campo,i,1) = '7')
      or (copy(Campo,i,1) = '8')
      or (copy(Campo,i,1) = '9')
      or (copy(Campo,i,1) = ',')
      or (copy(Campo,i,1) = '.') then
    begin
      if (copy(Campo,i,1) = '.') then
        vTexto := vTexto + ','
      else
        vTexto := vTexto + copy(Campo,i,1);
    end;
  end;
  Result := vTexto;
end;

function Criptografar(ABase: integer; AChave, AValue: string): string;
var
  Cipher: TJvVigenereCipher;
  Encoder: TIdEncoderMIME;
begin
  Cipher  := TJvVigenereCipher.Create(nil);
  Encoder := TIdEncoderMIME.Create(nil);
  try
    Cipher.Key := GerarSerial(ABase, AChave);
    Cipher.Decoded := AValue;
    Result := Encoder.Encode( Cipher.Encoded );
  finally
    FreeAndNil(Cipher);
    FreeAndNil(Encoder);
  end;
end;

function Descriptografar(ABase: integer; AChave, AValue: string): string;
var
  Cipher: TJvVigenereCipher;
  Decoder: TIdDecoderMIME;
begin
  Cipher  := TJvVigenereCipher.Create(nil);
  Decoder := TIdDecoderMIME.Create(nil);
  try
    Cipher.Key := GerarSerial(ABase, AChave);
    Cipher.Encoded := Decoder.DecodeToString( AValue );
    Result := Cipher.Decoded;
  finally
    FreeAndNil(Cipher);
    FreeAndNil(Decoder);
  end;
end;

function GerarSerial(ABase: Integer; AChave: string): string;
var
  SerialMaker: TJvSerialMaker;
begin
  SerialMaker := TJvSerialMaker.Create(nil);
  try
    Result := SerialMaker.GiveSerial(ABase, AChave);
  finally
    FreeAndNil(SerialMaker);
  end;
end;

function PegaTimeZone: string;
var
  TimeZone: TTimeZoneInformation;
begin
  GetTimeZoneInformation(TimeZone);
  Result := FormatFloat('00', TimeZone.Bias div -60) + ':00';
end;

function fnc_HorarioVerao: Boolean;
var
  T: TTimeZoneInformation;
begin
  Result := GetTimeZoneInformation(T) = TIME_ZONE_ID_DAYLIGHT;
end;

procedure prc_ShellExecute(MSG: String);
begin
  ShellExecute(Application.Handle, 'Open',pansichar(MSG) ,'', '',0);
end;

function fnc_Verifica_Numero(Campo : String) : Boolean;
var
  Resultado:Boolean;
  I:Integer;
begin
  Resultado := true;
  For i:=1 to Length(campo) do
    begin
      {Verifica sé é uma letra}
      if campo[i] in ['0'..'9'] then
      else
        Resultado := false;
    end;
  Result:=Resultado;
end;

procedure prc_Escolhe_Filial;
var
  ffrmEscolhe_Filial: TfrmEscolhe_Filial;
begin
  ffrmEscolhe_Filial := TfrmEscolhe_Filial.Create(frmEscolhe_Filial);
  ffrmEscolhe_Filial.ShowModal;
  FreeAndNil(ffrmEscolhe_Filial);

  if vFilial <= 0 then
    ShowMessage('Filial não informada!');
end;

end.
