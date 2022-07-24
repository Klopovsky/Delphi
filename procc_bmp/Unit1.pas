unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OpenGL, Menus,Math, eqPoint, matrconsolve, blum, ComCtrls,gistogramm,
  CubeRGB;
type
DesRGB = Array [0..2047, 0..2047, 0..2] of GLubyte;


   T3x3FloatArray = array[0..2] of array[0..2] of Extended;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Fi1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    OpenDialog1: TOpenDialog;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    notalowed1: TMenuItem;
    ProgressBar1: TProgressBar;
    N7: TMenuItem;
    N8: TMenuItem;
    random1: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure N2Click(Sender: TObject);
    procedure extrPoint(jump:integer); //����� ���-���-���
    procedure SimpleFindBlum(qBlum:integer);
    procedure ref;
    procedure view(n:byte);
    procedure copyDes(x1,y1,x2,y2,inp,outp:integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure XORLine;
    procedure Rect(x1,y1,x2,y2:integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure notalowed1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Convolve(AMask: T3x3FloatArray;ABias: Integer);//��������� �������
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure random1Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
  private
    DC : HDC;
    hrc: HGLRC;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  lx,ly,xo,yo:integer; dX,dY:single; resX,resY:integer;
  InputDes,WorkDes,operDes : DesRGB;Bitmap:TBitmap;

implementation

{$R *.dfm}

procedure Tform1.Convolve(AMask: T3x3FloatArray;ABias: Integer); //��������� �������
var i,j,LRow, LCol: integer;
   LNewBlue, LNewGreen, LNewRed: Extended;
   LCoef: Extended;
begin
if Form3.CheckBox1.Checked then  copyDes(xo,yo,lx,ly,0,1);
LCoef := 0;
   for LRow := 0 to 2 do
     for LCol := 0 to 2 do
       LCoef := LCoef + AMask[LCol, LRow];
   if LCoef = 0 then LCoef := 1;

if ((xo=lx)and(yo=ly)) then
  begin
    xo:=0;
    yo:=0;
    lx:=resX-1;
    ly:=resY-1;
  end;

for i:=xo to lx do
  for j:=yo to ly do begin
    LNewRed:=
    (WorkDes[i-1,j-1,0]*AMask[0,0] + WorkDes[i,j-1,0]*AMask[1,0]
    + WorkDes[i+1,j-1,0]*AMask[2,0]) +
    (WorkDes[i-1,j,0]*AMask[0,1] + WorkDes[i,j,0]*AMask[1,1]
    + WorkDes[i+1,j,0]*AMask[2,1]) +
    (WorkDes[i-1,j+1,0]*AMask[0,2] + WorkDes[i,j+1,0]*AMask[1,2]
    + WorkDes[i+1,j+1,0]*AMask[2,2]);
    LNewRed := (LNewRed / LCoef) + ABias;
       if LNewRed > 255 then
         LNewRed := 255;
       if LNewRed < 0 then
         LNewRed := 0;

    LNewGreen:=
    (WorkDes[i-1,j-1,1]*AMask[0,0] + WorkDes[i,j-1,1]*AMask[1,0]
    + WorkDes[i+1,j-1,1]*AMask[2,0]) +
    (WorkDes[i-1,j,1]*AMask[0,1] + WorkDes[i,j,1]*AMask[1,1]
    + WorkDes[i+1,j,1]*AMask[2,1]) +
    (WorkDes[i-1,j+1,1]*AMask[0,2] + WorkDes[i,j+1,1]*AMask[1,2]
    + WorkDes[i+1,j+1,1]*AMask[2,2]);
    LNewGreen := (LNewGreen / LCoef) + ABias;
       if LNewGreen > 255 then
         LNewGreen := 255;
       if LNewGreen < 0 then
         LNewGreen := 0;

    LNewBlue:=
    (WorkDes[i-1,j-1,2]*AMask[0,0] + WorkDes[i,j-1,2]*AMask[1,0]
    + WorkDes[i+1,j-1,2]*AMask[2,0]) +
    (WorkDes[i-1,j,2]*AMask[0,1] + WorkDes[i,j,2]*AMask[1,1]
    + WorkDes[i+1,j,2]*AMask[2,1]) +
    (WorkDes[i-1,j+1,2]*AMask[0,2] + WorkDes[i,j+1,2]*AMask[1,2]
    + WorkDes[i+1,j+1,2]*AMask[2,2]);
    LNewBlue := (LNewBlue / LCoef) + ABias;
       if LNewBlue > 255 then
         LNewBlue := 255;
       if LNewBlue < 0 then
         LNewBlue := 0;

    operDes[i,j,0]:= trunc(LNewRed);
    operDes[i,j,1]:= trunc(LNewGreen);
    operDes[i,j,2]:= trunc(LNewBlue);
                      end;
copyDes(xo,yo,lx,ly,2,1);

end;



{=======================================================================}
procedure SetDCPixelFormat (hdc : HDC);
var
 pfd : TPixelFormatDescriptor;
 nPixelFormat : Integer;
begin
 FillChar (pfd, SizeOf (pfd), 0);
 pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
 nPixelFormat := ChoosePixelFormat (hdc, @pfd);
 SetPixelFormat (hdc, nPixelFormat, @pfd);
end;

{=======================================================================}
procedure tForm1.ref;
begin
DC := GetDC (Handle);
 SetDCPixelFormat(DC);
 hrc := wglCreateContext(DC);
 wglMakeCurrent(DC, hrc);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_BLEND);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,  GL_NEAREST);

 wglUseFontBitmaps (Canvas.Handle, 0, 255, 100);
