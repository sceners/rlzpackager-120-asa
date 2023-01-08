(* *
  * Project: Relase Package Generator
  * Verstion: 1.2 .
  * Deverloper: Digital.Spirit
  * Date: 7 2014
  * Website: www.assassin.ir
  * Lincens: Just OpenSource
  * IDE : Delphi XE 6
  * OS : all windows only .
  * Compile on: Delphi XE 3 and newer
  * *)

unit uRlz;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, Vcl.Buttons, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, System.IOUtils,System.Zip;

type
  TfrmMain = class(TForm)
    imgLogo: TImage;
    Label1: TLabel;
    edtTarget: TEdit;
    Label2: TLabel;
    edtDate: TEdit;
    btnToday: TButton;
    Label3: TLabel;
    edtType: TEdit;
    cbbEng: TComboBox;
    edtEgineer: TEdit;
    Label4: TLabel;
    edtWebsite: TEdit;
    Label5: TLabel;
    edtProtection: TEdit;
    Label6: TLabel;
    edtLang: TEdit;
    Label7: TLabel;
    mmoComment: TMemo;
    grp1: TGroupBox;
    edtFile1: TEdit;
    edtFile2: TEdit;
    edtFile3: TEdit;
    btnChoos1: TButton;
    btnChoos2: TButton;
    btnChoose3: TButton;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    btnGenerate: TBitBtn;
    btnUpdateNfo: TBitBtn;
    btnAbout: TBitBtn;
    idhtp: TIdHTTP;
    btnLoad: TBitBtn;
    btnSave: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTodayClick(Sender: TObject);
    procedure btnChoos1Click(Sender: TObject);
    procedure btnChoos2Click(Sender: TObject);
    procedure btnChoose3Click(Sender: TObject);
    procedure btnUpdateNfoClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateForm();
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

const
  (* this constant is for your team info *)
  TEAM = 'ASA';
  DEFAULT_LENGTH = 36;
  HAS_DIZ = True; // has disz file.
  UPDATE_URL = 'http://assassin.ir/ASA.nfo';
  VERSTION = '1.2';

  STATIC_EDITZ: array [1 .. 7] of string = ('edtFile1', 'edtDate', 'edtType',
    'edtEgineer', 'edtWebsite', 'edtProtection', 'edtLang');

implementation

{$R *.dfm}

uses uFNc;

(* global variables *)
var
  nfo: TStringList;
  NFO_LENGTH: Byte;

  (* *
    * init nfo info
    * *)
procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  MessageBox(Handle, 'App: Release package generator' + #13#10 + 'Verstion: ' +
    VERSTION + #13#10 + 'Coder: Digital.Spirit' + #13#10 +
    'Website: http://assassin.ir' + #13#10 +
    'Thanks to: SadeghPM, HSN.C3r and AHA', 'Right', 64);
end;

