object Form2: TForm2
  Left = 638
  Top = 53
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Param'
  ClientHeight = 184
  ClientWidth = 357
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 128
    Top = 130
    Width = 86
    Height = 13
    Caption = #1042#1077#1083#1080#1095#1080#1085#1072' '#1087#1086#1088#1086#1075#1072
  end
  object Label2: TLabel
    Left = 16
    Top = 45
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label3: TLabel
    Left = 328
    Top = 40
    Width = 18
    Height = 13
    Caption = '255'
  end
  object Label4: TLabel
    Left = 16
    Top = 101
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label5: TLabel
    Left = 328
    Top = 96
    Width = 18
    Height = 13
    Caption = '255'
  end
  object Label6: TLabel
    Left = 72
    Top = 162
    Width = 144
    Height = 13
    Caption = #1044#1086#1087#1091#1089#1090#1080#1084#1099#1081' '#1076#1080#1092#1092#1077#1088#1077#1085#1094#1080#1072#1083
  end
  object Button1: TButton
    Left = 288
    Top = 144
    Width = 59
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object TrackBar1: TTrackBar
    Left = 8
    Top = 8
    Width = 337
    Height = 33
    Max = 255
    TabOrder = 1
    OnChange = TrackBar1Change
  end
  object Edit1: TEdit
    Left = 224
    Top = 128
    Width = 41
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object TrackBar2: TTrackBar
    Left = 8
    Top = 64
    Width = 337
    Height = 33
    Max = 255
    TabOrder = 3
    OnChange = TrackBar2Change
  end
  object Edit2: TEdit
    Left = 224
    Top = 158
    Width = 41
    Height = 21
    TabOrder = 4
    Text = '0'
  end
end
