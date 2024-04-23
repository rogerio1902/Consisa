unit ULogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg;

type
  TFrmLogin = class(TForm)
    LblUs: TLabel;
    EdtUs: TEdit;
    LblSenha: TLabel;
    EdtSenha: TEdit;
    BBtnOk: TBitBtn;
    BBtnCancelar: TBitBtn;
    ImgLogin: TImage;
    LblMostrar: TLabel;
    procedure BBtnOkClick(Sender: TObject);
    procedure LblMostrarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LblMostrarMouseLeave(Sender: TObject);
    procedure LblMostrarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LblMostrarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

procedure TFrmLogin.BBtnOkClick(Sender: TObject);
begin
  // Para logar, usuário ADM (maiúsculo ou não) e senha 123
  if (UpperCase(EdtUs.Text) = 'ADM') and (EdtSenha.Text = '123') then
    ModalResult := mrOk
  else
    Application.MessageBox('Acesso negado', 'Erro', MB_OK + MB_ICONERROR);
end;

procedure TFrmLogin.LblMostrarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Se clicar se segurar o botão com olho, mostra a senha
  EdtSenha.PasswordChar := #0;
end;

procedure TFrmLogin.LblMostrarMouseLeave(Sender: TObject);
begin
  LblMostrar.Font.Color := clWindowText; // Remove cor de destaque
end;

procedure TFrmLogin.LblMostrarMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  LblMostrar.Font.Color := clBlue; // Destaca ícone
end;

procedure TFrmLogin.LblMostrarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  EdtSenha.PasswordChar := '*'; // Se soltar o mouse do ícone, esconde a senha
end;

end.
