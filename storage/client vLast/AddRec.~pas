unit AddRec;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, sMaskEdit, sCustomComboEdit, sComboEdit,
  ExtCtrls, sPanel, sMonthCalendar, sTooledit, ComCtrls, sComboBoxes,
  acShellCtrls, sComboBox, sEdit, sLabel, sCurrEdit, Buttons, sSpeedButton,
  sColorSelect, sSpinEdit, acNoteBook, Grids, sListView, sFontCtrls,acDBGrid,
  sCurrencyEdit, DBCtrls, sDBLookupComboBox, sDialogs, sRadioButton,loadtypes, SendFileThread,
  sButton;

type
  TfAddRec = class(TForm)
    sdeDate: TsDateEdit;
    sLabelFX1: TsLabelFX;
    sLabelFX2: TsLabelFX;
    sgCoord: TStringGrid;
    sLabelFX3: TsLabelFX;
    sLabelFX4: TsLabelFX;
    sLabelFX5: TsLabelFX;
    sLabelFX6: TsLabelFX;
    sLabelFX8: TsLabelFX;
    sLabelFX9: TsLabelFX;
    sceSize: TsCurrencyEdit;
    sLabelFX10: TsLabelFX;
    sLabelFX11: TsLabelFX;
    sLabelFX12: TsLabelFX;
    sLabelFX13: TsLabelFX;
    seLocation: TsEdit;
    ssbApply: TsSpeedButton;
    ssbCancel: TsSpeedButton;
    sLabelFX14: TsLabelFX;
    sDBLookUpcbSpect: TsDBLookupComboBox;
    sDBLookUpcbRazr: TsDBLookupComboBox;
    sDBLookUpcbQuality: TsDBLookupComboBox;
    sDBLookUpcbKA: TsDBLookupComboBox;
    sOpenDialog1: TsOpenDialog;
    slPassport: TsLabelFX;
    sOpenDialog2: TsOpenDialog;
    sgRealCoord: TStringGrid;
    sButtonOpenFile: TsButton;
    sceFullNamePict: TsEdit;
    sButtonOpenPassport: TsButton;
    sceFullNamePassport: TsEdit;
    sLabel1: TsLabel;
    sseNomerVitka: TsSpinEdit;
    sseNomerMarsh: TsSpinEdit;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure XbledComponents(x:boolean);
    procedure ssbApplyClick(Sender: TObject);
    procedure sgCoordKeyPress(Sender: TObject; var Key: Char);
    procedure ResetForm;
    procedure ssbCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sgCoordDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sButtonOpenFileClick(Sender: TObject);
    procedure sButtonOpenPassportClick(Sender: TObject);
    procedure sseNomerVitkaExit(Sender: TObject);
    procedure sseNomerMarshExit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    LoadFiles:TStrings;
    Marshrut:string;
  end;

var
  fAddRec: TfAddRec; shortFileName:string;

implementation

uses DM, MConnect, SConnect, DB , addChoice, AddFromXML;

{$R *.dfm}

procedure TfAddRec.ResetForm;
var i:integer;
begin
if sOpenDialog1.FileName='' then sceFullNamePict.Text:='Введите полное имя снимка...'
  else sceFullNamePict.Text:=sOpenDialog1.FileName;
if sOpenDialog2.FileName='' then sceFullNamePassport.Text:='Введите полное имя паспорта...'
  else sceFullNamePassport.Text:=sOpenDialog2.FileName;
sdeDate.Text:='';
sceSize.Text:='';
sDBLookUpcbSpect.KeyValue:=-1;
sDBLookUpcbRazr.KeyValue:=-1;
sDBLookUpcbQuality.KeyValue:=-1;
sDBLookUpcbKA.KeyValue:=-1;
sseNomerVitka.Text:='00';
sseNomerMarsh.Text:='00000';
for i:=0 to 4 do
  begin
    sgCoord.Cells[i,0]:='';
    sgCoord.Cells[i,1]:='';
  end;
Tag:=0;
end;


