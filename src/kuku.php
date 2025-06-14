<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>九九の表</title>
    <style>
      td { width:30px; text-align:right; }
    </style>
  </head>
  <body>
    <h1>九九の表</h1>
    <table border="1">
      <?php // ここからPHPのプログラム --- (*1)
        for($y = 1; $y <= 9; $y++) {
          echo "<tr>"; // --- (*2)
          for ($x = 1; $x <= 9; $x++) {
            $v = $y * $x;
            echo "<td>$v</td>";
          }
          echo "</tr>";
        }
      ?>
    </table>
  </body>
</html>

