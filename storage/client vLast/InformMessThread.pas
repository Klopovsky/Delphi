unit InformMessThread;

interface

uses
  Classes;

type
  informMess = class(TThread)
  public
    constructor Create(str:string);
    procedure CloseThread;
  private
    procedure show;
    procedure closeWindow;
  protected
    procedure Execute; override;
  end;

implementation



uses mess,Main, SysUtils, Forms;

constructor informMess.Create(str:string);
begin
 inherited Create(false);
 Inform.Caption:=str;
 Inform.Top:=fMain.Top + (fMain.Height div 2);
 Inform.Left:= fMain.Left + (fMain.Width div 3);
 Inform.show();
end;

procedure informMess.show;
begin
  Inform.Show();
  Sleep(10);
end;

procedure informMess.closeWindow;
begin
  Inform.Close();
end;

Procedure informMess.CloseThread;
begin

  Synchronize(closeWindow);
  Terminate;
end;

procedure informMess.Execute;
begin
  Synchronize(show);
end;

end.
