unit RDMDZZ;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,
  DBClient, DZZServApp_TLB, StdVcl, Provider, DB, ADODB, Variants, Registry ,main,HelpfulFunc;

type
  TDZZRDM = class(TRemoteDataModule, IDZZRDM)
    ADOConnection1: TADOConnection;
    tKA: TADOTable;
    dsKA: TDataSource;
    dspKA: TDataSetProvider;
    qViewAll: TADOQuery;
    dsQViewAll: TDataSource;
    dspQViewAll: TDataSetProvider;
    qGetFullInfo: TADOQuery;
    dsGetFullInfo: TDataSource;
    dspGetFullInfo: TDataSetProvider;
    qFindPassport: TADOQuery;
    dsFindPassport: TDataSource;
    dspFindPassport: TDataSetProvider;
    qUser: TADOQuery;
    tSpect: TADOTable;
    dsSpect: TDataSource;
    dspSpect: TDataSetProvider;
    tRazr: TADOTable;
    tQuality: TADOTable;
    dsRazr: TDataSource;
    dsQuality: TDataSource;
    dspRazr: TDataSetProvider;
    dspQuality: TDataSetProvider;
    qAddRecord: TADOQuery;
    qFindUni: TADOQuery;
    dsFindUni: TDataSource;
    dspFindUni: TDataSetProvider;
    qLogger: TADOQuery;
    qUpdateStatusPict: TADOQuery;
    qGetMarshDir: TADOQuery;
    qFindAllPassports: TADOQuery;
    dsFindAllPassports: TDataSource;
    dspFindAllPassports: TDataSetProvider;
    procedure RemoteDataModuleDestroy(Sender: TObject);
    procedure RemoteDataModuleCreate(Sender: TObject);
  private
    Filestream,FilestreamWrite:TFileStream;
    SendState,QuantityMbyte:integer;
    TickCount:int64;
    MarshDir,MarshName:widestring;
    FileWriteName,username,PictNameGlobal:widestring; userAccess:integer;
    procedure ParsePath(var fname:widestring);
    procedure  logging(s:string);
    function AddLogBD(const PictN:WideString;Sz:int64;success:boolean;const Oper:WideString):integer;
    Function UpStatusPict(const pName:WideString):integer;
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
    function Login(const us, psw: WideString): Integer; safecall;
    function ConnectedToBD: Integer; safecall;
    procedure DiconnectToBD; safecall;
    function OpenFile(const FileName: WideString): Double; safecall;
    function GetFileData(out Data: OleVariant; ArraySize: Integer): Integer;
      safecall;
    procedure CloseFile; safecall;
    function IDZZRDM_OpenFile(const FileName: WideString): Int64; safecall;
    function SetParamFilter(const FieldName, Param: WideString): Integer;
      safecall;
    function GetAllInfo(id: Integer): Integer; safecall;
    function FindPassport(idPict: Integer): Integer; safecall;
    function AddRecord(const ishPictName,PassportName, MarshLocat,
      StrCoords: WideString; KAID, SpectID, RazrID, RateQuality: Integer;
      PictSize: Double; PictDate: TDateTime): Integer; safecall;
    function Find(const str, field: WideString): Integer; safecall;
    procedure CloseFileWrite; safecall;
    function SetFileData(VData: OleVariant; ArraySize: Integer): Integer;
      safecall;
    function OpenFileWrite(const fname: WideString): Integer; safecall;
    function StorageFileExist(const filename: WideString): Shortint; safecall;
    function FindAllPassports(const mname: WideString): Integer; safecall;
  public
    { Public declarations }
  end;

const
FLAG_REWRITE_FILE:integer=-1;
FILE_READY_WRITE:integer=0;
SUCCESS_WRITE_FILE:integer=1;
SUCCESS_REWRITE_FILE:integer=2;
ERROR_FILE_OPERATION:integer=901;



implementation

{$R *.DFM}
var disc:widestring ='e:\';
  DataSource:widestring ='Data Source=111v\SQLTEST';
  Reg: TRegistry;

