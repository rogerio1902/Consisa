program Consisa;

uses
  Vcl.Forms,
  UDM in 'UDM.pas' {DM: TDataModule},
  ULogin in 'ULogin.pas' {FrmLogin},
  UMenu in 'UMenu.pas' {FrmMenu},
  UMovVenda in 'UMovVenda.pas' {FrmVenda},
  UMovPed in 'UMovPed.pas' {FrmPed},
  URelVenda in 'URelVenda.pas' {FrmRelVenda};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMenu, FrmMenu);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmVenda, FrmVenda);
  Application.CreateForm(TFrmPed, FrmPed);
  Application.CreateForm(TFrmRelVenda, FrmRelVenda);
  Application.Run;
end.
