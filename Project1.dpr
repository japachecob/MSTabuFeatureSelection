program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ConstructivoClas in 'ConstructivoClas.pas',
  FuncionesClas in 'FuncionesClas.pas',
  MultiStartClass in 'MultiStartClass.pas',
  ParaleloClas in 'ParaleloClas.pas',
  TabuClas in 'TabuClas.pas',
  tipos in 'tipos.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
