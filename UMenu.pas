{******************************************************************************}
{*                                                                            *}
{*  Programa para teste prático admissional para a Consisa Sistemas           *}
{*  Início..........: 19/04/2024                                              *}
{*  Término.........: 23/04/2024                                              *}
{*  Versão do Delphi: XE4                                                     *}
{*                                                                            *}
{******************************************************************************}

unit UMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Grids,
  Vcl.DBGrids, StrUtils;

type
  TFrmMenu = class(TForm)
    MainMenu: TMainMenu;
    MICad: TMenuItem;
    MIMov: TMenuItem;
    MISep1: TMenuItem;
    MISair: TMenuItem;
    MIMovVenda: TMenuItem;
    ImgMenu: TImage;
    SBrPrin: TStatusBar;
    procedure MISairClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MIMovVendaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMenu: TFrmMenu;

procedure DBGrd_DrawColumnCellPadrao(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState;
  Marcado: Boolean = False);

implementation

{$R *.dfm}

uses UDM, ULogin, UMovVenda;

procedure DBGrd_DrawColumnCellPadrao(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState;
  Marcado: Boolean = False);
const
  KCORALTER  = $00FFF1E6;
  KCORSEL    = $00FF9933;
  KCORSELDES = $00E1C1A8;
begin
  // Para usar numa grid mudar a propriedade DefaultDrawing para False, inserir
  // um evento onDrawColumnCel e usar a seguinte linha:
  // DBGrd_DrawColumnCellPadrao(Sender, Rect, DataCol, Column, State);
  with (Sender as TDBgrid), Canvas, Brush do
  begin
    if (gdSelected in State) then
    begin
      if Focused then
        Color := KCORSEL
      else
        Color := KCORSELDES;
      Font.Color := clWhite;
    end
    else if SelectedRows.CurrentRowSelected then
    begin
      Color      := KCORSEL;
      Font.Color := clYellow;
    end
    else
    begin
      if not Odd(DataSource.DataSet.Recno) then
        Color := KCORALTER
      else
        Color := clWhite;
      Font.Color := clBlack;
    end;
    if Marcado then
      Color := KCORSEL;
    DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TFrmMenu.FormActivate(Sender: TObject);
begin
  if not DM.Abrir then
    Application.Terminate;
end;

procedure TFrmMenu.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox('Tem certeza que deseja encerrar?', 'Confirmação', mb_YesNo + mb_IconQuestion + mb_DefButton2) <> mrYes then
    Abort;
end;

procedure TFrmMenu.FormShow(Sender: TObject);
begin
  if FrmLogin.ShowModal = mrCancel then // Tela de login
    Application.Terminate;
end;

procedure TFrmMenu.MIMovVendaClick(Sender: TObject);
begin
  FrmVenda.ShowModal;
end;

procedure TFrmMenu.MISairClick(Sender: TObject);
begin
  Close;
end;

end.
