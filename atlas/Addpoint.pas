unit Addpoint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TForm2 = class(TForm)
    Button1: TButton;
    LatGradSpin: TSpinEdit;
    LatMinSpin: TSpinEdit;
    LatSecSpin: TSpinEdit;
    LongGradSpin: TSpinEdit;
    LongMinSpin: TSpinEdit;
    LongSecSpin: TSpinEdit;
    LatComboBox: TComboBox;
    LongComboBox: TComboBox;
    Label1: TLabel;
    LabelLat: TLabel;
    Label5: TLabel;
    LabelLong: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    LatGrad: TEdit;
    LongGrad: TEdit;
    Label2: TLabel;
    procedure LatGradSpinChange(Sender: TObject);
    procedure LatMinSpinChange(Sender: TObject);
    procedure LatSecSpinChange(Sender: TObject);
    procedure LatComboBoxChange(Sender: TObject);
    procedure LongGradSpinChange(Sender: TObject);
    procedure LongMinSpinChange(Sender: TObject);
    procedure LongSecSpinChange(Sender: TObject);
    procedure LongComboBoxChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure LongGradKeyPress(Sender: TObject; var Key: Char);
    procedure LatGradKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure ChangeLabelLat;
    procedure ChangeLabelLong;

  end;

var
  Form2: TForm2;

implementation
 uses mainUnit,hull;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var pntXY,pntGrad:TPointEx; mrk:Tmarkpoint; X,Y:extended;
begin
if RadioButton1.Checked then
begin
  pntGrad.X:= LongGradSpin.Value + LongMinSpin.Value/60 +LongSecSpin.Value/3600;
  if LongComboBox.ItemIndex=1 then pntGrad.X:=-pntGrad.X;
  pntGrad.Y:= LatGradSpin.Value + LatMinSpin.Value/60 +LatSecSpin.Value/3600;
  if LatComboBox.ItemIndex=1 then pntGrad.Y:=-pntGrad.Y;
end
else
begin
try
  pntGrad.X:=StrToFloat(LongGrad.Text);
  pntGrad.Y:=StrToFloat(LatGrad.Text)
Except
  ShowMessage('Incorrect value');
  exit;
end;
end;
with Form1 do
      begin
      pntXY:=GradToXY(pntGrad.X,pntGrad.Y);
      if pntXY.x<0 then exit;


      if StringGrid1.Cells[0,StringGrid1.RowCount-1]<>'' then
        StringGrid1.RowCount:=StringGrid1.RowCount+1;
      mrk:=TMarkPoint.create(StringGrid1.RowCount,round(pntXY.X*zoom),round(pntXY.Y*zoom),pntGrad);
      StringGrid1.Cells[0,StringGrid1.RowCount-1]:=inttostr(mrk.ID);
      StringGrid1.Cells[1,StringGrid1.RowCount-1]:=mrk.LongitudeString;
      StringGrid1.Cells[2,StringGrid1.RowCount-1]:=mrk.LatitudeString;
      MarksList.Add(mrk);
      DrawPoint(round(pntXY.X*zoom),round(pntXY.Y*zoom));
      MovePictureXY(round(pntXY.X*zoom),round(pntXY.Y*zoom));
      Form1.MoveNavigRect;
      if CheckViewPoligone.Checked then DrawPoligone;

    end;
end;

procedure TForm2.ChangeLabelLat;
var s:string;
begin
  if LatComboBox.ItemIndex = 0 then s:='Ñ.Ø.'
  else s:='Þ.Ø.';
try
  LabelLat.Caption:= inttostr(LatGradSpin.Value)+'° '+inttostr(LatMinSpin.Value)+''' '+inttostr(LatSecSpin.Value)+'" '+ s;
finally

end;
end;



procedure TForm2.ChangeLabelLong;
var s:string;
begin
  if LongComboBox.ItemIndex = 0 then s:='Â.Ä.'
  else s:='Ç.Ä.';
try
  LabelLong.Caption:= inttostr(LongGradSpin.Value)+'° '+inttostr(LongMinSpin.Value)+''' '+inttostr(LongSecSpin.Value)+'" '+ s;
finally

end;
end;



procedure TForm2.LatComboBoxChange(Sender: TObject);
begin
ChangeLabelLat;
end;

procedure TForm2.LatGradKeyPress(Sender: TObject; var Key: Char);
begin
if key='.' then key:=',';
end;

procedure TForm2.LatGradSpinChange(Sender: TObject);
begin
ChangeLabelLat;
end;

procedure TForm2.LatMinSpinChange(Sender: TObject);
begin
ChangeLabelLat;
end;

procedure TForm2.LatSecSpinChange(Sender: TObject);
begin
ChangeLabelLat;
end;

procedure TForm2.LongComboBoxChange(Sender: TObject);
begin
ChangeLabelLong;
end;

procedure TForm2.LongGradKeyPress(Sender: TObject; var Key: Char);
begin
if key='.' then key:=',';

end;

procedure TForm2.LongGradSpinChange(Sender: TObject);
begin
ChangeLabelLong;
end;

procedure TForm2.LongMinSpinChange(Sender: TObject);
begin
ChangeLabelLong;
end;

procedure TForm2.LongSecSpinChange(Sender: TObject);
begin
ChangeLabelLong;
end;

procedure TForm2.RadioButton1Click(Sender: TObject);
var lat,long:TgradGeo;
begin
LatGradSpin.Visible:=true;
LongGradSpin.Visible:=true;
LatMinSpin.Visible:=true;
LatSecSpin.Visible:=true;
LongMinSpin.Visible:=true;
LongSecSpin.Visible:=true;
LatGrad.Visible:=false;
LongGrad.Visible:=false;
try
  lat:=ExtendToGrad(strtofloat(LatGrad.Text));
  long:=ExtendToGrad(strtofloat(LongGrad.Text));
except
  exit;
end;
LatGradSpin.Value:=lat.grad;
LatMinSpin.Value:=lat.min;
LatSecSpin.Value:=lat.sec;
LongGradSpin.Value:=long.grad;
LongMinSpin.Value:=Long.min;
LongSecSpin.Value:=long.sec;

end;

procedure TForm2.RadioButton2Click(Sender: TObject);
begin
LatGradSpin.Visible:=false;
LongGradSpin.Visible:=false;
LatMinSpin.Visible:=false;
LatSecSpin.Visible:=false;
LongMinSpin.Visible:=false;
LongSecSpin.Visible:=false;
LatGrad.Visible:=true;
LongGrad.Visible:=true;
if (LatGradSpin.Value<>0)and(LongGradSpin.Value<>0)
   and(LatMinSpin.Value<>0)and(LongMinSpin.Value<>0)
   and(LatSecSpin.Value<>0)and(LongSecSpin.Value<>0)
 then
  begin
    LongGrad.Text:=FloatToStr(LongGradSpin.Value + LongMinSpin.Value/60 +LongSecSpin.Value/3600);
    LatGrad.Text:=FloatToStr(LatGradSpin.Value + LatMinSpin.Value/60 +LatSecSpin.Value/3600);
  end;
end;

end.
