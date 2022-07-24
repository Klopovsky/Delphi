unit gistogramm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm5 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses Unit1, DateUtils;

{$R *.dfm}



procedure TForm5.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TForm5.Button1Click(Sender: TObject);
var i,j,max:integer;gist:array[0..255,0..2] of integer;clr:byte;
begin
for j:=0 to 2 do
for i:=0 to 255 do
gist[i,j]:=0;


if RadioButton1.Checked then clr:=0;
if RadioButton2.Checked then clr:=1;
if RadioButton3.Checked then clr:=2;
if RadioButton4.Checked then clr:=3;

for i:=0 to resX-1 do
  for j:=0 to resY-1 do
    begin
      inc(gist[WorkDes[i,j,0],0]);
      inc(gist[WorkDes[i,j,1],1]);
      inc(gist[WorkDes[i,j,2],2]);
    end;
max:=1;
for i:=0 to 255 do
for j:=0 to 2 do
if gist[i,j]>max then max:=gist[i,j];
With PaintBox1 do
  begin
    Canvas.Brush.Color := ClWhite;
    Canvas.FillRect(Canvas.ClipRect);
    if clr=3 then
      PaintBox2.Canvas.Pen.Color:=$00000000
    else
      PaintBox2.Canvas.Pen.Color:=$00FFFFFF;
    Canvas.Pen.Mode:=pmNotXor;

    for i:=0 to 255 do
      begin
        if clr=3 then
          begin
            Canvas.Pen.Color:=clRed;
            Canvas.MoveTo(i,Height);
            Canvas.LineTo(i,Height-round((Height*gist[i,0])/max));
            Canvas.Pen.Color:=clGreen;
            Canvas.MoveTo(i,Height);
            Canvas.LineTo(i,Height-round((Height*gist[i,1])/max));
            Canvas.Pen.Color:=clBlue;
            Canvas.MoveTo(i,Height);
            Canvas.LineTo(i,Height-round((Height*gist[i,2])/max));
          end
        else
          begin
            Canvas.Pen.Color:=clBlack;
            Canvas.MoveTo(i,Height);
            Canvas.LineTo(i,Height-round((Height*gist[i,clr])/max));
          end;
        PaintBox2.Canvas.MoveTo(i,PaintBox2.Height);
        if i>0 then
          begin
            case clr of
            0:PaintBox2.Canvas.Pen.Color:=PaintBox2.Canvas.Pen.Color- $00010100;
            1:PaintBox2.Canvas.Pen.Color:=PaintBox2.Canvas.Pen.Color- $00010001;
            2:PaintBox2.Canvas.Pen.Color:=PaintBox2.Canvas.Pen.Color- $00000101;
            3:PaintBox2.Canvas.Pen.Color:=PaintBox2.Canvas.Pen.Color+ $00010101;
          end;
        end;
        PaintBox2.Canvas.LineTo(i,0);
      end;
  end;

end;

procedure TForm5.RadioButton1Click(Sender: TObject);
begin
Button1.Click;
end;

end.
 