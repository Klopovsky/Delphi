unit DM;

interface

uses
  SysUtils, DB, DBClient, Classes, MConnect, SConnect, Dialogs;

type
  TfDM = class(TDataModule)
    SocketConn: TSocketConnection;
    cdsQViewAll: TClientDataSet;
    dsQViewAll: TDataSource;
    cdsGetAllInfo: TClientDataSet;
    dsGetAllInfo: TDataSource;
    cdsFindPassport: TClientDataSet;
    dsFindPassport: TDataSource;
    cdsSpect: TClientDataSet;
    dsSpect: TDataSource;
    cdsRazr: TClientDataSet;
    dsRazr: TDataSource;
    cdsQuality: TClientDataSet;
    cdsKA: TClientDataSet;
    dsQuality: TDataSource;
    dsKA: TDataSource;
    cdsFindU: TClientDataSet;
    dsFindU: TDataSource;
    cdsFindAllPassports: TClientDataSet;
    dsFindAllPassports: TDataSource;
    procedure SocketConnLogin(Sender: TObject; Username, Password: String);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDM: TfDM; us,pass:string;

implementation



{$R *.dfm}


procedure TfDM.SocketConnLogin(Sender: TObject; Username,
  Password: String);

begin
if (Username='')and(Password='') then
  begin
    SocketConn.Close;
    exit;
  end
else begin
      us:=Username;
      pass:=Password;
      if SocketConn.LoginPrompt then SocketConn.LoginPrompt:=false;
     end;

end;




end.
