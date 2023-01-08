unit uFNc;

interface

uses Vcl.Forms,System.SysUtils,Winapi.Windows;


function GetAppDir():string;
function StrRepeat(InStr:string;Prefix:Char;Len:Byte):string;
function StriRepeat(InStr:string;Suffix:Char;Len:Byte):string;
procedure FatalError(Title,Text:string;Terminate:Boolean);

implementation


function GetAppDir():string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

function StrRepeat(InStr:string ;Prefix:Char; Len:Byte):string;
begin
  while Length(InStr) < Len  do
  begin
    InStr := Prefix + InStr ;
  end;
  Result := InStr;
end;

function StriRepeat(InStr:string;Suffix:Char;Len:Byte):string;
begin
  while Length(InStr) < Len  do
  begin
    InStr :=  InStr + Suffix ;
  end;
  Result := InStr;
end;


procedure FatalError(Title,Text:string;Terminate:Boolean);
begin
   MessageBoxW(0,PWideChar(Text),PWideChar(Title),16);
   if (Terminate) then Application.Terminate;
end;



end.
