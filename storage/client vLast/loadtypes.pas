unit loadtypes;

interface

uses Windows, Messages, SysUtils, Variants, Classes,XMLDoc,ShlObj;


type
  TDownLoad = class
  private
  _ID:integer;
  _Filename:string;
  _SourceFile:string;
  _FileSize:double;


  public
    constructor Create(const FName,SFile: String;i:integer;sz:double);
    function GetFileName():string;
    procedure SetFileName(Fn:string);
    function GetSourceFileName():string;
    procedure SetSourceFileName(FSn:string);
    function GetID():integer;
    procedure SetID(i:integer);
    function GetSize():double;
    procedure SetSize(s:double);
    property ID: integer read GetID write SetID;
    property Filename: string read GetFilename write SetFilename;
    property SourceFile: string read GetSourceFileName write SetSourceFileName;
    property FileSize: double read GetSize write SetSize;

  end;
{type
  TFileForStorage =class
  private
    _ShortFileName:string;
    _FullFileName:string;
    _FileSize:double;
    _Data:TData;
    _PassportFileName:string;
    _PassportFullFileName:string;
    _NameKA:string;
    _MarshrutName:string;
    _Prefix:string;
    _GeoLocation:string;
    _CoordList:string;
    _KA:integer;
    _Spect:integer;
    _Razr:integer;
    _Quality:integer;
  public
    constructor Create(const FileXML :widestring);
    function GetShortFileName():string;
    function GetFullFileName():string;
    function GetSize():double;
    function GetData():TData;
    function GetPassportFileName():string;
    function GetPassportFullFileName():string;
    function GetNameKA():string;
    function GetMarshrutName():string;
    function GetPrefix():string;
    function GetGeoLocation():string;
    function GetCoordList():string;
    function GetKA():integer;
    function GetSpect():integer;
    function GetRazr():integer;
    function GetQuality():integer;
  end;      }

function Inv(i:integer):integer;
Function GetShortName(const FullName:string):string;
function MesError(error:integer):string;
function GetBefore(substr, str:string):string;
function GetAfter(substr, str:string):string;
function ChangeSymbols(const source :string; symbolIn,symbolOut :char):string;
function ParseCoord(const source:widestring):widestring;
function StrToCoord(const source:string):real;  //���������� ������ ������ �������� ������ ���������� � �������� �����
function FileNameWithoutMarsrut(const source:string):widestring;
function GetUserMyDocumentsFolderPath : String;

var GlobPict,globFileName:string; MainHandle:cardinal;

implementation

constructor TDownLoad.Create(const FName,SFile: String;i:integer;sz:double);
begin
inherited create();
ID:=i;
Filename:=Fname;
SourceFile:=SFile;
FileSize:=sz;

end;

function TDownLoad.GetFileName():string;
begin
result:=_fileName;
end;

procedure TDownLoad.SetFileName(Fn:string);
begin
_Filename:=Fn;
end;

function TDownLoad.GetSourceFileName():string;
begin
Result:=_SourceFile;
end;

procedure TDownLoad.SetSourceFileName(FSn:string);
begin
_SourceFile:=Fsn;
end;

function TDownLoad.GetID():integer;
begin
Result:=_ID;
end;

procedure TDownLoad.SetID(i:integer);
begin
_ID:=i;
end;

function TDownLoad.GetSize;
begin
Result:=_FileSize;
end;

procedure TDownLoad.SetSize(s:double);
begin
_FileSize:=s;
end;

//----------------------------------------------------------End TDownload
//----------------------------------------------------------Begin TFileForStorage
{
constructor TFileForStorage.Create(const fname:widestring);
var XMLDoc:TXMLDocument;
begin
  XMLDoc.LoadFromFile(fname);  //����� ����� �������� �������� ��� ����������!!!
  XMLDoc.Active:=true;



end;   }
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
function Inv(i:integer):integer;
begin
if i>0 then Result:=0
else Result:=1
end;

Function GetShortName(const FullName:string):string;
var  StrList:TStringList;
begin
StrList:=TStringList.Create;
StrList.Text:=stringReplace(FullName,'\',#13#10,[rfReplaceAll]);
Result:=copy(StrList.Strings[StrList.Count-1],1,length(StrList.Strings[StrList.Count-1]));
StrList.Free;
end;


function GetBefore(substr, str:string):string;
begin
 if pos(substr,str)>0 then
   result:=copy(str,1,pos(substr,str)-1)
 else
   result:='';
end;

function GetAfter(substr, str:string):string;
begin
 if pos(substr,str)>0 then
   result:=copy(str,pos(substr,str)+length(substr),length(str))
 else
   result:='';
end;

function ChangeSymbols(const source:string; symbolIn, symbolOut: char):string;
var i:integer;
begin
Result:=source;
for i:=1 to length(source) do
if source[i]=symbolIn then Result[i]:=symbolOut;

end;

function ParseCoord(const source:widestring):widestring;
var lat,long:widestring;
begin
long:=GetBefore(' ',GetAfter('(',ChangeSymbols(source,'.',',')));
lat:=GetBefore(')',GetAfter(' ',GetAfter(' ',ChangeSymbols(source,'.',','))));

result:= long+' '+lat;
end;

function StrToCoord(const source:string):real;  //��������� ������ ���� "(-)��,����" ��� "(-)gg:mm:ss.ssss"
var list:TStringList;
    grad,min:integer;
    sec:real;
begin
result:=0.0;
list:=TStringList.Create();
list.Text:=stringReplace(source,':',#13#10,[rfReplaceAll]);
TRY
if (list.Count < 2)
  then
    begin
      sec:= StrTofloat(source);
      if (Abs(sec) < 180.0)
        then
          result:=sec;
    end
  else
    begin
      grad:=StrToInt(list.Strings[0]);
      min:=StrToInt(list.Strings[1]);
      sec:=StrToFloat(list.Strings[2]);
      if (Abs(grad)<180)and(min >= 0)and(min < 60)and(sec >= 0.0)and(sec < 60.0)
        then
          result:=grad + min/60 +sec/3600;
    end;
FINALLY
  list.Free;
END;
end;

function FileNameWithoutMarsrut(const source:string):widestring;
begin
  Result:=GetBefore('<',source)+GetAfter('>',source);
end;

function GetSpecialFolderPath(CSIDL : Integer) : String;
var
  Path : PChar;
begin
  Result := '';
  GetMem(Path,MAX_PATH);
  Try
    If Not SHGetSpecialFolderPath(0,Path,CSIDL,False) Then
      Raise Exception.Create('Shell function SHGetSpecialFolderPath fails.');
    Result := Trim(StrPas(Path));
    If Result = '' Then
      Raise Exception.Create('Shell function SHGetSpecialFolderPath return an empty string.');
    Result := IncludeTrailingPathDelimiter(Result);
  Finally
    FreeMem(Path,MAX_PATH);
  End;
end;

function GetUserMyDocumentsFolderPath : String;
begin
  Result := GetSpecialFolderPath(CSIDL_PERSONAL);
end;

function MesError(error:integer):string;
begin
case error of
229:result:='� ��� ��� ���� �� ��� ��������';
else
result:='�����-�� ������ � ������� '+inttostr(error);
end;
end;



end.
