object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Add Point'
  ClientHeight = 128
  ClientWidth = 494
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 19
    Width = 40
    Height = 13
    Caption = #1064#1080#1088#1086#1090#1072
  end
  object LabelLat: TLabel
    Left = 318
    Top = 19
    Width = 3
    Height = 13
  end
  object Label5: TLabel
    Left = 23
    Top = 59
    Width = 43
    Height = 13
    Caption = #1044#1086#1083#1075#1086#1090#1072
  end
  object LabelLong: TLabel
    Left = 318
    Top = 59
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 28
    Top = 85
    Width = 38
    Height = 13
    Caption = #1060#1086#1088#1084#1072#1090
  end
  object Button1: TButton
    Left = 423
    Top = 96
    Width = 63
    Height = 24
    Caption = 'Add Point'
    TabOrder = 0
    OnClick = Button1Click
  end
  object LatGradSpin: TSpinEdit
    Left = 72
    Top = 16
    Width = 57
    Height = 22
    MaxValue = 89
    MinValue = 0
    TabOrder = 1
    Value = 0
    OnChange = LatGradSpinChange
  end
  object LatMinSpin: TSpinEdit
    Left = 144
    Top = 16
    Width = 57
    Height = 22
    MaxValue = 59
    MinValue = 0
    TabOrder = 2
    Value = 0
    OnChange = LatMinSpinChange
  end
  object LatSecSpin: TSpinEdit
    Left = 215
    Top = 16
    Width = 57
    Height = 22
    MaxValue = 59
    MinValue = 0
    TabOrder = 3
    Value = 0
    OnChange = LatSecSpinChange
  end
  object LongGradSpin: TSpinEdit
    Left = 72
    Top = 56
    Width = 57
    Height = 22
    MaxValue = 179
    MinValue = 0
    TabOrder = 4
    Value = 0
    OnChange = LongGradSpinChange
  end
  object LongMinSpin: TSpinEdit
    Left = 144
    Top = 56
    Width = 57
    Height = 22
    MaxValue = 59
    MinValue = 0
    TabOrder = 5
    Value = 0
    OnChange = LongMinSpinChange
  end
  object LongSecSpin: TSpinEdit
    Left = 215
    Top = 56
    Width = 57
    Height = 22
    MaxValue = 59
    MinValue = 0
    TabOrder = 6
    Value = 0
    OnChange = LongSecSpinChange
  end
  object LatComboBox: TComboBox
    Left = 278
    Top = 16
    Width = 34
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 7
    Text = 'N'
    OnChange = LatComboBoxChange
    Items.Strings = (
      'N'
      'S')
  end
  object LongComboBox: TComboBox
    Left = 278
    Top = 56
    Width = 34
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 8
    Text = 'E'
    OnChange = LongComboBoxChange
    Items.Strings = (
      'E'
      'W')
  end
  object RadioButton1: TRadioButton
    Left = 72
    Top = 84
    Width = 168
    Height = 17
    Caption = #1043#1088#1072#1076#1091#1089#1099', '#1084#1080#1085#1091#1090#1099', '#1089#1077#1082#1091#1085#1076#1099
    Checked = True
    TabOrder = 9
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 72
    Top = 103
    Width = 185
    Height = 17
    Caption = #1043#1088#1072#1076#1091#1089#1099' ('#1074#1077#1097#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1095#1080#1089#1083#1086')'
    TabOrder = 10
    OnClick = RadioButton2Click
  end
  object LatGrad: TEdit
    Left = 72
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 11
    Text = '0'
    Visible = False
    OnKeyPress = LatGradKeyPress
  end
  object LongGrad: TEdit
    Left = 72
    Top = 57
    Width = 121
    Height = 21
    TabOrder = 12
    Text = '0'
    Visible = False
    OnKeyPress = LongGradKeyPress
  end
end
