unit sint_init;

interface

uses
  Windows,
  SysUtils,
  sint_classes,
  sint_functions;

procedure Initialize;
procedure Finalize;

var
  Interpretator: TInterpretator=nil;

implementation

procedure Initialize;
  var
    Com: TCommand;
begin
  Interpretator := TInterpretator.Create;
  Com := TCommand.Create;
    Com.SetName('ADD');
    Com.SetCommandFunction(sint_ADD);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('SUB');
    Com.SetCommandFunction(sint_SUB);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('MUL');
    Com.SetCommandFunction(sint_MUL);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('DIV');
    Com.SetCommandFunction(sint_DIV);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('MOD');
    Com.SetCommandFunction(sint_MOD);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('MOV');
    Com.SetCommandFunction(sint_MOV);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('AND');
    Com.SetCommandFunction(sint_AND);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('OR');
    Com.SetCommandFunction(sint_OR);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('XOR');
    Com.SetCommandFunction(sint_XOR);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('NOT');
    Com.SetCommandFunction(sint_NOT);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('CMP');
    Com.SetCommandFunction(sint_CMP);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('JMP');
    Com.SetCommandFunction(sint_JMP);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('JMP_EQ');
    Com.SetCommandFunction(sint_JMP_EQ);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('JMP_NE');
    Com.SetCommandFunction(sint_JMP_NE);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('JMP_GT');
    Com.SetCommandFunction(sint_JMP_GT);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('JMP_GE');
    Com.SetCommandFunction(sint_JMP_GE);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('JMP_LT');
    Com.SetCommandFunction(sint_JMP_LT);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('JMP_LE');
    Com.SetCommandFunction(sint_JMP_LE);
    Com.SetStack(Interpretator.GetCommandStore());
  Com := TCommand.Create;
    Com.SetName('RET');
    Com.SetCommandFunction(sint_RET);
    Com.SetStack(Interpretator.GetCommandStore());
end;

procedure Finalize;
begin
  Interpretator.Free;
end;

end.
