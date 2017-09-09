unit sint_const;

interface

uses
  Windows;

const

  COMMAND_SLEEP_TIME = 20;

  RESULT_SUCCESSFULL  = $00;
  RESULT_UNKNOWN      = $01;
  RESULT_NAME_IS_BUSY = $02;
  RESULT_DATA_OVERFLOW = $03;
  RESULT_VARIABLE_IS_CONSTANT = $04;
  RESULT_MISSING_VARIABLE_MANAGER = $05;
  RESULT_MISSING_INTERPRETATOR     = $06;
  RESULT_COMMAND_FUNCTION_INCORRECT = $07;
  RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS = $08;
  RESULT_FIRST_PARAM_IS_CONSTANT = $09;
  RESULT_COMMAND_NOT_FOUND = $0A;
  RESULT_FILE_NOT_FOUND  = $0B;
  RESULT_FILE_NOT_ACCESSIBLE = $0C;
  RESULT_MISSING_COMMAND_STACK = $0D;

  RESULT_STRINGS: Array [0..$0D] of String = ('RESULT_SUCCESSFULL',
                                             'RESULT_UNKNOWN',
                                             'RESULT_NAME_IS_BUSY',
                                             'RESULT_DATA_OVERFLOW',
                                             'RESULT_VARIABLE_IS_CONSTANT',
                                             'RESULT_MISSING_VARIABLE_MANAGER',
                                             'RESULT_MISSING_INTERPRETATOR',
                                             'RESULT_COMMAND_FUNCTION_INCORRECT',
                                             'RESULT_AMOUNT_PARAMS_DIFFERS_FROM_FUNCTION_PARAMS',
                                             'RESULT_FIRST_PARAM_IS_CONSTANT',
                                             'RESULT_COMMAND_NOT_FOUND',
                                             'RESULT_FILE_NOT_FOUND',
                                             'RESULT_FILE_NOT_ACCESSIBLE',
                                             'RESULT_MISSING_COMMAND_STACK');

function ResultToString(const AResult: DWORD): String;

implementation

function ResultToString(const AResult: DWORD): String;
begin
  Result := '';

  if (AResult<Low(RESULT_STRINGS)) or (AResult>High(RESULT_STRINGS)) then begin
    Exit;
  end;

  Result := RESULT_STRINGS[AResult];
end;

end.
