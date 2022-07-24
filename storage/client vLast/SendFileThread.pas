unit SendFileThread;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, Grids, DBGrids, DBCtrls, ExtCtrls;

type
  TFileLoadThreadWr = class(TThread)

  private
  ID:integer;
  Filename:string;
  VData: OleVariant;
  ByteCount: Integer;
  Fs:TFileStream;
  tt,ParentHandle:cardinal;
  countBlock:integer;
  StateSend:integer;
    { Private declarations }
  protected
    procedure Execute; override;
    procedure SockSetData;
    procedure ShowEnd;
    procedure OpenFile;
  public
    constructor Create(CreateSuspennded: Boolean;const FName: String;i,PH:integer);
    function GetFileName():string;
    function CloseThread:boolean;
    function FileThreadIsEmpty:boolean;
  end;

const ArraySize = 1048576*2;//2Mb
      SizeMB = 2;
      TF_CLOSE = WM_USER + 100;
implementation

uses DM, MConnect, SConnect,fMDownload;

constructor TFileLoadThreadWr.Create(CreateSuspennded: Boolean;
  const FName: String;i,PH:integer);
begin
 inherited Create(CreateSuspennded);
 FIleName := FName;
  ParentHandle:=PH;
 ID:=i;
  StateSend:=0;
 countBlock:=0;
 
end;

procedure TFileLoadThreadWr.OpenFile();
begin
if fDM.SocketConn.AppServer.OpenFileWrite(Filename)=1 then StateSend:=0
else StateSend:=-1;
end;

function TFileLoadThreadWr.GetFileName():string;
begin
Result:=Filename;
end;

function TFileLoadThreadWr.FileThreadIsEmpty;
begin
if fs<>nil then result:=false
else Result:=true;
end;

function TFileLoadThreadWr.CloseThread:boolean;
begin
  try
  fDM.SocketConn.AppServer.CloseFileWrite;
 
  fs.Free;
  fs:=nil;
  result:=true;
  Terminate;
  except Result:=false;
  end;
end;

procedure TFileLoadThreadWr.SockSetData;
begin
StateSend:=fDM.SocketConn.AppServer.SetFileData(VData, ByteCount);
//if (countBlock mod  64)=1 then
//fCopy.AddProgress(SizeMB,GetTickCount-tt)
//else fCopy.AddProgress(SizeMB,0)
end;

procedure TFileLoadThreadWr.ShowEnd;
begin
//ShowMessage('All Done!   -- '+inttostr(fs.Size div 1048576)+'Mb за '
//    +inttostr((GetTickCount-tt) div 1000)+'секунд'+';  средн€€ скорость передачи = '+
//    floattostr((fs.Size div 1048576)/((GetTickCount-tt) div 1000)) + 'ћбайт/сек');

end;

procedure TFileLoadThreadWr.Execute;
var PData:PByteArray;
begin

Synchronize(OpenFile);
tt:=GetTickCount;

if StateSend<0 then Terminate;
Fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);



while True do   begin
  VData :=Unassigned;
  VData := VarArrayCreate([0, ArraySize - 1], varByte);
{Lock the variant array and get a pointer to the array of bytes.
 This makes access to the variant array much faster.}
  PData := VarArrayLock(VData);

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
                 end;
  ID:=-1;
  fs.Free;fs:=nil;
  PostMessage(ParentHandle, TF_CLOSE, 0, 0);
end;

end.
