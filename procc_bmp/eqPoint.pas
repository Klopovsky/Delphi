unit eqPoint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    TrackBar1: TTrackBar;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TrackBar2: TTrackBar;
    Label6: TLabel;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure OnMove(var Msg: TWMMove); message WM_MOVE;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm2.Button1Click(Sender: TObject);
begin
Form1.view(1);
close;

end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin

Edit1.Text:=inttostr(TrackBar1.Position);
Form1.extrPoint(TrackBar1.Position);
form1.view(1);
end;

procedure TForm2.TrackBar2Change(Sender: TObject);
begin
Edit2.Text:=inttostr(TrackBar2.Position);
Form1.extrPoint(TrackBar1.Position);
form1.view(1);
end;

procedure TForm2.OnMove(var Msg: TWMMove);
begin  
  inherited;
  form1.view(1);
end;


procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.view(1);
end;

end.
