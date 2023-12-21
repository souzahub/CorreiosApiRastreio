unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StyledButton, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Authenticator.Basic, uEncomenda, uDados, Vcl.Imaging.pngimage;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    btBuscar: TStyledButton;
    edCodRestreio: TEdit;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    FDMemTable1idCliente: TWideStringField;
    FDMemTable1nome: TWideStringField;
    FDMemTable1email: TWideStringField;
    FDMemTable1fone: TWideStringField;
    lbTotal: TLabel;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    btCorreio: TStyledButton;
    btDados: TStyledButton;
    StyledButton1: TStyledButton;
    img_pessoas: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btBuscarClick(Sender: TObject);
    procedure btCorreioClick(Sender: TObject);
    procedure btDadosClick(Sender: TObject);
    procedure StyledButton1Click(Sender: TObject);
  private
    { Private declarations }

     const CodRastreio :string ='https://api.linketrack.com/track/json?user=teste&token=1abcd00b2731640e886fb41a8a9671ad1434c599dbaa0a0de9a5aa619f29a83f&codigo=';
  public
    { Public declarations }

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses Correios;

procedure TMainForm.btBuscarClick(Sender: TObject);
var
COD : string;
StartTime, EndTime, ElapsedTime, ElapsedMinutes: Cardinal;
begin
Exit;
  StartTime := GetTickCount;

  // Coloque o código que você deseja medir aqui --------------------------------
  if edCodRestreio.Text = '%'  then
  begin
   COD := 'cliente'
  end
  else
   COD := 'cliente/'+edCodRestreio.Text;

  RESTClient1.BaseURL := 'https://381e-177-223-0-208.ngrok-free.app/'+COD;
  HTTPBasicAuthenticator1.Username := '12345678';
  HTTPBasicAuthenticator1.Password := '12345678';
  RESTRequest1.Execute;
  lbTotal.Caption :=  IntToStr(FDMemTable1.RecordCount)+' Encontrado(s)';

  //------------------------------------------------------------------------------
  EndTime := GetTickCount;
  ElapsedTime := EndTime - StartTime;
  ElapsedMinutes := ElapsedTime div 60000; // Convertendo para minutos

  ShowMessage('Tempo de execução: ' + IntToStr(ElapsedMinutes) + ' minutos e ' +
    IntToStr((ElapsedTime mod 60000) div 1000) + ' segundos');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  edCodRestreio.Text := '';
  lbTotal.Caption := '';
end;

procedure TMainForm.StyledButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.btDadosClick(Sender: TObject);
begin
  dmDados.xAtivaBuscaCodigo := False; //  valor inicial
  formEncomenda.btFechar.Caption := 'Fechar';
  formEncomenda.ShowModal;
  Exit;
end;

procedure TMainForm.btCorreioClick(Sender: TObject);
begin
  dmDados.xAtivaBuscaCodigo := True;
  formEncomenda.btFechar.Caption := 'Buscar';
  formCorreios.ShowModal;
  Exit;
end;

end.

