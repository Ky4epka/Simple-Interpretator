unit sint_classes;

interface

uses
  Windows,
  LinkedList,
  sint_const,
  SysUtils,
  Classes;

type
  _Int = Int32;

const
  EMPTY_INT: _Int = 0;


type
  TVarManager = class;
  TVariable = class;
  TParamArray = Array of _Int;

  TOnDataChangedProc = procedure (AVariable: TVariable; AData: _Int);

  TVariable = class
    fName: String;
    fData: _Int;
    fIsConstant: Boolean;
    fMan: TVarManager;
    fOnDataChanged: TOnDataChangedProc;

    procedure Initialize;
    procedure Finalize;

  public
    constructor Create; overload;
    destructor Destroy; override;

    function SetManager(AMan: TVarManager): DWORD;
    function SetName(const AName: String): DWORD;
    function SetData(const AData: _Int): DWORD;
    procedure SetIsConstant(const AIsConstant: Boolean);

    function GetManager(): TVarManager;
    function GetName(): String;
    function GetData(): _Int;
    function GetIsConstant(): Boolean;

    property OnDataChanged: TOnDataChangedProc read fOnDataChanged write fOnDataChanged;
  end;

  TVarManager = class
    fVarList: TLinkedList;
    fConstList: TLinkedList;
    fOnVariableDataChangedProc: TOnDataChangedProc;

    procedure Initialize;
    procedure Finalize;

  public
    constructor Create;
    destructor Destroy; override;

    function NameIsBusy(const AVarName: String): Boolean;
    function IsConstant(const AVarName: String): Boolean;

    function GetVariableByName(const AVarName: String): TVariable;
    function GetVariableByData(const AVarData: _Int): TVariable;

    function GetConstantByName(const AVarName: String): TVariable;
    function GetConstantByData(const AVarData: _Int): TVariable;

    procedure Clear;

    function GetVarList: TLinkedList;
    function GetConstList: TLinkedList;

    property OnVariableDataChangedProc: TOnDataChangedProc read fOnVariableDataChangedProc write fOnVariableDataChangedProc;
  end;

  TCommandStack = class;

  TCommand = class;
  TCommandFunction = function (Command: TCommand; Testing: Boolean=false): DWORD;

  TNumberArray = Array of _Int;

  TCommandCompareValue = set of (ccvEQ, ccvNE, ccvGT, ccvGE, ccvLT, ccvLE);

  TCommand = class
    fStack: TCommandStack;
    fName: String;
    fParamList: TList;
    fFunction: TCommandFunction;

    procedure Initialize;
    procedure Finalize;

  public

    constructor Create;
    destructor Destroy; override;

    function SetStack(AStack: TCommandStack): DWORD;
    function SetName(const AName: String): DWORD;

    procedure SetCommandFunction(const AFunction: TCommandFunction);

    function GetCommandStack(): TCommandStack;
    function GetName(): String;
    function GetParamList(): TList;
    function GetCommandFunction(): TCommandFunction;

    function Execute(): DWORD;

    procedure ZeroParams;
    procedure ClearParams;

    function ParseCommand(const S: String): DWORD;

  end;

  TInterpretator = class;

  TCommandStack = class
    fInterpretator: TInterpretator;
    fName: String;
    fCommandStack: TLinkedList;
    fGotoCommand: Integer;
    fGoto: Boolean;
    fRet: Boolean;
    fSleepTime: DWORD;
    fCompareValue: TCommandCompareValue;

    fOnExecuteStart: TNotifyEvent;
    fOnExecuteFinish: TNotifyEvent;

    procedure Initialize;
    procedure Finalize;

  public

    constructor Create;
    destructor Destroy; override;

    function SetInterpretator(AInterpretator: TInterpretator): DWORD;
    function SetName(const AName: String): DWORD;
    procedure SetCompareValue(const ACompareValue: TCommandCompareValue);
    procedure SetSleepTime(const SleepTime: DWORD);

    function Execute(): DWORD;

    function GetInterpretator(): TInterpretator;
    function GetStack(): TLinkedList;
    function GetName(): String;
    function GetCompareValue(): TCommandCompareValue;
    function GetSleepTime(): DWORD;

    procedure SetGotoCommand(const AGoto: Integer);
    procedure SetRet(const Val: Boolean);

    procedure Clear;

    function ParseLines(List: TStringList): DWORD;
    function LoadFromFile(const FileName: String): DWORD;

    property OnExecuteStart: TNotifyEvent read fOnExecuteStart write fOnExecuteStart;
    property OnExecuteFinish: TNotifyEvent read fOnExecuteFinish write fOnExecuteFinish;
  end;

  TInterpretator = class

    var
    fCommandStore: TCommandStack;
    fStacks: TLinkedList;
    fVarMan: TVarManager;
    fExecuting: Boolean;
    fPostDelay: DWORD;
    fCycled: Boolean;
    fStop: Boolean;
    fDestroying: Boolean;
    fOnVariableDataChangedProc: TOnDataChangedProc;

    class var fTimerList: TLinkedList;

    class procedure InitializeClass;
    class procedure FinalizeClass;

    procedure Initialize;
    procedure Finalize;

    procedure SetVariableDataChangedProc(Proc: TOnDataChangedProc);

  public

    constructor Create;
    destructor Destroy; override;

    function SetCycled(const Val: Boolean): DWORD;
    function SetPostDelay(const APostDelay: DWORD): DWORD;
    procedure SetStop(const Val: Boolean);

    function Execute(): DWORD;

    function NameIsBusy(const AName: String): Boolean;

    function GetCycled(): Boolean;
    function GetPostDelay(): DWORD;
    function GetStop(): Boolean;
    function GetCommandFromStoreByName(const AName: String): TCommand;
    function GetCommandStackByName(const AName: String): TCommandStack;

    function GetCommandStore(): TCommandStack;
    function GetStacks(): TLinkedList;
    function GetVariableManager(): TVarManager;

    function AppendStackFromFile(const FileName: String): DWORD;

    procedure Clear;

    property OnVariableDataChangedProc: TOnDataChangedProc read fOnVariableDataChangedProc write SetVariableDataChangedProc;

  end;




