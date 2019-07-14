unit uGame;

interface
uses
  uBoard, uTiles, SysUtils, StrUtils;

type
   TMineSweep = class(TObject)
   private
     fMinesweepBoard: TMineSweepBoard;
     function GetParamValue(const aParam: String; out aValue: Integer): Boolean;
     procedure InitVariables;
     function PromptUserForWidth: Integer;
     function PromptUserForHeight: Integer;
     function PromptUserForMines: Integer;
     function PromptNextMove: Boolean;
     function ParseCoordinatres(aStr: String; out x: Integer; out y: Integer): Boolean;
     function GetUserInputInteger(aPrompt, aErrMsg: String): Integer;
     procedure PrintBoard;
   public
     destructor Destroy; override;
     procedure Run;
   end;

var
  dMineSweep: TMineSweep;

implementation

{ TMineSweep }

destructor TMineSweep.Destroy;
begin
  if Assigned(fMinesweepBoard) then
    fMinesweepBoard.Free;
  inherited;
end;

function TMineSweep.GetParamValue(const aParam: String;
  out aValue: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ParamCount do
  begin
    if ParamStr(i) = aParam then
    begin
      try
        if i + 1 <= ParamCount then
        begin
          aValue := StrToInt(ParamStr(i+1));
          Result := True;
        end;
      except
        on E: EConvertError do
          Result := False;
      end;
      Break;
    end;
  end;
end;

function TMineSweep.GetUserInputInteger(aPrompt, aErrMsg: String): Integer;
var
  lStr: String;
begin
  Result := -1;
  while Result = -1 do
  begin
    WriteLn(aPrompt);
    ReadLn(lStr);
    try
      Result := StrToInt(lStr);
    except
      on E: EConvertError do
        WriteLn(Format(aErrMsg, [lStr]));
    end;
  end;
end;

procedure TMineSweep.InitVariables;
var
  lWidth, lHeight, lMines: Integer;
begin
  if not GetParamValue(PARAM_WIDTH, lWidth) then
    lWidth := PromptUserForWidth;

  if not GetParamValue(PARAM_HEIGHT, lHeight) then
    lHeight := PromptUserForHeight;

  if not GetParamValue(PARAM_MINES, lMines) then
    lMines := PromptUserForMines;

  fMinesweepBoard := TMineSweepBoard.Create(lWidth, lHeight, lMines);
end;

function TMineSweep.ParseCoordinatres(aStr: String; out x, y: Integer): Boolean;
var
  lSpace: Integer;
  lXStr: String;
  lYStr: String;
begin
  lSpace := Pos(' ', Trim(aStr));
  lXStr := Trim(Copy(aStr, 1, lSpace));
  lYStr := Trim(Copy(aStr, lSpace + 1, Length(aStr) - lSpace));
  Result := True;
  try
    x := StrToInt(lXStr);
    y := StrToInt(lYStr);
  except on E: EConvertError do
    Result := False;
  end;
end;

procedure TMineSweep.PrintBoard;
var
  i, j: Integer;
  lLine: String;
begin
  lLine := '   |';
  for i := 0 to fMinesweepBoard.Width -1 do
    lLine := lLine + Format('%3d|', [i]);
  WriteLn(lLine);
  WriteLn('   |' + StringOfChar('-', (fMinesweepBoard.Width) * 4 ));
  for i := 0 to fMinesweepBoard.Height - 1do
  begin
    lLine := Format('%3d|', [i]);
    for j := 0 to fMinesweepBoard.Width - 1 do
    begin
      if Assigned(fMinesweepBoard.Tile[i, j]) then
        lLine := lLine + ' ' + Format('%-3s', [fMinesweepBoard.Tile[i, j].AsStr]);
    end;
    WriteLn(lLine);
  end;
end;

function TMineSweep.PromptNextMove: Boolean;
const
  INVALID_COORDINATES = 'Invalid coordinates';
var
  lResponse: String;
  x, y: Integer;
  lTurnResponse: TTurnResult;
begin
  Result := True;
  WriteLn('Enter X and Y coordinates of tile to reveal');
  ReadLn(lResponse);
  if ParseCoordinatres(lResponse, x, y) then
  begin
    lTurnResponse := fMinesweepBoard.TakeTurn(x, y);

    case lTurnResponse of
      trInvalid: WriteLn(INVALID_COORDINATES);
      trLoose:
      begin
        WriteLn('You have lost');
        Result := False;
      end;
      trWin:
      begin
        WriteLn('You have won!');
        Result := False;
      end;
    end;
  end
  else
  begin
    WriteLn(INVALID_COORDINATES);
    Result := True;
  end;
end;

function TMineSweep.PromptUserForHeight: Integer;
const
  PROMPT = 'Enter board height';
  ERR = '%s is not a valid height';
begin
  Result := GetUserInputInteger(PROMPT, ERR);
end;

function TMineSweep.PromptUserForMines: Integer;
const
  PROMPT = 'Enter number of mines';
  ERR = '% is not a valid mine count';
begin
  Result := GetUserInputInteger(PROMPT, ERR);
end;

function TMineSweep.PromptUserForWidth: Integer;
const
  PROMPT = 'Enter board width';
  ERR = '%s is not a valid width';
begin
  Result := GetUserInputInteger(PROMPT, ERR);
end;

procedure TMineSweep.Run;
begin
  InitVariables;
  repeat
    PrintBoard;
  until not PromptNextMove;
  PrintBoard;
  ReadLn;
end;

end.
