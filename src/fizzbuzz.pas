program FizzBuzz;
uses sysutils;

// FizzBuzzの値を返す関数 --- (*1)
function GetFizzBuzz(i: Integer): String;
  // インライン関数 --- (*2)
  function IsFizz(i: Integer): Boolean;
  begin
    Result := (i Mod 3 = 0);
  end;
  function IsBuzz(i: Integer): Boolean;
  begin
    Result := (i Mod 5 = 0);
  end;
begin
  if IsFizz(i) and IsBuzz(i) then Result := 'FizzBuzz'
  else if IsFizz(i) then Result := 'Fizz'
  else if IsBuzz(i) then Result := 'Buzz'
  else Result := IntToStr(i);
end;

// メイン処理 --- (*3)
var
  i: Integer;
  s: String;
begin
  for i := 1 to 100 do begin
    s := GetFizzBuzz(i);
    Writeln(s);
  end;
end.

