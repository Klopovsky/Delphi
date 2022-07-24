unit MatrConsolve;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TForm3 = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Button6: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure OnMove(var Msg: TWMMove); message WM_MOVE;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}
uses Unit1;


procedure TForm3.FormCreate(Sender: TObject);
begin
randomize;
StringGrid1.Cells[0,0]:=floattostr(-1);
StringGrid1.Cells[0,1]:=floattostr(-1);
StringGrid1.Cells[0,2]:=floattostr(-1);
StringGrid1.Cells[1,0]:=floattostr(-1);
StringGrid1.Cells[1,1]:=floattostr(8);
StringGrid1.Cells[1,2]:=floattostr(-1);
StringGrid1.Cells[2,0]:=floattostr(-1);
StringGrid1.Cells[2,1]:=floattostr(-1);
StringGrid1.Cells[2,2]:=floattostr(-1);
end;

procedure TForm3.Button1Click(Sender: TObject);
var i,j,n:integer; LMask: T3x3FloatArray;
begin
try
   LMask[0,0] := strtofloat(StringGrid1.Cells[0,0]);
   LMask[1,0] := strtofloat(StringGrid1.Cells[0,1]);
   LMask[2,0] := strtofloat(StringGrid1.Cells[0,2]);
   LMask[0,1] := strtofloat(StringGrid1.Cells[1,0]);
   LMask[1,1] := strtofloat(StringGrid1.Cells[1,1]);
   LMask[2,1] := strtofloat(StringGrid1.Cells[1,2]);
   LMask[0,2] := strtofloat(StringGrid1.Cells[2,0]);
   LMask[1,2] := strtofloat(StringGrid1.Cells[2,1]);
   LMask[2,2] := strtofloat(StringGrid1.Cells[2,2]);
   if CheckBox2.Checked then
    begin
      LMask[1,1] := 0;
      for i:=0 to 2 do
      for j:=0 to 2 do
      if (i<>1)or(j<>1) then   LMask[1,1]:=LMask[1,1]-Lmask[i,j];
      StringGrid1.Cells[1,1]:=floattostr(lmask[1,1]);
    end;
   Form1.Convolve(LMask,0);

   Form1.view(1);
   
except ShowMessage('Error!!!');
end;
end;

procedure TForm3.OnMove(var Msg: TWMMove);
begin  
  inherited;
  form1.view(1);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
close;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
StringGrid1.Cells[0,0]:=floattostr(-1);
StringGrid1.Cells[0,1]:=floattostr(-1);
StringGrid1.Cells[0,2]:=floattostr(-1);
StringGrid1.Cells[1,0]:=floattostr(-1);
StringGrid1.Cells[1,1]:=floattostr(8);
StringGrid1.Cells[1,2]:=floattostr(-1);
StringGrid1.Cells[2,0]:=floattostr(-1);
StringGrid1.Cells[2,1]:=floattostr(-1);
StringGrid1.Cells[2,2]:=floattostr(-1);
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.view(1);
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
StringGrid1.Cells[0,0]:=floattostr(random(32)-16);
StringGrid1.Cells[0,1]:=floattostr(random(32)-16);
StringGrid1.Cells[0,2]:=floattostr(random(32)-16);
StringGrid1.Cells[1,0]:=floattostr(random(32)-16);
StringGrid1.Cells[1,1]:=floattostr(random(32)-16);
StringGrid1.Cells[1,2]:=floattostr(random(32)-16);
StringGrid1.Cells[2,0]:=floattostr(random(32)-16);
StringGrid1.Cells[2,1]:=floattostr(random(32)-16);
StringGrid1.Cells[2,2]:=floattostr(random(32)-16);
Button1.Click;
end;

procedure TForm3.Button5Click(Sender: TObject);
var i,j:integer; f:Textfile;
begin
SaveDialog1.Execute;
try
AssignFile(f,SaveDialog1.FileName);
Rewrite(f);

for i:=0 to 2 do
for j:=0 to 2 do
  begin

    writeln(f,StringGrid1.Cells[j,i]);

  end;

CloseFile(f);
Except ShowMessage('Can`t open file');

end;

end;

procedure TForm3.Button6Click(Sender: TObject);
var i,j:integer; f:Textfile;s:string[255];
begin
OpenDialog1.Execute;
try
AssignFile(f,OpenDialog1.FileName);
Reset(f);

for i:=0 to 2 do
for j:=0 to 2 do
  begin

    readln(f,s);
    StringGrid1.Cells[j,i]:=s;
  end;

CloseFile(f);
Button1.Click;
Except ShowMessage('Can`t open file');
end;
end;


end.
