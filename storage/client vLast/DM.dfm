object fDM: TfDM
  OldCreateOrder = False
  Left = 548
  Top = 321
  Height = 546
  Width = 298
  object SocketConn: TSocketConnection
    Tag = -1
    ServerGUID = '{3F6BD6B1-BE14-4A32-BD15-25CF585CC399}'
    ServerName = 'DZZServApp.DZZRDM'
    OnLogin = SocketConnLogin
    Left = 16
    Top = 8
  end
  object cdsQViewAll: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'ident'
        ParamType = ptUnknown
        Value = 0
      end>
    ProviderName = 'dspQViewAll'
    RemoteServer = SocketConn
    StoreDefs = True
    Left = 104
    Top = 8
  end
  object dsQViewAll: TDataSource
    DataSet = cdsQViewAll
    Left = 200
    Top = 8
  end
  object cdsGetAllInfo: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGetFullInfo'
    RemoteServer = SocketConn
    Left = 104
    Top = 64
  end
  object dsGetAllInfo: TDataSource
    DataSet = cdsGetAllInfo
    Left = 200
    Top = 64
  end
  object cdsFindPassport: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspFindPassport'
    RemoteServer = SocketConn
    Left = 104
    Top = 120
  end
  object dsFindPassport: TDataSource
    DataSet = cdsFindPassport
    Left = 200
    Top = 120
  end
  object cdsSpect: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspSpect'
    ReadOnly = True
    RemoteServer = SocketConn
    Left = 104
    Top = 176
  end
  object dsSpect: TDataSource
    DataSet = cdsSpect
    Left = 200
    Top = 176
  end
  object cdsRazr: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspRazr'
    ReadOnly = True
    RemoteServer = SocketConn
    Left = 104
    Top = 232
  end
  object dsRazr: TDataSource
    DataSet = cdsRazr
    Left = 200
    Top = 232
  end
  object cdsQuality: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspQuality'
    ReadOnly = True
    RemoteServer = SocketConn
    Left = 104
    Top = 288
  end
  object cdsKA: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspKA'
    ReadOnly = True
    RemoteServer = SocketConn
    Left = 104
    Top = 344
  end
  object dsQuality: TDataSource
    DataSet = cdsQuality
    Left = 200
    Top = 288
  end
  object dsKA: TDataSource
    DataSet = cdsKA
    Left = 200
    Top = 344
  end
  object cdsFindU: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspFindUni'
    ReadOnly = True
    RemoteServer = SocketConn
    Left = 104
    Top = 400
  end
  object dsFindU: TDataSource
    DataSet = cdsFindU
    Left = 200
    Top = 400
  end
  object cdsFindAllPassports: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspFindAllPassports'
    RemoteServer = SocketConn
    Left = 104
    Top = 456
  end
  object dsFindAllPassports: TDataSource
    DataSet = cdsFindAllPassports
    Left = 200
    Top = 456
  end
end