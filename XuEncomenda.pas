unit uEncomenda;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ExtCtrls,
  Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, System.ImageList,
  Vcl.ImgList, Vcl.Mask, Vcl.DBCtrls, uDados, Correios;

type
  TformEncomenda = class(TForm)
    PnPrincipal: TCardPanel;
    CardCadastro: TCard;
    CardPesquisa: TCard;
    pnPesquisa: TPanel;
    pnPesquisaBotoes: TPanel;
    pnGrid: TPanel;
    edPesquisar: TEdit;
    lbPesquisar: TLabel;
    btPesquisar: TButton;
    ImageList1: TImageList;
    btFechar: TButton;
    btIncluir: TButton;
    btAlterar: TButton;
    btExcluir: TButton;
    Panel1: TPanel;
    btCancelar: TButton;
    btSalvar: TButton;
    Panel3: TPanel;
    Label2: TLabel;
    Panel6: TPanel;
    dsEncomenda: TDataSource;
    DBGrid1: TDBGrid;
    btLimpar: TButton;
    Label1: TLabel;
    edCod: TEdit;
    btCopiar: TButton;
    edNome: TEdit;
    Label3: TLabel;
    cbCategoria: TComboBox;
    Label4: TLabel;
    edVendedor: TEdit;
    Label5: TLabel;
    procedure btIncluirClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btPesquisarClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btCopiarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edPesquisarKeyPress(Sender: TObject; var Key: Char);
    procedure edPesquisarChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure LocalizaId; // direciona para o ultimo registro celecionado pelo ID
    { Private declarations }
  public
    xIncluindo, xDeletando, xEditando, xSoAlerta, xCopia: Boolean;
    xCod : Integer;
  end;

var
  formEncomenda: TformEncomenda;

implementation

{$R *.dfm}

uses Winapi.Windows;

procedure TformEncomenda.btAlterarClick(Sender: TObject);
begin
  if dmDados.FDEncomenda.IsEmpty then Exit;

  PnPrincipal.ActiveCard := CardCadastro;// ativa card cadastro

  edNome.Text := dmDados.FDEncomendaNOME.Value;
  edCod.Text := dmDados.FDEncomendaCODIGO.Value;
  cbCategoria.Text := dmDados.FDEncomendaCATEGORIA.Value;
  edVendedor.Text := dmDados.FDEncomendaEMPRESA.Value;
  
  xEditando := True;
  xDeletando := False;
  xCopia := False;

end;

procedure TformEncomenda.btCancelarClick(Sender: TObject);
begin
  LocalizaId;
  PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa
end;

procedure TformEncomenda.btCopiarClick(Sender: TObject);
begin
if dmDados.FDEncomenda.IsEmpty then Exit;
  xIncluindo := False;
  xEditando := False;
  xDeletando := False;
  xCopia := True;

  PnPrincipal.ActiveCard := CardCadastro;// ativa card cadastro
  edCod.Text := '';
  edNome.Text := dmDados.FDEncomendaNOME.Value;   
  cbCategoria.text := dmDados.FDEncomendaCATEGORIA.Value;
  edVendedor.Text := dmDados.FDEncomendaEMPRESA.Value;
end;

procedure TformEncomenda.btExcluirClick(Sender: TObject);
var
xErro : string;

begin
  if dmDados.FDEncomenda.IsEmpty then Exit;

   If MessageDlg(' DESEJA Excluir '+dmDados.FDEncomendaNOME.Value+' ?',mtConfirmation,[mbyes,mbno],0) = mryes then
   begin
     dmDados.FDEncomenda.delete;
     dmDados.FDEncomenda.Refresh;
     dmDados.FDEncomenda.Close();
     dmDados.FDEncomenda.Open();
     exit;
   end
   else
   begin
     Exit;
   end;

end;

procedure TformEncomenda.btFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TformEncomenda.btIncluirClick(Sender: TObject);
begin
  PnPrincipal.ActiveCard := CardCadastro;// ativa card cadastro
  edNome.Text := '';
  edCod.Text := '';
  cbCategoria.ItemIndex := -1;
  edVendedor.Text := '';  
    
  xIncluindo := True;
  xEditando := False;
  xDeletando := False;
  xCopia := False;

end;

procedure TformEncomenda.btPesquisarClick(Sender: TObject);
begin
     dmDados.FDEncomenda.Close;
     dmDados.FDEncomenda.SQL.Clear;
     dmDados.FDEncomenda.SQL.Add('select * from ENCOMENDA where');
     dmDados.FDEncomenda.SQL.Add('(NOME LIKE  '+QuotedStr('%'+edPesquisar.Text+'%') );
     dmDados.FDEncomenda.SQL.Add(')order by ID desc');
     dmDados.FDEncomenda.Open;
end;