implementation

procedure TVariable.Initialize;
begin
  fMan := nil;
  fName := '';
  fData := EMPTY_INT;
  fIsConstant := false;
  fOnDataChanged := nil;
end;

procedure TVariable.Finalize;
begin
  SetManager(nil);
  fName := '';
end;

constructor TVariable.Create;
begin
  Initialize;
end;

destructor TVariable.Destroy;
begin
  Finalize;
  Inherited Destroy;
end;

function TVariable.SetManager(AMan: TVarManager): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (AMan=fMan) then begin
    Exit;
  end;

  if (fMan<>nil) then begin

    if (fIsConstant) then begin
      fMan.GetConstList().Delete(Self);
    end
    else begin
      fMan.GetVarList().Delete(Self);
    end;

  end;

  if (AMan<>nil) then begin

    if AMan.NameIsBusy(fName) then begin
      Result := RESULT_NAME_IS_BUSY;
      fMan := nil;
    end
    else begin
      fMan := AMan;
      fOnDataChanged := fMan.OnVariableDataChangedProc;

      if (fIsConstant) then begin
        AMan.GetConstList().Append(Self);
      end
      else begin
        AMan.GetVarList().Append(Self);
      end;

    end;

  end;

end;

function TVariable.SetName(const AName: string): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (fMan<>nil) and (fMan.NameIsBusy(AName)) then begin
    Result := RESULT_NAME_IS_BUSY;
    Exit;
  end
  else begin
    fName := AName;
  end;

end;

procedure TVariable.SetIsConstant(const AIsConstant: Boolean);
begin
  fIsConstant := AIsConstant;

  if (fMan=nil) then begin
    Exit;
  end;

  if (AIsConstant) then begin
    fMan.GetVarList().Delete(Self);
    fMan.GetConstList().Append(Self);
  end
  else begin
    fMan.GetConstList().Delete(Self);
    fMan.GetVarList().Append(Self);
  end;

end;

function TVariable.SetData(const AData: _INT): DWORD;
begin
  Result := RESULT_SUCCESSFULL;
  fData := AData;

  if (Assigned(fOnDataChanged)) then begin
    fOnDataChanged(Self, fData);
  end;

end;

function TVariable.GetManager;
begin
  Result := fMan;
end;

function TVariable.GetName;
begin
  Result := fName;
end;

function TVariable.GetData;
begin
  Result := fData;
end;

function TVariable.GetIsConstant;
begin
  Result := fIsConstant;
end;


procedure TVarManager.Initialize;
begin
  fVarList := TLinkedList.Create;
  fConstList := TLinkedList.Create;
  fOnVariableDataChangedProc := nil;
end;

procedure TVarManager.Finalize;
begin
  Clear();
  fVarList.Free;
  fConstList.Free;
  Inherited Destroy;
end;

