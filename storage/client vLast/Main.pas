unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,StdCtrls, Grids, DBGrids, DBCtrls, ExtCtrls,DB, Gauges,LoFiTh,
  sSkinManager, sSkinProvider, sDialogs, sButton, acPathDialog,
  sCalculator, acMagn, sHintManager, acDBGrid,sListView,
  sPanel, sDBNavigator, Buttons, sSpeedButton, sGauge, sLabel, ImgList, acAlphaImageList,
  sEdit, Menus, sGroupBox, sRadioButton, Mask, sMaskEdit, sCustomComboEdit,
  sTooledit, acPNG, ComCtrls,midaslib,ShellApi;

const NameProg='Storage-client Version 2.2 15.07.2016 ';

type
  TfMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    sSkinManager1: TsSkinManager;
    sDBNavigator1: TsDBNavigator;
    sDBGrid1: TsDBGrid;
    sPathDialog1: TsPathDialog;
    sbSearch: TsSpeedButton;
    ssbConnect: TsSpeedButton;
    ssbRefresh: TsSpeedButton;
    ssbDisconnect: TsSpeedButton;
    ssbLoadFiles: TsSpeedButton;
    ssbTheme: TsSpeedButton;
    slSearchCount: TsLabel;
    ssbLoads: TsSpeedButton;
    ssbExit: TsSpeedButton;
    sHintManager1: TsHintManager;
    PopupMenu1: TPopupMenu;
    passport: TMenuItem;
    ssbAddRecord: TsSpeedButton;
    Image1: TImage;
    Image2: TImage;
    change: TMenuItem;
    slSearchServer: TsLabel;
    alllPasport: TMenuItem;
    bShowMap: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TFMesCloseThread(var Msg: TMessage); message TF_CLOSE;
    procedure TFMesDeleteDownload(var Msg: TMessage); message TF_DELETE_DOWNLOAD;
    procedure TFMesSuspendThread(var Msg: TMessage); message TF_SUSPEND;
    procedure TFMesResumeThread(var Msg: TMessage); message TF_RESUME;
    procedure FormActivate(Sender: TObject);
    procedure sSkinManager1AfterChange(Sender: TObject);
    procedure DownLoadFile(const DestName,SourceFullName:string;Size:double=0);
    procedure sbSearchClick(Sender: TObject);
    procedure sDBGrid1DblClick(Sender: TObject);
    procedure ssbConnectClick(Sender: TObject);
    procedure ssbRefreshClick(Sender: TObject);
    procedure ssbDisconnectClick(Sender: TObject);
    procedure ssbLoadFilesClick(Sender: TObject);
    procedure ssbThemeClick(Sender: TObject);
    procedure ssbLoadsClick(Sender: TObject);
    procedure ssbExitClick(Sender: TObject);
    procedure passportClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormatFcopyShow;
    procedure ssbAddRecordClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure changeClick(Sender: TObject);
    procedure alllPasportClick(Sender: TObject);
    procedure bShowMapClick(Sender: TObject);

  private
    { Private declarations }
  public
    FThread:TFileLoadThread;

  end;

var f:TextFile;  flagConnect:boolean=false;

function TrimStringEnd(Str: string;Symbol:char): string;
function TrimStringBegin(const Str: string;Symbol:char): string;
var
  fMain: TfMain;  ListLoad:TList; countLoad:integer=0;
  currLoad:integer;DisplayResol:TRect;
implementation

uses DM, MConnect,fMdownload,loadtypes,FullViewRec,AddRec,search,InformMessThread;

{$R *.dfm}


procedure TfMain.FormatFcopyShow;

begin

if (DisplayResol.Bottom-(top+Height))>fCopy.Height
then fCopy.Top:=top+Height
else fCopy.Top:=DisplayResol.Bottom-fCopy.Height;
fCopy.Left:=left;
fCopy.Show;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//if FThread<>nil then FThread.Terminate;
if (FThread<>nil)and(not FThread.FileThreadIsEmpty)then
  if MessageDlg('У вас еще есть загружаемые файлы! Удалить их?',mtWarning,[mbYes, mbNo],0)=mrNo
    then
        begin
          Abort;
        end
  else
