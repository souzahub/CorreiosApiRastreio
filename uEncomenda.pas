unit uEncomenda;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ExtCtrls,
  Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, System.ImageList,
  Vcl.ImgList, Vcl.Mask, Vcl.DBCtrls, uDados;

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
    btAtualiza: TButton;
    rgStatus: TRadioGroup;
    lbCod: TLabel;
    DBNavigator1: TDBNavigator;
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
    procedure btAtualizaClick(Sender: TObject);
    procedure rgStatusClick(Sender: TObject);
    procedure dsEncomendaDataChange(Sender: TObject; Field: TField);
  private
    procedure LocalizaId;
    procedure BuscaDinamica; // direciona para o ultimo registro celecionado pelo ID
    { Private declarations }
  public
    xIncluindo, xDeletando, xEditando, xSoAlerta, xCopia: Boolean;
    xCod : Integer;
    xStaus : string;
  end;

var
  formEncomenda: TformEncomenda;

implementation

{$R *.dfm}

uses Winapi.Windows, Correios, System.Threading;

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
  BuscaDinamica;

end;

procedure TformEncomenda.btSalvarClick(Sender: TObject);
var
xErro: string;
begin

    if Trim(edCod.Text) = '' then
    begin
      Application.MessageBox('Preencha o Código!',' ATENÇÃO ',mb_Ok+MB_ICONINFORMATION);
      edCod.SetFocus;
      exit;
    end;

    if Trim(edCod.Text) = '' then
    begin
      Application.MessageBox('Preencha o Código!',' ATENÇÃO ',mb_Ok+MB_ICONINFORMATION);
      edCod.SetFocus;
      exit;
    end;


    If MessageDlg(' DESEJA SALVAR ?',mtConfirmation,[mbyes,mbno],0) = mryes then
    begin

      if xIncluindo then
      begin
        dmDados.FDAuxiliar.Close;
        dmDados.FDAuxiliar.SQL.Clear;
        dmDados.FDAuxiliar.SQL.Add('insert into ENCOMENDA (CODIGO, NOME, CATEGORIA, EMPRESA, STATUS, DATA)');
        dmDados.FDAuxiliar.SQL.Add('values(:vCODIGO, :vNOME, :vCATEGORIA, :vEMPRESA, :vSTATUS, :vDATA)');

        dmDados.FDAuxiliar.ParamByName('vCODIGO').Value := edCod.Text;
        dmDados.FDAuxiliar.ParamByName('vNOME').Value := edNome.Text;
        dmDados.FDAuxiliar.ParamByName('vCATEGORIA').Value :=  cbCategoria.Text;
        dmDados.FDAuxiliar.ParamByName('vEMPRESA').Value := edVendedor.Text;
        dmDados.FDAuxiliar.ParamByName('vSTATUS').Value :=  'N';
        dmDados.FDAuxiliar.ParamByName('vDATA').Value := now;

        dmDados.FDAuxiliar.ExecSQL( xErro );
        dmDados.FDEncomenda.Close;
        dmDados.FDEncomenda.Open;

        xIncluindo := False;

//        LocalizaId;

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
        dmDados.FDAuxiliar.SQL.Add('insert into ENCOMENDA (CODIGO, NOME, CATEGORIA, EMPRESA, STATUS, DATA)');
        dmDados.FDAuxiliar.SQL.Add('values(:vCODIGO, :vNOME, :vCATEGORIA, :vEMPRESA, :vSTATUS, :vDATA)');

        dmDados.FDAuxiliar.ParamByName('vCODIGO').Value := edCod.Text;
        dmDados.FDAuxiliar.ParamByName('vNOME').Value := edNome.Text;
        dmDados.FDAuxiliar.ParamByName('vCATEGORIA').Value :=  cbCategoria.Text;
        dmDados.FDAuxiliar.ParamByName('vEMPRESA').Value := edVendedor.Text;
        dmDados.FDAuxiliar.ParamByName('vSTATUS').Value :=  'N';
        dmDados.FDAuxiliar.ParamByName('vDATA').Value := now;

        dmDados.FDAuxiliar.ExecSQL( xErro );
        dmDados.FDEncomenda.Close;
        dmDados.FDEncomenda.Open;

          xCopia := False;

