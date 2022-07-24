object fMain: TfMain
  Left = 192
  Top = 107
  Width = 711
  Height = 455
  Caption = 'fMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 703
    Height = 27
    Align = alTop
    AutoSize = True
    TabOrder = 0
    object DBNavigator1: TDBNavigator
      Left = 0
      Top = 1
      Width = 240
      Height = 25
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 27
    Width = 703
    Height = 251
    Align = alClient
    TabOrder = 1
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 701
      Height = 249
      Align = alClient
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 278
    Width = 703
    Height = 150
    Align = alBottom
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 0
      Top = 1
      Width = 441
      Height = 144
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object bConnect: TButton
      Left = 560
      Top = 8
      Width = 121
      Height = 17
      Caption = 'Connect to base'
      TabOrder = 1
    end
    object bRefresh: TButton
      Left = 560
      Top = 32
      Width = 121
      Height = 17
      Caption = 'Update data'
      TabOrder = 2
    end
    object bSaveToDB: TButton
      Left = 560
      Top = 56
      Width = 121
      Height = 17
      Caption = 'Save to base'
      TabOrder = 3
    end
    object bUnConnect: TButton
      Left = 560
      Top = 80
      Width = 121
      Height = 17
      Caption = 'Disconnect'
      TabOrder = 4
    end
    object bSaveToFile: TButton
      Left = 560
      Top = 104
      Width = 121
      Height = 17
      Caption = 'Save data to file'
      TabOrder = 5
    end
    object bLoadFromFile: TButton
      Left = 560
      Top = 128
      Width = 121
      Height = 17
      Caption = 'Load data from file'
      TabOrder = 6
    end
  end
end
