unit ProgressForm;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, sButton, ComCtrls, acProgressBar, sLabel;

type
  TfProgress = class(TForm)
    sLabel1: TsLabel;
    sProgressBar1: TsProgressBar;
    sButton1: TsButton;
  end;

var
  fProgress: TfProgress;

implementation

{$R *.DFM}

end.
