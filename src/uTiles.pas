unit uTiles;

interface

uses
  SysUtils;

const
   UNFLIPPED = '-';
   FLIPPED_EMPTY = '/';
type
  TMineSweepTile = class(TObject)
  private
    fExposed: Boolean;
    fNeighbourCount: Integer;
    function GetAsStr: String;
  protected
    function UnflippedString: String; virtual;
  public
    constructor Create;
    procedure AddNeighbour;
    property Exposed: Boolean read fExposed write fExposed;
    property NeighbourCount: Integer read fNeighbourCount;
    property AsStr: String read GetAsStr;
  end;

  TMineTile = class(TMineSweepTile)
  protected
    function UnflippedString: String; override;
  end;

  TMineTileFactory = class(TObject)
  private
    fMines: Integer;
    fTotalTiles: Integer;
    fTilesCreated: Integer;
    fMineSpots: array of Integer;
    function IsMine(aSpot: Integer): Boolean;
    procedure PopulateMineSpots;
  public
    constructor Create(aMines, aTiles: Integer);
    function NewTile: TMineSweepTile;
  end;

implementation

{ TMineSweepTile }

procedure TMineSweepTile.AddNeighbour;
begin
   Inc(fNeighbourCount);
end;

constructor TMineSweepTile.Create;
begin
  fNeighbourCount := 0;
end;

function TMineSweepTile.GetAsStr: String;
begin
   if not Exposed then
      Result := UNFLIPPED
   else
     Result := UnflippedString;
end;

function TMineSweepTile.UnflippedString: String;
begin
   if NeighbourCount > 0 then
      Result := Format('%d', [NeighbourCount])
   else
      Result := FLIPPED_EMPTY;
end;


{ TMineTile }

function TMineTile.UnflippedString: String;
begin
  Result := 'X'
end;

{ TMineTileFactory }

constructor TMineTileFactory.Create(aMines, aTiles: Integer);
begin
  inherited Create;
  fTotalTiles := aTiles;
  fTilesCreated := 0;
  fMines := aMines;
  if fMines >= fTotalTiles then
    fMines := fTotalTiles - 1;
  SetLength(fMineSpots, fMines);
  PopulateMineSpots;
end;

function TMineTileFactory.IsMine(aSpot: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(fMineSpots) to High(fMineSpots) do
  begin
    Result := fMineSpots[i] = aSpot;
    if Result then
      Break;
  end;
end;

function TMineTileFactory.NewTile: TMineSweepTile;
begin
  if IsMine(fTilesCreated) then
    Result := TMineTile.Create
  else
    Result := TMineSweepTile.Create;
  Inc(fTilesCreated);
end;

procedure TMineTileFactory.PopulateMineSpots;
var
  i: Integer;
  lSpot: Integer;
begin
  i := 0;
  Randomize;
  while i <= High(fMineSpots) do
  begin
    lSpot := Random(fTotalTiles);
    if not IsMine(lSpot) then
    begin
      fMineSpots[i] := lSpot;
      Inc(i);
    end;
  end;
end;

end.