constructor TVarManager.Create;
begin
  Initialize;
end;

destructor TVarManager.Destroy;
begin
  Finalize;
  Inherited Destroy;
end;

function TVarManager.NameIsBusy(const AVarName: string): Boolean;
begin
  Result := (GetVariableByName(AVarName)<>nil) or (GetConstantByName(AVarName)<>nil);
end;

function TVarManager.IsConstant(const AVarName: string): Boolean;
begin
  Result := (GetConstantByName(AVarName)<>nil);
end;

function TVarManager.GetVariableByName(const AVarName: string): TVariable;
  var
    LN: PLinkedNode;
begin
  Result := nil;

  LN := fVarList.GetFirstNode();
  while (LN<>nil) do begin

    if (TVariable(LN^.ln_Data).GetName()=AVarName) then begin
      Result := LN^.ln_Data;
      Exit;
    end;

    LN := LN^.ln_NextNode;
  end;

end;

function TVarManager.GetVariableByData(const AVarData: _Int): TVariable;
  var
    LN: PLinkedNode;
begin
  Result := nil;

  LN := fVarList.GetFirstNode();
  while (LN<>nil) do begin

    if (TVariable(LN^.ln_Data).GetData()=AVarData) then begin
      Result := LN^.ln_Data;
      Exit;
    end;

    LN := LN^.ln_NextNode;
  end;

end;

function TVarManager.GetConstantByName(const AVarName: string): TVariable;
  var
    LN: PLinkedNode;
begin
  Result := nil;

  LN := fConstList.GetFirstNode();
  while (LN<>nil) do begin

    if (TVariable(LN^.ln_Data).GetName()=AVarName) then begin
      Result := LN^.ln_Data;
      Exit;
    end;

    LN := LN^.ln_NextNode;
  end;

end;

function TVarManager.GetConstantByData(const AVarData: _Int): TVariable;
  var
    LN: PLinkedNode;
begin
  Result := nil;

  LN := fConstList.GetFirstNode();
  while (LN<>nil) do begin

    if (TVariable(LN^.ln_Data).GetData()=AVarData) then begin
      Result := LN^.ln_Data;
      Exit;
    end;

    LN := LN^.ln_NextNode;
  end;

end;

procedure TVarManager.Clear;
begin
  fVarList.Clear(true);
  fConstList.Clear(true);
end;

function TVarManager.GetVarList;
begin
  Result := fVarList;
end;

function TVarManager.GetConstList;
begin
  Result := fConstList;
end;



procedure TCommand.Initialize;
begin
  fStack := nil;
  fName := '';
  fParamList := TList.Create;
  fFunction := nil;
end;

procedure TCommand.Finalize;
begin
  SetStack(nil);
  ClearParams;
  fParamList.Free;
end;

constructor TCommand.Create;
begin
  Initialize;
end;

destructor TCommand.Destroy;
begin
  Finalize;
  Inherited Destroy;
end;

function TCommand.SetStack(AStack: TCommandStack): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (AStack=fStack) then begin
    Exit;
  end;

  if (fStack<>nil) then begin
    fStack.GetStack().Delete(Self);
  end;

  fStack := AStack;

  if (fStack<>nil) then begin
    fStack.GetStack().Append(Self);
  end;

end;

function TCommand.SetName(const AName: string): DWORD;
begin
  Result := RESULT_SUCCESSFULL;
  fName := AName;
end;

procedure TCommand.SetCommandFunction(const AFunction: TCommandFunction);
begin
  fFunction := AFunction;
end;

function TCommand.GetCommandStack;
begin
  Result := fStack;
end;

function TCommand.GetName;
begin
  Result := fName;
end;

function TCommand.GetParamList;
begin
  Result := fParamList;
end;

function TCommand.GetCommandFunction;
begin
  Result := fFunction;
end;

function TCommand.Execute(): DWORD;
  var
    I: Integer;
begin
  Result := RESULT_SUCCESSFULL;

  if (Assigned(fFunction)) then begin
    fFunction(Self);
  end
  else begin
    Result := RESULT_COMMAND_FUNCTION_INCORRECT;
  end;

end;

procedure TCommand.ZeroParams;
  var
    I: Integer;
begin

  for I := 0 to fParamList.Count - 1 do begin
    TVariable(fParamList[I]).SetData(EMPTY_INT);
  end;

end;

procedure TCommand.ClearParams;
begin
  fParamList.Clear;
end;