end;
{=======================================================================
�������� �����}
procedure Tform1.FormCreate(Sender: TObject);
begin

end;

{=======================================================================
����� ������ ����������}
procedure Tform1.FormDestroy(Sender: TObject);
begin
 wglMakeCurrent(0, 0);
 wglDeleteContext(hrc);
 ReleaseDC (Handle, DC);
 DeleteDC (DC);
end;

procedure Tform1.view(n:byte);
var Des:^DesRGB;
begin
case n of

0:Des:= @InputDes;
1:Des:= @WorkDes;
2:Des:= @operDes;
else Des:=nil;
end;
if Form5<>nil then Form5.Button1.Click;
if (form6<>nil)and(form6.fff=1) then
  begin Form6.Analiz; Form6.FormResize(nil)  ; end;

wglMakeCurrent(DC, hrc);

glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,
                 2048, 2048,
                 0, GL_RGB, GL_UNSIGNED_BYTE, Des);
    glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
    glEnable(GL_TEXTURE_2D);
glPushMatrix;
 glTranslatef(dx-1.0,-dy+1.0,0.0);  //��������� �����������
glColor3f (1.0, 1.0, 1.0);

glBegin (GL_QUADS);
   glTexCoord2d (0.0, -1.0);
   glVertex2f (-dx,-dy);
   glTexCoord2d (-1.0, -1.0);
   glVertex2f (-dx, dy);
   glTexCoord2d (-1.0, 0.0);
   glVertex2f (dx, dy);
   glTexCoord2d (0.0, 0.0);
   glVertex2f (dx, -dy);
glEnd;

glPopMatrix;     

 SwapBuffers(DC);

end;

procedure TForm1.extrPoint(jump:integer);   //����� ���-���-���
var i,j,keyColor,maxLight,minLight,temp,er:integer;
begin
if ((xo=lx)and(yo=ly)) then
  begin
    xo:=0;
    yo:=0;
    lx:=resX-1;
    ly:=resY-1;
  end;

///////////----------------------------------------------------------------
For i := xo-1 to lx+1  do
      For j := yo-1 to ly+1 do begin
        operDes[i,j,0]:=255;
        operDes[i,j,1]:=255;
        operDes[i,j,2]:=255;    end;
        copyDes(xo,yo,lx,ly,0,1);
