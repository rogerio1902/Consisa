unit UMovVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Samples.Spin, DBClient;

const
  KDESCACR: Array[0..6] of Shortint = (0, 5, 10, 0, -10, -12, 0);

type
  TFrmVenda = class(TForm)
    LblTitPed: TLabel;
    DBGrdVnd: TDBGrid;
    LblTitImpr: TLabel;
    RGrpCondPgto: TRadioGroup;
    PnlBBtnExt: TPanel;
    PnlBBtn: TPanel;
    BBtnNovo: TBitBtn;
    BBtnEditar: TBitBtn;
    BBtnExcluir: TBitBtn;
    GBoxCondPers: TGroupBox;
    BBtnSimVnd: TBitBtn;
    LblPerc: TLabel;
    SEdtPerc: TSpinEdit;
    procedure DBGrdVndDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormResize(Sender: TObject);
    procedure BBtnNovoClick(Sender: TObject);
    procedure BBtnEditarClick(Sender: TObject);
    procedure BBtnExcluirClick(Sender: TObject);
    procedure BBtnSimVndClick(Sender: TObject);
    procedure RGrpCondPgtoClick(Sender: TObject);
    procedure SEdtPercClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Habilitar;
  end;

var
  FrmVenda: TFrmVenda;

implementation

{$R *.dfm}

uses UDM, UMenu, UMovPed, URelVenda;

procedure TFrmVenda.Habilitar;
begin
  BBtnEditar.  Enabled := DM.CDSVenda.RecordCount > 0;
  BBtnExcluir. Enabled := BBtnEditar.Enabled;
  RGrpCondPgto.Enabled := BBtnEditar.Enabled;
  LblPerc.     Enabled := BBtnEditar.Enabled and (RGrpCondPgto.ItemIndex in [3, 6]);
  SEdtPerc.    Enabled := LblPerc.   Enabled;
  BBtnSimVnd.  Enabled := BBtnEditar.Enabled;
end;

procedure TFrmVenda.RGrpCondPgtoClick(Sender: TObject);
begin
  Habilitar;
end;

procedure TFrmVenda.SEdtPercClick(Sender: TObject);
begin
  //
end;

procedure TFrmVenda.BBtnEditarClick(Sender: TObject);
begin
  DM.CDSVenda.Edit;
  FrmPed.ShowModal;
end;

procedure TFrmVenda.BBtnExcluirClick(Sender: TObject);
begin
  if Application.MessageBox('Tem certeza que deseja excluir?', 'Confirmação', mb_YesNo + mb_IconQuestion + mb_DefButton2) = mrYes then
    with DM, CDSItensVenda do
    begin
      // Primeiro exclui os itens
      Close;
      Filter := 'CDSItensVendaNroPed = ' + IntToStr(CDSVenda.FieldByName('CDSVendaNroPed').AsInteger);
      Open;
      while CDSItensVenda.FieldByName('CDSItensVendaNroPed').AsInteger <> 0 do
        CDSItensVenda.Delete;
      // Exclui o cabeçalho da venda
      CDSVenda.Delete;
    end;
end;

procedure TFrmVenda.BBtnNovoClick(Sender: TObject);
begin
  DM.CDSVenda.Append;
  FrmPed.ShowModal;
end;

procedure TFrmVenda.BBtnSimVndClick(Sender: TObject);
begin
  with FrmRelVenda do
  begin
    if SEdtPerc.Enabled then
    begin
      DesctoAcr := SEdtPerc.Value;
      if RGrpCondPgto.ItemIndex = 6 then
        DesctoAcr := DesctoAcr * -1;
    end
    else
      DesctoAcr := KDESCACR[RGrpCondPgto.ItemIndex];
    ShowModal;
  end;
end;

procedure TFrmVenda.DBGrdVndDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DBGrd_DrawColumnCellPadrao(Sender, Rect, DataCol, Column, State);
end;

procedure TFrmVenda.FormResize(Sender: TObject);
var
  W: Integer;
begin
  // Redimensiona colunas conforme redimensiona o form
  with DBGrdVnd do
  begin
    W                := Width - 60;
    Columns[0].Width := Round(W *  7 / 100);
    Columns[1].Width := Round(W * 25 / 100);
    Columns[2].Width := Round(W * 35 / 100);
    Columns[3].Width := Round(W * 23 / 100);
    Columns[5].Width := Round(W * 10 / 100);
  end;
end;

end.