function ParseNumbers(const S: String; var AN: TNumberArray; var NCount: Integer): Boolean;
  var
    I: Integer;
    Buf: String;
    Len: Integer;
    C: Char;
    NegMark: Boolean;
begin
  Result := false;
  NCount := 0;
  Buf := '';
  Len := 0;
  NegMark := false;

  for I := 1 to Length(S) - 1 do begin
    C := S[I];

    if ((C>='0') and (C<='9')) or ((C='-') and (not NegMark)) then begin

      if (C='-') then begin
        NegMark := true;
      end;

      Buf := Buf+C;
      Inc(Len);
    end
    else begin

      if (Len>0) then begin
        Inc(NCount);
        SetLength(AN, NCount);
        AN[NCount-1] := StrToInt(Buf);
      end;

      Buf := '';
      Len := 0;
      NegMark := false;
    end;

  end;

  Result := (NCount>0);
end;

function TCommand.ParseCommand(const S: string): DWORD;
  var
    LN, SLN: PLinkedNode;
    CN, SN: String;
    CP, SP: Integer;
    BufW: String;
    WLen: Integer;
    I, E: Integer;
    BufN: _Int;
    C: Char;
    V: TVariable;
    SLen: Integer;
begin
  Result := RESULT_SUCCESSFULL;

  if (fStack<>nil) and (fStack.GetInterpretator()<>nil) then begin
    CP := 0;
    CN := '';
    SN := '';
    SP := 0;
    SLen := 0;
    SLN := 0;

    LN := fStack.GetInterpretator().GetCommandStore().GetStack().GetFirstNode;
    while LN<>nil do begin

      CN := TCommand(LN^.ln_Data).GetName();
      CP := Pos(CN, S);
      if (CP>0) and (Length(CN)>SLen) then begin
        SN := CN;
        SP := CP;
        SLen := Length(CN);
        SLN := LN;
      end;

      LN := LN^.ln_NextNode;
    end;

    CP := SP;
    CN := SN;
    LN := SLN;

    if (CP<>0) then begin
      SetName(CN);
      SetCommandFunction(TCommand(LN^.ln_Data).GetCommandFunction());
      BufW := '';
      WLen := 0;
      fParamList.Clear;

      for I := CP+Length(CN) to Length(S)+1 do begin
        C := S[I];

        if (((C>='0') and (C<='9')) or ((C>='A') and (C<='Z')) or ((C>='a') and (C<='z')) or (C='-') or (C='_')) and (I<Length(S)+1) then begin
          BufW := BufW+C;
          Inc(WLen);
        end
        else begin

          if (WLen>0) then begin
            E := 0;
            BufN := 0;
            Val(BufW, BufN, E);

            if not (fStack.fInterpretator.GetVariableManager().NameIsBusy(BufW)) then begin
              V := TVariable.Create;
              V.SetName(BufW);
              V.SetIsConstant(E=0);
              V.SetManager(fStack.fInterpretator.GetVariableManager);

              if (E=0) then begin
                V.SetData(BufN);
              end
              else begin
                V.SetData(EMPTY_INT);
              end;

              fParamList.Add(V);
            end
            else begin
              V := fStack.fInterpretator.GetVariableManager().GetVariableByName(BufW);

              if (V<>nil) then begin
                fParamList.Add(V);
              end
              else begin
                V := fStack.fInterpretator.GetVariableManager().GetConstantByName(BufW);

                if (V<>nil) then begin
                  fParamList.Add(V);
                end;

              end;

            end;

          end;

          BufW := '';
          WLen := 0;
        end;

        if (Assigned(fFunction)) then begin
          Result := fFunction(Self, true);
        end
        else begin
          Result := RESULT_COMMAND_FUNCTION_INCORRECT;
        end;

      end;

    end
    else begin
      Result := RESULT_COMMAND_NOT_FOUND;
    end;

  end
  else begin
    Result := RESULT_MISSING_INTERPRETATOR;
  end;

end;


procedure TCommandStack.Initialize;
begin
  fCommandStack := TLinkedList.Create;
  fOnExecuteStart := nil;
  fOnExecuteFinish := nil;
  fGotoCommand := -1;
  fGoto := false;
  fRet := false;
  fInterpretator := nil;
  fCompareValue := [];
  fSleepTime := COMMAND_SLEEP_TIME;
  fName := '';
end;

procedure TCommandStack.Finalize;
begin
  fName := '';
  SetInterpretator(nil);
  Clear;
  fCommandStack.Free;
end;

constructor TCommandStack.Create;
begin
  Initialize;
end;

