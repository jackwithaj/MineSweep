unit uBoard;

interface

uses
  SysUtils, uTiles;

const
  PARAM_WIDTH = '-w';
  PARAM_HEIGHT = '-h';
  PARAM_MINES = '-m';

type
  TTurnResult = (trInvalid, trContinue, trLoose, trWin);

  TMineSweepBoard = class(TObject)
  private
    fWidth: Integer;
    fHeight: Integer;
    fBoard: array of array of TMineSweepTile;
    fTileFactory: TMineTileFactory;
    procedure InitArray;
    procedure InitTiles;
    procedure UpdateNeighbours;
    function GetTile(i, j: Integer): TMineSweepTile;
    function AllNonMinesExposed: Boolean;
  public
    constructor Create(aWidth, aHeight, aMines: Integer);
    destructor Destroy; override;
    function TakeTurn(x, y: Integer): TTurnResult;
    property Width: Integer read fWidth write fWidth;
    property Height: Integer read fHeight write fHeight;
    property Tile[i, j: Integer]: TMineSweepTile read GetTile;
  end;

implementation

{ TMindSweepBoard }

function TMineSweepBoard.AllNonMinesExposed: Boolean;
var
  i, j: Integer;
begin
  Result := False;
  for i := Low(fBoard) to High(fBoard) do
  begin
    for j := Low(fBoard[i]) to High(fBoard[i]) do
      if not fBoard[i][j].Exposed then
        Exit;
  end;
  Result := True;
end;

constructor TMineSweepBoard.Create(aWidth, aHeight, aMines: Integer);
begin
  Width := aWidth;
  Height := aHeight;
  fTileFactory := TMineTileFactory.Create(aMines, aWidth * aHeight);
  InitArray;
  InitTiles;
  UpdateNeighbours;
end;

destructor TMineSweepBoard.Destroy;
var
  i, j: Integer;
begin
  for i := Low(fBoard) to High(fBoard) do
  begin
    for j := Low(fBoard[i]) to High(fBoard[i]) do
      fBoard[i][j].Free;
  end;
  inherited;
end;

function TMineSweepBoard.GetTile(i, j: Integer): TMineSweepTile;
begin
  if (i in [Low(fBoard) .. High(fBoard)]) and
    (j in [Low(fBoard[i]) .. High(fBoard[i])]) then
  begin
    Result := fBoard[i][j];
  end
  else
    Result := nil;
end;

procedure TMineSweepBoard.InitArray;
var
  i: Integer;
begin
  SetLength(fBoard, Height);
  for i := 0 to Height do
    SetLength(fBoard[i], Width);
end;

procedure TMineSweepBoard.InitTiles;
var
  i, j: Integer;
begin
  for i := Low(fBoard) to High(fBoard) do
  begin
    for j := Low(fBoard[i]) to High(fBoard[i]) do
      fBoard[i][j] := fTileFactory.NewTile;
  end;
end;

function TMineSweepBoard.TakeTurn(x, y: Integer): TTurnResult;
var
  lTile: TMineSweepTile;
begin
  lTile := Tile[y, x];
  if Assigned(lTile) then
  begin
    lTile.Exposed := True;
    if lTile is TMineTile then
      Result := trLoose
    else if AllNonMinesExposed then
      Result := trWin
    else
      Result := trContinue;
  end
  else
    Result := trInvalid;
end;

procedure TMineSweepBoard.UpdateNeighbours;
var
  i, j: Integer;
  x, y: Integer;
begin
  for i := Low(fBoard) to High(fBoard) do
  begin
    for j := Low(fBoard[i]) to High(fBoard[i]) do
    begin
      if Tile[i, j] is TMineTile then
      begin
        for x := i - 1 to i + 1 do
        begin
          for y := j - 1 to j + 1 do
          begin
            if Assigned(Tile[x, y]) then
              Tile[x, y].AddNeighbour;
          end;
        end;
      end;
    end;
  end;
end;

end.