//          LocalizaId;

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

procedure TformEncomenda.btAtualizaClick(Sender: TObject);
var
xErro : string;
begin

    If MessageDlg(' Confirmar recebimento do código: '+dmDados.FDEncomendaCODIGO.Value+' ?',mtConfirmation,[mbyes,mbno],0) = mryes then
    begin

      dmDados.FDAuxiliar.Close;
      dmDados.FDAuxiliar.SQL.Clear;
      dmDados.FDAuxiliar.SQL.Add('update ENCOMENDA set STATUS=:vSTATUS, DATA=:vDATA where ID=:vID ');

      dmDados.FDAuxiliar.ParamByName('vSTATUS').Value := 'S';
      dmDados.FDAuxiliar.ParamByName('vDATA').Value := now;
      dmDados.FDAuxiliar.ParamByName('vID').Value := dmDados.FDEncomendaID.Value;

      dmDados.FDAuxiliar.ExecSQL( xErro );
      dmDados.FDEncomenda.Close;
      dmDados.FDEncomenda.Open;
      BuscaDinamica;

    end
    else
    begin
     BuscaDinamica;
     Exit;

    end;
end;

procedure TformEncomenda.btLimparClick(Sender: TObject);
begin
  rgStatus.ItemIndex := 1;
  edPesquisar.Text :='';
  BuscaDinamica;
end;

procedure TformEncomenda.DBGrid1CellClick(Column: TColumn);
begin
 xCod :=  dmDados.FDEncomendaID.Value;
end;

procedure TformEncomenda.LocalizaId;
begin
  dmDados.FDEncomenda.Locate('ID', xCod, []);
end;

procedure TformEncomenda.BuscaDinamica;
begin
 btAtualiza.visible := True;

  with dmDados.FDEncomenda do
  begin
    close;
    prepared := true;
    SQL.Clear;
    SQL.Add('select * from ENCOMENDA');
    SQL.Add('where STATUS=:vSTATUS');
    SQL.Add('and (NOME LIKE  ' + QuotedStr('%' + edPesquisar.Text + '%'));
    SQL.Add(' or CODIGO LIKE  ' + QuotedStr('%' + edPesquisar.Text + '%'));
    SQL.Add(')order by ID desc');
    ParamByName('vSTATUS').AsString := xStaus;
    Open;

  end;


  if (dmDados.FDEncomendaSTATUS.value = 'S') or (dmDados.FDEncomenda.IsEmpty) then
  begin
   btAtualiza.visible := False;
   Exit;
  end;


end;

procedure TformEncomenda.DBGrid1DblClick(Sender: TObject);
begin
  btAlterarClick(Sender);

end;

procedure TformEncomenda.dsEncomendaDataChange(Sender: TObject;
  Field: TField);
begin
 lbCod.Caption := 'CÓDIGO: '+dmDados.FDEncomendaCODIGO.value;
end;

procedure TformEncomenda.rgStatusClick(Sender: TObject);
begin

  case rgStatus.ItemIndex of
   0: begin
    xStaus := 'S';
   end;

   1: begin
    xStaus := 'N';
   end;

  end;

  buscaDinamica;

end;

procedure TformEncomenda.edPesquisarChange(Sender: TObject);
begin
 BuscaDinamica;
end;

procedure TformEncomenda.edPesquisarKeyPress(Sender: TObject; var Key: Char);
begin
// if Key = #13 then
// btPesquisarClick(Sender);
end;

procedure TformEncomenda.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TTask.Run(procedure
  begin
//    Sleep(10000);
    TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      if  dmDados.xAtivaBuscaCodigo = True then
      begin
        formCOrreios.edCodRestreio.Text := dmDados.FDEncomendaCODIGO.Value;
        formCorreios.btBuscarClick(sender);
        dmDados.xAtivaBuscaCodigo := False;
        Exit;
      end;

    end);



  end);



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
  lbCod.Caption := '';
  edPesquisar.Text := '';
  rgStatus.ItemIndex := 1;
  btIncluir.SetFocus;
  buscaDinamica;


end;

end.
