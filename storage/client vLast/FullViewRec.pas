unit FullViewRec;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, sListView,Math, StdCtrls;

type
  TfViewAll = class(TForm)
    sListView1: TsListView;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure View;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fViewAll: TfViewAll;

implementation

uses DM, DB, loadtypes, InformMessThread;
{$R *.dfm}

procedure incl(var x:integer);      //��������� ���� ���������� �����(�����) //��, ������� �����������...
begin
inc(x);
fViewAll.Height:=fViewAll.Height+15;
end;

procedure TfViewAll.View;
var i,j,k:integer;t:TStringList;long,lat:extended; ff:TFormatSettings; longstr,latstr:string; info:informMess;
begin
  info:=informMess.Create('��������� �������...');
  t:=TStringList.create;
  Height:=48;
  k:=0;
  for i:=0 to fDM.dsGetAllInfo.DataSet.FieldCount -5 do    //������� ��� ������ ����� ���������� ��������� ����� � �������� �� �����
    begin
      sListView1.Items.Add.Caption := fDM.dsGetAllInfo.DataSet.Fields[i].FieldName; //�������� ����
      If ((fdm.dsGetAllInfo.DataSet.Fields[i].FieldName = '��')
          or(fdm.dsGetAllInfo.DataSet.Fields[i].FieldName = '��')
          or(fdm.dsGetAllInfo.DataSet.Fields[i].FieldName = '��')
          or(fdm.dsGetAllInfo.DataSet.Fields[i].FieldName = '��')
          or(fdm.dsGetAllInfo.DataSet.Fields[i].FieldName = '��������'))
          and(fDM.dsGetAllInfo.DataSet.Fields[i].AsString<>'')
        then
          begin
            ff.DecimalSeparator:=',';
            long:=StrToFloat(GetBefore(' ',ParseCoord(fDM.dsGetAllInfo.DataSet.Fields[i].AsString)),ff);
            lat:=StrToFloat(GetAfter(' ',ParseCoord(fDM.dsGetAllInfo.DataSet.Fields[i].AsString)),ff);
            if long<0
              then longstr:='�.�.'
              else longstr:='�.�.';
            if lat<0
              then latstr:='�.�.'
              else latstr:='�.�.';
            long:= abs(long);
            lat:=abs(lat);

            t.Text:=inttostr(trunc(lat))+'  '+inttostr(trunc((lat-Trunc(lat))*3600)div 60)+'''  '
                +floattostrF((trunc((lat-Trunc(lat))*3600)mod 60)+(((lat-Trunc(lat))*3600)-trunc((lat-Trunc(lat))*3600)),ffFixed,5,3,ff)+''''' '+latstr+'       '
                +inttostr(trunc(long))+'  '+inttostr(trunc((long-Trunc(long))*3600)div 60)+'''  '
                +floattostrF((trunc((long-Trunc(long))*3600)mod 60)+(((long-Trunc(long))*3600)-trunc((long-Trunc(long))*3600)),ffFixed,5,3,ff)+''''' '+longstr;
          end
        else
            t.Text:=fDM.dsGetAllInfo.DataSet.Fields[i].AsString;          //�������� � ���� ������

      if t.Text<>'' then
        begin
          sListView1.Items[k].SubItems.Append(t.Strings[0]);
          incl(k);
          for j:=1 to t.Count-1 do                                        //���� ����� ������� �� ���������� �����
            begin
              sListView1.Items.Add.Caption:='';                           //������ � ������ ���������
              sListView1.Items[k].SubItems.Append(t.Strings[j]);          //j-� ������ ������
              incl(k);
            end;
        end
      else
        begin
          sListView1.Items[k].SubItems.Append('');
          incl(k);
        end;
    end;
    t.Free;

   info.CloseThread;
end;


procedure TfViewAll.FormShow(Sender: TObject);
begin
View;
end;



procedure TfViewAll.FormClose(Sender: TObject; var Action: TCloseAction);
begin
sListView1.Clear;
end;

procedure TfViewAll.FormCreate(Sender: TObject);
begin
  sListView1.Columns.Add.Width := 150;
  sListView1.Columns.Add.Width := 400;
  sListView1.Columns[0].Caption:= '�������� ����';
  sListView1.Columns[1].Caption:= '��������';
end;

end.