class procedure TDZZRDM.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
begin
  if Register then
  begin
    inherited UpdateRegistry(Register, ClassID, ProgID);
    EnableSocketTransport(ClassID);
    EnableWebTransport(ClassID);
  end else
  begin
    DisableSocketTransport(ClassID);
    DisableWebTransport(ClassID);
    inherited UpdateRegistry(Register, ClassID, ProgID);
  end;
end;



function TDZZRDM.Login(const us, psw: WideString): Integer;
begin
result:=-1;

Reg := TRegIniFile.Create();
Reg.RootKey:=HKEY_LOCAL_MACHINE;
Reg.OpenKey('SOFTWARE\DZZServer',true);
DataSource:='Data Source='+Reg.ReadString('DataSource');
disc:=Reg.ReadString('Disk');
Reg.CloseKey;
Reg.Free;
ADOConnection1.ConnectionString:='Provider=SQLOLEDB.1;Password='+psw+
';Persist Security Info=True;User ID='+us+
';Initial Catalog=DZZ;'+DataSource;
ADOConnection1.Open;
if ADOConnection1.Connected
  then
  begin
    qUser.Active:=false;
    qUser.Parameters.ParamByName('user').Value:=us;
    qUser.Active:=true;
    qUser.First;
    userAccess:=qUser.Fields[0].AsInteger;
    result:=userAccess;
    username:=us;
    AddLogBD('',0,true,'Login');
    
  end
else
  begin
    AddLogBD(us,0,false,'Login');
    logging('Connection error!'+ '  user ' + us);
  end;
end;

function TDZZRDM.ConnectedToBD: Integer;
begin
if ADOConnection1.Connected then  result:=1
else result:=0;
end;

procedure TDZZRDM.RemoteDataModuleDestroy(Sender: TObject);
begin
if ADOConnection1.Connected then
ADOConnection1.Close;
fMain.Label1.Caption:=inttostr(strtoint(fMain.Label1.Caption)-1)
end;

procedure TDZZRDM.DiconnectToBD;
begin
if ADOConnection1.Connected then
ADOConnection1.Close;
end;

function TDZZRDM.OpenFile(const FileName: WideString): Double;    //Filename = ...\Marsh.Name\Pict.Name
var strL:TStringList;TrueShortFileName:WideString;
begin

if Filestream <> nil then
  result:=-1.0
