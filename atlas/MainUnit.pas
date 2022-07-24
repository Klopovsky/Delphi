unit mainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, StdCtrls, ComCtrls, ExtCtrls, Buttons, ToolWin, jpeg, spline3, Ap,
  Grids,hull,addpoint,OtherProc;

type
  TForm1 = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Panel1: TPanel;
    Image2: TImage;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Button2: TButton;
    Button1: TButton;
    StringGrid1: TStringGrid;
    Button4: TButton;
    CheckViewPoligone: TCheckBox;
    Memo1: TMemo;
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
    procedure Button4Click(Sender: TObject);
    procedure CheckViewPoligoneClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    StartPointRect : TPoint;
    EndPointRect : TPoint;
    procedure XORLine;
    procedure MovePicture;
    procedure readPoligoneFromFile();

  public
    procedure MoveNavigRect;
  end;

{
  TPointEx = packed record
    X:Extended;
    Y:Extended;
  end;
}

TGradGeo = packed record
  neg:boolean;
  grad:byte;
  min:byte;
  sec:byte;
end;

TLongitude = class
  public
    Name:string;
    Spl:Treal1DArray;
    X0,Xend,grad:integer;
    constructor create(str:string;gr:integer);
    destructor destroy();
end;

TMarkPoint = class
  public
    ID:integer;
    X:integer;
    Y:integer;
    Grad:TPointEx;
    Latitude:TGradGeo;
    Longitude:TGradGeo;
    constructor create(n,px,py:integer;Gr:TPointEx);
    Function LatitudeString():string;
    Function LongitudeString():string;
  private
    function GradToString(g:TGradGeo):string;
end;


const
      hProp=5;      //
      wProp=10;     //   пропорции для навигации по карте
      Proportion=50;//
      eps=0.001;   // точность нахождения решения
      CenterX=6000;  //  приблизительный центр карты по оси Х
      ecvator = 2964;
      quantityLong=14; // количество опорных меридианов
      //смещение относительно экватора

      dif30 = 1083;
      dif60 = 2138;
      dif66 = 2346;
      dif90 = 2910;
      Massiv_Shirot_decartY:array[1..5] of integer = (ecvator,ecvator+dif30,ecvator+dif60,ecvator+dif66,ecvator+dif90);
      Massiv_shirot_grad:array[1..5] of double = (0,30,60,66.555,90);

procedure LoadMeridian(f:TStrings);
procedure LoadMeridianFromFile(Fname:string);
function FindX(Y,X0,XN:double;func:Treal1DArray):Double;
function XYtoGrad(X,Y:double):TPointEx;
function FormatGrad(p:TPointEx):TStringList;
function GradToXY(X,Y:double):TPointEx;
function ExtendToGrad(x:extended):TGradGeo;
procedure DrawPoint(X,Y:integer);
procedure DrawAllMarks();
procedure DrawPoligone();
procedure MovePictureXY(X,Y:integer);
var
  Form1: TForm1; HSmallRect,WSmallRect,MoveX,MoveY:integer;
        zoom:real;
        Xspl,Yspl:TReal1DArray; pict:TBitmap;
        LongitudesList,MarksList:Tlist;
        lng:TLongitude;
        Gradfrm:Tstringlist;

implementation

{$R *.DFM}

constructor TLongitude.Create(str:string;gr:integer);
begin
  Inherited Create();
  Self.Name:=str;
  Self.grad:=gr;
end;

destructor TLongitude.destroy();
begin
  Setlength(Self.Spl,0);
  Inherited Destroy();
end;

constructor TMarkPoint.create(n: Integer; px: Integer; py: Integer; gr:TPointEx);
begin
  Inherited Create();
  ID:=n;
  X:=px;
  Y:=py;
  Grad:=gr;
  if AbsReal(Grad.Y)> 89.99999 then Grad.Y:=89.99999;
  if AbsReal(Grad.X)>179.99999 then Grad.X:=179.99999;
  Latitude:= ExtendToGrad(Grad.Y);
  Longitude:= ExtendToGrad(Grad.X);

end;

