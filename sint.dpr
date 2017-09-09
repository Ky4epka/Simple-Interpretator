program sint;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  sint_classes in 'sint_classes.pas',
  sint_const in 'sint_const.pas',
  LinkedList in 'LinkedList.pas',
  sint_functions in 'sint_functions.pas',
  sint_init in 'sint_init.pas';

var
  I, N, E: Integer;
  Buf: String;
  err_res: DWORD=0;

function ReverseString(const S: String): String;
  var
    I: Integer;
begin
  Result := '';

  for I := Length(S) downto 1 do begin
    Result := Result + S[I];
  end;

end;

function AddChars(const S: String; C: Char; Count: Integer): String;
  var
    I: Integer;
begin
  Result := S;

  for I := 0 to Count - 1 do begin
    Result := Result + C;
  end;

end;

function DecToBin(const N: _Int; BitAlign: Byte): String;
  var
    Num: _Int;
begin
  Result := '';
  Num := N;

  if (N=0) then begin
    Result := '0';
  end
  else begin

    while (Num<>0) do begin
      Result := Result + Char(Byte((Num mod 2)+Ord('0')));
      Num := Num div 2;
    end;

  end;

  Result := AddChars(Result, '0', BitAlign-(Length(Result)-1) mod BitAlign-1);
  Result := ReverseString(Result);
end;

procedure OnVarDataChanged(Variable: TVariable; Data: _Int);
begin

  if (Variable.GetName()<>'X') then begin
    Exit;
  end;

  if not(Variable.GetIsConstant()) then begin
    WriteLn(Variable.GetName(), ': ', DecToBin(Data, 8));
  end;


end;

begin

  try
    Initialize;
    Interpretator.OnVariableDataChangedProc := OnVarDataChanged;
    Interpretator.SetCycled(true);
    WriteLn('Reading command line...');

    for I := 1 to ParamCount()  do begin
      Buf := ParamStr(I);
      Val(Buf, N, E);

      if (E=0) then begin
        Interpretator.SetPostDelay(N);
        WriteLn('  Post execute delay: ', N);
      end
      else begin
        err_res := Interpretator.AppendStackFromFile(Buf);
        WriteLn('  Programm file "', Buf, '" read result: ', ResultToString(err_res));
      end;

    end;

    WriteLn('Command line readed.');

    WriteLn('Interpretator execute result: ', ResultToString(Interpretator.Execute));

    ReadLn;
    Finalize;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
