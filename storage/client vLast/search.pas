unit search;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, sComboBox, sLabel, Spin, DBCtrls,
  sDBLookupComboBox, Mask, sMaskEdit, sCustomComboEdit, sTooledit, sEdit,
  sSpinEdit;

type
  TfSearch = class(TForm)
    sLabel: TsLabel;
    cbChoiceSearch: TComboBox;
    Button1: TButton;
    sDBLookUpcbSpect: TsDBLookupComboBox;
    sDBLookUpcbRazr: TsDBLookupComboBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    dateFirst: TsDateEdit;
    dateSecond: TsDateEdit;
    eSizeMin: TsSpinEdit;
    eSizeMax: TsSpinEdit;
    sLabelLAT: TsLabel;
    sLabelLATgrad: TsLabel;
    sLabelLATmin: TsLabel;
    sLabelLATsec: TsLabel;
    sLATgrad: TsSpinEdit;
    sLATmin: TsSpinEdit;
    sLATsec: TsSpinEdit;
    sLabelLONG: TsLabel;
    sLabelLONGgrad: TsLabel;
    sLabelLONGmin: TsLabel;
    sLabelLONGsec: TsLabel;
    sLONGgrad: TsSpinEdit;
    sLONGmin: TsSpinEdit;
    sLONGsec: TsSpinEdit;
    sDBLookUpcbKA: TsDBLookupComboBox;
    eSearch: TsEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure InvisibleComponents;
    procedure FormShow(Sender: TObject);
    procedure cbChoiceSearchChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSearch: TfSearch;

implementation

uses DM,InformMessThread;

{$R *.dfm}


procedure TfSearch.InvisibleComponents;
begin
dateFirst.Visible:=false;
dateSecond.Visible:=False;
dateFirst.Visible:=false;
eSearch.Visible:=false;
eSizeMin.Visible:=false;
eSizeMax.Visible:=false;
sDBLookUpcbSpect.Visible:=false;
sDBLookUpcbRazr.Visible:=false;
sDBLookUpcbKA.Visible:=false;
sLabel1.Visible:=false;
sLabel2.Visible:=false;
sLabelLAT.Visible:=false;
sLabelLATgrad.Visible:=false;
sLabelLATmin.Visible:=false;
sLabelLATsec.Visible:=false;
sLabelLONG.Visible:=false;
sLabelLONGgrad.Visible:=false;
sLabelLONGmin.Visible:=false;
sLabelLONGsec.Visible:=false;
sLATgrad.Visible:=false;
sLATmin.Visible:=false;
sLATsec.Visible:=false;
sLONGgrad.Visible:=false;
sLONGmin.Visible:=false;
sLONGsec.Visible:=false;
end;


procedure TfSearch.Button1Click(Sender: TObject);
var str:WideString;  ff:TFormatSettings; mess:informMess;
begin
fdm.cdsQViewAll.Active:=false;
mess:=informMess.Create('обработка запроса...');
Button2.Enabled:=False;
case cbChoiceSearch.ItemIndex of
  0:begin
      if eSearch.Text <> '' then 
      tag:=fdm.SocketConn.AppServer.SetParamFilter('Pict.Name',eSearch.Text);
      close;
    end;
  1:begin
      tag:=fdm.SocketConn.AppServer.SetParamFilter('Pict.Date',''''+FormatDateTime('yyyy-mm-dd',dateFirst.Date)+''' AND '''+FormatDateTime('yyyy-mm-dd',dateSecond.Date)+'''');
      close;
    end;
  2:begin
      tag:=fdm.SocketConn.AppServer.SetParamFilter('Pict.Size',inttostr(eSizeMin.Value)+' AND '+inttostr(eSizeMax.Value));
      close;
    end;
  3:begin
      tag:=fdm.SocketConn.AppServer.SetParamFilter('Pict.Razr',inttostr(sDBLookUpcbRazr.KeyValue));
      close;
    end;
  4:begin
      tag:=fdm.SocketConn.AppServer.SetParamFilter('Pict.Spect',inttostr(sDBLookUpcbSpect.KeyValue));
      close;
    end;
  5:begin
      tag:=fdm.SocketConn.AppServer.SetParamFilter('KA.ID',inttostr(sDBLookUpcbKA.KeyValue));
      close;
    end;
  6:begin
      ff.DecimalSeparator:='.';
      str:='POINT('+floattostrF(sLONGgrad.Value+sLONGmin.Value/60.0+sLONGsec.Value/3600.0,ffFixed,9,6,ff)
           +' '+ floattostrF(sLATgrad.Value+sLATmin.Value/60.0+sLATsec.Value/3600.0,ffFixed,9,6,ff)+')';
      tag:=fdm.SocketConn.AppServer.SetParamFilter('Marsh.Plg',str);
      close;
    end;
{  7:begin
      tag:=fdm.SocketConn.AppServer.SetParamFilter('Pict.Name','');
      close;
    end;
    }
end;
mess.CloseThread;
mess:=nil;
Button2.Enabled:=true;
end;

procedure TfSearch.FormShow(Sender: TObject);
begin
cbChoiceSearch.ItemIndex:=0;
//tag:=fdm.SocketConn.AppServer.SetParamFilter('Pict.Name','');
InvisibleComponents;
eSearch.Visible:=true;
end;

procedure TfSearch.cbChoiceSearchChange(Sender: TObject);
begin
InvisibleComponents;
  case cbChoiceSearch.ItemIndex of
    0: eSearch.Visible:=true;
    1: begin
          dateFirst.Visible:=true;
          dateSecond.Visible:=true;
          sLabel1.Visible:=true;
          sLabel2.Visible:=true;
       end;
    2: begin
          eSizeMin.Visible:=true;
          eSizeMax.Visible:=true;
          sLabel1.Visible:=true;
          sLabel2.Visible:=true;
       end;
    3: begin
          if not fDM.cdsRazr.Active then fDM.cdsRazr.Active:=true;
          sDBLookUpcbRazr.Visible:=true;
       end;
    4: begin
          if not fDM.cdsSpect.Active then fDM.cdsSpect.Active:=true;
          sDBLookUpcbSpect.Visible:=true;
       end;
    5: begin
          if not fDM.cdsKA.Active then fDM.cdsKA.Active:=true;
          sDBLookUpcbKA.Visible:=true;
       end;
    6: begin
          sLabelLAT.Visible:=true;
          sLabelLATgrad.Visible:=true;
          sLabelLATmin.Visible:=true;
          sLabelLATsec.Visible:=true;
          sLabelLONG.Visible:=true;
          sLabelLONGgrad.Visible:=true;
          sLabelLONGmin.Visible:=true;
          sLabelLONGsec.Visible:=true;
          sLATgrad.Visible:=true;
          sLATmin.Visible:=true;
          sLATsec.Visible:=true;
          sLONGgrad.Visible:=true;
          sLONGmin.Visible:=true;
          sLONGsec.Visible:=true;
       end;

  end;

end;

procedure TfSearch.Button2Click(Sender: TObject);
begin
Tag:=-1;
fSearch.Close;
end;

procedure TfSearch.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
if key =#13 then Button1.Click;
end;

end.