function TMarkPoint.GradToString(g:TGradGeo):string;
begin
  result:=inttostr(g.grad)+'° '+ inttostr(g.min) + ''' ' +inttostr(g.sec) + '" ';
end;

function TMarkPoint.LatitudeString;
begin
  Result:=GradToString(Latitude);
  if Latitude.neg then
    result:= result + ' Ю.Ш.'
  else
    result:= Result + ' С.Ш.';
end;

function TMarkPoint.LongitudeString;
begin
    Result:=GradToString(Longitude);
  if Longitude.neg then
    result:= result + ' З.Д.'
  else
    result:= Result + ' В.Д.';
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

procedure DrawAllMarks();
var i:integer; mrk:TMarkPoint;
begin
  for i := 0 to MarksList.Count - 1 do
    begin
      mrk:=marksList.Items[i];
      drawpoint(mrk.X,mrk.Y);
    end;
end;

function ExtendToGrad(x:extended):TGradGeo;
begin
    if x > 0 then result.neg:=false
  else
    begin
      result.neg:=true;
      x:=-x;
    end;
  result.grad:=trunc(x);
  x:= (x - result.grad)*60;
  result.min:=trunc(x);
  result.sec:= round((x - result.min)*60);
end;

procedure DrawPoint(X,Y:integer);
var d:integer;
begin
  d:=round(2*zoom);
  form1.image1.canvas.brush.color:=clred;
  form1.Image1.Canvas.Brush.Style:=bsSolid;
  form1.image1.Canvas.FillRect(Rect(x-d,y-d,x+d,y+d));
end;


procedure TForm1.readPoligoneFromFile();
var pntXY,pntGrad:TPointEx; mrk:Tmarkpoint; X,Y:extended;f:textfile;
strLong,strLat:string;
begin
//AssignFile(f,'Poli.txt');
AssignFile(f,GetUserMyDocumentsFolderPath+'/poli.txt');
Reset(f);
while not(Eof(f)) do
BEGIN
try
Readln(f,strLong);
Readln(f,strLat);
except
ShowMessage('Data corrupt');
CloseFile(f);
  exit;
end;
try
  pntGrad.X:=StrToFloat(strLong);
  pntGrad.Y:=StrToFloat(strLat)
Except
  ShowMessage('Incorrect value');
  exit;
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
END;
CloseFile(f);
end;


procedure TForm1.XORLine;
begin
  Image2.Canvas.Rectangle(StartPointRect.x, StartPointRect.y,EndPointRect.x, EndPointRect.y);
end;

procedure TForm1.MoveNavigRect;
var X,Y:integer;
begin
X:= round(ScrollBox1.HorzScrollBar.Position*zoom/Proportion + WSmallRect);
Y:= round(ScrollBox1.VertScrollBar.Position*zoom/Proportion + HSmallRect);
  XORLine;
  StartPointRect.x := X+WSmallRect;
  StartPointRect.y := Y+HSmallRect;
  EndPointRect.x := X-WSmallRect;
  EndPointRect.y := Y-HSmallRect;
  Image2.Canvas.Pen.Mode := pmNotXor;
  XORLine;
end;

procedure TForm1.MovePicture;
begin
  ScrollBox1.HorzScrollBar.Position:=round((StartPointRect.X-WSmallRect*2)*(Proportion/zoom));
  ScrollBox1.VertScrollBar.Position:=round((StartPointRect.Y-HSmallRect*2)*(Proportion/zoom));
end;

procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Hiword(GetKeyState(VK_DELETE))<>0 then ShowMessage('!!!!');
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var i:integer;mrk:TMarkPoint;
begin
  for I := 0 to MarksList.Count - 1 do
    begin
      mrk:=MarksList.Items[i];
      if mrk.ID = (ARow+1) then
        MovePictureXY(mrk.X,mrk.y);
    end;
end;

procedure MovePictureXY(X,Y:integer);
begin
  Form1.ScrollBox1.HorzScrollBar.Position:=round(X/zoom)- (Form1.ScrollBox1.Width div 2);
  Form1.ScrollBox1.VertScrollBar.Position:=round(Y/zoom)- (Form1.ScrollBox1.Height div 2);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  SetImageSize(Image1,TrackBar1.Position*10);
  zoom:=( 10/TrackBar1.Position);
  HSmallRect:=round(hProp*zoom);
  WSmallRect:=round(wProp*zoom);
  Label1.Caption:='Масштаб '+inttostr(TrackBar1.Position*10)+'%';
  Image1.Picture.Bitmap.Assign(Pict);
  DrawAllMarks;
  MovePicture;
  if CheckViewPoligone.Checked then DrawPoligone;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Form2.ShowModal;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Image1.Picture.Bitmap.Assign(Pict);
end;

procedure DrawPoligone();
var i,j:integer; arrP:TPointArray; ap:array of Tpoint;  mrk:TMarkPoint;
begin
  SetLength(arrP,4);//MarksList.Count);

  for I := 0 to MarksList.Count - 1 do
    begin
      mrk:=marksList.Items[i];
      arrP[i mod 4].X:=mrk.X;
      arrP[i mod 4].Y:=mrk.Y;

   if ((i mod 4)=3)and(FindConvexHull(arrP)) then
    begin
      SetLength(aP,4);//length(arrP));
      for j := 0 to High(arrp) do
        begin
          ap[j].x:= round(arrP[j].X);
          ap[j].Y:= round(arrP[j].Y);


        end;

          //Form1.Image1.Canvas.Brush.Color:=random(65535);
          Form1.Image1.Canvas.Brush.Style:=bsDiagCross;
          Form1.Image1.Canvas.Polygon(ap);

     end;
    end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
StringGrid1.RowCount:=1;
StringGrid1.Cells[1,0]:='';
StringGrid1.Cells[0,0]:='';
StringGrid1.Cells[2,0]:='';
MarksList.Clear;
Image1.Picture.Bitmap.Assign(Pict);
end;

procedure TForm1.CheckViewPoligoneClick(Sender: TObject);
begin
if CheckViewPoligone.Checked then DrawPoligone;

end;

function FindX(Y,X0,XN:double;func:Treal1DArray):Double;
var midX,midY:double;
begin
  midX:= (XN+X0)/2;
  midY:= SplineInterpolation(func,midX);
  if MidY<0 then  exit;

  if (abs(MidY-Y)<eps)or(abs(X0-XN)<eps) then
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
    lt:Tlongitude;
    flag,sever:boolean;
begin
  flag:=false;
  sever:=false;
  result.X:=190.0; //признак того что точка вне карты ( >180 )
  result.Y:=190.0;
  if (X<59)or(X>11530) then Exit();  //точка точно вне карты
  if (Y<(ecvator-dif90))or(Y>(ecvator+dif90)) then Exit();

  if Y<ecvator then
    begin
      sever:=true;
      Y:=2*ecvator-Y;
    end;
  //Поиск поиск координат Y двух ближайших широт для данного Y
  for i := 1 to high(massiv_shirot_grad)-1 do
    if (Y>=Massiv_Shirot_decartY[i])and(Y<Massiv_Shirot_decartY[i+1]) then
      begin
        firstY:=Massiv_Shirot_decartY[i];
        secY:=Massiv_Shirot_decartY[i+1];
        firstY_grad:=Massiv_Shirot_grad[i];
        secY_grad:=Massiv_Shirot_grad[i+1];
        break;
      end;

  //поиск координат Х персечния прямой Y=const и двух ближайших меридиан
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
    lt_first,lt_sec:Tlongitude;
    sever:boolean;
begin
  result.x:=-1.0;       //признак того что точка вне карты (  < 0 )
  result.y:=-1.0;
  sever:=false;
  if (y>89.99999)or(X>179.99999)or(y<-89.99999)or(Y<-179.99999) then  exit();
  if Y >= 0 then sever:=true     //все расчеты проводятся только для южного полушария (симметрия)
    else Y:=-Y;
  if (X<-170)and(X>-180) then X:=360+X; //необходимая поправка из-за особенности карты    (-170;-180) = (180;190)

//поиск координаты Y по известному значению широты
// if y>89.8336 then result.Y:=58
//недостаток дихотомического поиска, при значении близком к 90 происходит переполнение стека!!!!  //проблема исправлена!
//  else
  begin
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
  end;
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
if (p.x>180) then
  begin
    result.append('out of map');
    result.append(' ');
    exit;
  end;
grad:= trunc(p.X);
p.x:= (p.x - grad)*60;
min:=trunc(p.x);
sec:= round((p.x - min)*60);
if p.X > 0 then
  result.append(inttostr(grad)+'° '+ inttostr(min) + ''' ' +inttostr(sec) + '" '+' в.д.')
