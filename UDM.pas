unit UDM;

interface

uses
  System.SysUtils, System.Classes, Data.DBXFirebird, Data.DB, Data.SqlExpr,
  Data.FMTBcd, Datasnap.DBClient, SimpleDS, Vcl.ImgList, Vcl.Controls, Windows,
  Vcl.Forms, Variants, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  IWSystem;

type
  TDM = class(TDataModule)
    ImgLstGen: TImageList;
    XMLDViaCEP: TXMLDocument;
    CDSVenda: TClientDataSet;
    CDSItensVenda: TClientDataSet;
    DSVenda: TDataSource;
    DSItensVendaTmp: TDataSource;
    CDSVendaCDSVendaNroPed: TAutoIncField;
    CDSVendaCDSVendaCli: TStringField;
    CDSVendaCDSVendaEnd: TStringField;
    CDSVendaCDSVendaCid: TStringField;
    CDSVendaCDSVendaUF: TStringField;
    CDSVendaCDSVendaValor: TCurrencyField;
    CDSItensVendaCDSItensVendaNroPed: TIntegerField;
    CDSItensVendaCDSItensVendaProd: TStringField;
    CDSItensVendaCDSItensVendaQtde: TIntegerField;
    CDSItensVendaCDSItensVendaValor: TCurrencyField;
    CDSItensVendaCDSItensVendaTotal: TCurrencyField;
    DSItensVenda: TDataSource;
    CDSItensVendaTmp: TClientDataSet;
    CDSItensVendaTmpCDSItensVendaNroPed: TIntegerField;
    CDSItensVendaTmpCDSItensVendaProd: TStringField;
    CDSItensVendaTmpCDSItensVendaQtde: TIntegerField;
    CDSItensVendaTmpCDSItensVendaValor: TCurrencyField;
    CDSItensVendaTmpCDSItensVendaTotal: TCurrencyField;
    CDSItensVendaTmpCDSItensVendaTotalAnt: TCurrencyField;
    procedure CDSItensVendaTmpCDSItensVendaQtdeValorChange(Sender: TField);
    procedure CDSItensVendaTmpCDSItensVendaTotalChange(Sender: TField);
    procedure CDSVendaAfterCancel(DataSet: TDataSet);
    procedure CDSVendaAfterDelete(DataSet: TDataSet);
    procedure CDSVendaAfterPost(DataSet: TDataSet);
    procedure CDSVendaAfterOpen(DataSet: TDataSet);
    procedure CDSItensVendaTmpAfterCancel(DataSet: TDataSet);
    procedure CDSItensVendaTmpAfterDelete(DataSet: TDataSet);
    procedure CDSItensVendaTmpAfterInsert(DataSet: TDataSet);
    procedure CDSItensVendaTmpAfterPost(DataSet: TDataSet);
    procedure CDSItensVendaTmpAfterEdit(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function Abrir: Boolean;
    procedure GravaVenda;
  end;

var
  DM: TDM;
  ArqVnd,
  ArqItens: String;

function DSStatus(SDS: TSimpleDataSet): String;
function Atualizar(SDS: TSimpleDataSet): Boolean;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UMovPed, UMovVenda;

{$R *.dfm}

function DSStatus(SDS: TSimpleDataSet): String;
begin
  with SDS do
  begin
    if State = dsBrowse then Result := 'Visualizando';
    if State = dsInsert then Result := 'Novo';
    if State = dsEdit   then Result := 'Editando';
  end;
end;

function Atualizar(SDS: TSimpleDataSet): Boolean;
begin
  // Após gravar ou deletar deve comitar
end;

function TDM.Abrir: Boolean;
var
  PastaBco: String;
begin
  // Abre banco e tabela
  CDSVenda.CreateDataSet;
  CDSItensVenda.CreateDataSet;
  CDSItensVendaTmp.CreateDataSet;
  PastaBco := gsAppPath + '\Banco';
  if not DirectoryExists(PastaBco) then
    ForceDirectories(PastaBco);
  ArqVnd   := PastaBco + '\Venda.xml';
  ArqItens := PastaBco + '\ItensVenda.xml';
  if FileExists(ArqVnd) then
    CDSVenda.LoadFromFile(ArqVnd);
  if FileExists(ArqItens) then
    CDSItensVenda.LoadFromFile(ArqItens);
  Result := True;
end;

procedure TDM.GravaVenda;
begin
  // Atualiza as tabelas
  CDSVenda.     SaveToFile(ArqVnd,   dfXML);
  CDSItensVenda.SaveToFile(ArqItens, dfXML);
end;

procedure TDM.CDSItensVendaTmpAfterCancel(DataSet: TDataSet);
begin
  FrmPed.Habilitar;
end;

procedure TDM.CDSItensVendaTmpAfterDelete(DataSet: TDataSet);
begin
  FrmPed.Habilitar;
end;

procedure TDM.CDSItensVendaTmpAfterEdit(DataSet: TDataSet);
begin
  FrmPed.Habilitar;
end;

procedure TDM.CDSItensVendaTmpAfterInsert(DataSet: TDataSet);
begin
  FrmPed.Habilitar;
end;

procedure TDM.CDSItensVendaTmpAfterPost(DataSet: TDataSet);
begin
  FrmPed.Habilitar;
end;

procedure TDM.CDSItensVendaTmpCDSItensVendaQtdeValorChange(Sender: TField);
begin
  with CDSItensVendaTmp do
    FieldByName('CDSItensVendaTotal').AsFloat := FieldByName('CDSItensVendaValor').AsFloat * FieldByName('CDSItensVendaQtde').AsInteger;
end;

procedure TDM.CDSItensVendaTmpCDSItensVendaTotalChange(Sender: TField);
begin
  with FrmPed, CDSItensVendaTmp do
  begin
    ValorTotal                                   := ValorTotal - FieldByName('CDSItensVendaTotalAnt').AsFloat + FieldByName('CDSItensVendaTotal').AsFloat;
    FieldByName('CDSItensVendaTotalAnt').AsFloat := FieldByName('CDSItensVendaTotal').AsFloat;
  end;
end;

procedure TDM.CDSVendaAfterCancel(DataSet: TDataSet);
begin
  FrmVenda.Habilitar;
end;

procedure TDM.CDSVendaAfterDelete(DataSet: TDataSet);
begin
  FrmVenda.Habilitar;
  GravaVenda;
end;

procedure TDM.CDSVendaAfterOpen(DataSet: TDataSet);
begin
  FrmVenda.Habilitar;
end;

procedure TDM.CDSVendaAfterPost(DataSet: TDataSet);
begin
  FrmVenda.Habilitar;
  GravaVenda;
end;

end.