if not FThread.CloseThread then
   ShowMessage('Неудалось завершить поток');


if fDM.SocketConn.Connected then
  begin
    //fDM.SocketConn.AppServer.DiconnectToBD;
     fDM.SocketConn.Close;
  end;

   

end;

procedure TfMain.FormCreate(Sender: TObject);
var k:integer;str:string;f:textfile;
begin
//Screen.Cursors[1] := LoadCursorFromFile('earth.ani');
//Screen.Cursor := 1;
SystemParametersInfo(SPI_GETWORKAREA, 0, @displayResol, 0);
ListLoad:=TList.Create();
fMain.Caption:= NameProg;
//чтение файла с пользовательскими настройками++++++++++++++++++++++++++++++++++
try
  AssignFile(f,GetUserMyDocumentsFolderPath+'/Server.ini');
  Reset(f);
  
  while not (Eof(f)) do
    BEGIN
      Readln(f,str);
      k:=pos('//',str);
      if k > 0
        then str:=copy(str,0,k-1);

      k:=pos('style',str);
      if k > 0
        then
          begin
            str:=copy(str,k,length(str)-k+1);
            str:=copy(str,pos('=',str)+1,length(str)-k);
            str:=TrimStringEnd(str,' ');
            str:=TrimStringBegin(str,' ');
          end;

    END;

finally
  closefile(f)
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if str<>''
  then sSkinManager1.SkinName:= str
else
  sSkinManager1.SkinName:=sSkinManager1.GetRandomSkin;
fMain.Caption:=NameProg + sSkinManager1.SkinName;
if FileExists(GetUserMyDocumentsFolderPath+'/newServer.ini')
    then
      begin
        DeleteFile(GetUserMyDocumentsFolderPath+'/Server.ini');
        RenameFile(GetUserMyDocumentsFolderPath+'/newServer.ini',GetUserMyDocumentsFolderPath+'/Server.ini');
      end;

//fMain.sSkinManager1.Active:=true;
//sButton1.Caption:=fMain.sSkinManager1.SkinName;
MainHandle:=Handle;

end;

procedure TfMain.FormResize(Sender: TObject);
begin

ssbConnect.Left:=sDBNavigator1.Width + 20;
ssbRefresh.Left:=ssbConnect.Width +ssbConnect.Left+ 2;
ssbDisConnect.Left:=ssbRefresh.Width +ssbRefresh.Left +2;
ssbLoadFiles.Left:=ssbDisconnect.Width+ssbDisconnect.Left +2;
ssbTheme.Left:=ssbLoadFiles.Width + ssbLoadFiles.Left+2;
ssbAddRecord.Left:=ssbTheme.Width + ssbTheme.Left+2;
sbSearch.Left:=ssbTheme.Width + ssbTheme.Left + 52;
ssbLoads.Left:=Panel3.Width - ssbLoads.Width;
bShowMap.Left:=ssbLoads.Left - 125;
ssbExit.Left:=Panel1.Width - ssbExit.Width-1;
slSearchCount.Left:=round(Panel3.Width*0.4) ;

if fDM.cdsQViewAll.Active then
  begin
    sDBGrid1.Columns[0].Width:=round(sDBGrid1.Width*0.05);
    sDBGrid1.Columns[1].Width:=round(sDBGrid1.Width*0.1);
    sDBGrid1.Columns[2].Width:=round(sDBGrid1.Width*0.1);
    sDBGrid1.Columns[3].Width:=round(sDBGrid1.Width*0.45);
    sDBGrid1.Columns[4].Width:=round(sDBGrid1.Width*0.12);
    sDBGrid1.Columns[5].Width:=round(sDBGrid1.Width*0.2);

  end;
Refresh;
end;

procedure Tfmain.TFMesDeleteDownload(var Msg: TMessage);
var i,j,index:integer;dwLoad:TDownLoad;str:string;Gg:TsGauge;LsVi:TsListView;LsIt:TListItem;

begin

