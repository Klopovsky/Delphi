object fSearch: TfSearch
  Left = 884
  Top = 119
  Width = 389
  Height = 116
  BorderIcons = []
  Caption = 'Filter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel: TsLabel
    Left = 8
    Top = 8
    Width = 87
    Height = 13
    Caption = #1060#1080#1083#1100#1090#1088#1086#1074#1072#1090#1100' '#1087#1086' '
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabel1: TsLabel
    Left = 8
    Top = 40
    Width = 11
    Height = 13
    Caption = #1086#1090
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabel2: TsLabel
    Left = 128
    Top = 40
    Width = 12
    Height = 13
    Caption = #1076#1086
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabelLAT: TsLabel
    Left = 8
    Top = 43
    Width = 38
    Height = 13
    Caption = #1064#1080#1088#1086#1090#1072
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabelLATgrad: TsLabel
    Left = 112
    Top = 43
    Width = 23
    Height = 13
    Caption = #1075#1088#1072#1076
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabelLATmin: TsLabel
    Left = 200
    Top = 43
    Width = 20
    Height = 13
    Caption = #1084#1080#1085
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabelLATsec: TsLabel
    Left = 288
    Top = 43
    Width = 18
    Height = 13
    Caption = #1089#1077#1082
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabelLONG: TsLabel
    Left = 8
    Top = 75
    Width = 43
    Height = 13
    Caption = #1044#1086#1083#1075#1086#1090#1072
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabelLONGgrad: TsLabel
    Left = 112
    Top = 75
    Width = 23
    Height = 13
    Caption = #1075#1088#1072#1076
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabelLONGmin: TsLabel
    Left = 200
    Top = 75
    Width = 20
    Height = 13
    Caption = #1084#1080#1085
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object sLabelLONGsec: TsLabel
    Left = 288
    Top = 75
    Width = 18
    Height = 13
    Caption = #1089#1077#1082
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object cbChoiceSearch: TComboBox
    Left = 100
    Top = 4
    Width = 145
    Height = 19
    Style = csOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbChoiceSearchChange
    Items.Strings = (
      #1087#1086' '#1080#1084#1077#1085#1080' '#1092#1072#1081#1083#1072
      #1087#1086' '#1076#1072#1090#1077
      #1087#1086' '#1088#1072#1079#1084#1077#1088#1091' '#1092#1072#1081#1083#1072' ('#1052#1073#1072#1081#1090')'
      #1087#1086' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1102' '#1089#1085#1080#1084#1082#1072
      #1087#1086' '#1090#1080#1087#1091' '#1089#1098#1077#1084#1082#1080
      #1087#1086' '#1072#1087#1087#1072#1088#1072#1090#1091
      #1087#1086' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1072#1084)
  end
  object Button1: TButton
    Left = 324
    Top = 5
    Width = 49
    Height = 20
    Caption = #1055#1086#1080#1089#1082
    TabOrder = 1
    OnClick = Button1Click
  end
  object sDBLookUpcbSpect: TsDBLookupComboBox
    Left = 100
    Top = 35
    Width = 145
    Height = 21
    Color = clWhite
    DropDownWidth = 100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    KeyField = 'ID'
    ListField = 'Name'
    ListSource = fDM.dsSpect
    ParentFont = False
    TabOrder = 2
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'COMBOBOX'
  end
  object sDBLookUpcbRazr: TsDBLookupComboBox
    Left = 100
    Top = 35
    Width = 145
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    KeyField = 'ID'
    ListField = 'Name'
    ListSource = fDM.dsRazr
    ParentFont = False
    TabOrder = 3
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'COMBOBOX'
  end
  object dateFirst: TsDateEdit
    Left = 24
    Top = 35
    Width = 86
    Height = 21
    AutoSize = False
    Color = clWhite
    EditMask = '!99/99/9999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 4
    Text = '  .  .    '
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Blend = 0
    GlyphMode.Grayed = False
  end
  object dateSecond: TsDateEdit
    Left = 148
    Top = 35
    Width = 86
    Height = 21
    AutoSize = False
    Color = clWhite
    EditMask = '!99/99/9999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 5
    Text = '  .  .    '
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Blend = 0
    GlyphMode.Grayed = False
  end
  object eSizeMin: TsSpinEdit
    Left = 24
    Top = 35
    Width = 89
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Visible = False
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    MaxValue = 0
    MinValue = 0
    Value = 0
  end
  object eSizeMax: TsSpinEdit
    Left = 156
    Top = 35
    Width = 89
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Visible = False
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    MaxValue = 0
    MinValue = 0
    Value = 0
  end
  object sLATgrad: TsSpinEdit
    Left = 64
    Top = 35
    Width = 41
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Text = '0'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    MaxValue = 89
    MinValue = -89
    Value = 0
  end
  object sLATmin: TsSpinEdit
    Left = 160
    Top = 35
    Width = 36
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    Text = '0'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    MaxValue = 59
    MinValue = 0
    Value = 0
  end
  object sLATsec: TsSpinEdit
    Left = 248
    Top = 35
    Width = 36
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    Text = '0'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    MaxValue = 59
    MinValue = 0
    Value = 0
  end
  object sLONGgrad: TsSpinEdit
    Left = 64
    Top = 67
    Width = 41
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    Text = '0'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    MaxValue = 179
    MinValue = -179
    Value = 0
  end
  object sLONGmin: TsSpinEdit
    Left = 160
    Top = 67
    Width = 36
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    Text = '0'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    MaxValue = 59
    MinValue = 0
    Value = 0
  end
  object sLONGsec: TsSpinEdit
    Left = 248
    Top = 67
    Width = 36
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    Text = '0'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    MaxValue = 59
    MinValue = 0
    Value = 0
  end
  object sDBLookUpcbKA: TsDBLookupComboBox
    Left = 100
    Top = 35
    Width = 145
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    KeyField = 'ID'
    ListField = 'Name'
    ListSource = fDM.dsKA
    ParentFont = False
    TabOrder = 14
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'COMBOBOX'
  end
  object eSearch: TsEdit
    Left = 9
    Top = 35
    Width = 236
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 15
    OnKeyPress = eSearchKeyPress
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
  end
  object Button2: TButton
    Left = 324
    Top = 69
    Width = 49
    Height = 20
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 16
    OnClick = Button2Click
  end
end
