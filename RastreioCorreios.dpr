program RastreioCorreios;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Correios in 'Correios.pas' {formCorreios},
  uDados in 'uDados.pas' {dmDados: TDataModule},
  uEncomenda in 'uEncomenda.pas' {formEncomenda},
  uFormLoading in 'uFormLoading.pas' {formLoading};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TformCorreios, formCorreios);
  Application.CreateForm(TdmDados, dmDados);
  Application.CreateForm(TformEncomenda, formEncomenda);
  Application.Run;
end.