///////////----------------------------------------------------------------
 For i := xo to lx  do  begin
      keyColor:=255;//InputDes[i,yo,0];

      maxLight:=0;
      minLight:=255;
      For j := yo to ly do begin /////((ly+yo) div 2) do  begin
      temp:=(InputDes[i,j,0]-keyColor);
       if (temp>=jump)
        then begin
              operDes[i,yo-1,0]:=temp;


             end;
        if (InputDes[i,j,0]>maxLight)
          then begin
                operDes[i,yo-1,1]:=InputDes[i,j,0];
                maxLight:=InputDes[i,j,0];
               end;
         if (InputDes[i,j,0]<minLight)
          then begin
                operDes[i,yo-1,2]:=InputDes[i,j,0];
                minLight:=InputDes[i,j,0];
               end;
          keyColor:=inputDes[i,j,0];
                                           end;
                            end;
 For i := lx downto xo do  begin
      keyColor:=255; //InputDes[i,ly,0];

      maxLight:=0;
      minLight:=255;
      For j := ly downto yo do begin   ////((yo+ly) div 2) do  begin
      temp:=(InputDes[i,j,0]-keyColor);
       if (temp>=jump)
        then begin
              operDes[i,ly+1,0]:=temp;

             end;
        if (InputDes[i,j,0]>maxLight)
          then begin
                operDes[i,ly+1,1]:=InputDes[i,j,0];
                maxLight:=InputDes[i,j,0];
               end;
         if (InputDes[i,j,0]<minLight)
          then begin
                operDes[i,ly+1,2]:=InputDes[i,j,0];
                minLight:=InputDes[i,j,0];
               end;
          keyColor:=inputDes[i,j,0];
                                             end;
                            end;
//////////////////////////////////////////////////
For j := yo to ly do  begin
      keyColor:=255; //InputDes[xo,j,0];

      maxLight:=0;
      minLight:=255;
      For i := xo to lx do begin ///((lx+xo)div 2)  do  begin
      temp:=(InputDes[i,j,0]-keyColor);
        if (temp>=jump)
        then begin
              operDes[i,ly+1,0]:=temp;

             end;
        if (InputDes[i,j,0]>maxLight)
          then begin
                operDes[xo-1,j,1]:=InputDes[i,j,0];
                maxLight:=InputDes[i,j,0];
               end;
         if (InputDes[i,j,0]<minLight)
          then begin
                operDes[xo-1,j,2]:=InputDes[i,j,0];
                minLight:=InputDes[i,j,0];
               end;
          keyColor:=inputDes[i,j,0];
                                          end;
                            end;
For j := ly downto yo do  begin
      keyColor:=255;  //InputDes[lx,j,0];

      maxLight:=0;
      minLight:=255;
        For i := lx downto xo  do begin  ///((xo+lx)div 2) do  begin
        temp:=InputDes[i,j,0]-keyColor;
       if (temp>=jump)
        then begin
              operDes[i,ly+1,0]:=temp;

             end;
        if (InputDes[i,j,0]>maxLight)
          then begin
                operDes[lx+1,j,1]:=InputDes[i,j,0];
                maxLight:=InputDes[i,j,0];
               end;
         if (InputDes[i,j,0]<minLight)
          then begin
                operDes[lx+1,j,2]:=InputDes[i,j,0];
                minLight:=InputDes[i,j,0];
               end;
          keyColor:=inputDes[i,j,0];
                                               end;
                            end;
