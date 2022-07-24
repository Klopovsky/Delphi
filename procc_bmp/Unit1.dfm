object Form1: TForm1
  Left = 189
  Top = 105
  AlphaBlendValue = 100
  BorderStyle = bsSingle
  Caption = 'RedIm'
  ClientHeight = 16
  ClientWidth = 516
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar1: TProgressBar
    Left = 0
    Top = -8
    Width = 513
    Height = 16
    ParentShowHint = False
    Smooth = True
    Step = 1
    ShowHint = False
    TabOrder = 0
    Visible = False
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object Fi1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N2: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100'...'
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100'...'
      end
    end
    object N1: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
      object N6: TMenuItem
        Caption = #1074#1085#1077#1096#1085#1080#1081' '#1092#1088#1086#1085#1090
        OnClick = N6Click
      end
      object notalowed1: TMenuItem
        Caption = 'not alowed'
        OnClick = notalowed1Click
      end
      object N7: TMenuItem
        Caption = #1057#1074#1077#1088#1090#1082#1072
        OnClick = N7Click
      end
      object random1: TMenuItem
        Caption = 'random'
        OnClick = random1Click
      end
    end
    object N4: TMenuItem
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = #1040#1085#1072#1083#1080#1079
      object N9: TMenuItem
        Caption = #1043#1080#1089#1090#1086#1075#1088#1072#1084#1084#1072
        OnClick = N9Click
      end
      object N10: TMenuItem
        Caption = #1044#1080#1072#1075#1088#1072#1084#1084#1072' '#1088#1072#1089#1089#1077#1103#1085#1080#1103
        OnClick = N10Click
      end
    end
    object N8: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = N8Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.bmp|*.bmp'
    Left = 56
    Top = 8
  end
end
