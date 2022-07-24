unit propCon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry, ComCtrls, ShellCtrls;

type
  TFConProperty = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  StrKeyDest: string = 'Disk';
  StrKeyDataSource: string = 'DataSource';
var
  FConProperty: TFConProperty;

implementation

{$R *.dfm}

var Reg: TRegistry;



procedure TFConProperty.Button2Click(Sender: TObject);
begin
try
Reg := TRegistry.Create();
Reg.RootKey := HKEY_LOCAL_MACHINE;
Reg.OpenKey('SOFTWARE\DZZServer',true);
Reg.WriteString('DataSource',Edit1.Text);
if Edit2.Text[length(Edit2.Text)]<>'\' then Edit2.Text:=edit2.Text + '\';
Reg.WriteString('Disk',Edit2.Text);
except
ShowMessage('Не могу записать данные в реестр');
end;
reg.CloseKey;
Reg.Free;

Close();


end;

procedure TFConProperty.FormShow(Sender: TObject);
begin
try
Reg := TRegistry.Create();
Reg.RootKey := HKEY_LOCAL_MACHINE;
Reg.OpenKey('SOFTWARE\DZZServer',true);
Edit1.Text:=Reg.ReadString('DataSource');
Edit2.Text:=Reg.ReadString('Disk');
except
Edit1.Text:='Нет данных';
Edit2.Text:='Нет данных';
end;
reg.CloseKey;
Reg.Free;


end;

end.
