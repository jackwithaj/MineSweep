program MineSweeper;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uBoard in 'src/uBoard.pas',
  uTiles in 'src/uTiles.pas',
  uGame in 'src/uGame.pas';

begin
  try
    dMineSweep := TMineSweep.Create;
    try
      dMineSweep.Run;
    finally
      dMineSweep.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
