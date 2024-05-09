unit Correios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StyledButton, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  uDados, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  System.Threading, uFormLoading, Vcl.Imaging.GIFImg;

type
  TformCorreios = class(TForm)
    dsBusca: TDataSource;
    Panel1: TPanel;
    btBuscar: TStyledButton;
    edCodRestreio: TEdit;
    pnGrid: TPanel;
    DBGrid1: TDBGrid;
    lbTotal: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    FDMemTable1data: TWideStringField;
    FDMemTable1hora: TWideStringField;
    FDMemTable1local: TWideStringField;
    FDMemTable1status: TWideStringField;
    FDMemTable1subStatus: TWideStringField;
    Label1: TLabel;
    btCorreio: TStyledButton;
    Button1: TButton;
    label001: TLabel;
    procedure btBuscarClick(Sender: TObject);
    procedure btCorreioClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }

    // usado para Gerenciar Tela de Login
    AllTasks: array of ITask;
    FLoading: TformLoading;

  public
    { Public declarations }
    COD : string;
    procedure RunTask(var aTask: ITask);
    procedure ExibirLoading;
  end;

var
  formCorreios: TformCorreios;

implementation

{$R *.dfm}

uses
 uEncomenda;

procedure TformCorreios.btBuscarClick(Sender: TObject);
begin

  if edCodRestreio.Text = '' then  Exit;

  COD := edCodRestreio.Text; //'NB800391949BR';
  RESTClient1.BaseURL := 'https://api.linketrack.com/track/json?user=meudocbackup01@gmail.com&token=b72b2c4d7576314d72658887eb0248cad70c31091b689ef66ff3fd093550d5c5&codigo='+COD;
  RESTRequest1.Execute;
  lbTotal.Caption :=  IntToStr(FDMemTable1.RecordCount)+' Encontrado(s)';

end;

procedure TformCorreios.btCorreioClick(Sender: TObject);
begin
    SetLength(AllTasks, 1);
    RunTask(AllTasks[0]);
    ExibirLoading;
//    dmDados.xAtivaBuscaCodigo := True;
//    formEncomenda.ShowModal;
//    Exit;

end;

procedure TformCorreios.Button1Click(Sender: TObject);
begin
Exit;
    SetLength(AllTasks, 1);
    RunTask(AllTasks[0]);
    ExibirLoading;

//  TTask.Run(procedure
//  begin
//    Sleep(10000);
//    TThread.Synchronize(TThread.CurrentThread,
//    procedure
//    begin
//
//     label001.Caption := DateTimeToStr(Now)
//
//    end);
//
//
//
//  end);

end;

procedure TformCorreios.ExibirLoading;
begin
  TTask.Run(
    procedure
    begin
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
            FLoading := TformLoading.Create(nil);
            FLoading.Show;
        end);
        TTask.WaitForAll(AllTasks);
        TThread.Queue(TThread.CurrentTHread,
        procedure
        begin
            FLoading.Close;
            FLoading.Free;
        end);
    end);
end;

procedure TformCorreios.FormShow(Sender: TObject);
begin

 edCodRestreio.Text := '';
 lbTotal.Caption := '';

 FDMemTable1.Open;
 FDMemTable1.EmptyDataSet;
 FDMemTable1.Close;
 FDMemTable1.Open;


end;

procedure TformCorreios.RunTask(var aTask: ITask);
begin
  aTask := TTask.Run(
  procedure
    begin
//        FDMemTable1.Close;
        Sleep(1000);
        TThread.Synchronize(nil,
        procedure
        begin
//          FDMemTable1.Open;
          dmDados.xAtivaBuscaCodigo := True;
          formEncomenda.ShowModal;
          Exit;

        end);

    end);

end;

end.