procedure TfAddRec.XbledComponents(x:boolean);
begin
sceFullNamePassport.Enabled:=x;
//sceSize.Enabled:=x;
sDBLookUpcbSpect.Enabled:=x;
sDBLookUpcbRazr.Enabled:=x;
sDBLookUpcbQuality.Enabled:=x;
sDBLookUpcbKA.Enabled:=x;
sdeDate.Enabled:=x;
seLocation.Enabled:=x;
sgCoord.Enabled:=x;
sseNomerVitka.Enabled:=x;
sseNomerMarsh.Enabled:=x;
end;


procedure TfAddRec.FormShow(Sender: TObject);
begin
ResetForm;
Caption:='Add new record';
slPassport.Caption:='';
if not fDM.cdsSpect.Active then fDM.cdsSpect.Active:=true;
if not fDM.cdsRazr.Active then fDM.cdsRazr.Active:=true;
if not fDM.cdsQuality.Active then fDM.cdsQuality.Active:=true;
if not fDM.cdsKA.Active then fDM.cdsKA.Active:=true;
if GlobPict<>'' then
  begin
    Caption:='Modify data';
    sceFullNamePict.Text:=GlobPict;
    sButtonOpenFileClick(self);

  end;
end;

procedure TfAddRec.ssbApplyClick(Sender: TObject);
var i,j,res,IDPict:integer;
    strCoords,postfix,Fname:string;
    invalid:boolean;
    flt:real;
begin
sseNomerVitka.OnExit(self);
sseNomerMarsh.OnExit(self);
                                             //проверка введенных праметров
{if not(FileExists(sOpenDialog1.FileName))
  then
    begin
      ShowMessage('Файла'+ sOpenDialog1.FileName+' не существует!');
      Exit;
    end;    }
if (sdeDate.Text='')or(sDBLookUpcbSpect.Text='')or(sDBLookUpcbRazr.Text='')
    or(sDBLookUpcbQuality.Text='')or(sDBLookUpcbKA.Text='')
  then
    begin
      ShowMessage('Одно или несколько полей не заполнены!');
      Exit;
    end;
fAddRec.SetFocus;
invalid:=false;
if (sceFullNamePassport.Text='')or(sceFullNamePassport.Text='Введите полное имя паспорта...')
  then
    sceFullNamePassport.Text:='NONE';


for i:=0 to 4 do                 //заполняем невидимую таблицу с настоящими координатами
for j:=0 to 1 do                 //на основе таблицы заполненую пользователем
try
flt:=0;
//if sgCoord.Cells[i,j]='###ERROR!!!' then sgCoord.Cells[i,j]:='';
if (sgCoord.Cells[i,j]<>'')or(sgCoord.Cells[i,inv(j)]<>'')
  then
    flt:=StrToCoord(sgCoord.Cells[i,j]);

    if ((j=0)and((flt<-90)or(flt>90)))or((j=1)and((flt<-180)or(flt>180)))
      then
        raise Exception.Create('Вне диапазона');
    sgRealCoord.Cells[i,j]:=FloatToStr(flt);
except
invalid:=true;
sgRealCoord.Cells[i,j]:='0,0'  //признак неправильного значения

end;
sgCoord.Repaint;
if invalid then exit;

for i:=0 to 4 do
for j:=1 downto 0 do
  if sgRealCoord.Cells[i,j]=''
    then strCoords:=strCoords +'@'+'|'
    else strCoords:=strCoords + stringReplace(sgRealCoord.Cells[i,j],',','.',[rfReplaceAll])+'|';

postfix:='_prc';
Marshrut:='<' + sseNomerMarsh.Text+ '_' + sseNomerVitka.Text + '>';
res:=0;
if (fChoise.Tag = 1)and(sOpenDialog1.Files.Count < 1)
  then
    begin
      Fname:=GetShortName(sceFullNamePict.Text);
      res:=res+   fDM.SocketConn.AppServer.AddRecord(
        Fname+ Marshrut +postfix,
        sceFullNamePassport.Text,
        seLocation.Text,
        strCoords,
        sDBLookUpcbKA.KeyValue,
        sDBLookUpcbSpect.KeyValue,
        sDBLookUpcbRazr.KeyValue,
        sDBLookUpcbQuality.KeyValue,
        sceSize.Value,
        sdeDate.Date);
    end
  else
    for i:=0 to sOpenDialog1.Files.Count-1 do
      BEGIN
        Fname:=GetShortName(sOpenDialog1.Files[i]);
        IDPict:=fDM.SocketConn.AppServer.Find(FName,'Pict');
        if IDPict > 0
          then
            if MessageDlg('Файл '+ FName + '  уже есть в БД. Заменить его?',mtWarning,[mbYes, mbNo],0)=mrNO
              then
                begin
                  sOpenDialog1.Files[i]:='none';
                  Continue;
                end;
        res:=res+   fDM.SocketConn.AppServer.AddRecord(
          Fname+ Marshrut +postfix,
          sceFullNamePassport.Text,
          seLocation.Text,
          strCoords,
          sDBLookUpcbKA.KeyValue,
          sDBLookUpcbSpect.KeyValue,
          sDBLookUpcbRazr.KeyValue,
          sDBLookUpcbQuality.KeyValue,
          sceSize.Value,
          sdeDate.Date);
      END;
