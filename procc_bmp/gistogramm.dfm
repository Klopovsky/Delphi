object Form5: TForm5
  Left = 1169
  Top = 285
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = #1043#1080#1089#1090#1086#1075#1088#1072#1084#1084#1072
  ClientHeight = 238
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 8
    Top = 8
    Width = 256
    Height = 200
  end
  object PaintBox2: TPaintBox
    Left = 8
    Top = 216
    Width = 256
    Height = 20
  end
  object Button1: TButton
    Left = 272
    Top = 8
    Width = 51
    Height = 17
    Caption = #1040#1085#1072#1083#1080#1079
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 271
    Top = 211
    Width = 51
    Height = 17
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 1
    OnClick = Button2Click
  end
  object RadioButton1: TRadioButton
    Left = 272
    Top = 72
    Width = 113
    Height = 17
    Caption = 'Red'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 272
    Top = 88
    Width = 113
    Height = 17
    Caption = 'Green'
    TabOrder = 3
    OnClick = RadioButton1Click
  end
  object RadioButton3: TRadioButton
    Left = 272
    Top = 104
    Width = 113
    Height = 17
    Caption = 'Blue'
    TabOrder = 4
    OnClick = RadioButton1Click
  end
  object RadioButton4: TRadioButton
    Left = 272
    Top = 128
    Width = 113
    Height = 17
    Caption = 'RGB'
    TabOrder = 5
    OnClick = RadioButton1Click
  end
end
