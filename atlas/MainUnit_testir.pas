unit mainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, StdCtrls, ComCtrls, ExtCtrls, Buttons, ToolWin, jpeg, spline3, Ap;

type
  TForm1 = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Panel1: TPanel;
    Image2: TImage;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Button2: TButton;
    Button6: TButton;
    Button1: TButton;
    Button3: TButton;
    Memo1: TMemo;
    Button4: TButton;
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    StartPointRect : TPoint;
    EndPointRect : TPoint;
    procedure XORLine;
    procedure MovePicture;
  public
    { Public declarations }
  end;

const hProp=5;      //
      wProp=10;     //   пропорции дл€ навигации по карте
      Proportion=50;//
      eps=0.001;   // точность нахождени€ решени€
      CenterX=6000;  //  приблизительный центр карты по оси ’
      ecvator = 2964;
      quantityLong=14; // количество опорных меридианов
      //смещение относительно экватора

      dif30 = 1083;
      dif60 = 2138;
      dif66 = 2346;
      dif90 = 2910;
      Massiv_Shirot_decartY:array[1..5] of integer = (ecvator,ecvator+dif30,ecvator+dif60,ecvator+dif66,ecvator+dif90);
      Massiv_shirot_grad:array[1..5] of double = (0,30,60,66.555,90);

type TPointEx =  packed record
  X: Extended;  Y: Extended;end;

type Longitude = class
  public
    Name:string;
    Spl:Treal1DArray;
    X0,Xend,grad:integer;
    constructor create(str:string;gr:integer);
    destructor destroy();
end;

procedure LoadMeridianFromFile(Fname:string);
function FindX(Y,X0,XN:double;func:Treal1DArray):Double;
function XYtoGrad(X,Y:double):TPointEx;
function FormatGrad(p:TPointEx):TStringList;
function GradToXY(X,Y:double):TPointEx;

var
  Form1: TForm1; HSmallRect,WSmallRect,MoveX,MoveY:integer;
        zoom:real;
        Xspl,Yspl:TReal1DArray; pict:TBitmap;
        LongitudesList:Tlist;
        lng:Longitude;
        stop:boolean;
implementation

{$R *.DFM}

constructor Longitude.Create(str:string;gr:integer);
begin
  Inherited Create();
  Self.Name:=str;
  Self.grad:=gr;
end;

destructor Longitude.destroy();
begin
  Setlength(Self.Spl,0);
  Inherited Destroy();
end;


function SetImageSize(Img: TImage; SizePercent: Integer): boolean;
var
  K: Double;
  nw, nh: Integer;
begin
  Result := false;
  if Img = nil then
    exit;
  if SizePercent < 0 then
    exit;
  Img.AutoSize := True;
  Img.AutoSize := False;

  try
    K := img.height / img.width;
  except exit;
  end;
  nw := Round(img.Width * SizePercent / 100);
  nh := round(nw * k);
  img.Stretch := true;
  img.Width := nw;
  img.Height := nh;
  Result := true;
end;

procedure DrawPoint(X,Y:double);
var d,xx,yy:integer;
begin
  xx:=round(X*zoom);
  yy:=round(Y*zoom);
  d:=round(2*zoom);
  form1.image1.canvas.brush.color:=clred;
  form1.image1.Canvas.FillRect(Rect(xx-d,yy-d,xx+d,yy+d));
end;

procedure TForm1.XORLine;
begin
  Image2.Canvas.Rectangle(StartPointRect.x, StartPointRect.y,EndPointRect.x, EndPointRect.y);
end;

procedure TForm1.MovePicture;
begin
  ScrollBox1.HorzScrollBar.Position:=round((StartPointRect.X-WSmallRect*2)*(Proportion/zoom));
  ScrollBox1.VertScrollBar.Position:=round((StartPointRect.Y-HSmallRect*2)*(Proportion/zoom));
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  SetImageSize(Image1,TrackBar1.Position*10);
  zoom:=( 10/TrackBar1.Position);
  HSmallRect:=round(hProp*zoom);
  WSmallRect:=round(wProp*zoom);
  Label1.Caption:='ћасштаб '+inttostr(TrackBar1.Position*10)+'%';
end;

