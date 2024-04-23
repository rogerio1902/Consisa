unit UMovPed;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, DB,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask, Vcl.Grids, Vcl.DBGrids,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons, DBClient;

type
  TFrmPed = class(TForm)
    LblNumPed: TLabel;
    DBtxtNroPed: TDBText;
    LblNomeCli: TLabel;
    DBEdtNomeCli: TDBEdit;
    LblEnd: TLabel;
    DBEdtEnd: TDBEdit;
    LblCid: TLabel;
    DBEdtCid: TDBEdit;
    DBCBoxUF: TDBComboBox;
    LblUF: TLabel;
    LblTitItens: TLabel;
    DBGrdVnd: TDBGrid;
    LblTitLanc: TLabel;
    ImgCantoEsq: TImage;
    ImgCantoDir: TImage;
    LblValTot: TLabel;
    LblTitValTot: TLabel;
    LblProd: TLabel;
    DBEdtProd: TDBEdit;
    LblQtde: TLabel;
    DBEdtQtde: TDBEdit;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    BBtnGravar: TBitBtn;
    BBtnCancelar: TBitBtn;
    PnlBBtn: TPanel;
    BBtnNovo: TBitBtn;
    BBtnConf: TBitBtn;
    BBtnExcluir: TBitBtn;
    BBtnCan: TBitBtn;
    procedure DBGrdVndDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure BBtnGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BBtnCancelarClick(Sender: TObject);
    procedure BBtnNovoClick(Sender: TObject);
    procedure BBtnConfClick(Sender: TObject);
    procedure BBtnCanClick(Sender: TObject);
    procedure BBtnExcluirClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FValorTotal: Currency;
    procedure SetValorTotal(pValorTotal: Currency);
  public
    { Public declarations }
    property ValorTotal: Currency read FValorTotal write SetValorTotal;
    procedure Habilitar;
  end;

var
  FrmPed: TFrmPed;

implementation

{$R *.dfm}

uses UDM, UMenu;

procedure TFrmPed.Habilitar;
begin
  BBtnGravar.Enabled := Trim(DBEdtNomeCli.Text) <> '';
  with DM.CDSItensVendaTmp do
  begin
    BBtnConf.   Enabled := (State in [dsInsert, dsEdit]);
    BBtnNovo.   Enabled := BBtnGravar.Enabled and not BBtnConf.Enabled;
    BBtnCan.    Enabled := BBtnConf.Enabled;
    BBtnExcluir.Enabled := RecordCount > 0;
  end;
end;

procedure TFrmPed.BBtnCancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Tem certeza que deseja cancelar?', 'Confirmação', mb_YesNo + mb_IconQuestion + mb_DefButton2) = mrYes then
  begin
    DM.CDSVenda.Cancel;
    ModalResult := mrCancel;
  end;
end;

procedure TFrmPed.BBtnCanClick(Sender: TObject);
begin
  if Application.MessageBox('Tem certeza que deseja cancelar?', 'Confirmação', mb_YesNo + mb_IconQuestion + mb_DefButton2) = mrYes then
    with DM.CDSItensVendaTmp do
    begin
      ValorTotal := ValorTotal - FieldByName('CDSItensVendaTotalAnt').AsFloat;
      Cancel;
      ValorTotal := ValorTotal + FieldByName('CDSItensVendaTotal').AsFloat;
    end;
end;

procedure TFrmPed.BBtnConfClick(Sender: TObject);
begin
  DM.CDSItensVendaTmp.Post;
end;

procedure TFrmPed.BBtnExcluirClick(Sender: TObject);
begin
  if Application.MessageBox('Tem certeza que deseja excluir?', 'Confirmação', mb_YesNo + mb_IconQuestion + mb_DefButton2) = mrYes then
  begin
    ValorTotal := ValorTotal - DM.CDSItensVendaTmp.FieldByName('CDSItensVendaTotal').AsFloat;
    DM.CDSItensVendaTmp.Delete;
  end;
end;

procedure TFrmPed.BBtnGravarClick(Sender: TObject);
begin
  with DM do
  begin
    CDSVenda.FieldByName('CDSVendaValor').AsFloat := ValorTotal;
    CDSVenda.Post;
    // Exclui os produtos antes de gravar
    CDSItensVenda.First;
    while CDSItensVenda.FieldByName('CDSItensVendaNroPed').AsInteger <> 0 do
      CDSItensVenda.Delete;
    // Atualiza produtos
    CDSItensVendaTmp.First;
    while not CDSItensVendaTmp.Eof do
    begin
      CDSItensVenda.Append;
      CDSItensVenda.FieldByName('CDSItensVendaNroPed').AsString := DBtxtNroPed.Caption;
      CDSItensVenda.FieldByName('CDSItensVendaProd'). AsString  := CDSItensVendaTmp.FieldByName('CDSItensVendaProd'). AsString;
      CDSItensVenda.FieldByName('CDSItensVendaQtde'). AsInteger := CDSItensVendaTmp.FieldByName('CDSItensVendaQtde'). AsInteger;
      CDSItensVenda.FieldByName('CDSItensVendaValor').AsFloat   := CDSItensVendaTmp.FieldByName('CDSItensVendaValor').AsFloat;
      CDSItensVenda.Post;
      CDSItensVendaTmp.Next;
    end;
    GravaVenda;
  end;
end;

procedure TFrmPed.BBtnNovoClick(Sender: TObject);
begin
  DM.CDSItensVendaTmp.Append;
  DBEdtProd.SetFocus;
end;

procedure TFrmPed.DBGrdVndDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DBGrd_DrawColumnCellPadrao(Sender, Rect, DataCol, Column, State);
end;

procedure TFrmPed.FormResize(Sender: TObject);
begin
  // Redimensiona colunas conforme redimensiona o form
  DBGrdVnd.Columns[0].Width := Width - 295;
end;

procedure TFrmPed.FormShow(Sender: TObject);
begin
  DBEdtNomeCli.SetFocus;
  // Carrega os itens na tabela temporária
  ValorTotal := 0;
  with DM, CDSItensVenda do
  begin
    Close;
    Filter := 'CDSItensVendaNroPed = ' + IntToStr(CDSVenda.FieldByName('CDSVendaNroPed').AsInteger);
    Open;
    CDSItensVendaTmp.EmptyDataSet;
    while not Eof do
    begin
      CDSItensVendaTmp.Append;
      CDSItensVendaTmp.FieldByName('CDSItensVendaProd'). AsString  := FieldByName('CDSItensVendaProd'). AsString;
      CDSItensVendaTmp.FieldByName('CDSItensVendaQtde'). AsInteger := FieldByName('CDSItensVendaQtde'). AsInteger;
      CDSItensVendaTmp.FieldByName('CDSItensVendaValor').AsFloat   := FieldByName('CDSItensVendaValor').AsFloat;
      CDSItensVendaTmp.Post;
      Next;
    end;
  end;
  Habilitar;
end;

procedure TFrmPed.SetValorTotal(pValorTotal: Currency);
begin
  FValorTotal := pValorTotal;
  if FValorTotal < 0 then
    FValorTotal := 0;
  LblValTot.Caption := 'R$ ' + FormatFloat( '#,##0.00', FValorTotal);
end;

end.