if (FThread<>nil)and(not FThread.FileThreadIsEmpty)then
begin
  str:=GetShortName(FThread.GetFileName);
  if (str=GlobFileName)
  then
    begin
      FThread.SetStateSend(-1); // остановим загрузку файла
      fCopy.sListView1.Selected.SubItems.Strings[1]:='Отменено!';
    end;
end;


if (str<>GlobFileName)
then
for i:=0 to ListLoad.Count-1 do
  begin
    dwLoad:=ListLoad.Items[i];
    if GetShortName(dwLoad.GetFileName)=GlobFileName then
      begin
        LsVi:=fCopy.sListView1;
        LsIt:=LsVi.Selected;
        if LsIt<>nil then
         begin
          index := LsIt.Index;
          TsGauge(LsIt.Data).Free;
          LsVi.Items.Delete(index);
              //переместить индикаторы выше
          for j:=index to LsVi.Items.Count-1 do
            begin
              LsIt := LsVi.Items.Item[j];
              Gg := TsGauge(LsIt.Data);
              Gg.Top := Gg.Top -
                (Gg.BoundsRect.Bottom -
                 Gg.BoundsRect.Top);
            end;
         end;
        fCopy.sListView1.Refresh;
        ListLoad.Delete(i);
        ListLoad.Pack;
        break;
      end;
  end;
end;

procedure TfMain.TFMesSuspendThread(var Msg: TMessage);
begin
if (FThread<>nil)and(not FThread.FileThreadIsEmpty)and(not FThread.Suspended)then
FThread.Suspend;
end;

procedure Tfmain.TFMesResumeThread(var Msg: TMessage);
begin
if (FThread<>nil)and(not FThread.FileThreadIsEmpty)and(FThread.Suspended)
then
FThread.Resume;
end;

procedure Tfmain.TFMesCloseThread(var Msg: TMessage);
var i:integer;dwLoad:TDownLoad;
begin
for i:=0 to ListLoad.Count-1 do
  begin
    dwLoad:=listLoad.Items[i];
    if dwLoad.ID = currLoad then
      begin
        ListLoad.Delete(i);
        ListLoad.Pack;
        break;
      end;
  end;
if ListLoad.Count > 0
then
  begin
    dwLoad:=listLoad.Items[0];
    FThread:=TFileLoadThread.Create(true,dwLoad.Filename,dwLoad.SourceFile,dwLoad.ID,fMain.Handle,dwLoad.GetSize);
    FThread.FreeOnTerminate:=true;
    currLoad:=dwLoad.ID;
    FThread.Resume;
  end
else FThread:=nil;
end;


procedure TfMain.FormActivate(Sender: TObject);
begin

Refresh;
end;

function TrimStringEnd(Str: string;Symbol:char): string;      //функция удаления пробелов справа
begin
  Result := Str;
  if Str = '' then
    exit;
  Str := Trim(Str);

  while (length(Str) > 0) and
    (AnsiUpperCase(Str[length(Str)]) = AnsiUpperCase(Symbol)) do
    Delete(Str, length(Str), 1);
  Result := Str;
end;

function TrimStringBegin(const Str: string;Symbol:char): string;                  //функция удаления пробелов слева
var
  len: Byte absolute Str;
  i: Integer;
begin
  Result := Str;
  if Str = '' then
    exit;

  i := 1;
  while (i <= len) and (Str[i] = Symbol) do
    Inc(i);
  TrimStringBegin := Copy(Str, i, len)
end;

procedure TfMain.DownLoadFile(const DestName,SourceFullName:string;size:double=0);
var dwLoad:TDownLoad;
begin
if (DestName<>'')and(SourceFullName<>'') then
  begin
    inc(countLoad);

    dwLoad:=TDownLoad.Create(DestName,SourceFullName,countLoad,Size);
    ListLoad.Add(dwLoad);
    if ((FThread=nil)or(FThread.FileThreadIsEmpty))           ////////////??????????????
      then                                                    //весьма проблемный участок при множественной загрузке
        begin
          dwLoad:=listLoad.Items[0];
          FThread:=TFileLoadThread.Create(true,dwLoad.Filename,dwLoad.SourceFile,dwLoad.ID,fMain.Handle,dwLoad.GetSize);
          FThread.FreeOnTerminate:=true;
          currLoad:=dwLoad.ID;
          FThread.Resume;
        end;
     if length(dwLoad.SourceFile)>3 then
        fCopy.AddDownload(dwLoad.SourceFile,dwLoad.ID)
     else
        fCopy.AddDownload('Загрузка на сервер ' + dwLoad.Filename,dwLoad.ID);
     FormatFcopyShow;
  end;
