unit LoFiTh;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, Grids, DBGrids, DBCtrls, ExtCtrls,Loadtypes;

type
  TFileLoadThread = class(TThread)

  private
  ID:integer;
  Filename:string;
  SourceFile:string;
  VData: Variant;
  PData: PByteArray;
  ByteCount: Integer;
  Fs:TFileStream;
  tt,ParentHandle:cardinal;
  countBlock:integer;
  StateSend:integer;
  SizeFileMb:double;

    { Private declarations }
  protected
    procedure Execute; override;
    procedure SockGetData;
    procedure SockSetData;
    procedure Op;
    procedure Closefl;
    procedure ShowEnd;
  public
    constructor Create(CreateSuspennded: Boolean;const FName,SFile: String;i:integer;PH:cardinal;sz:double);
    function GetFileName():string;
    function CloseThread:boolean;
    function FileThreadIsEmpty:boolean;
    procedure SetStateSend(x:integer);
  end;

const ArraySize = 1048576*2;//2Mb
      SizeMB = 2;
      TF_CLOSE = WM_USER + 100;
      TF_SUSPEND = WM_USER + 101;
      TF_RESUME = WM_USER + 102;
      TF_DELETE_DOWNLOAD = WM_USER + 103;

implementation

uses DM, MConnect, SConnect,fMDownload,Addrec;

constructor TFileLoadThread.Create(CreateSuspennded: Boolean;
  const FName,SFile: String;i:integer;PH:cardinal;sz:double);
begin
 inherited Create(CreateSuspennded);
 FIleName := FName;
 SourceFile:=SFile;
 ID:=i;
 ParentHandle:=PH;
 countBlock:=0;
 StateSend:=0;
 SizeFileMb:=sz;
end;

procedure TFileLoadThread.SetStateSend(x:integer);
begin
StateSend:=x;
end;

function TFileLoadThread.GetFileName():string;
begin
Result:=Filename;
end;

function TFileLoadThread.FileThreadIsEmpty;
begin
if (Fs<>nil)or(ID>0) then result:=false     //иногда создание файлового потока "тормозит"
else Result:=true;                          //нужна дополнительная проверка по ID потока
end;

function TFileLoadThread.CloseThread:boolean;
begin
  try
  if length(SourceFile)>3 then
    begin
      fDM.SocketConn.AppServer.CloseFile;
      DeleteFile(Filename);
    end
  else
    fDM.SocketConn.AppServer.CloseFileWrite;

  fs.Free;
  fs:=nil;
  result:=true;
  Terminate;
  except Result:=false;
  end;
end;

procedure TFileLoadThread.SockGetData;
begin
bytecount:=fdm.SocketConn.AppServer.GetFileData(VData, ArraySize);
if (countBlock mod  64)=1 then
fCopy.AddProgress(SizeMB,GetTickCount-tt)
else fCopy.AddProgress(SizeMB,0)
end;

procedure TFileLoadThread.SockSetData;
begin
StateSend:=fDM.SocketConn.AppServer.SetFileData(VData, ByteCount);
if (countBlock mod  64)=1 then
fCopy.AddProgress(SizeMB,GetTickCount-tt)
else fCopy.AddProgress(SizeMB,0)
end;

procedure TFileLoadThread.Op;
var d:integer;
begin
if length(SourceFile)>3 then
  begin
    d:=trunc(fdm.SocketConn.AppServer.OpenFile(SourceFile));
    fCopy.InitDownload(d+1,ID);
    if d<0 then StateSend:=-1;
  end
else
  begin
    if fDM.SocketConn.AppServer.OpenFileWrite(GetShortName(Filename)+'_'+SourceFile)=1 then
      begin
        StateSend:=0;
        fCopy.InitDownload(trunc(SizeFileMb)+1,ID);
      end
    else StateSend:=-1;
  end;
end;

procedure TFileLoadThread.Closefl;
begin
if length(SourceFile)>3
  then
    begin
      fDM.SocketConn.AppServer.CloseFile;
      if StateSend<0 then DeleteFile(GetFileName);
    end
  else fDM.SocketConn.AppServer.CloseFileWrite;
end;

procedure TFileLoadThread.ShowEnd;
begin
//ShowMessage('All Done!   -- '+inttostr(fs.Size div 1048576)+'Mb за '
//    +inttostr((GetTickCount-tt) div 1000)+'секунд'+';  средняя скорость передачи = '+
//    floattostr((fs.Size div 1048576)/((GetTickCount-tt) div 1000)) + 'Мбайт/сек');

end;

procedure TFileLoadThread.Execute;
begin
Synchronize(Op);
if StateSend<0 then
  begin
    ID:=-1;
    fs.Free;
    fs:=nil;
    Synchronize(Closefl);
    PostMessage(ParentHandle, TF_CLOSE, 0, 0);
    Terminate;
    exit;
  end;
tt:=GetTickCount;
if length(SourceFile)>3 then
  begin
    Fs := TFileStream.Create(FileName, fmOpenWrite or fmCreate or fmShareDenyWrite);
    while StateSend>=0 do
      begin

        VData := Unassigned;
        Synchronize(SockGetData);
        inc(countBlock);
        if ByteCount = 0 then Break;
        PData := VarArrayLock(VData);
        try
          fs.Write(PData^,ByteCount);
        finally
          VarArrayUnlock(VData);
        end;
      end;   //while

  end
else
  begin

    Fs := TFileStream.Create(FileNameWithoutMarsrut(FileName), fmOpenRead or fmShareDenyWrite);
    while True do
      begin
        VData :=Unassigned;
        VData := VarArrayCreate([0, ArraySize - 1], varByte);
        {Lock the variant array and get a pointer to the array of bytes.
        This makes access to the variant array much faster.}
        PData := VarArrayLock(VData);
        inc(countBlock);
        try
        {Read data from the TFileStream. The number of bytes to read is
        the high bound of the variant array plus one (because the array
        is zero based). The number of bytes actually read is
        returned by this function.}

          ByteCount := Fs.Read(PData^, VarArrayHighBound(VData, 1) + 1);

        finally
          StateSend:=-1;
          VarArrayUnlock(VData);
      end;
    Synchronize(SockSetData);
    if StateSend<>0 then break;
      end;//while
  end;

ID:=-1;
fs.Free;
fs:=nil;
Synchronize(Closefl);
PostMessage(ParentHandle, TF_CLOSE, 0, 0);
end;

end.
