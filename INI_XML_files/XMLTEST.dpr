program XMLTEST;

uses
  Forms,
  MANPAGESRC in 'MANPAGESRC.pas' {XMLTESTMAINPAGE},
  uCiaXml in 'uCiaXml.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TXMLTESTMAINPAGE, XMLTESTMAINPAGE);
  Application.Run;

end.