fCopy.sListView1.Refresh;

end;


procedure TfMain.sSkinManager1AfterChange(Sender: TObject);
begin
Refresh;
end;

procedure TfMain.sbSearchClick(Sender: TObject);
var i,k:integer;mess:informMess;
begin


if not fdm.SocketConn.Connected then
     ssbConnectClick(self);
 if fdm.SocketConn.AppServer.ConnectedToBD then
   begin
    fsearch.showmodal();
    if fSearch.Tag > 0
    then
      with fdm do begin
        mess:=informMess.Create('обработка запроса...');
        slSearchCount.Caption:='Найдено записей -- '+inttostr(fSearch.Tag);
        cdsQViewAll.Active:=true;
        sDBGrid1.Columns[0].Width:=round(sDBGrid1.Width*0.05);
        sDBGrid1.Columns[1].Width:=round(sDBGrid1.Width*0.1);
        sDBGrid1.Columns[2].Width:=round(sDBGrid1.Width*0.1);
        sDBGrid1.Columns[3].Width:=round(sDBGrid1.Width*0.45);
        sDBGrid1.Columns[4].Width:=round(sDBGrid1.Width*0.12);
        sDBGrid1.Columns[5].Width:=round(sDBGrid1.Width*0.2);
        k:=cdsQViewAll.FieldCount-1;
        //for i:=5 to k do
        //  sDBGrid1.Columns[i].Width:=round(sDBGrid1.Width*0.05);
        mess.CloseThread;
        mess:=nil;
                  end;

    end
 else fdm.SocketConn.Close;

end;

procedure TfMain.sDBGrid1DblClick(Sender: TObject);
begin
enabled:=false;
if (DisplayResol.Right-(Left+Width))>fViewAll.Width
  then fViewAll.Left:=Left+Width
  else fViewAll.Left:=DisplayResol.Right-fViewAll.Width;
fViewAll.Top:=Top;
with sDBgrid1.SelectedRows do

    if Count > 0 then
      if IndexOf(Items[0]) > -1 then
        begin
          sDBgrid1.Datasource.Dataset.Bookmark := Items[0];
          fDM.cdsGetAllInfo.Active:=false;
          fDM.SocketConn.AppServer.GetAllInfo(sDBgrid1.Datasource.Dataset.Fields[0].AsInteger);
          if fViewAll.Visible= true
          then fViewAll.sListView1.Clear;
          fDM.cdsGetAllInfo.Active:=true;
          if fViewAll.Visible
          then fViewAll.View
          else fViewAll.Show;
        end;

enabled:=true;

fViewAll.Show;
end;

procedure TfMain.ssbConnectClick(Sender: TObject);
var str:string;tstr:TstringList; ports:array[1..1000]of integer;i,k:integer;
begin
tstr:=TStringList.Create();
if fDM.SocketConn.Tag>0 then
  begin
    ssbDisconnectClick(self);
  end;
if not(flagConnect) then
BEGIN
try

  slSearchServer.Left:=ssbExit.Left+ssbExit.Width+15;
  slSearchServer.Visible:=true;
  Application.ProcessMessages;
  AssignFile(f,GetUserMyDocumentsFolderPath+'/Server.ini');
  Reset(f);
except

  fDM.SocketConn.Host:='Storage-server';
  tstr.Text:='//Чем меньше список тем быстрее подключаемся :)';
  tstr.Append('Storage-server');
  tstr.Append('192.168.0.254');
  tstr.Append('127.0.0.1');
  tstr.Append('port 211');
  tstr.SaveToFile(GetUserMyDocumentsFolderPath+'/Server.ini');
  AssignFile(f,GetUserMyDocumentsFolderPath+'/Server.ini');
  Reset(f);
