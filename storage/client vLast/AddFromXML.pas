unit AddFromXML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ExtCtrls,
   sMonthCalendar, sTooledit, ComCtrls, Mask, xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls,
  xercesxmldom, oxmldom;

type
  TfAddFromXML = class(TForm)
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    XMLDocument1: TXMLDocument;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAddFromXML: TfAddFromXML; quantFiles:integer; nomVitka,marshroute:string;

implementation

uses Main, DM,InformMessThread, StrUtils;

{$R *.dfm}

procedure TfAddFromXML.Button1Click(Sender: TObject);
var i:integer; str:widestring; StrList:TStringList;
begin
if OpenDialog1.Execute then
  begin
    Memo1.Clear;
    XMLDocument1.LoadFromFile(widestring(OpenDialog1.FileName));
    XMLDocument1.Active:=true;
    StrList:=TStringList.Create;
    StrList.Text:=stringReplace(OpenDialog1.FileName,'_',#13#10,[rfReplaceAll]);
    i:=StrList.Count;
    marshroute := StrList.strings[i - 3]+'_'+strlist.strings[i - 2];
    StrList.Clear;
    //nomVitka:='';
    //for i:=1 to (5-length(XMLDocument1.DocumentElement.ChildNodes['nCycleNum'].Text)) do
    //  begin
    //    nomVitka:=nomVitka+'0';
    //  end;
    //nomVitka:=nomVitka+XMLDocument1.DocumentElement.ChildNodes['nCycleNum'].Text;
    quantFiles:=StrToInt(XMLDocument1.DocumentElement.ChildNodes['RouteFiles'].ChildNodes['nNumberOfFiles'].Text);
    Memo1.Lines.Append('Номер витка и маршрута: ' + marshroute);
    //Memo1.Lines.Append('    '
    //                    + nomVitka +'_0'
    //                    + XMLDocument1.DocumentElement.ChildNodes['nRouteInCycleNum'].Text);
    Memo1.Lines.Append('Дата съемки:');
    Memo1.Lines.Append('    ' + XMLDocument1.DocumentElement.ChildNodes['dStartDateTime'].Text);
    Memo1.Lines.Append('Имя устройства:');
    Memo1.Lines.Append('    ' + XMLDocument1.DocumentElement.ChildNodes['cDeviceName'].Text);
    Memo1.Lines.Append('Описание: ' + XMLDocument1.DocumentElement.ChildNodes['cComment'].Text);
    Memo1.Lines.Append('Файлы:');
    for i:=0 to quantFiles-1 do
      begin
        str:= XMLDocument1.DocumentElement.ChildNodes['RouteFiles'].ChildNodes['cFilePath1'].Text;
        Memo1.Lines.Append('    ' + XMLDocument1.DocumentElement.ChildNodes['RouteFiles']
                                    .ChildNodes[i].Text);
      end;
    Memo1.Lines.Append('Координаты полигона:');
    for i:=0 to 7 do
      begin
        Memo1.Lines.Append('    ' +XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[i].NodeName+' = '
                                  + XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[i].Text);
      end;
    Button2.Enabled:=true;
  end;
  //Memo1.Lines:=XMLDocument1.XML;

end;

procedure TfAddFromXML.Button2Click(Sender: TObject);
var i,IDPict:integer;strCoords,Marshrut,DirName,FName,BegData,Comment:string;ts:TSearchRec;sceSize:double;
messa : informMess;
begin
Button2.Enabled:=false;
DirName:=ExtractFileDir(OpenDialog1.FileName);

Marshrut:='<' + marshroute + '>';
BegData := copy(XMLDocument1.DocumentElement.ChildNodes['dStartDateTime'].Text,0,4)+'.'+
            copy(XMLDocument1.DocumentElement.ChildNodes['dStartDateTime'].Text,5,2)+'.'+
            copy(XMLDocument1.DocumentElement.ChildNodes['dStartDateTime'].Text,7,2);
Comment := XMLDocument1.DocumentElement.ChildNodes['cComment'].Text;
 //запись координат, очень запутана из-за того что нужно чтобы получился полигон
  begin
    strCoords:=strCoords + XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[1].Text + '|';
    strCoords:=strCoords + XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[0].Text + '|';
    strCoords:=strCoords + XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[3].Text + '|';
    strCoords:=strCoords + XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[2].Text + '|';
    strCoords:=strCoords + XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[7].Text + '|';
    strCoords:=strCoords + XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[6].Text + '|';
    strCoords:=strCoords + XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[5].Text + '|';
    strCoords:=strCoords + XMLDocument1.DocumentElement.ChildNodes['RouteRegion']
                                    .ChildNodes[4].Text + '|';

  end;
strCoords:=strCoords + '0|0|';

for i:=0 to quantFiles-1 do
  begin
  FName:=XMLDocument1.DocumentElement.ChildNodes['RouteFiles']
                                    .ChildNodes[i].Text;
  if FindFirst(DirName+'\'+ FName, faAnyFile, ts)=0 then
      sceSize:=ts.FindData.nFileSizeHigh*4096+ts.FindData.nFileSizeLow/1048576;
  messa:=informMess.Create('Запись данных на сервер');
  IDPict:=fDM.SocketConn.AppServer.Find(FName,'Pict');
  if IDPict > 0
    then
      if MessageDlg('Файл '+ FName + '  уже есть в БД. Заменить его?',mtWarning,[mbYes, mbNo],0)=mrNO
        then
          Continue;

  if fDM.SocketConn.AppServer.AddRecord(
        FName + Marshrut +'_prc',
        'NONE',
        Comment,
        strCoords,
        7,  //number KA
        1,  //spect
        4,  //Razr
        0,  //Quality
        sceSize,
        StrToDateFmt('yyyy.mm.dd',BegData))<>0
   then ShowMessage('error')
   else
    begin
      if FindFirst(FName, faAnyFile, ts)=0
      then
        fMain.DownLoadFile(DirName+'\'+ FName+Marshrut,'prc',ts.FindData.nFileSizeHigh*4096+ts.FindData.nFileSizeLow/1048576);
        if PosEx('.bsv',FName)>0
          then
            begin
              FName  := StringReplace(FName, '.bsv', '_str.bsv',
                          [rfReplaceAll, rfIgnoreCase]);
              if FileExists (FName)
                then  fMain.DownLoadFile(DirName+'\'+FName+Marshrut,'prc',ts.FindData.nFileSizeHigh*4096+ts.FindData.nFileSizeLow/1048576);
              FName  := StringReplace(FName, '_str.bsv', '_sli.bsv',
                          [rfReplaceAll, rfIgnoreCase]);
              if FileExists (FName)
                then  fMain.DownLoadFile(DirName+'\'+FName+Marshrut,'prc',ts.FindData.nFileSizeHigh*4096+ts.FindData.nFileSizeLow/1048576);

            end;

    end;

  end;
  if messa<>nil then
  begin
    messa.CloseThread;
    messa:=nil;
//    FileCreate(DirName+ '.done');
    ShowMessage('Записи успешно внесены в БД');
  end;
  
end;

procedure TfAddFromXML.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Memo1.Clear;
Button2.Enabled:=false;
end;

end.
