object DZZRDM: TDZZRDM
  OldCreateOrder = False
  OnCreate = RemoteDataModuleCreate
  OnDestroy = RemoteDataModuleDestroy
  Left = 804
  Top = 144
  Height = 756
  Width = 445
  object ADOConnection1: TADOConnection
    CommandTimeout = 120
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=DZZ;Data Source=111v\SQLTEST'
    ConnectionTimeout = 60
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 32
    Top = 8
  end
  object tKA: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandTimeout = 120
    TableName = 'KA'
    Left = 96
    Top = 248
  end
  object dsKA: TDataSource
    DataSet = tKA
    Left = 208
    Top = 248
  end
  object dspKA: TDataSetProvider
    DataSet = tKA
    Left = 320
    Top = 248
  end
  object qViewAll: TADOQuery
    Connection = ADOConnection1
    CommandTimeout = 120
    ParamCheck = False
    Parameters = <>
    SQL.Strings = (
      'USE DZZ;'
      
        'SELECT     Pict.ID, KA.Name AS '#39#1040#1087#1087#1072#1088#1072#1090#39', Marsh.Name AS '#39#1052#1072#1088#1096#1088#1091#1090 +
        #39','
      '  Pict.Name AS '#39#1060#1072#1081#1083#39', Marsh.Dir AS '#39#1044#1080#1088#1077#1082#1090#1086#1088#1080#1103#39','
      '  Marsh.NW.STAsText() AS '#39#1057#1047#39','
      
        '           Marsh.NE.STAsText() AS '#39#1057#1042#39', Marsh.SE.STAsText() AS '#39 +
        #1070#1042#39', '
      '     Marsh.SW.STAsText() AS '#39#1070#1047#39
      ''
      'FROM         KA INNER JOIN'
      '                      Marsh ON KA.ID = Marsh.ID_KA INNER JOIN'
      '                      Pict ON Marsh.ID = Pict.ID_Marsh'
      '')
    Left = 96
    Top = 56
  end
  object dsQViewAll: TDataSource
    DataSet = qViewAll
    Left = 208
    Top = 56
  end
  object dspQViewAll: TDataSetProvider
    DataSet = qViewAll
    Left = 320
    Top = 56
  end
  object qGetFullInfo: TADOQuery
    Connection = ADOConnection1
    CommandTimeout = 120
    Parameters = <
      item
        Name = 'param'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end>
    Prepared = True
    SQL.Strings = (
      'use DZZ;'
      
        'SELECT     Marsh.Name AS '#39#1052#1072#1088#1096#1088#1091#1090#39', Marsh.Locat AS '#39#1052#1077#1089#1090#1085#1086#1089#1090#1100#39', ' +
        'KA.Name AS '#39#1040#1087#1087#1072#1088#1072#1090#39','
      
        '           KA.Descript AS '#39#1054#1087#1080#1089#1072#1085#1080#1077' '#1072#1087#1087#1072#1088#1072#1090#1072#39', Pict.ID AS '#39#1059#1085#1080#1082#1072 +
        #1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1092#1072#1081#1083#1072#39', Pict.Name AS '#39#1060#1072#1081#1083#39','
      
        '           Pict.Date AS '#39#1044#1072#1090#1072' '#1089#1098#1077#1084#1082#1080#39', Pict.Size AS '#39#1056#1072#1079#1084#1077#1088' '#1092#1072#1081#1083 +
        #1072#39', Marsh.NW.STAsText() AS '#39#1057#1047#39','
      
        '           Marsh.NE.STAsText() AS '#39#1057#1042#39', Marsh.SE.STAsText() AS '#39 +
        #1070#1042#39', '
      '     Marsh.SW.STAsText() AS '#39#1070#1047#39', '
      '           Pict.Descript AS '#39#1054#1087#1080#1089#1072#1085#1080#1077' '#1092#1072#1081#1083#1072#39','
      '           Passport.Name AS '#39#1055#1072#1089#1087#1086#1088#1090#39','
      
        '           Razr.Name AS '#39#1056#1072#1079#1088#1077#1096#1077#1085#1080#1077#39', Razr.Descript AS '#39#1054#1087#1080#1089#1072#1085#1080#1077 +
        ' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103#39','
      
        '           Spect.Name AS '#39#1057#1087#1077#1082#1090#1088' '#1089#1098#1077#1084#1082#1080#39', Spect.Descript AS '#39#1054#1087#1080 +
        #1089#1072#1085#1080#1077' '#1089#1087#1077#1082#1090#1088#1072#39', '
      '           Quality.Descript AS '#39#1050#1072#1095#1077#1089#1090#1074#1086#39', '
      
        '           Spect.ID AS Spect, Razr.ID AS Razr, Quality.Rate AS R' +
        'ate, KA.ID AS KA '
      'FROM         KA INNER JOIN'
      '                      Marsh ON KA.ID = Marsh.ID_KA INNER JOIN'
      
        '                      Pict ON Marsh.ID = Pict.ID_Marsh INNER JOI' +
        'N'
      
        '                      Passport ON Pict.ID_Pass = Passport.ID INN' +
        'ER JOIN'
      
        '                      Quality ON Pict.Quality = Quality.Rate INN' +
        'ER JOIN'
      '                      Razr ON Pict.Razr = Razr.ID INNER JOIN'
      '                      Spect ON Pict.Spect = Spect.ID'
      'WHERE       Pict.ID =:param  ')
    Left = 96
    Top = 104
  end
  object dsGetFullInfo: TDataSource
    DataSet = qGetFullInfo
    Left = 208
    Top = 104
  end
  object dspGetFullInfo: TDataSetProvider
    DataSet = qGetFullInfo
    Left = 320
    Top = 104
  end
  object qFindPassport: TADOQuery
    Connection = ADOConnection1
    CommandTimeout = 120
    Parameters = <
      item
        Name = 'IdPict'
        DataType = ftInteger
        Value = 0
      end>
    Prepared = True
    SQL.Strings = (
      'USE DZZ;'
      'SELECT     top(1) Passport.Path, Passport.Name'
      'FROM         Passport INNER JOIN'
      '                      Pict ON Passport.ID = Pict.ID_Pass'
      'WHERE Pict.ID =:IdPict')
    Left = 96
    Top = 152
  end
  object dsFindPassport: TDataSource
    DataSet = qFindPassport
    Left = 208
    Top = 152
  end
  object dspFindPassport: TDataSetProvider
    DataSet = qFindPassport
    Left = 320
    Top = 152
  end
  object qUser: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    LockType = ltBatchOptimistic
    CommandTimeout = 120
    Parameters = <
      item
        Name = 'user'
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 50
        Value = ''
      end>
    Prepared = True
    SQL.Strings = (
      'USE DZZ;'
      ''
      'SELECT top(1) Users.access'
      'FROM Users'
      'WHERE Login=:user')
    Left = 96
    Top = 8
  end
  object tSpect: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandTimeout = 120
    EnableBCD = False
    TableDirect = True
    TableName = 'Spect'
    Left = 96
    Top = 200
  end
  object dsSpect: TDataSource
    DataSet = tSpect
    Left = 208
    Top = 200
  end
  object dspSpect: TDataSetProvider
    DataSet = tSpect
    Left = 320
    Top = 200
  end
  object tRazr: TADOTable
    Connection = ADOConnection1
    LockType = ltReadOnly
    CommandTimeout = 120
    TableName = 'Razr'
    Left = 96
    Top = 296
  end
  object tQuality: TADOTable
    Connection = ADOConnection1
    LockType = ltReadOnly
    CommandTimeout = 120
    TableName = 'Quality'
    Left = 96
    Top = 344
  end
  object dsRazr: TDataSource
    DataSet = tRazr
    Left = 208
    Top = 296
  end
  object dsQuality: TDataSource
    DataSet = tQuality
    Left = 208
    Top = 344
  end
  object dspRazr: TDataSetProvider
    DataSet = tRazr
    Left = 320
    Top = 296
  end
  object dspQuality: TDataSetProvider
    DataSet = tQuality
    Left = 320
    Top = 344
  end
  object qAddRecord: TADOQuery
    Connection = ADOConnection1
    CommandTimeout = 120
    ParamCheck = False
    Parameters = <>
    Prepared = True
    SQL.Strings = (
      '')
    Left = 96
    Top = 488
  end
  object qFindUni: TADOQuery
    Connection = ADOConnection1
    CommandTimeout = 120
    ParamCheck = False
    Parameters = <>
    Left = 96
    Top = 392
  end
  object dsFindUni: TDataSource
    DataSet = qFindUni
    Left = 208
    Top = 392
  end
  object dspFindUni: TDataSetProvider
    DataSet = qFindUni
    Left = 320
    Top = 392
  end
  object qLogger: TADOQuery
    Connection = ADOConnection1
    CommandTimeout = 120
    ParamCheck = False
    Parameters = <>
    Prepared = True
    Left = 96
    Top = 536
  end
  object qUpdateStatusPict: TADOQuery
    Connection = ADOConnection1
    CommandTimeout = 120
    ParamCheck = False
    Parameters = <>
    Prepared = True
    SQL.Strings = (
      '')
    Left = 96
    Top = 584
  end
  object qGetMarshDir: TADOQuery
    Connection = ADOConnection1
    CommandTimeout = 120
    Parameters = <
      item
        Name = 'param'
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 100
        Value = '0'
      end
      item
        Name = 'ParamKA'
        Size = -1
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'use DZZ;'
      'SELECT   TOP(1)  Marsh.Dir'
      'FROM  Marsh  '
      ''
      'WHERE Marsh.Name =:Param '
      'AND Marsh.ID_KA = (SELECT ID FROM KA WHERE KA.Name = :ParamKA)  ')
    Left = 96
    Top = 632
  end
  object qFindAllPassports: TADOQuery
    Connection = ADOConnection1
    CommandTimeout = 120
    Parameters = <
      item
        Name = 'MarshName'
        DataType = ftWideString
        Size = -1
        Value = ''
      end>
    Prepared = True
    SQL.Strings = (
      'USE DZZ;'
      'SELECT Passport.Path, Passport.Name'
      'FROM Passport INNER JOIN'
      '     Marsh ON Passport.ID_Marsh = Marsh.ID'
      'WHERE Marsh.Name = :MarshName')
    Left = 96
    Top = 440
  end
  object dsFindAllPassports: TDataSource
    DataSet = qFindAllPassports
    Left = 208
    Top = 440
  end
  object dspFindAllPassports: TDataSetProvider
    DataSet = qFindAllPassports
    Left = 320
    Top = 440
  end
end