end;
k:=1;
while not (Eof(f)) do
  BEGIN
    Readln(f,str);
    str:=TrimStringEnd(str,' ');
    str:=TrimStringBegin(str,' ');
    if (str<>'')and(str[1]='p')and(str[2]='o')and(str[3]='r')and(str[4]='t')    //индуский код  :)    надо иправить!!!!
      then
        begin
          str:=copy(str,5,length(str)-1);
          str:=TrimStringEnd(str,' ');
          try
            ports[k]:=strtoint(str);
            k:=k+1;
          except

          end;
        end;
  END;
for i:=1 to k-1 do
BEGIN
if flagConnect then break;
fDM.SocketConn.Port:=ports[i];
reset(f);
while (not(Eof(f)))and(not flagConnect) do
try
  Readln(f,str);
  str:=TrimStringEnd(str,' ');
  str:=TrimStringBegin(str,' ');
  if (str[1]='/' )and(str[2]='/' ) then continue;

  if (str[1] in ['0'..'9'])
    then begin fDM.SocketConn.Address:=str; fDM.SocketConn.Host:=''; end
    else begin fDM.SocketConn.Host:=str; fDM.SocketConn.Address:=''; end;
  fDM.SocketConn.Open;
  flagConnect:=true;
except
   Continue;
end;
END;
slSearchServer.Visible:=false;
if not flagConnect then begin ShowMessage('Сервер не найден!');exit; end;

closefile(f);
//fDM.SocketConn.Open;
END;
if (not(fDM.SocketConn.LoginPrompt))then fDM.SocketConn.LoginPrompt:=true;
fDM.SocketConn.Connected:=false;
fDM.SocketConn.Open;
with fDM do
try

if SocketConn.Tag<0 then
SocketConn.Tag:=SocketConn.AppServer.Login(us,pass);
Image1.Visible:=false;
Image2.Visible:=true;

except
SocketConn.Close;
    MessageDlg('Невозможно подключиться к базе данных! Проверьте правильность ввода логина и пароля!'
               +'  code: '+IntToStr(SocketConn.Tag)
               ,mtError,[mbOK],0);

     exit;
end;

if fDM.SocketConn.Tag > 2 then  ssbAddRecord.Enabled :=true
else ssbAddRecord.Enabled :=false;
if fdm.SocketConn.AppServer.StorageFileExist('$Server.ini')>0 then
DownLoadFile(GetUserMyDocumentsFolderPath+'/newServer.ini','$Server.ini',2);


end;

procedure TfMain.ssbRefreshClick(Sender: TObject);
begin
if not(fDM.SocketConn.Connected) then exit;
if fDM.SocketConn.AppServer.ConnectedToBD then
  begin
     fDM.cdsQViewAll.Close;
     fDM.cdsQViewAll.Open;
     fMain.Resize;


  end;
end;

procedure TfMain.ssbDisconnectClick(Sender: TObject);
var i:integer; dwload:TDownLoad; gg:TsGauge;
begin
    if not(fDM.SocketConn.Connected) then exit;
    if (FThread <> nil)and(not FThread.FileThreadIsEmpty)and(not FThread.Suspended)
    then
      begin
        FThread.Suspend;
        if MessageDlg('У вас еще есть загружаемые файлы! Удалить их?',mtWarning,[mbYes, mbNo],0)=mrNo
        then
          begin
            FThread.Resume;
            Abort;
          end
        else
          begin
            FThread.Resume;
            if not FThread.CloseThread then
              ShowMessage('Неудалось завершить поток')
              else FThread:=nil;
              for i:=fCopy.sListView1.Items.Count -1 downto 0 do
              if strtoint(fCopy.sListView1.Items[i].SubItems[0]) >= currload
              then
                begin
                  fCopy.sListView1.Items.BeginUpdate;
                  fCopy.sListView1.Items[i].SubItems.Clear;
                  gg:=fCopy.sListView1.Items[i].Data;
                  gg.Free;
                  fCopy.sListView1.Items[i].Data:=nil;
                  fCopy.sListView1.Items[i].Delete;
                  fCopy.sListView1.Items.EndUpdate;
                  fCopy.sListView1.Refresh;
                  //dec(countTFs);
                end;
          end;
      end;
    for i:=ListLoad.Count-1 downto 0 do
      begin
        dwLoad:=listLoad.Items[i];
        if dwLoad.ID >= currLoad then
          begin
            ListLoad.Delete(i);
          end;

      end;
    ListLoad.Pack;
    fDM.SocketConn.AppServer.DiconnectToBD;
    fDM.SocketConn.Close;
    fdm.SocketConn.Tag:=-1;
    ssbAddRecord.Enabled:=false;
    Image2.Visible:=false;
    Image1.Visible:=true;
    ShowMessage('Соеденение с базой данных разорвано');

