unit MANPAGESRC;

interface

uses
  SysUtils,
  Classes, TypInfo,
  Controls, Forms, Dialogs, StdCtrls,
  uCiaXml, ComCtrls, inifiles, Buttons, ExtCtrls;

type
  TXMLTESTMAINPAGE = class(TForm)
    SRC: TOpenDialog;
    DEST: TSaveDialog;
    tv1: TTreeView;
    grp1: TGroupBox;
    grp2: TGroupBox;
    rbSECTIONSREAD: TRadioButton;
    btn10: TButton;
    mmo1: TMemo;
    rbWRITETESTDATA: TRadioButton;
    rbREADUPDATESEC: TRadioButton;
    rbDELUPDATESEC: TRadioButton;
    rbREADUPDSECVALS: TRadioButton;
    rbDELITEMBYINDEX: TRadioButton;
    rbDELITEMBYNAME: TRadioButton;
    rbREADUPDITEMS: TRadioButton;
    btn1: TButton;
    rbEXADDTESTDATA: TRadioButton;
    rbreadexupd: TRadioButton;
    rbREADALLSEC: TRadioButton;
    rbREADEXUPITEMS: TRadioButton;
    rbDELEXUPSEC: TRadioButton;
    rbREADEXUPVALS: TRadioButton;
    rbEXUPDELITEMBYINDEX: TRadioButton;
    rbEXUPDDELITMBYNAME: TRadioButton;
    grp3: TGroupBox;
    btn2: TButton;
    rbSAVECOMPOINFO: TRadioButton;
    rbGETAPPSCOMPOINFO: TRadioButton;
    mmo2: TMemo;
    rbconvertxmltoini: TRadioButton;
    pnl1: TPanel;
    dlgFont2: TFontDialog;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btn7: TButton;
    btn8: TButton;
    pnl2: TPanel;
    dlgColor1: TColorDialog;
    procedure btn10Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);

  private
    procedure TREEvXML(Tree: TTreeView; Expand: Boolean);

  public
    { Public declarations }
  end;

var
  XMLTESTMAINPAGE: TXMLTESTMAINPAGE;

implementation

{$R *.dfm}

procedure TXMLTESTMAINPAGE.TREEvXML(Tree: TTreeView; Expand: Boolean);
  function IdOf(s: string): string;
  begin
    result := copy(s, 1, pos('=', s) - 1);
  end;

  function ValOf(s: string): string;
  begin
    result := copy(s, pos('=', s) + 1, maxint);
  end;

var
  n, k: Integer;
  Section, Sections: TStringList;
  XMLASINI: TXMLConfig;
  FL: string;
  nod: TTreeNode;
begin
  XMLASINI := TXMLConfig.Create;
  FL := XMLASINI.Filename;
  Sections := TStringList.Create;
  Section := TStringList.Create;
  try
    XMLASINI.ReadSections(Sections);

    for k := 0 to Sections.count - 1 do
    begin

      XMLASINI.EXReadSection(Sections[k], Section);
       nod := Tree.Items.AddChild(nil, Sections[k]);
      for n := 0 to Section.count - 1 do
      begin

        Tree.Items.AddChildObject(nod, (Section[n]+' = '+XMLASINI.EXReadString(Sections[k],Section[n],'')), 0);


      end;

    end;

  finally
    XMLASINI.free;
    Section.free;
    Sections.free;

  end;
end;

function RandomP(PLen: Integer): string;
var
  str: string;