destructor TCommandStack.Destroy;
begin
  Finalize;
  Inherited Destroy;
end;

function TCommandStack.SetInterpretator(AInterpretator: TInterpretator): DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (AInterpretator=fInterpretator) then begin
    Exit;
  end;

  if (fInterpretator<>nil) then begin
    fInterpretator.GetStacks().Delete(Self);
  end;

  fInterpretator := AInterpretator;

  if (fInterpretator<>nil) then begin
    fInterpretator.GetStacks.Append(Self);
  end;

end;

function TCommandStack.SetName(const AName: string): DWORD;
begin
  Result := RESULT_SUCCESSFULL;
  fName := AName;
end;

procedure TCommandStack.SetCompareValue(const ACompareValue: TCommandCompareValue);
begin
  fCompareValue := ACompareValue;
end;

function TCommandStack.GetInterpretator;
begin
  Result := fInterpretator;
end;

procedure TCommandStack.SetSleepTime(const SleepTime: DWORD);
begin
  fSleepTime := SleepTime;
end;

function TCommandStack.Execute;
  var
    LN: PLinkedNode;
    res: DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (Assigned(fOnExecuteStart)) then begin
    fOnExecuteStart(Self);
  end;

  LN := fCommandStack.GetFirstNode;
  while LN<>nil do begin
    res := TCommand(LN^.ln_Data).Execute();

    if (res<>RESULT_SUCCESSFULL) then begin
      Result := res;
      Break;
    end;

    if (fGoto) then begin
      LN := fCommandStack.GetNodeByIndex(fGotoCommand);
      fGoto := false;
      fGotoCommand := -1;
    end
    else begin
      LN := LN^.ln_NextNode;
    end;

    if (fRet) then begin
      fRet := false;
      Break;
    end;

    if (fInterpretator<>nil) and (fSleepTime>0) and not(fInterpretator.GetStop()) then begin
      Sleep(fSleepTime);
    end;

  end;

  if (Assigned(fOnExecuteFinish)) then begin
    fOnExecuteFinish(Self);
  end;

end;

function TCommandStack.GetStack;
begin
  Result := fCommandStack;
end;

function TCommandStack.GetName;
begin
  Result := fName;
end;

function TCommandStack.GetCompareValue;
begin
  Result := fCompareValue;
end;

function TCommandStack.GetSleepTime;
begin
  Result := fSleepTime;
end;

procedure TCommandStack.SetGotoCommand(const AGoto: Integer);
begin
  fGoto := true;
  fGotoCommand := AGoto;
end;

procedure TCommandStack.SetRet(const Val: Boolean);
begin
  fRet := Val;
end;

procedure TCommandStack.Clear;
begin
  fCommandStack.Clear(true);
end;

function TCommandStack.ParseLines(List: TStringList): DWORD;
  var
    I: Integer;
    Com: TCommand;
    res: DWORD;
    B: String;
begin
  Result := RESULT_SUCCESSFULL;

  for I := 0 to List.Count - 1 do begin
    Com := TCommand.Create;
    Com.SetStack(Self);
    res := Com.ParseCommand(List[I]);
    B := Com.GetName;

    if (res<>RESULT_SUCCESSFULL) then begin
      Result := res;
      Exit;
    end;

  end;

end;

function TCommandStack.LoadFromFile(const FileName: string): DWORD;
  var
    F: TextFile;
    Line: String;
    SL: TStringList;
begin
  Result := RESULT_SUCCESSFULL;
  Clear;
  AssignFile(F, FileName);
  Reset(F);
  SL := TStringList.Create;

  while not Eof(F) do begin
    ReadLn(F, Line);
    SL.Append(Line);
  end;

  Result := ParseLines(SL);
  SL.Free;
  CloseFile(F);
end;



class procedure TInterpretator.InitializeClass;
begin
  fTimerList := TLinkedList.Create;
end;

class procedure TInterpretator.FinalizeClass;
begin
  fTimerList.Free;
end;

procedure TInterpretator.Initialize;
begin
  fCommandStore := TCommandStack.Create;
  fCommandStore.SetName('CommandStore');
  fStacks := TLinkedList.Create;
  fVarMan := TVarManager.Create;
  fExecuting := false;
  fPostDelay := 0;
  fOnVariableDataChangedProc := nil;
  fStop := false;
  fDestroying := false;
end;

procedure TInterpretator.Finalize;
begin

  if not (fDestroying) and (fExecuting) then begin
    fDestroying := true;
    Exit;
  end;

  fCommandStore.Clear();
  fStacks.Clear(true);
  fCommandStore.Free;
  fVarMan.Clear;
  fStacks.Free;
  fVarMan.Free;
