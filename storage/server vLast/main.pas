unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, DB, ADODB, Menus;

type
  TfMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation
//uses RDMDZZ,configServ;

{$R *.dfm}
uses propCon;

procedure TfMain.FormCreate(Sender: TObject);
begin
Caption := 'version 2.56 27.07.2017';

end;

procedure TfMain.N1Click(Sender: TObject);
begin
FConProperty.ShowModal;
end;

end.