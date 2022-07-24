unit addChoice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sGroupBox, sLabel;

type
  TfChoise = class(TForm)
    sRadioGroup1: TsRadioGroup;
    sLabel1: TsLabel;
    procedure sRadioGroup1Changing(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fChoise: TfChoise;

implementation

{$R *.dfm}

procedure TfChoise.sRadioGroup1Changing(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
begin
Tag:=NewIndex;
sRadioGroup1.ItemIndex:=-1;
 close;
end;

end.