procedure TfrmMain.btnChoos1Click(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    edtFile1.Text := dlgOpen.FileName;
  end;
end;

procedure TfrmMain.btnChoos2Click(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    edtFile2.Text := dlgOpen.FileName;
  end;
end;

procedure TfrmMain.btnChoose3Click(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    edtFile3.Text := dlgOpen.FileName;
  end;
end;

procedure TfrmMain.btnGenerateClick(Sender: TObject);
var
  TmpStr, TmpNfo, TmpDiz, TmpRlz,Prefix: string;
  MyNfo, Diz, Rlz: TStringList;
  i: Integer;
  Relase, FinalZ: TZipFile;
begin
  TmpDiz := '';

  // check inputs
  if ((edtTarget.Text = '') or (edtEgineer.Text = '') or (edtType.Text = '') or
    (edtDate.Text = '')) then
  begin
    FatalError('Stop',
      'Error: Some input(s) are empty please check inputs.', False);
    Exit;
  end;
  // check first release file
  if ((edtFile1.Text = '') or (not FileExists(edtFile1.Text))) then
  begin
    FatalError('File error', 'Are you sure have any release file?', False);
    Exit;
  end;
  // info
  MyNfo := TStringList.Create;
  try
    MyNfo.Text := nfo.Text;
    MyNfo.Delete(0);
    // make target
    TmpStr := StrRepeat(edtTarget.Text, '.', NFO_LENGTH);
    MyNfo.Text := StringReplace(MyNfo.Text, '{target}', TmpStr, [rfReplaceAll]);
    // make date
    TmpStr := StrRepeat(edtDate.Text, '.', NFO_LENGTH);
    MyNfo.Text := StringReplace(MyNfo.Text, '{date}', TmpStr, [rfReplaceAll]);
    // make type
    TmpStr := StrRepeat(edtType.Text, '.', NFO_LENGTH);
    MyNfo.Text := StringReplace(MyNfo.Text, '{type}', TmpStr, [rfReplaceAll]);
    // make lang
    TmpStr := StrRepeat(edtLang.Text, '.', NFO_LENGTH);
    MyNfo.Text := StringReplace(MyNfo.Text, '{lang}', TmpStr, [rfReplaceAll]);
    // make engineer
    TmpStr := StrRepeat(edtEgineer.Text, '.', NFO_LENGTH);
    MyNfo.Text := StringReplace(MyNfo.Text, '{author}', TmpStr, [rfReplaceAll]);
    // website
    TmpStr := StrRepeat(edtWebsite.Text, '.', NFO_LENGTH);
    MyNfo.Text := StringReplace(MyNfo.Text, '{website}', TmpStr,
      [rfReplaceAll]);
    // protection
    TmpStr := StrRepeat(edtProtection.Text, '.', NFO_LENGTH);
    MyNfo.Text := StringReplace(MyNfo.Text, '{protect}', TmpStr,
      [rfReplaceAll]);
    // engineer
    TmpStr := StriRepeat(cbbEng.Text, ' ', 7);
    MyNfo.Text := StringReplace(MyNfo.Text, '{cracker}', TmpStr,
      [rfReplaceAll]);

    // add comment
    for i := 1 to 5 do
    begin

      if mmoComment.Lines.Count >= i then
      begin
        TmpStr := StriRepeat(mmoComment.Lines[i-1], '.', NFO_LENGTH);
      end
      else
      begin
        TmpStr := StrRepeat('', '.', NFO_LENGTH);
      end;
      MyNfo.Text := StringReplace(MyNfo.Text, '{m'+IntToStr(i)+'}', TmpStr,
      [rfReplaceAll]);
    end;
    // save nfo
    TmpNfo := TPath.GetTempFileName ;
    MyNfo.SaveToFile(TmpNfo);
    // make diz file if has and Exists
    if HAS_DIZ and FileExists(GetAppDir+TEAM+'.diz')  then
    begin
       Diz := TStringList.Create;
       Diz.LoadFromFile(GetAppDir+TEAM+'.diz');
       Diz.Text:= StringReplace(Diz.Text, '{target}', edtTarget.Text,
        [rfReplaceAll]);
       Diz.Text:= StringReplace(Diz.Text, '{date}', edtDate.Text,
        [rfReplaceAll]);
      TmpDiz := TPath.GetTempFileName;
      Diz.SaveToFile(TmpDiz);
      Diz.Free;
    end;
    // make relase zip
    Relase := TZipFile.Create;
    Prefix := StringReplace(edtTarget.Text+'-'+edtType.Text,' ','.',[rfReplaceAll])+'-'+TEAM;
    TmpStr := TPath.GetTempPath+Prefix+'.zip';
    Relase.Open(TmpStr,zmWrite);
    Relase.Add(TmpNfo,TEAM+'.nfo');
    if ( (HAS_DIZ) and (TmpDiz <> '')) then
    begin
      Relase.Add(TmpDiz,TEAM+'.diz');
    end;
    // attach release files
    for I := 1 to 3 do
    begin
      if (FileExists(TEdit(FindComponent('edtFile'+IntToStr(i))).Text)) then
      begin
        Relase.Add(TEdit(FindComponent('edtFile'+IntToStr(i))).Text,
        ExtractFileName(TEdit(FindComponent('edtFile'+IntToStr(i))).Text));
      end;
    end;
    Relase.Close;

    dlgSave.InitialDir := TPath.GetDocumentsPath+'Desktop';
    dlgSave.FileName := Prefix+'-pkg.zip'; ;
    if not dlgSave.Execute then
    begin
      Beep;Exit;
    end;
    // make .rlz file
    Rlz  := TStringList.Create;
    Rlz.Values['target'] := edtTarget.Text;
    // 07/30/2014 => 2014/07/30  ;
    TmpStr := edtDate.Text;
    Rlz.Values['date'] := Copy(TmpStr,7,4) + '/' + Copy(TmpStr,1,2) +
     '/' + Copy(TmpStr,4,2);
    Rlz.Values['type'] := edtType.Text ;
    Rlz.Values['cracker'] := edtEgineer.Text;
    Rlz.Values['website'] := edtWebsite.Text;
    Rlz.Values['protection'] := edtProtection.Text;
    TmpRlz := TPath.GetTempFileName;
    Rlz.SaveToFile(TmpRlz);
    Rlz.Free;
    //make final file
    FinalZ := TZipFile.Create;
    FinalZ.Open(dlgSave.FileName,zmWrite);
    TmpStr := TPath.GetTempPath+Prefix+'.zip';
    FinalZ.Add(TmpStr,ExtractFileName(TmpStr));
    FinalZ.Add(TmpRlz,edtTarget.Text+'-'+edtType.Text+'-'+TEAM+'.rlz');
    FinalZ.Close;
    DeleteFileW(PWideChar(TmpStr));
    DeleteFileW(PWideChar(TmpRlz));
    DeleteFileW(PWideChar(TmpNfo));
    DeleteFileW(PWideChar(TmpDiz));
    MessageBeep(64);
  finally
    MyNfo.Free;
  end;

end;

procedure TfrmMain.btnLoadClick(Sender: TObject);
var
  load: TStringList;
  I: Integer;
begin
  // load saved latest item
  if (FileExists(GetAppDir + 'save.dat')) then
  begin
    load := TStringList.Create;
    load.LoadFromFile(GetAppDir + 'save.dat');
    for I := 1 to 7 do
    begin
      TEdit(FindComponent(STATIC_EDITZ[I])).Text :=
        load.Values[STATIC_EDITZ[I]];
    end;
    mmoComment.Text := StringReplace(load.Values['mmoComment'], '<br />',
     #13#10, [rfReplaceAll]);
    cbbEng.ItemIndex := StrToIntDef(load.Values['cbbEng'], 0);
    MessageBeep(64);
  end
  else
  begin
    Beep;
  end;

end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
var
  save: TStringList;
  I: Integer;
begin
  // save current item
  save := TStringList.Create;
  for I := 1 to 7 do
  begin
    save.Add(STATIC_EDITZ[I] + '=' +
      TEdit(FindComponent(STATIC_EDITZ[I])).Text);
  end;
  save.Add('mmoComment=' + StringReplace(mmoComment.Text, #13#10, '<br />',
    [rfReplaceAll]));
  save.Add('cbbEng=' + IntToStr(cbbEng.ItemIndex));
  save.SaveToFile(GetAppDir + 'save.dat');
  MessageBeep(64);
end;

procedure TfrmMain.btnTodayClick(Sender: TObject);
begin
  edtDate.Text := FormatDateTime('mm/dd/yyyy', Now);
end;

procedure TfrmMain.btnUpdateNfoClick(Sender: TObject);
var
  Resp: TStringStream;
  Temp: string;
begin
  Resp := TStringStream.Create;
  try
    // LOAD FROM SERVER
    idhtp.Get(UPDATE_URL, Resp);
    Temp := Resp.DataString;

    // save into nfo
    nfo.Clear;
    nfo.Text := Temp;
    nfo.SaveToFile(GetAppDir + TEAM + '.nfo');
    // update form
    UpdateForm;
    MessageBox(Handle, 'Application pattern nfo was updated.', 'Right', 64);

  except
    FatalError('Oppsss', 'Application can''t be update nfo.', False);
    Resp.Free;
  end;
  Resp.Free;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  nfo.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);

begin
  try
    nfo := TStringList.Create;
    if (not FileExists(GetAppDir + TEAM + '.nfo')) then
    begin
      FatalError('Ops', 'Nfo File not found.', True);
    end
    else
    begin
      UpdateForm;
    end;
  except
    // on error
    FatalError('Sorry', 'Initial Package Generator is unsuccessful.', True);
  end;
end;

procedure TfrmMain.UpdateForm;
const
  edits: array [1 .. 7] of string = ('edtTarget', 'edtDate', 'edtType',
    'edtEgineer', 'edtWebsite', 'edtProtection', 'edtLang');
var
  I: Integer;
begin
  nfo.LoadFromFile(GetAppDir + TEAM + '.nfo');
  NFO_LENGTH := StrToIntDef(Trim(nfo.Strings[0]), DEFAULT_LENGTH);
  // set max length of form's edits .
  for I := 1 to 7 do
  begin
    TEdit(FindComponent(edits[I])).MaxLength := NFO_LENGTH;
  end;
end;

end.