//////////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
er:=Form2.TrackBar2.Position;
 For i := xo to lx  do  begin
      keyColor:=255; //InputDes[i,yo,0];
      For j := yo to {ly do begin  ////}((ly+yo) div 2) do  begin
      temp:=(InputDes[i,j,0]-keyColor);
       if (temp>=jump)and((InputDes[i,j,0]-((operDes[i,yo-1,1]+operDes[i,yo-1,2]) div 2))<=er)
        then begin operDes[i,j,0]:=255;operDes[i,j,1]:=255;operDes[i,j,2]:=255; end
        else  workDes[i,j,2]:=0;
          keyColor:=inputDes[i,j,0];
                                          end;
                            end;
 For i := lx downto xo do  begin
      keyColor:=255; //InputDes[i,ly,0];
      For j := ly downto {yo do begin  ///}((yo+ly) div 2) do  begin
      temp:=(InputDes[i,j,0]-keyColor);
       if (temp>=jump)and((InputDes[i,j,0]-((operDes[i,ly+1,1]+operDes[i,ly+1,2]) div 2))<=er)
        then  begin operDes[i,j,0]:=255;operDes[i,j,1]:=255;operDes[i,j,2]:=255; end
        else  workDes[i,j,2]:=0;
           keyColor:=inputDes[i,j,0];
                                             end;
                            end;
//////////////////////////////////////////////////
For j := yo to ly do  begin
      keyColor:=255; //InputDes[xo,j,0];
      For i := xo to {lx do begin ////}((lx+xo)div 2)  do  begin
      temp:=(InputDes[i,j,0]-keyColor);
       if (temp>=jump)and((InputDes[i,j,0]-((operDes[xo-1,j,1]+operDes[xo-1,j,2]) div 2))<=er)
        then begin operDes[i,j,0]:=255;operDes[i,j,1]:=255;operDes[i,j,2]:=255; end
        else begin workDes[i,j,1]:=0;workDes[i,j,0]:=0;   end;
           keyColor:=inputDes[i,j,0];

                                          end;
                            end;
For j := ly downto yo do  begin
      keyColor:=255; //InputDes[lx,j,0];
      For i := lx downto {xo do begin ///}((xo+lx)div 2) do  begin
        temp:=(InputDes[i,j,0]-keyColor);
       if (temp>=jump)and((InputDes[i,j,0]-((operDes[lx+1,j,1]+operDes[lx+1,j,2]) div 2))<=er)
        then begin operDes[i,j,0]:=255;operDes[i,j,1]:=255;operDes[i,j,2]:=255; end
        else  begin workDes[i,j,1]:=0;workDes[i,j,0]:=0;   end;
           keyColor:=inputDes[i,j,0];
                                            end;
                            end;

end;



procedure TForm1.copyDes(x1,y1,x2,y2,inp,outp:integer);
var i,j:integer;inDes,outDes:^DesRGB;

begin
case inp of
0:inDes:=@InputDes;
1:inDes:= @WorkDes;
2:inDes:=@operDes;
else
inDes:=nil;
end;

case outp of
0:outDes:=@InputDes;
1:outDes:= @WorkDes;
2:outDes:=@operDes;
else
outDes:=nil;
end;
 For i := x1 to x2 do
      For j := y1 to y2 do  begin
       outDes [i, j, 0]:=InDes [i, j, 0];
       outDes [i, j, 1]:=InDes [i, j, 1];
       outDes [i, j, 2]:=InDes [i, j, 2];
                               end;
end;

procedure TForm1.N2Click(Sender: TObject);
var i,j:integer;
begin
OpenDialog1.Execute;
xo:=0;
yo:=0;
lx:=0;
ly:=0;
ProgressBar1.Visible:=true;
ProgressBar1.Position:=0;
if bitmap<>nil then bitmap.Free;
bitmap := TBitmap.Create;
bitmap.LoadFromFile(OpenDialog1.FileName);
resX:=Bitmap.Width;     //������� �����������
resY:=Bitmap.Height;
ProgressBar1.Max:=resX div 11;
ProgressBar1.StepIt;

form1.Top:=5;
Form1.Left:=3;



For i := 0 to resX-1 do   begin     //������ �����������
  if(i mod 12) = 0 then
    ProgressBar1.StepIt;
  For j := 0 to resY-1 do  begin
    InputDes [i, j, 0] := GetRValue(bitmap.Canvas.Pixels[i,j]);
    InputDes [i, j, 1] := GetGValue(bitmap.Canvas.Pixels[i,j]);
    InputDes [i, j, 2] := GetBValue(bitmap.Canvas.Pixels[i,j]);
                           end;
                          end;

copyDes(0,0,resX-1,resY-1,0,1);
ProgressBar1.Visible:=false;
dX:=2048/resX;  //������������
dY:=2048/resY;

Form1.ClientWidth:=resX;
Form1.ClientHeight:=resY; 
ref;
view(1);

end;

procedure TForm1.XORLine;
begin
  Form1.Rect(xo,yo,lx,ly);

end;

procedure TForm1.Rect(x1,y1,x2,y2:integer);
begin
Form1.Canvas.MoveTo(x1,y1);
Form1.Canvas.LineTo(x2,y1);
Form1.Canvas.LineTo(x2,y2);
Form1.Canvas.LineTo(x1,y2);
Form1.Canvas.LineTo(x1,y1);
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SwapBuffers(DC);
  XORLine;
  Form1.Tag := 1;
  xo := X;
  yo := Y;
  lx := X;
  ly := Y;
  Form1.Canvas.Pen.Mode := pmNotXor;
  XORLine;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if ssLeft in Shift then
  begin
    XORLine;
    lx := X;
    ly := Y;
    XORLine;
  end;
Caption:='RGB='+inttostr(workDes[X,Y,2])+'   X=' +inttostr(X)+'  Y='+inttostr(Y);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var temp:integer;
begin
 Form1.Canvas.Pen.Mode := pmCopy;
 if (xo mod 2) = 1 then inc(xo);
 if (yo mod 2) = 1 then inc(yo);
 if (X mod 2) = 1 then lx:=X+1 else lx:=X;
 if (Y mod 2) = 1 then ly:=Y+1 else ly:=Y;
 if (lx<xo) then begin temp:=lx; lx:=xo; xo:=temp; end;
 if (ly<yo) then begin temp:=ly; ly:=yo; yo:=temp; end;
 Form1.Rect(xo,yo,lx,ly);
end;

procedure TForm1.N4Click(Sender: TObject);
begin
copyDes(0,0,resX-1,resY-1,0,1);
View(1);
xo:=0;
lx:=0;
yo:=0;
ly:=0;
end;

procedure TForm1.N6Click(Sender: TObject); //����� ���-���-���
begin
Form2.Show;
end;

procedure TForm1.SimpleFindBlum(qBlum:integer);
var i,j:integer;
begin
if ((xo=lx)and(yo=ly)) then
  begin
    xo:=0;
    yo:=0;
    lx:=resX-1;
    ly:=resY-1;
  end;

for i:=xo to lx do
  for j:=yo to ly do
    begin
      if workDes[i,j,0]>=qBlum
      then
        begin
          WorkDes[i,j,0]:=WorkDes[i,j,0]-(255-qBlum);
          WorkDes[i,j,1]:=WorkDes[i,j,1]-(255-qBlum);
          WorkDes[i,j,2]:=WorkDes[i,j,2]-(255-qBlum);

        end
      else
        begin
          WorkDes[i,j,0]:=WorkDes[i,j,0];
          WorkDes[i,j,1]:=WorkDes[i,j,1];
          WorkDes[i,j,2]:=WorkDes[i,j,2];
        end;
    end;

view(1);
end;

procedure TForm1.notalowed1Click(Sender: TObject);
begin
Form4.Show;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
//view(1);
{wglDeleteContext(hrc);
DC := GetDC (Handle);
 SetDCPixelFormat(DC);
 hrc := wglCreateContext(DC);
 wglMakeCurrent(DC, hrc);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_BLEND);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,  GL_NEAREST);

 wglUseFontBitmaps (Canvas.Handle, 0, 255, 100);   }
end;

procedure TForm1.N7Click(Sender: TObject);
begin
Form3.Show;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
Bitmap.Free;
close;
end;

procedure TForm1.random1Click(Sender: TObject);
var i,j:integer;k,rn,rr:extended;
begin
randomize;
if ((xo=lx)and(yo=ly)) then
  begin
    xo:=0;
    yo:=0;
    lx:=resX-1;
    ly:=resY-1;
  end;
k:=0.2;

for i:=xo to lx do
  for j:=yo to ly do

        begin
          rn:=0.5+(arctan(randg(0.0,k)));
          rr:=random;
          WorkDes[i,j,0]:=round(Workdes[i,j,0]*(rr+rn));
          WorkDes[i,j,1]:=round(Workdes[i,j,1]*(rr+rn));
          WorkDes[i,j,2]:=round(workdes[i,j,2]*(rr+rn));

        end;



view(1);
end;

procedure TForm1.N9Click(Sender: TObject);
begin
Form5.Show;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
Application.CreateForm(TForm6, Form6);

Form6.des:=@WorkDes;
Form6.resX:=resX-1;
Form6.resY:=resY-1;
Form6.Analiz;
Form6.Show;
end;

end.