end;

procedure TInterpretator.SetVariableDataChangedProc(Proc: TOnDataChangedProc);
begin

  if (fVarMan<>nil) then begin
    fVarMan.OnVariableDataChangedProc := Proc;
  end;

  fOnVariableDataChangedProc := Proc;
end;

constructor TInterpretator.Create;
begin
  Initialize;
end;

destructor TInterpretator.Destroy;
begin
  Finalize;
  Inherited Destroy;
end;

function TInterpretator.SetCycled(const Val: Boolean): DWORD;
  var
    Tmp: Boolean;
begin
  Result := RESULT_SUCCESSFULL;
  Tmp := fCycled;
  fCycled := Val;
end;

function TInterpretator.SetPostDelay(const APostDelay: Cardinal): DWORD;
begin
  Result := RESULT_SUCCESSFULL;
  fPostDelay := APostDelay;
end;

procedure TInterpretator.SetStop(const Val: Boolean);
begin
  fStop := Val;
end;

function TInterpretator.Execute;
  var
    LN: PLinkedNode;
    res: DWORD;
begin
  Result := RESULT_SUCCESSFULL;
  fExecuting := true;

  LN := fStacks.GetFirstNode();
  while LN<>nil do begin
    res := TCommandStack(LN^.ln_Data).Execute;

    if (res<>RESULT_SUCCESSFULL) then begin
      Result := res;
      Exit;
    end;

    LN := LN^.ln_NextNode;
  end;


  if (fPostDelay<>0) and (fCycled) and not (fStop) and not (fDestroying) then begin
    Sleep(fPostDelay);
    Execute();
  end;

  fExecuting := false;

  if (fDestroying) then begin
    Finalize;
  end;

end;

function TInterpretator.NameIsBusy(const AName: string): Boolean;
begin
  Result := GetCommandStackByName(AName)<>nil;
end;

function TInterpretator.GetCycled;
begin
  Result := fCycled;
end;

function TInterpretator.GetPostDelay;
begin
  Result := fPostDelay;
end;

function TInterpretator.GetStop;
begin
  Result := fStop;
end;

function TInterpretator.GetCommandFromStoreByName(const AName: string): TCommand;
  var
    LN: PLinkedNode;
begin
  Result := nil;

  LN := fCommandStore.GetStack.GetFirstNode();
  while LN<>nil do begin

    if (TCommand(LN^.ln_Data).GetName()=AName) then begin
      Result := LN^.ln_Data;
      Exit;
    end;

    LN := LN^.ln_NextNode;
  end;

end;

function TInterpretator.GetCommandStackByName(const AName: string): TCommandStack;
  var
    LN: PLinkedNode;
begin
  Result := nil;

  LN := fStacks.GetFirstNode;
  while (LN<>nil) do begin

    if (TCommandStack(LN^.ln_Data).GetName()=AName) then begin
      Result := LN^.ln_Data;
    end;

    LN := LN^.ln_NextNode;
  end;

end;

function TInterpretator.GetCommandStore;
begin
  Result := fCommandStore;
end;

function TInterpretator.GetStacks;
begin
  Result := fStacks;
end;

function TInterpretator.GetVariableManager;
begin
  Result := fVarMan;
end;

function TInterpretator.AppendStackFromFile(const FileName: string): DWORD;
  var
    Stack: TCommandStack;
    F: TextFile;
    TestStr: String;
    err_res: DWORD;
begin
  Result := RESULT_SUCCESSFULL;

  if (FileExists(FileName)) then begin
    AssignFile(F, FileName);
    {$I-}
      Reset(F);
      ReadLn(F, TestStr);
    {$I+}

    if (IOResult=0) then begin
      CloseFile(F);
      Stack := TCommandStack.Create;
      Stack.SetInterpretator(Self);
      Stack.SetName(FileName);
      err_res := Stack.LoadFromFile(FileName);

      if (err_res<>RESULT_SUCCESSFULL) then begin
        Result := err_res;
      end;

    end
    else begin
      CloseFile(F);
      Result := RESULT_FILE_NOT_ACCESSIBLE;
    end;

  end
  else begin
    Result := RESULT_FILE_NOT_FOUND;
  end;

end;

procedure TInterpretator.Clear;
begin
  fStacks.Clear(true);
end;


initialization
  TInterpretator.InitializeClass;

finalization
  TInterpretator.FinalizeClass;

end.