else
  result.append(inttostr(-grad)+'° '+ inttostr(-min) + ''' ' +inttostr(-sec) + '" '+' з.д.');
grad:= trunc(p.Y);
p.y:= (p.y - grad)*60;
min:=trunc(p.y);
sec:= round((p.y - min)*60);
if p.Y > 0 then
  result.append(inttostr(grad)+'° '+ inttostr(min) + ''' ' +inttostr(sec) + '" '+'с.ш.')
else
  result.append(inttostr(-grad)+'° '+ inttostr(-min) + ''' ' +inttostr(-sec) + '" '+'ю.ш.');

end;

procedure LoadMeridian(f:TStrings);
var strX,strY,s,name:string; list:TStringList;i,j,len,grad:integer;
begin
list:=TStringList.create();
j:=0;
while j<= (f.Count-1) do
  Begin
    s:=f.Strings[j];
    strX:=f.Strings[j+1];
    strY:=f.Strings[j+2];
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

    lng:=TLongitude.create(name,grad);
    BuildAkimaSpline(Xspl,Yspl,len,lng.spl);
    lng.X0:=round(lng.spl[3]);
    lng.Xend:=round(lng.Spl[2+round(lng.Spl[2])]);
    LongitudesList.Add(lng);
    lng:=nil;
    j:=j+3;
  End;{while}

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

    lng:=TLongitude.create(name,grad);
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
  if  FileExists('colibr.txt')
    then LoadMeridianFromFile('colibr.txt')
  else
    LoadMeridian(Memo1.Lines);
  pict:=TBitmap.create();
  Pict.Assign(Image1.Picture.Bitmap);
  Gradfrm:=TStringList.Create;
  MarksList:=TList.Create;
  StringGrid1.ColWidths[0]:=round(StringGrid1.Width/10);
  StringGrid1.ColWidths[1]:=round((StringGrid1.Width-1.5*StringGrid1.ColWidths[0])/2);
  StringGrid1.ColWidths[2]:=round((StringGrid1.Width-1.5*StringGrid1.ColWidths[0])/2);
  readPoligoneFromFile;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;   Shift: TShiftState; X, Y: Integer);
var Pnt:TPointEx; mrk:TMarkPoint;
begin
  MoveX:=X;
  MoveY:=Y;
  MoveNavigRect;
  if ssShift in Shift then
    begin
      pnt:=XYtoGrad(X*zoom,Y*zoom);
      if pnt.x>=180 then  exit;

      if StringGrid1.Cells[0,StringGrid1.RowCount-1]<>'' then
        StringGrid1.RowCount:=StringGrid1.RowCount+1;
      mrk:=TMarkPoint.create(StringGrid1.RowCount,round(X*zoom),round(Y*zoom),pnt);
      StringGrid1.Cells[0,StringGrid1.RowCount-1]:=inttostr(mrk.ID);
      StringGrid1.Cells[1,StringGrid1.RowCount-1]:=mrk.LongitudeString;
      StringGrid1.Cells[2,StringGrid1.RowCount-1]:=mrk.LatitudeString;
      MarksList.Add(mrk);
      DrawPoint(round(X*zoom),round(Y*zoom));

      if CheckViewPoligone.Checked then DrawPoligone;

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
      MoveNavigRect;
    end;
  Caption:='X='+inttostr(X)+' Y='+inttostr(Y);
  pnt:=XYtoGrad(X*zoom,Y*zoom);
  Gradfrm:=FormatGrad(pnt);
  caption:=caption + '                 ' + Gradfrm.strings[0] + '    ' + Gradfrm.strings[1];
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
