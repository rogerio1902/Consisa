unit URelVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, StrUtils;

type
  TFrmRelVenda = class(TForm)
    MmRelVenda: TMemo;
    BBtnVoltar: TBitBtn;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DesctoAcr: Currency;
  end;

var
  FrmRelVenda: TFrmRelVenda;

implementation

{$R *.dfm}

uses UDM, UMovVenda;

procedure TFrmRelVenda.FormShow(Sender: TObject);
var
  Linha:      String;
  Total,
  ValorTotal: Currency;
begin
  Linha      := DupeString('-', 80);
  ValorTotal := 0;
  with MmRelVenda.Lines, DM do
  begin
    Clear;
    // Cabeçalho
    with CDSVenda do
    begin
      Add(Linha);
      Add('Venda....: ' + FieldByName('CDSVendaNroPed').AsString);
      Add('Cliente..: ' + FieldByName('CDSVendaCli').   AsString);
      Add('Endereço.: ' + FieldByName('CDSVendaEnd').   AsString);
      Add('Cidade/UF: ' + FieldByName('CDSVendaCid').   AsString + ' ' + FieldByName('CDSVendaUF').AsString);
      Add(Linha);
      Add('PRODUTO                                     QUANTIDADE     UNITÁRIO        TOTAL');
      Add(Linha);
    end;
    // Itens
    with CDSItensVenda do
    begin
      Close;
      Filter := 'CDSItensVendaNroPed = ' + IntToStr(CDSVenda.FieldByName('CDSVendaNroPed').AsInteger);
      Open;
      while not Eof do
      begin
        Total := FieldByName('CDSItensVendaQtde').AsInteger * FieldByName('CDSItensVendaValor').AsFloat;
        // Calcula desconto e acréscimo
        if DesctoAcr <> 0 then
          Total := Total - (Total * DesctoAcr / 100);
        ValorTotal := ValorTotal + Total;
        Add(LeftStr(FieldByName('CDSItensVendaProd').AsString + DupeString(' ', 47), 47) + ' ' +
            RightStr(DupeString(' ',  6) + FieldByName('CDSItensVendaQtde').AsString, 6)  + ' ' +
            RightStr(DupeString(' ', 12) + FormatFloat('#,##0.00', FieldByName('CDSItensVendaValor').AsFloat), 12) + ' ' +
            RightStr(DupeString(' ', 12) + FormatFloat('#,##0.00', Total), 12));
        Next;
      end;
      Add(Linha);
      Add(RightStr(DupeString(' ', 80) + 'VALOR TOTAL: ' + FormatFloat('#,##0.00', ValorTotal), 80));
      Add(Linha);
      with FrmVenda, RGrpCondPgto do
        Add(StringReplace(Items[ItemIndex], '(informar %)', SEdtPerc.Text + '%', []));
      Add(Linha);
    end;
  end;
end;

end.
