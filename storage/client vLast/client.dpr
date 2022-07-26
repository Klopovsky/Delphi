program client;

uses
  Forms,
  Windows,
  Main in 'Main.pas' {fMain},
  DM in 'DM.pas' {fDM: TDataModule},
  LoFiTh in 'LoFiTh.pas',
  fMDownload in 'fMDownload.pas' {fCopy},
  loadtypes in 'loadtypes.pas',
  FullViewRec in 'FullViewRec.pas' {fViewAll},
  AddRec in 'AddRec.pas' {fAddRec},
  addChoice in 'addChoice.pas' {fChoise},
  search in 'search.pas' {fSearch},
  mess in 'mess.pas' {Inform},
  InformMessThread in 'InformMessThread.pas',
  AddFromXML in 'AddFromXML.pas' {fAddFromXML};

var hMutex:THandle; nameMut:PAnsiChar = 'once';
{$R *.res}


begin

  hMutex:=createMutex(nil,false,nameMut);         //��� ������� ������ ����� ����� ����������
  if GetLastError=ERROR_ALREADY_EXISTS then exit;
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfDM, fDM);
  Application.CreateForm(TfCopy, fCopy);
  Application.CreateForm(TfViewAll, fViewAll);
  Application.CreateForm(TfAddRec, fAddRec);
  Application.CreateForm(TfChoise, fChoise);
  Application.CreateForm(TfSearch, fSearch);
  Application.CreateForm(TInform, Inform);
  Application.CreateForm(TfAddFromXML, fAddFromXML);
  Application.Run;

end.