procedure TForm1.Button1Click(Sender: TObject);
VAR I,j:INTEGER;
begin
 Image1.Canvas.Pen.color:=$00000000;
 Image1.Canvas.Pen.Width:=10;
 for j := 0 to LongitudesList.Count - 1 do
  BEGIN
 Image1.Canvas.Pen.color:=Image1.Canvas.Pen.color+$00024466;
 lng:=LongitudesList.Items[j];
    image1.Canvas.MoveTo(0, round(SplineInterpolation(lng.spl,0)));
    for i:=0 to  Image1.Width do
      Image1.Canvas.LineTo(i,Round(SplineInterpolation(lng.spl,i)));
  END;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Image1.Picture.Bitmap.Assign(Pict);
end;

procedure TForm1.Button3Click(Sender: TObject);
var i,j,n:integer; p:TPointEx; f:textfile;s:string;
begin
  Button3.Enabled:=false;
  n:=0;
  stop:=false;
  assignfile(f,'testing.tst');
  reset(f);
  readln(f,s);
  n:=strtoint(s);
  closefile(f);
  for i := n to Image1.width do
    begin
      for j := 0 to Image1.height do
        begin
          p:=XYtoGrad(i,j);
          memo1.lines.append('X='+inttostr(i)+'  Y='+inttostr(j));
        end;
      if (i mod 1000)=0 then ForceDirectories('e:\testing atlas\'+inttostr(i));
      application.Processmessages;
      if stop then
        begin
          rewrite(f);
          writeln(f,inttostr(i-1));
          closefile(f);
          exit();
        end;

    end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
stop:=true;
button3.enabled:=true;
end;

procedure TForm1.Button6Click(Sender: TObject);
var i,j:integer; lt:longitude;
begin
Image1.Canvas.Pen.Width:=30;
Image1.Canvas.Pen.color:=clRed;
for j := 0 to LongitudesList.Count - 1 do
  BEGIN
    lt:=LongitudesList.Items[j];
    image1.Canvas.MoveTo(lt.X0, round(SplineInterpolation(lt.spl,lt.X0)));
    for i:=lt.X0 to  lt.Xend do
      Image1.Canvas.LineTo(i,Round(SplineInterpolation(lt.spl,i)));
  END;
end;

function FindX(Y,X0,XN:double;func:Treal1DArray):Double;
var midX,midY:double;
begin
  midX:= (XN+X0)/2;
  midY:= SplineInterpolation(func,midX);
  if MidY<0 then  exit;

  if abs(MidY-Y)<eps then
    result:=midX
  else
    if (MidY-Y)>0 then
      result:=FindX(Y,X0,MidX,func)
    else
      result:=FindX(Y,MidX,XN,func);

end;


function XYtoGrad(X,Y:double):TPointEx;
var i,first_grad,sec_grad:integer;
    firstY_grad,secY_grad:double;
    first,sec:double;
    firstY,secY:integer;
    lt:longitude;
    flag,sever:boolean;
begin
  flag:=false;
  sever:=false;
  result.X:=190.0; //признак того что точка вне карты ( >180 )
  result.Y:=190.0;
  if (X<59)or(X>11530) then Exit();  //точка точно вне карты
  if (Y<(ecvator-dif90+4))or(Y>(ecvator+dif90-4)) then Exit();

  if Y<ecvator then
    begin
      sever:=true;
      Y:=2*ecvator-Y;
    end;
  //ѕоиск поиск координат Y двух ближайших широт дл€ данного Y
  for i := 1 to high(massiv_shirot_grad)-1 do
    if (Y>=Massiv_Shirot_decartY[i])and(Y<Massiv_Shirot_decartY[i+1]) then
      begin
        firstY:=Massiv_Shirot_decartY[i];
        secY:=Massiv_Shirot_decartY[i+1];
        firstY_grad:=Massiv_Shirot_grad[i];
        secY_grad:=Massiv_Shirot_grad[i+1];
        break;
      end;

  //поиск координат ’ персечни€ пр€мой Y=const и двух ближайших меридиан
  if X>=centerX then
    begin
      lt:=longitudesList.Items[(quantityLong div 2)-1];
      first:=findX(Y,lt.X0,lt.Xend,lt.spl);
      first_grad:=lt.grad;
      for I := (quantityLong div 2) to LongitudesList.Count - 1 do
        begin
          lt:=longitudesList.Items[i];
          sec:=findX(Y,lt.Xend,lt.X0,lt.spl);
          sec_grad:=lt.grad;
          if sec>=X then
            begin
              flag:=true;
              break;
            end
          else
            begin
              first:=sec;
              first_grad:=sec_grad;
            end;
        end;
    end
  else
    begin
      lt:=longitudesList.Items[(quantityLong div 2)];
      sec:=findX(Y,lt.XEnd,lt.X0,lt.spl);
      sec_grad:=lt.grad;
      for I := (quantityLong div 2)-1 downto 0 do
        begin
          lt:=longitudesList.Items[i];
          first:=findX(Y,lt.X0,lt.Xend,lt.spl);
          first_grad:=lt.grad;
          if first<=X then
            begin
              flag:=true;
              break;
            end
          else
            begin
              sec:=first;
              sec_grad:=first_grad;
            end;
        end;
    end;

  //вычисление широты и долготы на основе пропорции
  if flag then
    begin
      Result.X:=first_grad+((sec_grad-first_grad)/((sec-first)/(X-first+0.0000001)));
      Result.Y:=firstY_grad+((secY_grad-firstY_grad)/((secY-firstY)/(Y-firstY+0.0000001)));
      if Result.X>180 then result.X:=(Result.X-360);
      if not sever then Result.Y:=-Result.Y;
    end;

end;
function GradToXY(X,Y:double):TPointEx;
var i:integer;
    firstY_grad,secY_grad:double;
    first,sec:double;
    firstY,secY:integer;
    lt_first,lt_sec:longitude;
    sever:boolean;
begin
  result.x:=-1.0;       //признак того что точка вне карты (  < 0 )
  result.y:=-1.0;
  sever:=false;
  if (y>90)or(X>180)or(y<-90)or(Y<-180) then  exit();

  if Y >= 0 then sever:=true     //все расчеты провод€тс€ только дл€ южного полушари€ (симметри€)
    else Y:=-Y;

  if (X<-170)and(X>-180) then X:=360+X; //необходима€ поправка из-за особенности карты    (-170;-180) = (180;190)


  //поиск координаты Y по известному значению широты
  for i := 1 to high(massiv_shirot_grad)-1 do
    if (Y>=Massiv_Shirot_grad[i])and(Y<Massiv_Shirot_grad[i+1]) then
      begin
        firstY:=Massiv_Shirot_decartY[i];
        secY:=Massiv_Shirot_decartY[i+1];
        firstY_grad:=Massiv_Shirot_grad[i];
        secY_grad:=Massiv_Shirot_grad[i+1];
        break;
      end;
    Result.Y:=firstY+((secY-firstY)/((secY_grad-firstY_grad)/(Y-firstY_grad+0.0000001)));

    //поиск сектора из двух меридиан внутри которого наше значение долготы
      for i := 0 to LongitudesList.count-2 do
        begin
          lt_first:=LongitudesList.Items[i];
          lt_sec:=LongitudesList.Items[i+1];
          if (X>=lt_first.grad)and(X<lt_sec.grad) then
            begin
              if i<6 then
                begin
                  first:=findX(Result.Y,lt_first.X0,lt_first.Xend,lt_first.spl);
                  sec:=findX(Result.Y,lt_sec.X0,lt_sec.Xend,lt_sec.spl);
                  break;
                end;
              if i=6 then
                begin
                  first:=findX(Result.Y,lt_first.X0,lt_first.Xend,lt_first.spl);
                  sec:=findX(Result.Y,lt_sec.Xend,lt_sec.X0,lt_sec.spl);
                  break;
                end;
              if i>6 then
                begin
                  first:=findX(Result.Y,lt_first.Xend,lt_first.X0,lt_first.spl);
                  sec:=findX(Result.Y,lt_sec.XEnd,lt_sec.X0,lt_sec.spl);
                  break;
                end;

            end;
        end;
    Result.X:=first+((sec-first)/((lt_sec.grad-lt_first.grad)/(X-lt_first.grad+0.0000001)));

  if sever then result.Y:=2*ecvator-result.Y;


end;


function FormatGrad(p:TPointEx):TStringList;
var sec,grad,min:integer;
begin
Result:=TStringList.create();
if p.x>180 then
  begin
    result.append('outside of map');
    result.append(' ');
    exit;
  end;
grad:= trunc(p.X);
p.x:= (p.x - grad)*60;
min:=trunc(p.x);
sec:= round((p.x - min)*60);
if p.X > 0 then
  result.append(inttostr(grad)+'∞ '+ inttostr(min) + ''' ' +inttostr(sec) + '" '+' в.д.')
else
  result.append(inttostr(-grad)+'∞ '+ inttostr(-min) + ''' ' +inttostr(-sec) + '" '+' з.д.');
grad:= trunc(p.Y);
p.y:= (p.y - grad)*60;
min:=trunc(p.y);
sec:= round((p.y - min)*60);
if p.Y > 0 then
  result.append(inttostr(grad)+'∞ '+ inttostr(min) + ''' ' +inttostr(sec) + '" '+'с.ш.')
else
  result.append(inttostr(-grad)+'∞ '+ inttostr(-min) + ''' ' +inttostr(-sec) + '" '+'ю.ш.');

end;


procedure LoadMeridianFromFile(Fname:string);
var f:TextFile; strX,strY,s,name:string; list:TStringList;i,len,grad:integer;
begin
list:=TStringList.create();
assignfile(f,fname);
reset(f);

  while not eof(f) do
  Begin
    readln(f,s);
    readln(f,strX);
    readln(f,strY);
    list.text:=StringReplace(s,' ',#13#10,[rfReplaceAll]);
    name:=list[0];
    len:=strtoint(list[1]);
    setlength(Xspl,len);
    setlength(Yspl,len);
    list.clear;
    list.text:=StringReplace(strX,' ',#13#10,[rfReplaceAll]);
    for I := 0 to len - 1 do
       Xspl[i]:=strtoint(list[i]);
    list.clear;
    list.text:=StringReplace(strY,' ',#13#10,[rfReplaceAll]);
    for I := 0 to len - 1 do
      Yspl[i]:=strtoint(list[i]);
    list.clear;
    grad:=strtoint(copy(name,2,length(name)-1));
    if name[1]='W' then
      grad:=-grad;

    lng:=Longitude.create(name,grad);
    BuildAkimaSpline(Xspl,Yspl,len,lng.spl);
    lng.X0:=round(lng.spl[3]);
    lng.Xend:=round(lng.Spl[2+round(lng.Spl[2])]);
    LongitudesList.Add(lng);
    lng:=nil;

  End;{while not eof}
   closefile(f);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Image2.Canvas.Pen.Color := clBlack;
  Image2.Canvas.Pen.Width := 1;
  HSmallRect:=hProp;
  WSmallRect:=wProp;
  zoom:=1;
  LongitudesList:=Tlist.create();
  LoadMeridianFromFile('colibr.txt');
  pict:=TBitmap.create();
  Pict.Assign(Image1.Picture.Bitmap);

end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;   Shift: TShiftState; X, Y: Integer);
var Pnt,grd:TPointEx;
begin
  MoveX:=X;
  MoveY:=Y;
  if ssshift in Shift then
    begin
      {drawPoint(X,Y);
      l1:=LongitudesList.items[0];
      l2:=LongitudesList.items[13];

      X0:=FindX(Y,l1.X0,l1.Xend,l1.spl);
      XN:=FindX(Y,l2.Xend,l2.X0,l2.spl);
      DrawPoint(X0,Y);
      DrawPoint(XN,Y);
      Image1.Canvas.MoveTo(round(X0),Y);
      Image1.Canvas.LineTo(round(XN),Y); }

      pnt:=XYtoGrad(X*zoom,Y*zoom);
      grd:=GradToXY(pnt.X,pnt.Y);
      caption:=caption+'  '+FormatGrad(pnt).strings[0]+'  '+FormatGrad(pnt).strings[1] +  ' ---  X='+ inttostr(round(grd.X))+'  Y='+inttostr(round(grd.Y));
    end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
var Pnt:TpointEx;
begin
  if ssLeft in Shift then
    begin
      if MoveX<>X then
        ScrollBox1.HorzScrollBar.Position:= ScrollBox1.HorzScrollBar.Position + (MoveX-X);
      if MoveY<>Y then
        ScrollBox1.VertScrollBar.Position:= ScrollBox1.VertScrollBar.Position + (MoveY-Y);
    end;
  Caption:='X='+inttostr(X)+' Y='+inttostr(Y);
  pnt:=XYtoGrad(X*zoom,Y*zoom);
  caption:=caption+'  '+FormatGrad(pnt).strings[0]+'  '+FormatGrad(pnt).strings[1];
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer);
begin
  XORLine;
  StartPointRect.x := X+WSmallRect;
  StartPointRect.y := Y+HSmallRect;
  EndPointRect.x := X-WSmallRect;
  EndPointRect.y := Y-HSmallRect;
  Image2.Canvas.Pen.Mode := pmNotXor;
  XORLine;
  MovePicture;
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,   Y: Integer);
begin
 if ssLeft in Shift then
  begin
    XORLine;
    StartPointRect.x := X+WSmallRect;
    StartPointRect.y := Y+HSmallRect;
    EndPointRect.x := X-WSmallRect;
    EndPointRect.y := Y-HSmallRect;
    XORLine;
    MovePicture;
  end;
end;

end.