if res=0
then
  begin
    ShowMessage('Записи успешно внесены в базу данных');

    if (fChoise.Tag>1)or(tag=1) then         //магическая хрень с tag-ми для определения - нужно ли загружать файл на сервер...
      tag:=sOpenDialog1.Files.Count  //файлы будут загружаться
    else
      Tag:=0;                        //соответственно не будут (признак- нулевой tag)

    fChoise.Tag:=0;                  //чтобы по умолчанию файл не загружался
    //все эту хрень с tag-ми лучше переделать!!! да и вообще все переделать!
     close;
  end
else showmessage(MesError(res));


end;

procedure TfAddRec.sgCoordKeyPress(Sender: TObject; var Key: Char);
begin
if key in ['.'] then key:=',';
if key in [' '] then key:=':';
end;

procedure TfAddRec.ssbCancelClick(Sender: TObject);
begin
sOpenDialog1.FileName:='';
sOpenDialog2.FileName:='';
Tag:=0;
close;
end;

procedure TfAddRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//ResetForm;

end;

procedure TfAddRec.sgCoordDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
if sgRealCoord.Cells[ACol, ARow] = '0,0' then
  sgCoord.Canvas.Brush.color := clRed;
sgCoord.canvas.fillRect(Rect);
sgCoord.canvas.TextOut(Rect.Left,Rect.Top,sgCoord.Cells[ACol,ARow]);



end;

procedure TfAddRec.sButtonOpenFileClick(Sender: TObject);
var StrList:TStringList;marshName,crd,mar:string; ts:TSearchRec; i,IDPict:integer;
begin
if GlobPict='' then
  begin
    if not sOpenDialog1.Execute then  exit;
      /////////////////////////////////////////////////////////////////forrrrrrrrrrrrr( укоротить файлы)
       if FindFirst(sOpenDialog1.FileName, faAnyFile, ts)=0 then
      sceSize.Value:=ts.FindData.nFileSizeHigh*4096+ts.FindData.nFileSizeLow/1048576;

    sceFullNamePict.Text:=sOpenDialog1.FileName;

    shortFileName:=GetShortName(sOpenDialog1.FileName);
  end
else
    shortFileName:=sceFullNamePict.Text;
XbledComponents(true);

