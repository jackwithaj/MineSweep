unit utTileTests;

interface
uses
  DUnitX.TestFramework, uTiles;

type
  TTileTests = class(TObject)

  public
    [TestCase('TestMineCreate1', '100,50')]
    [TestCase('TestMineCreate2', '10,9')]
    [TestCase('TestMineCreate3', '2,1')]
    procedure TestMineCreation(aTotalTiles, aMines: Integer);

    [TestCase('TestNeighbourCount1', '15')]
    [TestCase('TestNeighbourCount1', '115')]
    procedure TestNeighbours(aNeigbourCount: Integer);

  end;

implementation

{ TTileTests }

procedure TTileTests.TestMineCreation(aTotalTiles, aMines: Integer);
var
  lFactory: TMineTileFactory;
  lTile: TMineSweepTile;
  i: Integer;
  lMineCount: Integer;
begin
  lMineCount := 0;
  lFactory := TMineTileFactory.Create(aMines, aTotalTiles);
  try
    for i := 0 to aTotalTiles do
    begin
      lTile := lFactory.NewTile;
      try
        if lTile is TMineTile then
          Inc(lMineCount);
      finally
        lTile.Free;
      end;
    end;
  finally
    lFactory.Free;
  end;
  Assert.AreEqual(aMines, lMineCount);
end;

procedure TTileTests.TestNeighbours(aNeigbourCount: Integer);
var
  i: Integer;
  lTile: TMineSweepTile;
begin
  lTile := TMineSweepTile.Create;
  try
    for i := 1 to aNeigbourCount do
      lTile.AddNeighbour;
    Assert.AreEqual(lTile.NeighbourCount, aNeigbourCount);
  finally
    lTile.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTileTests);

end.