end;

procedure TfMain.ssbLoadFilesClick(Sender: TObject);
var
  x: word; FilePath,SaveTo:widestring;
  TempBookmark: TBookMark;
begin
  if sDBGrid1.SelectedRows.Count<1 then abort;
  if not fdm.SocketConn.Connected then
     ssbConnectClick(self);
  if not sPathDialog1.Execute then abort;
  sDBGrid1.Datasource.Dataset.DisableControls;
  TempBookmark := sDBGrid1.Datasource.Dataset.GetBookmark;
  with sDBgrid1.SelectedRows do
    if Count > 0 then
    begin

      for x := 0 to Count - 1 do
      begin
        if IndexOf(Items[x]) > -1 then
        begin
          sDBGrid1.Datasource.Dataset.Bookmark := Items[x];
          FilePath:='...'
            +'\'+TrimStringEnd(sDBGrid1.Datasource.Dataset.Fields[1].AsString,' ')
            +'\'+TrimStringEnd(sDBGrid1.Datasource.Dataset.Fields[2].AsString,' ')
            +'\'+TrimStringEnd(sDBGrid1.Datasource.Dataset.Fields[3].AsString,' ');
          SaveTo:= sPathDialog1.Path+'\'+TrimStringEnd(sDBGrid1.Datasource.Dataset.Fields[3].AsString,' ');
          if  fdm.SocketConn.AppServer.StorageFileExist(FilePath)>0
            then

              if FileExists(SaveTo)
              then
                if MessageDlg('Файл '+ SaveTo + '  уже существует. Заменить его?',mtWarning,[mbYes, mbNo],0)=mrYes
                  then
                    DownLoadFile(SaveTo,FilePath,sDBGrid1.Datasource.Dataset.Fields[4].AsFloat)
                  else
              else
                DownLoadFile(SaveTo,FilePath,sDBGrid1.Datasource.Dataset.Fields[4].AsFloat)
            else
              showmessage('Файл ' + sDBGrid1.Datasource.Dataset.Fields[3].AsString + ' не найден или недоступен!');
        end;
      end;
    end;
  sDBGrid1.Datasource.Dataset.GotoBookmark(TempBookmark);
  sDBGrid1.Datasource.Dataset.FreeBookmark(TempBookmark);
  sDBGrid1.Datasource.Dataset.EnableControls;

end;

procedure TfMain.ssbThemeClick(Sender: TObject);
var i,n:integer; alltext:TstringList;
begin
n:=sSkinManager1.InternalSkins.IndexOf(sSkinManager1.SkinName);
if n>=sSkinManager1.InternalSkins.Count-1 then n:=0
  else inc(n);
sSkinManager1.SkinName:=sSkinManager1.InternalSkins.Items[n].Name;
fMain.Caption:=NameProg + sSkinManager1.SkinName;

//Запись в файл с пользовательскими настройками+++++++++++++++++++++++++++++++++
try
  alltext:=TStringList.Create;
  alltext.LoadFromFile(GetUserMyDocumentsFolderPath+'/Server.ini');
  n:=-1;
  for i:=0 to alltext.Count-1 do
    if pos('style',alltext.Strings[i]) > 0
      then
        begin
          alltext.Strings[i]:='style = '+ sSkinManager1.SkinName;
          n:=i;
        end;

  if n<0
    then alltext.Append('style = '+ sSkinManager1.SkinName);
  alltext.SaveToFile(GetUserMyDocumentsFolderPath+'/Server.ini');
