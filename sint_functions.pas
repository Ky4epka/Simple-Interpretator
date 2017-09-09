unit sint_functions;

interface

uses
  Windows,
  sint_classes,
  sint_const;

function sint_ADD(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_SUB(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_MUL(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_DIV(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_MOD(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_MOV(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_AND(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_OR(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_XOR(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_NOT(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_CMP(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_JMP(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_JMP_EQ(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_JMP_NE(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_JMP_GT(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_JMP_GE(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_JMP_LT(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_JMP_LE(Command: TCommand; Testing: Boolean=false): DWORD;
function sint_RET(Command: TCommand; Testing: Boolean=false): DWORD;

implementation

function sint_ADD(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        TVariable(Command.GetParamList()[0]).GetData()+
        TVariable(Command.GetParamList()[1]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_SUB(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        TVariable(Command.GetParamList()[0]).GetData()-
        TVariable(Command.GetParamList()[1]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_MUL(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        TVariable(Command.GetParamList()[0]).GetData()*
        TVariable(Command.GetParamList()[1]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_DIV(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        TVariable(Command.GetParamList()[0]).GetData() div
        TVariable(Command.GetParamList()[1]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_MOD(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        TVariable(Command.GetParamList()[0]).GetData() mod
        TVariable(Command.GetParamList()[1]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_MOV(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        TVariable(Command.GetParamList()[1]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_AND(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        TVariable(Command.GetParamList()[0]).GetData() and
        TVariable(Command.GetParamList()[1]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_OR(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        TVariable(Command.GetParamList()[0]).GetData() or
        TVariable(Command.GetParamList()[1]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_XOR(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        TVariable(Command.GetParamList()[0]).GetData() xor
        TVariable(Command.GetParamList()[1]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_NOT(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=1) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      TVariable(Command.GetParamList()[0]).SetData(
        not TVariable(Command.GetParamList()[0]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_CMP(Command: TCommand; Testing: Boolean=false): DWORD;
  var
    delta: _Int;
    cmp_res: TCommandCompareValue;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=2) then
  begin

    if (TVariable(Command.GetParamList()[0]).GetIsConstant()) then begin
      Result := RESULT_FIRST_PARAM_IS_CONSTANT;
    end
    else if (not Testing) then begin
      delta :=
        TVariable(Command.GetParamList()[0]).GetData() -
        TVariable(Command.GetParamList()[1]).GetData();
      cmp_res := [];

      if (delta=0) then begin
        cmp_res := cmp_res+[ccvEQ, ccvGE, ccvLE];
      end
      else if (delta<>0) then begin
        cmp_res := cmp_res+[ccvNE];

        if (delta<0) then begin
          cmp_res := cmp_res+[ccvLT, ccvLE];
        end
        else begin
          cmp_res := cmp_res+[ccvGT, ccvGE];
        end;

      end;

      if (Command.GetCommandStack()<>nil) then begin
        Command.GetCommandStack().SetCompareValue(cmp_res);
      end
      else begin
        Result := RESULT_MISSING_COMMAND_STACK;
      end;

    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_JMP(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=1) then
  begin

    if (not Testing) then begin
      Command.GetCommandStack().SetGotoCommand(TVariable(Command.GetParamList()[0]).GetData());
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_JMP_EQ(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=1) then
  begin

    if (not Testing) then begin

      if (Command.GetCommandStack()<>nil) then begin

        if (ccvEQ in Command.GetCommandStack().GetCompareValue()) then begin
          Command.GetCommandStack().SetGotoCommand(TVariable(Command.GetParamList()[0]).GetData());
        end;

      end
      else begin
        Result := RESULT_MISSING_COMMAND_STACK;
      end;

    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_JMP_NE(Command: TCommand; Testing: Boolean=false): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=1) then
  begin

    if (not Testing) then begin

      if (Command.GetCommandStack()<>nil) then begin

        if (ccvNE in Command.GetCommandStack().GetCompareValue()) then begin
          Command.GetCommandStack().SetGotoCommand(TVariable(Command.GetParamList()[0]).GetData());
        end;

      end
      else begin
        Result := RESULT_MISSING_COMMAND_STACK;
      end;

    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_JMP_GT(Command: TCommand; Testing: Boolean=false): DWORD;
begin  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=1) then
  begin

    if (not Testing) then begin

      if (Command.GetCommandStack()<>nil) then begin

        if (ccvGT in Command.GetCommandStack().GetCompareValue()) then begin
          Command.GetCommandStack().SetGotoCommand(TVariable(Command.GetParamList()[0]).GetData());
        end;

      end
      else begin
        Result := RESULT_MISSING_COMMAND_STACK;
      end;

    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_JMP_GE(Command: TCommand; Testing: Boolean=false): DWORD;
begin  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=1) then
  begin

    if (not Testing) then begin

      if (Command.GetCommandStack()<>nil) then begin

        if (ccvGE in Command.GetCommandStack().GetCompareValue()) then begin
          Command.GetCommandStack().SetGotoCommand(TVariable(Command.GetParamList()[0]).GetData());
        end;

      end
      else begin
        Result := RESULT_MISSING_COMMAND_STACK;
      end;

    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_JMP_LT(Command: TCommand; Testing: Boolean=false): DWORD;
begin  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=1) then
  begin

    if (not Testing) then begin

      if (Command.GetCommandStack()<>nil) then begin

        if (ccvLT in Command.GetCommandStack().GetCompareValue()) then begin
          Command.GetCommandStack().SetGotoCommand(TVariable(Command.GetParamList()[0]).GetData());
        end;

      end
      else begin
        Result := RESULT_MISSING_COMMAND_STACK;
      end;

    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_JMP_LE(Command: TCommand; Testing: Boolean=false): DWORD;
begin  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=1) then
  begin

    if (not Testing) then begin

      if (Command.GetCommandStack()<>nil) then begin

        if (ccvLE in Command.GetCommandStack().GetCompareValue()) then begin
          Command.GetCommandStack().SetGotoCommand(TVariable(Command.GetParamList()[0]).GetData());
        end;

      end
      else begin
        Result := RESULT_MISSING_COMMAND_STACK;
      end;

    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

function sint_RET(Command: TCommand; Testing: Boolean=false): DWORD;
begin  Result := RESULT_SUCCESSFULL;

  if (Command.fParamList.Count=0) then
  begin

    if (not Testing) then begin
      Command.GetCommandStack().SetRet(true);
    end;

  end
  else begin
    RESULT := RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS;
  end;

end;

end.