procedure TformEncomenda.btSalvarClick(Sender: TObject);
var
xErro: string;
begin

    if Trim(edCod.Text) = '' then
    begin
      Application.MessageBox('Preencha o C�digo!',' ATEN��O ',mb_Ok+MB_ICONINFORMATION);
      edCod.SetFocus;
      exit;
    end;

    if Trim(edCod.Text) = '' then
    begin
      Application.MessageBox('Preencha o C�digo!',' ATEN��O ',mb_Ok+MB_ICONINFORMATION);
      edCod.SetFocus;
      exit;
    end;


    If MessageDlg(' DESEJA SALVAR ?',mtConfirmation,[mbyes,mbno],0) = mryes then
    begin
    
      if xIncluindo then  
      begin      
        dmDados.FDAuxiliar.Close;
        dmDados.FDAuxiliar.SQL.Clear;
        dmDados.FDAuxiliar.SQL.Add('insert into ENCOMENDA (CODIGO, NOME, CATEGORIA, EMPRESA)');
        dmDados.FDAuxiliar.SQL.Add('values(:vCODIGO, :vNOME, :vCATEGORIA, :vEMPRESA)');

        dmDados.FDAuxiliar.ParamByName('vCODIGO').Value := edCod.Text;
        dmDados.FDAuxiliar.ParamByName('vNOME').Value := edNome.Text;
        dmDados.FDAuxiliar.ParamByName('vCATEGORIA').Value :=  cbCategoria.Text;
        dmDados.FDAuxiliar.ParamByName('vEMPRESA').Value := edVendedor.Text;

        dmDados.FDAuxiliar.ExecSQL( xErro );
        dmDados.FDEncomenda.Close;
        dmDados.FDEncomenda.Open;

        xIncluindo := False;

        LocalizaId;

        PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa

      end;

      if xEditando then
      begin

          dmDados.FDAuxiliar.Close;
          dmDados.FDAuxiliar.SQL.Clear;
          dmDados.FDAuxiliar.SQL.Add('update ENCOMENDA set CODIGO=:vCODIGO, NOME=:vNOME, CATEGORIA=:vCATEGORIA, EMPRESA=:vEMPRESA  where ID=:vID ');

          dmDados.FDAuxiliar.ParamByName('vCODIGO').Value := edCod.Text;
          dmDados.FDAuxiliar.ParamByName('vNOME').Value := edNome.Text;
          dmDados.FDAuxiliar.ParamByName('vCATEGORIA').Value :=  cbCategoria.Text;
          dmDados.FDAuxiliar.ParamByName('vEMPRESA').Value := edVendedor.Text;
          dmDados.FDAuxiliar.ParamByName('vID').Value := dmDados.FDEncomendaID.Value;

          dmDados.FDAuxiliar.ExecSQL( xErro );
          dmDados.FDEncomenda.Close;
          dmDados.FDEncomenda.Open;

          xEditando := False;

          LocalizaId;

          PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa         
               
          
      end;

      if xCopia then
      begin

        dmDados.FDAuxiliar.Close;
        dmDados.FDAuxiliar.SQL.Clear;
        dmDados.FDAuxiliar.SQL.Add('insert into ENCOMENDA (CODIGO, NOME, CATEGORIA, EMPRESA)');
        dmDados.FDAuxiliar.SQL.Add('values(:vCODIGO, :vNOME, :vCATEGORIA, :vEMPRESA)');

        dmDados.FDAuxiliar.ParamByName('vCODIGO').Value := edCod.Text;
        dmDados.FDAuxiliar.ParamByName('vNOME').Value := edNome.Text;
        dmDados.FDAuxiliar.ParamByName('vCATEGORIA').Value :=  cbCategoria.Text;
        dmDados.FDAuxiliar.ParamByName('vEMPRESA').Value := edVendedor.Text;

        dmDados.FDAuxiliar.ExecSQL( xErro );
        dmDados.FDEncomenda.Close;
        dmDados.FDEncomenda.Open;

          xCopia := False;

          LocalizaId;

          PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa

      end;

    end
    else
    begin
     Close;
     xIncluindo := False;
     xEditando  := False;
     xDeletando := False;
     Exit;

    end;


end;

procedure TformEncomenda.btLimparClick(Sender: TObject);
begin
edPesquisar.Text :='';
btPesquisarClick(Sender);
end;

procedure TformEncomenda.DBGrid1CellClick(Column: TColumn);
begin
 xCod :=  dmDados.FDEncomendaID.Value;
end;

procedure TformEncomenda.LocalizaId;
begin
  dmDados.FDEncomenda.Locate('ID', xCod, []);
end;

procedure TformEncomenda.DBGrid1DblClick(Sender: TObject);
begin
  btAlterarClick(Sender);

end;

procedure TformEncomenda.edPesquisarChange(Sender: TObject);
begin
  btPesquisarClick(Sender);
end;

procedure TformEncomenda.edPesquisarKeyPress(Sender: TObject; var Key: Char);
begin
// if Key = #13 then
// btPesquisarClick(Sender);
end;

procedure TformEncomenda.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dmDados.xAtivaBuscaCodigo = True then
  begin
   formCorreios.edCodRestreio.text := dmDados.FDEncomendaCODIGO.value;
  end;
  
end;

procedure TformEncomenda.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
     Perform(WM_nextdlgctl,0,0);
// else if Key =  #27 then
//     Perform(WM_nextdlgctl,1,0)
//
  If Key = #27 Then Close;
end;

procedure TformEncomenda.FormShow(Sender: TObject);
begin

  PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa
  btPesquisarClick(Sender);
  edPesquisar.Text := '';
  btIncluir.SetFocus;

end;

end.