finally

end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end;

procedure TfMain.ssbLoadsClick(Sender: TObject);
begin
if fCopy.Showing then fCopy.Close
else FormatFcopyShow;
end;

procedure TfMain.ssbExitClick(Sender: TObject);
begin
  fMain.Close;
end;

procedure TfMain.passportClick(Sender: TObject);
var FilePath:widestring;
begin
if (sDBGrid1.DataSource.DataSet.IsEmpty) then exit;


if fDM.SocketConn.AppServer.FindPassport(sDBGrid1.Datasource.Dataset.Fields[0].AsInteger)<1 then
  begin
    ShowMessage('В базе данных нет паспорта для данного файла!');
    exit;
  end;
if sPathDialog1.Execute then
  begin
    fDM.cdsFindPassport.Active:=true;
    FilePath:='...'+ TrimStringEnd(fDM.dsFindPassport.DataSet.Fields[0].AsString ,' ')
            +'\'+TrimStringEnd(fDM.dsFindPassport.DataSet.Fields[1].AsString ,' ');
    if  fdm.SocketConn.AppServer.StorageFileExist(FilePath)>0
      then  DownLoadFile(sPathDialog1.Path+'\'+TrimStringEnd(fDM.dsFindPassport.DataSet.Fields[1].AsString,' ')
                  ,FilePath )
      else  showmessage('Файл ' + fDM.dsFindPassport.DataSet.Fields[1].AsString + ' не найден или недоступен!');
    fDM.cdsFindPassport.Active:=false;
  end;
end;

procedure TfMain.PopupMenu1Popup(Sender: TObject);
begin
if not(sDBGrid1.DataSource.DataSet.IsEmpty)
  then
    begin
      PopupMenu1.Items[0].Caption:='Скачать пасспорт для '+
          (sDBGrid1.Datasource.Dataset.Fields[3].AsString);
      PopupMenu1.Items[1].Caption:='Редактировать данные для '+
          (sDBGrid1.Datasource.Dataset.Fields[3].AsString);
      PopupMenu1.Items[2].Caption:='Скачать все паспорта маршрута '+
          (sDBGrid1.Datasource.Dataset.Fields[2].AsString);
      if fDM.SocketConn.Tag < 2 then PopupMenu1.Items[1].Enabled:= false;
    end;
end;

procedure TfMain.ssbAddRecordClick(Sender: TObject);
var i:integer;postfix:string;searchRecF:TSearchRec;
begin
if fDM.SocketConn.Tag < 2 then
  begin
    ssbAddRecord.Enabled:=false;
    if fdm.SocketConn.Connected then
    ShowMessage('Незнаю как вы смогли нажать на эту кнопку, но у вас нет прав редактировать и добавлять новые записи');
    exit;
  end;
{if fDM.SocketConn.Connected then
fAddRec.Show
else ShowMessage('Соединение отсуствует!');   }
 fAddRec.ShowModal;

     postfix:='prc';


if fAddRec.Tag>0 then begin            //использую tag формы для признака необходимости загрузить файл(ы) на сервер (плохо, надо исправить...)
  if (fAddRec.sOpenDialog2.Files.Count>0)and(FindFirst(fAddRec.sOpenDialog2.Files[0], faAnyFile, searchRecF)=0)
    then
      DownLoadFile(fAddRec.sOpenDialog2.Files[0]+ fAddRec.Marshrut ,postfix,searchRecF.FindData.nFileSizeHigh*4096+searchRecF.FindData.nFileSizeLow/1048576);
  for i:=0 to fAddRec.sOpenDialog1.Files.Count-1 do
   if (fAddRec.sOpenDialog1.Files[i]<>'none')and(FindFirst(fAddRec.sOpenDialog1.Files[i], faAnyFile, searchRecF)=0)
    then
      DownLoadFile(fAddRec.sOpenDialog1.Files[i]+fAddRec.Marshrut,postfix,searchRecF.FindData.nFileSizeHigh*4096+searchRecF.FindData.nFileSizeLow/1048576);
                      end;
