// Excelを操作するオブジェクトを得る --- (*1)
var excel = new ActiveXObject('Excel.Application');
excel.Visible = true;
// 操作対象のシートを得る --- (*2)
var book = excel.Workbooks.Add();
var sheet = book.ActiveSheet;
// シートに九九の表を書き込む --- (*3)
for (var i = 1; i <= 9; i++) {
  for (var j = 1; j <= 9; j++) {
    sheet.Cells(i, j) = i * j;
  }
}

