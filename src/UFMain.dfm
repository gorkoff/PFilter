object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1043#1086#1088#1100#1082#1086#1074' '#1040'. - '#1060#1080#1083#1100#1090#1088#1072#1094#1080#1103
  ClientHeight = 388
  ClientWidth = 969
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    9999999999999999999999999999999999999999999999999999999999999900
    0000000000000000000000000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900099999999000000999900
    0000999990009999999900000099990000009999900099999999000000999900
    0000999990009999999900000099990000009999900099999999000000999900
    0000999990000000000000000099990000009999900000000000000000999900
    0000999990000000000000000099990000009999900000000000000000999900
    0000999990000000000000000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999900000009999000000999900
    0000999990000000999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000009999999999999999000000999900
    0000999999999999999900000099990000000000000000000000000000999999
    9999999999999999999999999999999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object IIn: TImage
    Left = 8
    Top = 8
    Width = 345
    Height = 345
    Center = True
    Proportional = True
    Stretch = True
    OnDblClick = IInDblClick
  end
  object IOut: TImage
    Left = 615
    Top = 8
    Width = 345
    Height = 345
    Center = True
    ParentShowHint = False
    Proportional = True
    ShowHint = False
    Stretch = True
    OnDblClick = IOutDblClick
  end
  object BFilter: TButton
    Left = 8
    Top = 359
    Width = 952
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1092#1080#1083#1100#1090#1088#1072#1094#1080#1102
    TabOrder = 0
    OnClick = BFilterClick
  end
  object RGFilterSelect: TRadioGroup
    Left = 359
    Top = 88
    Width = 250
    Height = 265
    Caption = #1042#1099#1073#1086#1088' '#1092#1080#1083#1100#1090#1088#1072':'
    ItemIndex = 0
    Items.Strings = (
      #1059#1089#1088#1077#1076#1085#1103#1102#1097#1080#1081' ('#1089#1088#1077#1076#1085#1077#1077' '#1072#1088#1080#1092#1084#1077#1090#1080#1095#1077#1089#1082#1086#1077')'
      #1059#1089#1088#1077#1076#1085#1103#1102#1097#1080#1081' ('#1089#1088#1077#1076#1085#1077#1077' '#1075#1077#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1086#1077')'
      #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' ('#1084#1077#1076#1080#1072#1085#1085#1099#1081')'
      #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' ('#1084#1072#1082#1089#1080#1084#1091#1084')'
      #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' ('#1084#1080#1085#1080#1084#1091#1084')'
      #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' ('#1089#1088#1077#1076#1080#1085#1085#1072#1103' '#1090#1086#1095#1082#1072')')
    TabOrder = 1
  end
  object GBFilterParams: TGroupBox
    Left = 359
    Top = 8
    Width = 250
    Height = 74
    Caption = #1040#1087#1077#1088#1090#1091#1088#1072' '#1092#1080#1083#1100#1090#1088#1072
    TabOrder = 2
    object LEFilterN: TLabeledEdit
      Left = 51
      Top = 40
      Width = 30
      Height = 21
      EditLabel.Width = 35
      EditLabel.Height = 13
      EditLabel.Caption = #1057#1090#1088#1086#1082':'
      ReadOnly = True
      TabOrder = 0
      Text = '1'
    end
    object UDFilterN: TUpDown
      Left = 81
      Top = 40
      Width = 16
      Height = 21
      Associate = LEFilterN
      Position = 1
      TabOrder = 1
    end
    object UDFilterM: TUpDown
      Left = 181
      Top = 40
      Width = 16
      Height = 21
      Associate = LEFilterM
      Position = 1
      TabOrder = 2
    end
    object LEFilterM: TLabeledEdit
      Left = 151
      Top = 40
      Width = 30
      Height = 21
      EditLabel.Width = 53
      EditLabel.Height = 13
      EditLabel.Caption = #1057#1090#1086#1083#1073#1094#1086#1074':'
      ReadOnly = True
      TabOrder = 3
      Text = '1'
    end
  end
  object OPD1: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 16
    Top = 16
  end
end
