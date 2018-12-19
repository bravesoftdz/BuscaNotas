object frmSel_Filial: TfrmSel_Filial
  Left = 230
  Top = 173
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmSel_Filial'
  ClientHeight = 446
  ClientWidth = 748
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 748
    Height = 30
    Align = alTop
    Color = 13565853
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Nome:'
    end
    object Edit1: TEdit
      Left = 48
      Top = 4
      Width = 321
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnKeyDown = Edit1KeyDown
    end
    object btnConsultar: TNxButton
      Left = 374
      Top = 3
      Width = 75
      Caption = 'Consultar'
      TabOrder = 1
      OnClick = btnConsultarClick
    end
  end
  object SMDBGrid1: TSMDBGrid
    Left = 0
    Top = 30
    Width = 748
    Height = 399
    Align = alClient
    Ctl3D = False
    DataSource = dsFilial
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = SMDBGrid1DblClick
    OnKeyDown = SMDBGrid1KeyDown
    OnTitleClick = SMDBGrid1TitleClick
    Flat = True
    BandsFont.Charset = DEFAULT_CHARSET
    BandsFont.Color = clWindowText
    BandsFont.Height = -11
    BandsFont.Name = 'MS Sans Serif'
    BandsFont.Style = []
    Groupings = <>
    GridStyle.Style = gsCustom
    GridStyle.OddColor = clWindow
    GridStyle.EvenColor = clWindow
    TitleHeight.PixelCount = 24
    FooterColor = clBtnFace
    ExOptions = [eoDisableDelete, eoDisableInsert, eoENTERlikeTAB, eoKeepSelection, eoStandardPopup, eoBLOBEditor, eoTitleWordWrap, eoShowFilterBar]
    RegistryKey = 'Software\Scalabium'
    RegistrySection = 'SMDBGrid'
    WidthOfIndicator = 11
    DefaultRowHeight = 17
    ScrollBars = ssHorizontal
    ColCount = 4
    RowCount = 2
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'ID'
        Title.Alignment = taCenter
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME'
        Title.Alignment = taCenter
        Title.Caption = 'Nome'
        Width = 420
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CNPJ_CPF'
        Title.Alignment = taCenter
        Title.Caption = 'CNPJ'
        Width = 218
        Visible = True
      end>
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 429
    Width = 748
    Height = 17
    Align = alBottom
    BorderStyle = sbsSingle
    Caption = 
      'Duplo Clique  ou   Enter para selecionar o registro       ESC= F' +
      'echar tela'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object sdsFilial: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 'SELECT *'#13#10'FROM FILIAL'#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.scoDados
    Left = 208
    Top = 168
  end
  object cdsFilial: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'NOME'
    Params = <>
    ProviderName = 'dspFilial'
    Left = 304
    Top = 168
    object cdsFilialID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object cdsFilialNOME: TStringField
      FieldName = 'NOME'
      Size = 60
    end
    object cdsFilialPESSOA: TStringField
      FieldName = 'PESSOA'
      FixedChar = True
      Size = 1
    end
    object cdsFilialCNPJ_CPF: TStringField
      FieldName = 'CNPJ_CPF'
      Size = 18
    end
    object cdsFilialINSCR_EST: TStringField
      FieldName = 'INSCR_EST'
      Size = 18
    end
  end
  object dspFilial: TDataSetProvider
    DataSet = sdsFilial
    Left = 256
    Top = 168
  end
  object dsFilial: TDataSource
    DataSet = cdsFilial
    Left = 360
    Top = 168
  end
end
