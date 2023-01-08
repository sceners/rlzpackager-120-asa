program RlzPackage;

uses
  Vcl.Forms,
  uRlz in 'uRlz.pas' {frmMain},
  uFNc in 'uFNc.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
