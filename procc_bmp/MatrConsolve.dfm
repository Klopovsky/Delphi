object Form3: TForm3
  Left = 842
  Top = 156
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Consolve Matrix'
  ClientHeight = 116
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 8
    Top = 8
    Width = 105
    Height = 81
    ColCount = 3
    DefaultColWidth = 32
    FixedCols = 0
    RowCount = 3
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
  end
  object Button1: TButton
    Left = 184
    Top = 8
    Width = 57
    Height = 17
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 32
    Width = 57
    Height = 17
    Caption = 'Close'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 96
    Width = 49
    Height = 17
    Caption = 'Normal'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 64
    Top = 96
    Width = 49
    Height = 17
    Caption = 'random'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 128
    Top = 32
    Width = 33
    Height = 17
    Caption = 'Save'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 128
    Top = 8
    Width = 33
    Height = 17
    Caption = 'Open'
    TabOrder = 6
    OnClick = Button6Click
  end
  object CheckBox1: TCheckBox
    Left = 128
    Top = 72
    Width = 105
    Height = 17
    Caption = #1040#1074#1090#1086#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077
    TabOrder = 7
  end
  object CheckBox2: TCheckBox
    Left = 128
    Top = 96
    Width = 105
    Height = 17
    Caption = #1058#1086#1083#1100#1082#1086' '#1082#1086#1085#1090#1091#1088#1072
    TabOrder = 8
  end
  object SaveDialog1: TSaveDialog
    Filter = 'txt|txt'
    Left = 32
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.txt|*.txt'
  end
end