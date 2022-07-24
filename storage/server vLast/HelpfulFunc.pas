unit HelpfulFunc;

interface

uses Windows, Messages, SysUtils, Variants, Classes;

function GetBefore(substr, str:string):string;
function GetAfter(substr, str:string):string;
function FileNameWithoutMarsrut(const source:string):widestring;
function GetMarshrutFromFileName(const source:string):widestring;

implementation

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

function FileNameWithoutMarsrut(const source:string):widestring;
begin
  Result:=GetBefore('<',source)+GetAfter('>',source);
  if Result='' then Result:=source;
end;

function GetMarshrutFromFileName(const source:string):widestring;
begin
  Result:=GetBefore('>', GetAfter('<',source));
end;

end.
