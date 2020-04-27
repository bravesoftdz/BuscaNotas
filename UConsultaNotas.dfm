object frmConsultaNotas: TfrmConsultaNotas
  Left = 216
  Top = 82
  Width = 1030
  Height = 345
  Caption = 'Busca Notas na Receita    (Vers'#227'o 1.0.22  20/03/2020)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 104
    Top = 152
    Width = 415
    Height = 25
    Caption = '... Aguarde, buscando documentos ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -20
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 192
    Width = 993
    Height = 97
    ScrollBars = ssVertical
    TabOrder = 0
    Visible = False
  end
  object NxPanel1: TNxPanel
    Left = 0
    Top = 0
    Width = 1022
    Height = 34
    Align = alTop
    BorderPen.Style = psClear
    UseDockManager = False
    ParentBackground = False
    TabOrder = 1
    object NxButton1: TNxButton
      Left = 84
      Top = 5
      Width = 75
      Caption = 'Empresa'
      TabOrder = 0
      OnClick = NxButton1Click
    end
    object NxButton2: TNxButton
      Left = 8
      Top = 5
      Width = 75
      Caption = 'Contador'
      TabOrder = 1
      OnClick = NxButton2Click
    end
    object NxButton3: TNxButton
      Left = 160
      Top = 5
      Width = 75
      Caption = 'Par'#226'metros'
      TabOrder = 2
      OnClick = NxButton3Click
    end
  end
  object NxPanel2: TNxPanel
    Left = 0
    Top = 34
    Width = 1022
    Height = 56
    Align = alTop
    ColorScheme = csBlue2010
    UseDockManager = False
    ParentBackground = False
    TabOrder = 2
    object Label36: TLabel
      Left = 8
      Top = 5
      Width = 101
      Height = 13
      Caption = 'CPF/CNPJ Contador:'
      Transparent = True
    end
    object Label39: TLabel
      Left = 316
      Top = 5
      Width = 129
      Height = 13
      Caption = 'CNPJ Para Baixar as Notas'
      Transparent = True
    end
    object Label1: TLabel
      Left = 584
      Top = 5
      Width = 87
      Height = 13
      Caption = 'Pasta para Salvar:'
      Transparent = True
    end
    object Label2: TLabel
      Left = 130
      Top = 5
      Width = 75
      Height = 13
      Caption = 'Notas / Cupons'
      Transparent = True
    end
    object Label3: TLabel
      Left = 462
      Top = 5
      Width = 23
      Height = 13
      Caption = 'NSU'
      Transparent = True
    end
    object Label4: TLabel
      Left = 321
      Top = 40
      Width = 61
      Height = 13
      Caption = 'F2- Pesquisa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object edtCNPJContabil: TEdit
      Left = 8
      Top = 18
      Width = 121
      Height = 21
      TabOrder = 0
      OnExit = edtCNPJContabilExit
    end
    object edtCNPJBaixarXML: TEdit
      Left = 316
      Top = 18
      Width = 145
      Height = 21
      TabOrder = 2
      OnExit = edtCNPJBaixarXMLExit
      OnKeyDown = edtCNPJBaixarXMLKeyDown
    end
    object DirectoryEdit1: TDirectoryEdit
      Left = 584
      Top = 18
      Width = 409
      Height = 21
      NumGlyphs = 1
      TabOrder = 4
    end
    object ComboBox1: TComboBox
      Left = 130
      Top = 18
      Width = 185
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnExit = ComboBox1Exit
      Items.Strings = (
        'NFe (Notas)'
        'NFCe (Cupons)')
    end
    object CurrencyEdit1: TCurrencyEdit
      Left = 462
      Top = 18
      Width = 121
      Height = 21
      AutoSize = False
      DecimalPlaces = 0
      DisplayFormat = '0'
      TabOrder = 3
      ZeroEmpty = False
    end
  end
  object btnConsultar: TNxButton
    Left = 8
    Top = 96
    Width = 113
    Height = 28
    Caption = 'Consultar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnConsultarClick
  end
  object btnContinua: TNxButton
    Left = 128
    Top = 96
    Width = 113
    Height = 28
    Caption = '...Continua'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnConsultarClick
  end
  object CheckBox1: TCheckBox
    Left = 264
    Top = 104
    Width = 233
    Height = 17
    Caption = 'Continuar a consultar autom'#225'tico'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object IdDecoderMIME: TIdDecoderMIME
    FillChar = '='
    Left = 664
    Top = 144
  end
end
