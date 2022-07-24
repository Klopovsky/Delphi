program atlas;

uses
  Forms,
  Windows,
  MainUnit in 'MainUnit.pas' {Form1},
  spline3 in 'spline3.pas',
  ap in 'ap.pas',
  hull in 'hull.pas',
  Addpoint in 'Addpoint.pas' {Form2},
  OtherProc in 'OtherProc.pas';

var hMutex:THandle; nameMut:PWideChar = 'atl';

{$R *.res}

begin
  hMutex:=createMutex(nil,false,nameMut);
  if GetLastError=ERROR_ALREADY_EXISTS then exit;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