IDPict:=fDM.SocketConn.AppServer.Find(shortFileName,'Pict');
if IDPict > 0 then
  begin
    fChoise.ShowModal;
    if fChoise.Tag=0 then     //отмена перезаписи
      begin
        sOpenDialog1.Files.Clear;
        sOpenDialog1.FileName:='';
        sOpenDialog2.Files.Clear;
        sOpenDialog2.FileName:='';
        ResetForm;
        exit;
      end;
    if (fChoise.Tag=1)or(fChoise.Tag=3)
      then
        begin
           sseNomerVitka.Enabled:=false;
           sseNomerMarsh.Enabled:=false;
           seLocation.Enabled:=false;
           sDBLookUpcbKA.Enabled:=false;
           sgCoord.Enabled:=false;
           if (fChoise.Tag=1)
            then
              begin
                sceFullNamePict.Enabled:=false;
                //
              end;
        end;
    if fChoise.Tag=2 then
      XbledComponents(false);
    //получение полной информации по снимку
    fDM.cdsGetAllInfo.Active:=false;
    fDM.SocketConn.AppServer.GetAllInfo(IDPict);
    fDM.cdsGetAllInfo.Active:=true;
    mar:=fDM.dsGetAllInfo.DataSet.FieldByName('Маршрут').AsString;
    sseNomerMarsh.Text:=GetBefore('_',mar);
    sseNomerVitka.Text:=GetAfter('_',mar);
    sceFullNamePassport.Text:=fDM.dsGetAllInfo.DataSet.FieldByName('Паспорт').AsString;
    seLocation.Text:= fDM.dsGetAllInfo.DataSet.FieldByName('Местность').AsString;
    sDBLookUpcbSpect.KeyValue:=fDM.dsGetAllInfo.DataSet.FieldByName('Spect').AsInteger;
    sDBLookUpcbRazr.KeyValue:=fDM.dsGetAllInfo.DataSet.FieldByName('Razr').AsInteger;
    sDBLookUpcbQuality.KeyValue:=fDM.dsGetAllInfo.DataSet.FieldByName('Rate').AsInteger;
    sDBLookUpcbKA.KeyValue:=fDM.dsGetAllInfo.DataSet.FieldByName('KA').AsInteger;
    sceSize.Value:=StrToFloat(fDM.dsGetAllInfo.DataSet.FieldByName('Размер файла').AsString);
    sdeDate.Date :=StrToDateFmt('yyyy.mm.dd',fDM.dsGetAllInfo.DataSet.FieldByName('Дата съемки').AsString);

    for i:=0 to 3 do  //жуткий парсинг строки с координатами
      begin
        case i of
        0:crd:='СЗ';
        1:crd:='СВ';
        2:crd:='ЮВ';
        3:crd:='ЮЗ';

        end;
        sgCoord.Cells[i,1]:=GetBefore(' ',GetAfter('(',ChangeSymbols(fDM.dsGetAllInfo.DataSet.FieldByName(crd).AsString,'.',',')));
        sgCoord.Cells[i,0]:=GetBefore(')',GetAfter(' ',GetAfter(' ',ChangeSymbols(fDM.dsGetAllInfo.DataSet.FieldByName(crd).AsString,'.',','))));
      end;
  end
else tag:=1;

  try
    StrList:=TStringList.Create;
    StrList.Text:=stringReplace(shortFileName,'_',#13#10,[rfReplaceAll]);
    if StrList.Count<6 then exit;
    marshName:=StrList.strings[4]+'_'+strlist.strings[5];
    if fDM.SocketConn.AppServer.Find(marshName,'passport')>0 then
      begin
        fDM.cdsFindU.Active:=true;
        sceFullNamePassport.Text:=fDM.dsFindU.DataSet.Fields[1].AsString;
        slPassport.Caption:='В базе данных был найден подходящий паспорт';
      end;
   // получение даты из названия файла (работает только для "ресурса", поэтому пока не нужно...)
   // sdeDate.Text :=copy(StrList.Strings[2],5,2)+'.'+copy(StrList.Strings[2],3,2)+'.20'+copy(StrList.Strings[2],1,2);
   //
    if FindFirst(sOpenDialog1.FileName, faAnyFile, ts)=0 then
      sceSize.Value:=ts.FindData.nFileSizeHigh*4096+ts.FindData.nFileSizeLow/1048576;
    //получение полной информации по снимку

  finally
    StrList.Free;
  end;
end;

procedure TfAddRec.sButtonOpenPassportClick(Sender: TObject);
begin
if not sOpenDialog2.Execute then  exit;
slPassport.Caption:='';
sceFullNamePassport.Text:=sOpenDialog2.FileName;

end;

procedure TfAddRec.sseNomerVitkaExit(Sender: TObject);
begin
if sseNomerVitka.Value < 10 then sseNomerVitka.Text:='0'+IntToStr(sseNomerVitka.Value);
end;

procedure TfAddRec.sseNomerMarshExit(Sender: TObject);
var i,len,val:integer;
begin

val:=sseNomerMarsh.Value;
len:=Length(IntToStr(val));
sseNomerMarsh.Text:='';
if len < 5 then
  for i:=len to 4 do
    sseNomerMarsh.Text:=sseNomerMarsh.Text+'0';
sseNomerMarsh.Text:=sseNomerMarsh.Text+IntToStr(val);
end;

procedure TfAddRec.Button1Click(Sender: TObject);
begin
fAddFromXML.Show;
fAddRec.Close;
end;

end.