begin
  Randomize;

  str := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  result := '';
  repeat
    result := result + str[Random(Length(str)) + 1];
  until (Length(result) = PLen) end;

  procedure TXMLTESTMAINPAGE.btn10Click(Sender: TObject);
  Var
    XMLASINI: TXMLConfig;
    XMLDATA: TStringList;
    s, FL: string;
    i: Integer;
    TS: TMemoryStream;
  begin
    TS := TMemoryStream.Create;
    XMLASINI := TXMLConfig.Create;
    XMLDATA := TStringList.Create;
    s := 'Update';
    FL := XMLASINI.Filename;

    try
      mmo1.Lines.clear;

      // Ajouté des données
      if rbWRITETESTDATA.Checked then
      begin
        XMLASINI.WriteString(s, 'Major', inttostr(Random(9)));
        XMLASINI.WriteString(s, 'Minor', inttostr(Random(9)));
        XMLASINI.WriteString(s, 'build', inttostr(Random(9)));
        XMLASINI.WriteString(s, 'Date', datetostr(date));
        XMLASINI.WriteString(s, 'Size', inttostr(Random(315654)) + ' Kb');
        XMLASINI.WriteString(s, 'website', 'www.' + RandomP(5) + '.com');
        XMLASINI.WriteString(s, 'Changes', RandomP(20));
        XMLASINI.WriteString('GENERAL', 'ACTIVEPAGE', 'Page 1');
        XMLASINI.WriteString('Interface', 'Height', inttostr(self.Height));
        XMLASINI.WriteString('Interface', 'width', inttostr(self.Width));
        XMLASINI.WriteString('Applicaiton', 'Name', Application.ExeName);

      end;

      // Lire tout les sections
      if rbSECTIONSREAD.Checked then
        XMLASINI.ReadSections(mmo1.Lines);

      // Lire la section update
      if rbREADUPDATESEC.Checked then
      begin

        // Exemple 1

        with XMLASINI do
          for i := 0 to Sectionitemscount(s) - 1 do
            mmo1.Lines.add(Itemnamebyindex(s, i) + ' ---> ' +
              Itemvaluebyindex(s, i));



        // Exemple 2
        {
          XMLASINI.ReadSection(s,XMLDATA);
          for i := 0 to  XMLDATA.count-1 do
          mmo1.Lines.add( XMLDATA[i]+' ---> ' +XMLASINI.ReadString(s,XMLDATA[i],''));
        }

      end;

      // Lire les items de la section update
      if rbREADUPDITEMS.Checked then
        XMLASINI.ReadSection(s, mmo1.Lines);

      // Supprimer la section update
      if rbDELUPDATESEC.Checked then
        XMLASINI.EraseSection(s);

      // Lire les valeurs de la section update
      if rbREADUPDSECVALS.Checked then
        XMLASINI.ReadSectionValues(s, mmo1.Lines);

      // Supprimer l'item avec l'index (2) dans  la section update
      if rbDELITEMBYINDEX.Checked then
        XMLASINI.DeleteKeyByindex(s, 2);
      // Supprimer l'item avec le nom (Date) dans  la section update
      if rbDELITEMBYNAME.Checked then
        XMLASINI.DeleteKeybyname(s, 'Date');

      // Read from stream
      XMLASINI.GetXmlasStream(TS);
      mmo2.Lines.LoadFromStream(TS);

    finally

      XMLDATA.free;
      XMLASINI.Destroy;
      TS.free;
      TREEvXML(tv1, false);
    end;

  end;

  procedure TXMLTESTMAINPAGE.btn1Click(Sender: TObject);
  Var
    XMLASINI: TXMLConfig;
    XMLDATA: TStringList;
    s, FL: string;
    i: Integer;
  begin
    XMLASINI := TXMLConfig.Create;
    XMLDATA := TStringList.Create;
    s := 'EXUpdate';
    FL := XMLASINI.Filename;

    try
      mmo1.Lines.clear;

      // Ajouté des données
      if rbEXADDTESTDATA.Checked then
      begin

        XMLASINI.EXWriteString(s, 'EX_Major', inttostr(Random(9)));
        XMLASINI.EXWriteString(s, 'EX_Minor', inttostr(Random(9)));
        XMLASINI.EXWriteString(s, 'EX_build', inttostr(Random(9)));
        XMLASINI.EXWriteString(s, 'EX_Date', datetostr(date));
        XMLASINI.EXWriteString(s, 'EX_Size', inttostr(Random(315654)) + ' Kb');
        XMLASINI.EXWriteString(s, 'EX_website', 'www.' + RandomP(5) + '.com');
        XMLASINI.EXWriteString(s, 'EX_Changes', RandomP(20));
        XMLASINI.EXWriteString('EXGENERAL', 'EX_ACTIVEPAGE', 'Page 1');
        XMLASINI.EXWriteString('EXInterface', 'EX_Height',
          inttostr(self.Height));
        XMLASINI.EXWriteString('EXInterface', 'EX_width', inttostr(self.Width));
        XMLASINI.EXWriteString('EXApplicaiton', 'EX_Name', Application.ExeName);

      end;

      // Lire tout les sections
      if rbREADALLSEC.Checked then
        XMLASINI.ReadSections(mmo1.Lines);

      // Lire la section EXupdate
      if rbreadexupd.Checked then
      begin
        // Exemple 1

        with XMLASINI do
          for i := 0 to EXSectionitemscount(s) - 1 do
            mmo1.Lines.add(EXItemnamebyindex(s, i) + ' ---> ' +
              EXItemvaluebyindex(s, i));


        // Exemple 2
        {
          XMLASINI.EXReadSection(s,XMLDATA);
          for i := 0 to  XMLDATA.count-1 do
          mmo1.Lines.add( XMLDATA[i]+' ---> ' +XMLASINI.EXReadString(s,XMLDATA[i],''));
        }

      end;

      // Lire les items de la section EXupdate
      if rbREADEXUPITEMS.Checked then
        XMLASINI.EXReadSection(s, mmo1.Lines);

      // Lire les valeurs de la section EXupdate
      if rbREADEXUPVALS.Checked then
        XMLASINI.EXReadSectionValues(s, mmo1.Lines);

      // Supprimer la section EXupdate
      if rbDELEXUPSEC.Checked then
        XMLASINI.EraseSection(s);

      // Supprimer l'item avec l'index (2) dans  la section EXupdate
      if rbEXUPDELITEMBYINDEX.Checked then
        XMLASINI.EXDeleteKeyByindex(s, 2);
      // Supprimer l'item avec le nom (EX_Date) dans  la section EXupdate
      if rbEXUPDDELITMBYNAME.Checked then
        XMLASINI.EXDeleteKeybyname(s, 'EX_Date');

    finally

      XMLDATA.free;
      XMLASINI.Destroy;

      // attention ici vous devez lire le fichier aprés 'XMLASINI.Destroy' ou 'XMLASINI.Save'
      mmo2.Lines.LoadFromFile(FL);

      TREEvXML(tv1, false);
    end;

  end;

  procedure TXMLTESTMAINPAGE.btn2Click(Sender: TObject);

  Var
    XMLASINI: TXMLConfig;
    FL: string;
  begin
    XMLASINI := TXMLConfig.Create;
    FL := XMLASINI.Filename;
    try

      // Enregistrer les paramètres des composants
      if rbSAVECOMPOINFO.Checked then
        XMLASINI.SAVEAPPSCOMPONENTS;

      // Récupérer   les paramètres des composants
      if rbGETAPPSCOMPOINFO.Checked then
        XMLASINI.GETAPPSCOMPONENTS;

      // Convertir Fichier INI vers  Fichier XML
      if rbconvertxmltoini.Checked then
      begin
        if SRC.execute then
          if DEST.execute then
          begin

            XMLASINI.Filename := DEST.Filename + '.xml';
            XMLASINI.INIFILETOXMLFILE(SRC.Filename);
          end;

      end;

    finally
      mmo2.Lines.text := XMLASINI.GetXmlasText;
      XMLASINI.Destroy;

      TREEvXML(tv1, false);
    end;

  end;

  procedure TXMLTESTMAINPAGE.btn3Click(Sender: TObject);
  begin
    if dlgFont2.execute then
      pnl1.font := dlgFont2.font;
  end;

  procedure TXMLTESTMAINPAGE.btn4Click(Sender: TObject);
  Var
    XMLASINI: TXMLConfig;

  begin

    XMLASINI := TXMLConfig.Create;
    try

      XMLASINI.EXWriteFont('EXFont_test', pnl1.name, pnl1.font);

    finally
      XMLASINI.Destroy;
    end;

  end;

  procedure TXMLTESTMAINPAGE.btn5Click(Sender: TObject);
  Var
    XMLASINI: TXMLConfig;

  begin

    XMLASINI := TXMLConfig.Create;
    try

      XMLASINI.EXReadFont('EXFont_test', pnl1.name, pnl1.font);

    finally
      XMLASINI.Destroy;
    end;

  end;

  procedure TXMLTESTMAINPAGE.btn6Click(Sender: TObject);
  Var
    XMLASINI: TXMLConfig;

  begin

    XMLASINI := TXMLConfig.Create;
    try

      pnl2.color := XMLASINI.EXReadcolor('EXcolor_test', pnl2.name, pnl2.color);

    finally
      XMLASINI.Destroy;
    end;

  end;

  procedure TXMLTESTMAINPAGE.btn7Click(Sender: TObject);
  Var
    XMLASINI: TXMLConfig;

  begin

    XMLASINI := TXMLConfig.Create;
    try

      XMLASINI.EXWritecolor('EXcolor_test', pnl2.name, pnl2.color);

    finally
      XMLASINI.Destroy;
    end;

  end;

  procedure TXMLTESTMAINPAGE.btn8Click(Sender: TObject);
  begin

    if dlgColor1.execute then
      pnl2.color := dlgColor1.color;
  end;

end.
