unit fMDownload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, Spin, acProgressBar, sButton, sGauge,
  sListView, ExtCtrls, sPanel, Buttons, sSpeedButton,loadtypes;

type
  TfCopy = class(TForm)
    sListView1: TsListView;
    sPanel1: TsPanel;
    sSpeedButton1: TsSpeedButton;
    ssbDeleteDownload: TsSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure AddDownload(const FName:string;id:integer);
    function FindFieldToList(const ncol:string):integer;
    procedure InitDownload(const Size,id:integer);
    procedure AddProgress(i:integer;tm:cardinal);
    procedure sSpeedButton1Click(Sender: TObject);
    procedure ssbDeleteDownloadClick(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  fCopy: TfCopy;    BuffFileStream:TFileStream; listFStream:Tlist;
   currDownload,currSize:integer;        
implementation

{$R *.dfm}

uses LoFiTh;

procedure TfCopy.FormCreate(Sender: TObject);
begin
  sListView1.Columns.Add.Width := 360;
  sListView1.Columns.Add.Width := 100;
  sListView1.Columns.Add.Width := 100;
  sListView1.Columns.Add.Width := 100;
end;

procedure TfCopy.AddDownload(const FName:string;id:integer);
var r: TRect;
Gg: TsGauge;
countTF:integer;
begin

  countTF:=sListView1.Items.Count;
//  if countTF >= (sListView1.Height div 14) then
//  fCopy.Height:=fCopy.Height + 14;
  sListView1.Items.Add.Caption := GetShortName(Fname);
  r := sListView1.Items[countTF].DisplayRect(drBounds);
  r.Left  := r.Left + sListView1.columns[0].Width;
  r.Right := r.Left + sListView1.columns[1].Width;

  Gg :=TsGauge.create(self);
  Gg.Parent := sListView1;
  Gg.BoundsRect := r;
  Gg.Progress:=0;
  Gg.Refresh;
  sListView1.Items[countTF].Data := Gg;
  sListView1.Items[countTF].SubItems.Append(inttostr(id));
  sListView1.Items[countTF].SubItems.Append('0');
  sListView1.Items[countTF].SubItems.Append('0 Мбит/сек');
  //inc(countTFs);

end;

function TfCopy.FindFieldToList(const ncol:string):integer;
var i:integer;
begin
result:= -1;
for i:=0 to sListView1.Items.Count -1 do
if sListView1.Items[i].SubItems.Strings[0] = ncol
  then
    begin
      Result:=i;
      break;
    end;
end;

procedure TfCopy.InitDownload(const Size,id:integer);
var i:integer;
Gg: TsGauge;
begin
if Size<=0 then
  begin
    ShowMessage('Файл недоступен' );

    exit;
  end;
i:=FindFieldToList(inttostr(id));
currDownload:=i;
currSize:=Size;
Gg := TsGauge(sListView1.Items[i].Data);
if size > 0 then Gg.MaxValue:=Size
else Gg.MaxValue:=1;
sListView1.Items[i].SubItems.Strings[1]:='1 из '+inttostr(size)+'(MB)';
sListView1.Items[i].SubItems.Strings[2]:='0 Мбит/сек';
end;

procedure TfCopy.AddProgress(i:integer;tm:cardinal);
var Gg: TsGauge;
begin
Gg := TsGauge(sListView1.Items[currDownload].Data);
Gg.AddProgress(i);
if Gg.MaxValue>1 then
sListView1.Items[currDownload].SubItems.Strings[1]:=inttostr(Gg.Progress)+' из '+inttostr(currsize)+'(MB)';
if tm > 0 then
sListView1.Items[currDownload].SubItems.Strings[2]:=floattostrf((Gg.Progress*8000/tm),ffFixed,5,2)+'Мбит/сек';

end;

procedure TfCopy.sSpeedButton1Click(Sender: TObject);
begin
fCopy.Visible:=false;
end;

procedure TfCopy.ssbDeleteDownloadClick(Sender: TObject);
var Gg:TsGauge;phrase1,phrase2:string;
begin
if sListView1.Selected=nil then exit;

try
globFileName:=sListView1.Selected.Caption;

PostMessage(MainHandle, TF_SUSPEND, 0, 0);
Gg:=sListView1.Selected.Data;
if Gg.PercentDone=0
  then
    begin
      phrase1:='Удалить загрузку файла ';
      phrase2:=' из очереди загрузок?'
    end
  else
    begin
      phrase1:='Отменить загрузку файла ';
      phrase2:=' ?'
    end;
if (Gg.PercentDone<>100)
      and(sListView1.Selected.SubItems.Strings[1]<>'Отменено')
      and(MessageDlg(phrase1+globFileName+phrase2,mtWarning,[mbYes, mbNo],0)=mrYes)    
then
  begin

    PostMessage(MainHandle, TF_DELETE_DOWNLOAD, 0, 0);
    Application.ProcessMessages;

  end;
PostMessage(MainHandle, TF_RESUME, 0, 0);
sListView1.Repaint;

finally
//globFileName:='';
end;

end;

end.
