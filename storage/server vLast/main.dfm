object fMain: TfMain
  Left = -2
  Top = 168
  Width = 266
  Height = 90
  Caption = 'Server Application '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 232
    Top = 13
    Width = 12
    Height = 24
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 0
    Top = 16
    Width = 222
    Height = 20
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1081' -->'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object MainMenu1: TMainMenu
    Top = 24
    object N1: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1080#1090#1100
      OnClick = N1Click
    end
  end
end
