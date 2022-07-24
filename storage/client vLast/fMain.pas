unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DBCtrls, ExtCtrls;

type
  TfMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    bConnect: TButton;
    bRefresh: TButton;
    bSaveToDB: TButton;
    bUnConnect: TButton;
    bSaveToFile: TButton;
    bLoadFromFile: TButton;
    DBGrid2: TDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

end.