fAddRec.sOpenDialog1.Files.Clear;
fAddRec.sOpenDialog2.Files.Clear;



end;

procedure TfMain.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
if (NewWidth<500)or(NewHeight<200) then
  begin
    Resize:=false;
  end;

end;

procedure TfMain.changeClick(Sender: TObject);
begin
///
GlobPict:=sDBGrid1.Datasource.Dataset.Fields[3].AsString;
ssbAddRecordClick(self);
GlobPict:='';
end;

procedure TfMain.alllPasportClick(Sender: TObject);
var FilePath:widestring;i:integer;
begin
if (sDBGrid1.DataSource.DataSet.IsEmpty) then exit;

if fDM.SocketConn.AppServer.FindAllPassports(sDBGrid1.Datasource.Dataset.Fields[2].AsString) < 1
  then
    begin
      showmessage('Паспорта для машрута '+ sDBGrid1.Datasource.Dataset.Fields[2].AsString + ' не найдены!');
      exit;
    end;
if sPathDialog1.Execute  then
  begin
        fdm.cdsFindAllPassports.Active:=true;
        fdm.dsFindAllPassports.DataSet.First;
    for i:=1 to fdm.cdsFindAllPassports.RecordCount do
      begin
        FilePath:='...'+ TrimStringEnd(fDM.dsFindAllPassports.DataSet.Fields[0].AsString ,' ')
            +'\'+TrimStringEnd(fDM.dsFindAllPassports.DataSet.Fields[1].AsString ,' ');
        if  fdm.SocketConn.AppServer.StorageFileExist(FilePath)>0
          then  DownLoadFile(sPathDialog1.Path+'\'+TrimStringEnd(fDM.dsFindAllPassports.DataSet.Fields[1].AsString,' ')
                  ,FilePath );
        fdm.dsFindAllPassports.DataSet.Next;
      end;
    fDM.cdsFindAllPassports.Active:=false;
  end;
end;

procedure TfMain.bShowMapClick(Sender: TObject);
var i:integer; f:textfile;

begin
  //AssignFile(f,'poli.txt');
  AssignFile(f,GetUserMyDocumentsFolderPath+'/poli.txt');

  if sDBGrid1.FieldCount<2 then
    begin
      ShellExecute(Handle,'open','atlas.exe',nil,nil,SW_SHOWNORMAL);
      abort;
    end;
  try

  sDBGrid1.DataSource.DataSet.DisableControls;

  Rewrite(f);
  sDBGrid1.DataSource.DataSet.First;
  
  
  while not (sDBGrid1.DataSource.DataSet.Eof) do
    begin
        for i:=0 to sDBGrid1.DataSource.DataSet.FieldCount-1 do
          begin

        If ((sDBGrid1.DataSource.DataSet.Fields[i].FieldName = 'СВ')
          or(sDBGrid1.DataSource.DataSet.Fields[i].FieldName = 'СЗ')
          or(sDBGrid1.DataSource.DataSet.Fields[i].FieldName = 'ЮВ')
          or(sDBGrid1.DataSource.DataSet.Fields[i].FieldName = 'ЮЗ'))
          and(sDBGrid1.DataSource.DataSet.Fields[i].AsString <> '')
        then   Begin

          writeln(f,GetBefore(' ',ParseCoord(sDBGrid1.DataSource.DataSet.Fields[i].AsString)));
          writeln(f,GetAfter(' ',ParseCoord(sDBGrid1.DataSource.DataSet.Fields[i].AsString)));
               end;

          end;
        sDBGrid1.DataSource.DataSet.Next;
    end;


  finally
  sDBGrid1.DataSource.DataSet.EnableControls;
  CloseFile(f);
  Sleep(100);
  ShellExecute(Handle,'open','atlas.exe',nil,nil,SW_SHOWNORMAL);
  end;



  

end;

end.
