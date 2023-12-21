unit Vendas.View.Grupo;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ExtCtrls,
  Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, System.ImageList,
  Vcl.ImgList, Vcl.Mask, Vcl.DBCtrls;

type
  TformGrupo = class(TForm)
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
    dsGrupo: TDataSource;
    DBGrid1: TDBGrid;
    btLimpar: TButton;
    Label1: TLabel;
    EdtNome: TEdit;
    btCopiar: TButton;
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
  private
    procedure LocalizaId; // direciona para o ultimo registro celecionado pelo ID
    { Private declarations }
  public
    xIncluindo, xDeletando, xEditando, xSoAlerta, xCopia: Boolean;
    xCod : Integer;
  end;

var
  formGrupo: TformGrupo;

implementation

{$R *.dfm}

uses Vendas.Model.Conexao,
  Vendas.View.Principal, Winapi.Windows, uFuncoes;

procedure TformGrupo.btAlterarClick(Sender: TObject);
begin
  if dmConexao.FDQueryGrupo.IsEmpty then Exit;

  PnPrincipal.ActiveCard := CardCadastro;// ativa card cadastro
  EdtNome.Text := dmConexao.FDQueryGrupoNOME.Value;
  xEditando := True;
  xDeletando := False;
  xCopia := False;

end;

procedure TformGrupo.btCancelarClick(Sender: TObject);
begin
  LocalizaId;
  PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa
end;

procedure TformGrupo.btCopiarClick(Sender: TObject);
begin
if dmConexao.FDQueryGrupo.IsEmpty then Exit;
  xIncluindo := False;
  xEditando := False;
  xDeletando := False;
  xCopia := True;

  PnPrincipal.ActiveCard := CardCadastro;// ativa card cadastro
  EdtNome.Text := dmConexao.FDQueryGrupoNOME.Value;

end;

procedure TformGrupo.btExcluirClick(Sender: TObject);
var
xErro : string;

begin
  if dmConexao.FDQueryGrupo.IsEmpty then Exit;

   If MessageDlg(' DESEJA Excluir '+dmConexao.FDQueryGrupoNOME.Value+' ?',mtConfirmation,[mbyes,mbno],0) = mryes then
   begin
     dmConexao.FDQueryGrupo.delete;
     dmConexao.FDQueryGrupo.Refresh;
     dmConexao.FDQueryGrupo.Close();
     dmConexao.FDQueryGrupo.Open();
     exit;
   end
   else
   begin
     Exit;
   end;

end;

procedure TformGrupo.btFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TformGrupo.btIncluirClick(Sender: TObject);
begin
  PnPrincipal.ActiveCard := CardCadastro;// ativa card cadastro
  EdtNome.Text := '';
  EdtNome.SetFocus;
  xIncluindo := True;
  xEditando := False;
  xDeletando := False;
  xCopia := False;

end;

procedure TformGrupo.btPesquisarClick(Sender: TObject);
begin
     dmConexao.FDQueryGrupo.Close;
     dmConexao.FDQueryGrupo.SQL.Clear;
     dmConexao.FDQueryGrupo.SQL.Add('select * from GRUPO where');
     dmConexao.FDQueryGrupo.SQL.Add('(NOME LIKE  '+QuotedStr('%'+edPesquisar.Text+'%') );
     dmConexao.FDQueryGrupo.SQL.Add(')order by ID desc');
     dmConexao.FDQueryGrupo.Open;
end;

procedure TformGrupo.btSalvarClick(Sender: TObject);
var
xErro: string;
begin

    if Trim(EdtNome.Text) = '' then
    begin
      Application.MessageBox('Preencha o Nome!',' ATENÇÃO ',mb_Ok+MB_ICONINFORMATION);
      EdtNome.SetFocus;
      exit;
    end;



    If MessageDlg(' DESEJA SALVAR ?',mtConfirmation,[mbyes,mbno],0) = mryes then
    begin
      if xIncluindo then  
      begin      
        dmConexao.FDAuxiliar.Close;
        dmConexao.FDAuxiliar.SQL.Clear;
        dmConexao.FDAuxiliar.SQL.Add('insert into GRUPO (NOME)');
        dmConexao.FDAuxiliar.SQL.Add('values(:vNOME)');

        dmConexao.FDAuxiliar.ParamByName('vNOME').Value := edtNome.Text;

        dmConexao.FDAuxiliar.ExecSQL( xErro );
        dmConexao.FDQueryGrupo.Close;
        dmConexao.FDQueryGrupo.Open;

        xIncluindo := False;

        LocalizaId;

        PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa

      end;

      if xEditando then
      begin

          dmConexao.FDAuxiliar.Close;
          dmConexao.FDAuxiliar.SQL.Clear;
          dmConexao.FDAuxiliar.SQL.Add('update GRUPO set NOME=:vNOME where ID=:vID ');

          dmConexao.FDAuxiliar.ParamByName('vNOME').Value := edtNome.Text;
          dmConexao.FDAuxiliar.ParamByName('vID').AsInteger := dmConexao.FDQueryGrupoID.Value;

          dmConexao.FDAuxiliar.ExecSQL( xErro );
          dmConexao.FDQueryGrupo.Close;
          dmConexao.FDQueryGrupo.Open;

          xEditando := False;

          LocalizaId;

          PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa         
               
          
      end;

      if xCopia then
      begin

        dmConexao.FDAuxiliar.Close;
        dmConexao.FDAuxiliar.SQL.Clear;
        dmConexao.FDAuxiliar.SQL.Add('insert into GRUPO (NOME)');
        dmConexao.FDAuxiliar.SQL.Add('values(:vNOME)');

        dmConexao.FDAuxiliar.ParamByName('vNOME').Value := edtNome.Text;

        dmConexao.FDAuxiliar.ExecSQL( xErro );
        dmConexao.FDQueryGrupo.Close;
        dmConexao.FDQueryGrupo.Open;

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

procedure TformGrupo.btLimparClick(Sender: TObject);
begin
edPesquisar.Text :='';
btPesquisarClick(Sender);
end;

procedure TformGrupo.DBGrid1CellClick(Column: TColumn);
begin
 xCod :=  dmConexao.FDQueryProdutoID.Value;
end;

procedure TformGrupo.LocalizaId;
begin
  dmConexao.FDQueryGrupo.Locate('ID', xCod, []);
end;

procedure TformGrupo.DBGrid1DblClick(Sender: TObject);
begin
  btAlterarClick(Sender);

end;

procedure TformGrupo.edPesquisarChange(Sender: TObject);
begin
  btPesquisarClick(Sender);
end;

procedure TformGrupo.edPesquisarKeyPress(Sender: TObject; var Key: Char);
begin
// if Key = #13 then
// btPesquisarClick(Sender);
end;

procedure TformGrupo.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
     Perform(WM_nextdlgctl,0,0);
// else if Key =  #27 then
//     Perform(WM_nextdlgctl,1,0)
//
  If Key = #27 Then Close;
end;

procedure TformGrupo.FormShow(Sender: TObject);
begin

  PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa
  btPesquisarClick(Sender);
  edPesquisar.Text := '';
  btIncluir.SetFocus;

end;

end.
