unit OtherProc;

interface

uses Windows, Messages, SysUtils, Variants, Classes,XMLDoc,ShlObj;

function GetUserMyDocumentsFolderPath : String;
function GetSpecialFolderPath(CSIDL : Integer) : String;

implementation

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


end.