else
  if FileName[1]='$'
  then
    begin
      try
        if FileName[2]='$'
          then
            TrueShortFileName:=copy(FileName,3,length(FileName))
          else
            TrueShortFileName:=disc + copy(FileName,2,length(FileName));
        Filestream := TFileStream.Create(TrueShortFileName, fmOpenRead or fmShareDenyWrite);

        AddLogBD(FileName,Filestream.Size,true,'DownloadFile');      ///don`t forget modify!!!

        result:=Filestream.Size/1048576;
      except
        Result:=-2.0;
        logging('OpenFile error!'+ 'file:'+ FileName+ '  user ' + username);
      end;
    end
  else
  try
    strL:=TStringList.Create;
    strL.Text:=stringReplace(FileName,'\',#13#10,[rfReplaceAll]);
    TrueShortFileName:=strL[strL.Count-1];

    qGetMarshDir.Active:=false;
    qGetMarshDir.Parameters.ParamByName('Param').Value:=strL[strL.Count-2];
    qGetMarshDir.Active:=true;
    qGetMarshDir.First;

    Filestream := TFileStream.Create(qGetMarshDir.Fields[0].AsString+'\'+strL[strL.Count-2]+'\'+TrueShortFileName, fmOpenRead or fmShareDenyWrite);

    AddLogBD(TrueShortFileName,Filestream.Size,true,'DownloadFile');      ///don`t forget modify!!!

    result:=Filestream.Size/1048576;
  except
    Result:=-2.0;
    logging('OpenFile error!'+ 'file:'+ FileName+ '  user ' + username);
  end;
end;

function TDZZRDM.GetFileData(out Data: OleVariant;
  ArraySize: Integer): Integer;
var PData: PByteArray;
begin
  Data := VarArrayCreate([0, ArraySize - 1], varByte);
{Lock the variant array and get a pointer to the array of bytes.
 This makes access to the variant array much faster.}
  PData := VarArrayLock(Data);
  try
  {Read data from the TFileStream. The number of bytes to read is
  the high bound of the variant array plus one (because the array
  is zero based). The number of bytes actually read is
  returned by this function.}
    Result := Filestream.Read(PData^, VarArrayHighBound(Data, 1) + 1);
  finally
    VarArrayUnlock(Data);
  end;

end;

procedure TDZZRDM.CloseFile;
begin
 if Assigned(Filestream) then
  begin
    Filestream.Free;
    Filestream := nil;

  end;
end;

function TDZZRDM.IDZZRDM_OpenFile(const FileName: WideString): Int64;
begin

end;

function TDZZRDM.SetParamFilter(const FieldName,
  Param: WideString): Integer;
begin
qViewAll.Active:=False;
qViewAll.SQL.Text:='USE DZZ;';
if FieldName='Marsh.Plg'
  then
    begin
      qViewAll.SQL.Append('DECLARE @point geography;');
      qViewAll.SQL.Append('SET @point=geography::STPointFromText('''+Param+''',4923);');
    end;
qViewAll.SQL.Append('SELECT     Pict.ID, KA.Name AS ''�������'', Marsh.Name AS ''�������'', Pict.Name AS ''��� �����'' ');
//if userAccess>=2   //������� �������
//  then
//    qViewAll.SQL.Append(',Marsh.Dir AS ''����������'',Marsh.Locat AS ''���������'' ')
//  else
    qViewAll.SQL.Append(',Pict.Size AS ''������ �����, �����'',Marsh.Locat AS ''���������          '' ');
qViewAll.SQL.Append(',Marsh.NW.STAsText() AS ''��'', Marsh.NE.STAsText() AS ''��'', Marsh.SE.STAsText() AS ''��'',Marsh.SW.STAsText() AS ''��'' ');
qViewAll.SQL.Append(' FROM         KA INNER JOIN ');
qViewAll.SQL.Append('Marsh ON KA.ID = Marsh.ID_KA INNER JOIN ');
qViewAll.SQL.Append('Pict ON Marsh.ID = Pict.ID_Marsh ');

if (FieldName='Pict.Name')or(FieldName='Marsh.Locat') then
  qViewAll.SQL.Append('WHERE (Pict.Name LIKE(''%'+Param+'%''))or(Marsh.Locat LIKE(''%'+Param+'%''))');
if FieldName='Pict.Size' then
  qViewAll.SQL.Append('WHERE '+FieldName+' BETWEEN '+Param);
if FieldName='Pict.Date' then
  qViewAll.SQL.Append('WHERE '+FieldName+' BETWEEN '+Param);
if (FieldName='Pict.Razr')or(FieldName='Pict.Spect')or(FieldName='Pict.Quality')or(FieldName='KA.ID') then
  qViewAll.SQL.Append('WHERE '+FieldName+' = '+Param);
if FieldName='Marsh.Plg' then
  qViewAll.SQL.Append('WHERE @point.STIntersects(Marsh.Plg) = 1');
try
qViewAll.SQL.SaveToFile('c:\SQLQUERY\view.txt');    //����� SQLQUERY ���� �� ���������!
qViewAll.Active:=True;                              //���������� �� ������� �� ����� ��������� �������.
result:=qViewAll.RecordCount;
except
  Result:=0;
  logging('qViewAll query error!'+ '  user ' + username);
end;
end;

function TDZZRDM.GetAllInfo(id: Integer): Integer;
begin
try
qGetFullInfo.Active:=False;
qGetFullInfo.Parameters.ParamByName('param').Value:=id;
qGetFullInfo.Active:=true;
Result:=1;
except
  Result:=0;
  logging('GetAllInfo query error!'+ '  user ' + username);
end;
end;

function TDZZRDM.FindPassport(idPict: Integer): Integer;
begin
try
qFindPassport.Active:=false;
qFindPassport.Parameters.ParamByName('IdPict').Value:=idPict;
qFindPassport.Active:=true;
result:=qFindPassport.RecordCount;
except
  Result:=0;
  logging('qFindPassport query error!'+ '  IdPict:'+ IntToStr(IdPict)+ '  user ' + username);
end;
end;

procedure  TDZZRDM.logging(s:string);
var str,filenameLog:string;log:TFilestream;
Begin
filenameLog:= FormatDateTime('yyyy_dd_mm',Now())+'_Error_log.txt';
str:= FormatDateTime('hh:mm:ss',Now())+'  '+s+#13#10;

try
  if FileExists(filenameLog)
  then
    log:=TFileStream.create(FileNameLog, fmOpenWrite)
  else
    log:=TFileStream.create(FileNameLog, fmCreate or fmOpenWrite);
  log.Seek(0,soFromEnd);
  log.Write(pointer(str)^,length(str));

finally
  log.free;
end;
end;

function TDZZRDM.AddLogBD(const PictN:WideString;Sz:int64;success:boolean;const Oper:WideString):integer;
var dateLog:string;
begin
try
  dateLog:= FormatDateTime('yyyy-dd-mm hh:mm:ss',Now());
  qLogger.Active:=false;
  qLogger.SQL.Text:='USE DZZ';
  qLogger.SQL.Append('INSERT INTO Download (ID_User, ID_Pict, Date, LengthTimeLoad, Size, Success, Operation)');
  qLogger.SQL.Append('VALUES(');
  qLogger.SQL.Append('(SELECT TOP(1) ID FROM Users WHERE Login='+''''+username+''''+'),');

  if PictN<>'' then
    qLogger.SQL.Append('(SELECT TOP(1) ID FROM Pict WHERE Pict.Name='+''''+PictN+''''+'),')
  else
    qLogger.SQL.Append('NULL,');

  qLogger.SQL.Append(''''+ dateLog+''''+',');
  qLogger.SQL.Append('0,');
  qLogger.SQL.Append(IntToStr(Sz)+',');
  if success then
    qLogger.SQL.Append('1,')
  else
    qLogger.SQL.Append('0,');
  dateLog:=StringReplace(dateLog,':','-',[rfReplaceAll]);
  qLogger.SQL.Append(''''+ Oper + '''');
  qLogger.SQL.Append(')');
  qLogger.SQL.SaveToFile('f:\SQLQUERY\log_'+username+'_'+dateLog+'.txt');
  qLogger.Open;
  qLogger.First;
  Result:=qLogger.Fields[0].AsInteger;
except
  Result:=0;
  logging('qLogger query error!'+ ' operation:'+ oper + '  user ' + username);
end;

end;

function NumToMonth(num:integer):string;
begin
case num of
  1: Result:='������';
  2: Result:='�������';
  3: Result:='����';
  4: Result:='������';
  5: Result:='���';
  6: Result:='����';
  7: Result:='����';
  8: Result:='������';
  9: Result:='��������';
  10: Result:='�������';
  11: Result:='������';
  12: Result:='�������';
else
   Result:='Unknow\'+inttostr(num);
end
end;

function TDZZRDM.AddRecord( const ishPictName, PassportName, MarshLocat,
  StrCoords: WideString; KAID, SpectID, RazrID, RateQuality: Integer;
  PictSize: Double; PictDate: TDateTime): Integer;
var i:integer;coords:TStringList;ff:TFormatSettings;PictName,passName,crd,sym:widestring;
begin
try
ff.DecimalSeparator:='.';
qAddRecord.Active:=false;
coords:=TStringList.Create;
coords.Text:=stringReplace(PassportName,'\',#13#10,[rfReplaceAll]);
passName:=coords.Strings[coords.count-1];
coords.Clear;
coords.Text:=stringReplace(StrCoords,'|',#13#10,[rfReplaceAll]);
//PictName:=copy(ishPictName,0,length(ishPictName));
PictName:=ishPictName;
ParsePath(PictName);

qAddRecord.SQL.Text:='USE DZZ';

qAddRecord.SQL.Append('DECLARE @geog1 varchar(50);');
qAddRecord.SQL.Append('DECLARE @geog2 varchar(50);');
qAddRecord.SQL.Append('DECLARE @geog3 varchar(50);');
qAddRecord.SQL.Append('DECLARE @geog4 varchar(50);');
i:=0;
while i<8 do
  begin
    if (coords[i]='@')and(coords[i+1]='@')
      then qAddRecord.SQL.Append('SET @geog'+inttostr((i+2) div 2)+' = '+''''''+';')
      else qAddRecord.SQL.Append('SET @geog'+inttostr((i+2) div 2)+' = '+''''+ coords[i]+' '+coords[i+1]+''''+';');
    i:=i+2;
  end;

qAddRecord.SQL.Append('begin transaction');
qAddRecord.SQL.Append('begin TRY ');
qAddRecord.SQL.Append('IF (SELECT COUNT(Marsh.ID) FROM Marsh WHERE Name = '+''''+MarshName+
                                                      ''' AND ID_KA = '+ inttostr(KAID) +')=0');

qAddRecord.SQL.Append('INSERT INTO Marsh(ID_KA,Dir,Name,Locat,NW,NE,SE,SW)');
qAddRecord.SQL.Append('VALUES ('+inttostr(KAID)+','+
   ''''+MarshDir+''''+','+
   ''''+MarshName+''''+','+
   ''''+MarshLocat+'''');

qAddRecord.SQL.Append(',geography::STPointFromText(''POINT(''+@geog1+'')'',4923)');
qAddRecord.SQL.Append(',geography::STPointFromText(''POINT(''+@geog2+'')'',4923)');
qAddRecord.SQL.Append(',geography::STPointFromText(''POINT(''+@geog3+'')'',4923)');
qAddRecord.SQL.Append(',geography::STPointFromText(''POINT(''+@geog4+'')'',4923)');
qAddRecord.SQL.Append(')');

qAddRecord.SQL.Append('ELSE UPDATE Marsh SET Locat = '''+MarshLocat+'''');
qAddRecord.SQL.Append(',NW=geography::STPointFromText(''POINT(''+@geog1+'')'',4923)');
qAddRecord.SQL.Append(',NE=geography::STPointFromText(''POINT(''+@geog2+'')'',4923)');
qAddRecord.SQL.Append(',SE=geography::STPointFromText(''POINT(''+@geog3+'')'',4923)');
qAddRecord.SQL.Append(',SW=geography::STPointFromText(''POINT(''+@geog4+'')'',4923)');
qAddRecord.SQL.Append('WHERE Name = '''+MarshName+''' AND ID_KA = '+inttostr(KAID)+';');


qAddRecord.SQL.Append('IF (SELECT COUNT(Passport.ID) FROM Passport WHERE Name='+''''+passName+''''+')=0');
qAddRecord.SQL.Append('INSERT INTO Passport(Path,Name)');
qAddRecord.SQL.Append('VALUES ('+''''+MarshDir+MarshName +''''+','+
   ''''+passName+''''+
   ');');
qAddRecord.SQL.Append('IF (SELECT COUNT(Pict.ID) FROM Pict WHERE Name='+''''+PictName+''''+' ');
qAddRecord.SQL.Append(' AND ID_Marsh=(Select (Marsh.ID) FROM Marsh WHERE Name = '+''''+MarshName+
                                                      ''' AND ID_KA = '+inttostr(KAID)+'))=0');
qAddRecord.SQL.Append('BEGIN');
qAddRecord.SQL.Append('INSERT INTO Pict(Name,ID_Marsh,ID_Pass,Spect,Razr,Quality,Size,Date)');
qAddRecord.SQL.Append('VALUES('+''''+PictName+''''+',');
qAddRecord.SQL.Append('(SELECT Marsh.ID FROM Marsh WHERE Marsh.Name='+''''+MarshName+''' AND ID_KA = '+inttostr(KAID)+'),');
qAddRecord.SQL.Append('(SELECT TOP(1) Passport.ID FROM Passport WHERE Passport.Name ='+''''+passName+''''+'),');
qAddRecord.SQL.Append(inttostr(SpectID)+','+inttostr(RazrID)+','+inttostr(RateQuality)+','
    +FloatToStrF(PictSize,ffFixed,7,2,ff)+','+''''+DateToStr(PictDate)+'''');

qAddRecord.SQL.Append(');');
qAddRecord.SQL.Append('END');
qAddRecord.SQL.Append('ELSE');
qAddRecord.SQL.Append('BEGIN');
qAddRecord.SQL.Append('UPDATE Pict');
qAddRecord.SQL.Append('SET');

qAddRecord.SQL.Append('ID_Marsh='+'(SELECT Marsh.ID FROM Marsh WHERE Marsh.Name='+''''+MarshName+''' AND ID_KA = '+inttostr(KAID)+'),');
qAddRecord.SQL.Append('ID_Pass='+'(SELECT TOP(1) Passport.ID FROM Passport WHERE Passport.Name ='+''''+passName+''''+'),');
qAddRecord.SQL.Append('Spect='+inttostr(SpectID)+',');
qAddRecord.SQL.Append('Razr='+inttostr(RazrID)+',');
qAddRecord.SQL.Append('Quality='+inttostr(RateQuality)+',');
qAddRecord.SQL.Append('Size='+FloatToStrF(PictSize,ffFixed,7,2,ff)+',');
qAddRecord.SQL.Append('Date='+''''+DateToStr(PictDate)+''' ');

qAddRecord.SQL.Append('WHERE Name='+''''+PictName+''''+';');
qAddRecord.SQL.Append('END;');

qAddRecord.SQL.Append('SELECT 0 AS Error ');
qAddRecord.SQL.Append('COMMIT ');
qAddRecord.SQL.Append('End TRY ');
qAddRecord.SQL.Append('BEGIN CATCH ');
qAddRecord.SQL.Append('  SELECT ERROR_NUMBER() AS Error ');
qAddRecord.SQL.Append('  ,ERROR_MESSAGE() AS ErrorMessage; ');
qAddRecord.SQL.Append('ROLLBACK ');
qAddRecord.SQL.Append(' END CATCH; ');

qAddRecord.SQL.Append('begin TRY');
qAddRecord.SQL.Append('UPDATE  Marsh');
qAddRecord.SQL.Append('SET Marsh.Plg = geography::STGeomFromText(''POLYGON((''+@geog4+'', ''+@geog3+'', ''+@geog2+'', '' +@geog1+'', ''+@geog4+''))'', 4923)');
qAddRecord.SQL.Append('WHERE Name = '''+MarshName+''' AND ID_KA = '+inttostr(KAID)+';');
qAddRecord.SQL.Append('end TRY');
qAddRecord.SQL.Append('BEGIN CATCH');
qAddRecord.SQL.Append('END CATCH;');

qAddRecord.SQL.SaveToFile('c:\SQLQUERY\sqladd_'+username+'_'+FormatDateTime('dd_mm_yyyy--hh_mm_ss', now())+'.txt');

///////////////open for loading file
{if FilestreamWrite <> nil then
  result:=-1
else
  begin
    FileWriteName:=MarshDir+'\'+MarshName+'\'+PictName;
    ForceDirectories(MarshDir+'\'+MarshName);
    FilestreamWrite := TFileStream.Create(FileWriteName, fmCreate or fmShareExclusive);
    SendState:=0;
    result:=1;
  end;
                            }

///////////////
//qAddRecord.ExecSQL;
qAddRecord.Open;
qAddRecord.First;
Result:=qAddRecord.Fields[0].AsInteger;
if Result=0 then AddLogBD(PictName,0,true,'InsertRecord')
else AddLogBD(PictName,0,false,'InsertRecord');
except
   Result:=0;
   logging('qAddRecord query error!'+ '  user ' + username);
  // CloseFileWrite;
end;
coords.Free;


end;



function TDZZRDM.Find(const str, field: WideString): Integer;
begin
qFindUni.Active:=false;

if field='passport' then
  begin
    qFindUni.SQL.Text:='SELECT Passport.ID, Passport.Name ';
    qFindUni.SQL.Append('FROM Passport ');
    qFindUni.SQL.Append('WHERE Passport.Name LIKE(''%'+'_'+str+'_'+'%'') ');
    qFindUni.SQL.Append('ORDER BY Passport.Name DESC');
  end
else
if field='Pict'then
  begin
    qFindUni.SQL.Text:='SELECT TOP(1) Pict.ID ';
    qFindUni.SQL.Append('FROM Pict ');
    qFindUni.SQL.Append('WHERE Pict.Name='+''''+str+'''');
  end;

try
  qFindUni.Active:=true;
  qFindUni.First;
  Result:=qFindUni.Fields[0].AsInteger;
  //result:=qFindUni.RecordCount;
except
  Result:=0;
  logging('qFindUni query error!'+ '  field:'+ field+ '  user ' + username);
end;
end;

Function TDZZRDM.UpStatusPict(const pName:WideString):integer;
begin
  try
    qUpdateStatusPict.Active:=False;
    qUpdateStatusPict.SQL.Text:='UPDATE Pict SET Status=1 WHERE Pict.Name='''+pName+'''';
    qUpdateStatusPict.Active:=true;
    Result:=1;
  except
    Result:=0;
    logging('qUpdateStatusPict query error!'+ ' file:'+ pName+ '  user ' + username);
  end;
end;

procedure TDZZRDM.CloseFileWrite;
var tmpstr:widestring;
begin
if Assigned(FilestreamWrite) then
  begin
    FilestreamWrite.Free;
    FilestreamWrite := nil;
    if SendState<=0 then DeleteFile(FileWriteName)
    else
      if (SendState>1)then
        begin
          SendState:=ERROR_FILE_OPERATION;
          logging('Close File error!'+ '  file:'+ FileWriteName+ '  user ' + username);
          tmpstr:=Copy(FileWriteName,0,length(FileWriteName)-4);
          if RenameFile(tmpstr,tmpstr+'_'+IntToStr(GetTickCount)) then
            if RenameFile(FileWriteName,tmpstr) then
              begin SendState:=FILE_READY_WRITE;UpStatusPict(PictNameGlobal)  end;
        end
      else
        begin SendState:=FILE_READY_WRITE;UpStatusPict(PictNameGlobal)  end;
  end;

end;

function TDZZRDM.SetFileData(VData: OleVariant;
  ArraySize: Integer): Integer;
var PData:PByteArray;
begin
result:=-1; //������ ������

if FilestreamWrite=nil
  then exit;

if ArraySize=0
  then
    begin
      if SendState<0 then
        SendState:=SUCCESS_REWRITE_FILE      //���������� ����� ��������� �������
      else
        SendState:=SUCCESS_WRITE_FILE;       //������ ����� ��������� �������
      CloseFileWrite;
      //if SendState<>ERROR_FILE_OPERATION then
      //  qAddRecord.Open;
      FileWriteName:='';
      Result:=1
    end
  else
    begin
      PData := VarArrayLock(VData);

      try
        FilestreamWrite.Write(PData^,ArraySize);
        Result:=0;                 //������ ����� ������ � ���� ������ �������
      finally
        VarArrayUnlock(VData);
      end;

    end;

end;

procedure TDZZRDM.ParsePath(var fname:widestring);
var path:TStringList; marsrut:widestring;
begin
path:=TStringList.Create;
path.Text:=stringReplace(fName,'_',#13#10,[rfReplaceAll]);
if (path[path.Count-1]='prc')
    or(path[path.Count-1]='src')
    or(path[path.Count-1]='frg')
  then Delete(fname,length(fname)-3,4);
{if Path.count>5 then                             //������ ���� ��� �������-��1, ������ ��� ����� �
      begin                                      //����������� �� ���� ��� ��������, ����, � �����
                                                 //������� ��������������� ���������.   ���� ������ ���������� �� �����!
                                                 //������ ���� ���...
        MarshDir:=disc+'20'+copy(path.Strings[2],1,2)+'\'
          + NumToMonth(strtoint(copy(path.Strings[2],3,2)));
        MarshName:=path.Strings[4]+'_'+path.Strings[5];

      end
    else           }
marsrut:=GetMarshrutFromFileName(fname);
fname:=FileNameWithoutMarsrut(fname);
if (marsrut='')or(marsrut='00000_00')
  then
      begin
        MarshDir:=disc + username;
        MarshName:=FormatDateTime('dd_mm_yyyy', Date);
       // DateToStr(Date);
      end
  else
      begin
        MarshDir:=disc;
        MarshName:=marsrut;
      end;
path.Free;
end;

function TDZZRDM.OpenFileWrite(const fname: WideString): Integer;
var FileName,operation:wideString;
begin
FileName:=fname;

if FilestreamWrite <> nil then
  result:=-1
else
  begin

    ParsePath(filename);
    PictNameGlobal:=FileName;
    FileWriteName:=MarshDir+'\'+MarshName+'\'+fileName;
    ForceDirectories(MarshDir+'\'+MarshName);
    if FileExists(FileWriteName) then
      begin
        FileWriteName:=FileWriteName + '_tmp';
        SendState:=FLAG_REWRITE_FILE;              //������� ���������� �����
        operation:='ReLoadFile';
      end
    else
      begin
        SendState:=FILE_READY_WRITE;
        operation:='LoadFile';
      end;
    try
      FilestreamWrite := TFileStream.Create(FileWriteName, fmCreate or fmShareExclusive);
      AddLogBD(fname,FilestreamWrite.Size,false,operation);
      TickCount:=GetTickCount;
      result:=1;
    except
      FilestreamWrite.Free;
      FilestreamWrite:=nil;
      logging('OpenFileWrite error!'+ '  file:'+ fname+ '  user ' + username);
    end;

  end;
end;

procedure TDZZRDM.RemoteDataModuleCreate(Sender: TObject);
begin
fMain.Label1.Caption:=inttostr(strtoint(fMain.Label1.Caption)+1)
end;

function TDZZRDM.StorageFileExist(const filename: WideString): Shortint;
var str,TrueShortFileName:widestring;strL:tstringlist;
begin
str:=copy(FileName,1,length(FileName));
if pos('...',str)=1
  then
    begin
      strL:=TStringList.Create;
      strL.Text:=stringReplace(str,'\',#13#10,[rfReplaceAll]);
      TrueShortFileName:=strL[strL.Count-1];
      qGetMarshDir.Active:=false;
      qGetMarshDir.Parameters.ParamByName('Param').Value:=strL[strL.Count-2];
      qGetMarshDir.Parameters.ParamByName('ParamKA').Value:=strL[strL.Count-3];
      qGetMarshDir.Active:=true;
      qGetMarshDir.First;
      str:='$$'+qGetMarshDir.Fields[0].AsString+'\'+strL[strL.Count-2]+'\'+TrueShortFileName;
      strL.Free;
    end;
 if str[1]='$'
  then
    begin
      try
        if str[2]='$'
          then
            str:=copy(str,3,length(str))
          else
            str:=disc + copy(str,2,length(str));
        if FileExists(str)
          then
            result:=1
          else
            result:=0;

      except
        Result:=0;
        logging('StorageFileExist error!'+ '  file:'+ filename+ '  user ' + username);
      end;
    end
end;

function TDZZRDM.FindAllPassports(const mname: WideString): Integer;
begin
try
  qFindAllPassports.Active:=false;
  qFindAllPassports.Parameters.ParamByName('MarshName').Value:=mname;
  qFindAllPassports.Open;
  result:=qFindAllPassports.RecordCount;
except
  Result:=0;
  logging('qFindAllPassports query error!'+ '  marshname:'+ mname+ '  user ' + username);
end;
end;

initialization
  TComponentFactory.Create(ComServer, TDZZRDM,
    Class_DZZRDM, ciMultiInstance, tmApartment);



end.
