{
  Date:???????
  Author: Wilfried Mestdagh

  by Author
  ///////////////////////////////////////////////////////////////////////////////
  type
  TXMLConfig = class
  private
  FModified: Boolean;
  FFileName: string;
  FXMLDoc: TXMLDocument;
  FBackup: Boolean;
  function GetVersion: string;
  public
  constructor Create(const FileName: string); overload;
  constructor Create; overload;
  destructor Destroy; override;
  procedure Save;
  function ReadString(const Section, Key, default: string): string;
  procedure WriteString(const Section, Key, Value: string);
  function ReadInteger(const Section, Key: string; default: Integer): Integer;
  procedure WriteInteger(const Section, Key: string; Value: Integer);
  function ReadBoolean(const Section, Key: string; default: Boolean): Boolean;
  procedure WriteBoolean(const Section, Key: string; Value: Boolean);
  property Backup: Boolean read FBackup write FBackup;
  property Version: string read GetVersion;
  end;

  /////////////////////////////////////////////////////////////////////////////


  date:2012
  Edited By: daoudzd@gmail.com
  Veuillez m'envoyez les améliorations que vous avez fait à ce source, Merci.

}
unit uCiaXml;

interface

uses
  Forms, SysUtils, classes, Windows, Controls, XmlIntf, XMLDoc,
  TypInfo, inifiles, Graphics;

type
  TXMLConfig = class
  private
    FModified: Boolean;
    FFileName: string;
    FXMLDoc: TXMLDocument;
    FBackup: Boolean;
    function GetVersion: string;
    function GetFilename: string;
    procedure SetFilename(const Filename: string);


  public

    constructor Create(const Filename: string); overload;
    constructor Create; overload;
    destructor Destroy; override;

    property Filename: string read GetFilename write SetFilename;
    property Version: string read GetVersion;
    property Backup: Boolean read FBackup write FBackup;

    function SectionExists(const section: string): Boolean;
    function Sectionscount: integer;
    function GetXmlasText: string;

    procedure Clear;
    procedure Save;
    procedure INIFILETOXMLFILE(INIFILE: string);
    Procedure SAVEAPPSCOMPONENTS;
    Procedure GETAPPSCOMPONENTS;
    Procedure GetXmlasStream(STEARM: TMemoryStream);
    procedure SavetoFile(Filename: string);
    procedure ReadSections(List: tstrings);

    {

      Using Attribute
      <Section_name
      Key_name_1="value"
      Key_name_2="value"
      Key_name_3="value"
      Key_name_4="value"
      />

    }
    function ReadString(const section, Key, default: string): string;
    procedure WriteString(const section, Key, Value: string);
    function ReadInteger(const section, Key: string; default: integer): integer;
    procedure WriteInteger(const section, Key: string; Value: integer);
    function ReadBoolean(const section, Key: string; default: Boolean): Boolean;
    procedure WriteBoolean(const section, Key: string; Value: Boolean);
    function ReadDate(const section, Key: string; default: TDateTime)
      : TDateTime;
    function ReadDateTime(const section, Key: string; default: TDateTime)
      : TDateTime;
    function ReadFloat(const section, Key: string; default: TDateTime): Double;
    function ReadTime(const section, Key: string; default: TDateTime)
      : TDateTime;
    procedure WriteDate(const section, Key: string; Value: TDateTime);
    procedure WriteDateTime(const section, Key: string; Value: TDateTime);
    procedure WriteFloat(const section, Key: string; Value: integer);
    procedure WriteTime(const section, Key: string; Value: TDateTime);
    function Itemvaluebyindex(const section: string; Index: integer): string;
    function Itemnamebyindex(const section: string; Index: integer): string;
    procedure ReadSection(const section: string; List: tstrings);
    procedure ReadSectionValues(const section: string; List: tstrings);
    function Sectionitemscount(const section: string): integer;
    function EraseSection(const section: string): integer;
    function DeleteKeyByindex(const section: string; Index: integer): integer;
    function DeleteKeybyname(const section, Key: string): integer;
    function KEYEXISTS(const section, Key: string): Boolean;
    procedure WriteFont(const section, Key: string; Value: TFont);
    procedure ReadFont(const section, Key: string; Value: TFont);
      procedure Writecolor(const section, Key: string; Value: Tcolor);

    function Readcolor(const section, Key: string; default: Tcolor): Tcolor;

    {

      Using Nodes
      <Section_name>
      <Key name 1> Value </Key name 1>
      <Key name 2> Value </Key name 2>
      <Key name 3> Value </Key name 3>
      <Key name 4> Value </Key name 4>
      </Section_name>

    }

    procedure EXWriteString(const section, Key, Value: string);
    procedure EXWriteInteger(const section, Key: string; Value: integer);
    procedure EXWriteBoolean(const section, Key: string; Value: Boolean);
    function EXReadBoolean(const section, Key: string;
      default: Boolean): Boolean;
    function EXReadInteger(const section, Key: string;
      default: integer): integer;
    function EXReadString(const section, Key, default: string): string;
    function EXKEYEXISTS(const section, Key: string): Boolean;
    procedure EXReadSection(const section: string; List: tstrings);
    function EXSectionitemscount(const section: string): integer;
    function EXItemnamebyindex(const section: string; Index: integer): string;
    function EXItemvaluebyindex(const section: string; Index: integer): string;
    procedure EXReadSectionValues(const section: string; List: tstrings);
    function EXDeleteKeybyname(const section, Key: string): integer;
    function EXDeleteKeyByindex(const section: string; Index: integer): integer;
    function EXReadDate(const section, Key: string; default: TDateTime)
      : TDateTime;
    function EXReadDateTime(const section, Key: string; default: TDateTime)
      : TDateTime;
    function EXReadFloat(const section, Key: string;
      default: TDateTime): Double;
    function EXReadTime(const section, Key: string; default: TDateTime)
      : TDateTime;
    procedure EXWriteDate(const section, Key: string; Value: TDateTime);
    procedure EXWriteDateTime(const section, Key: string; Value: TDateTime);
    procedure EXWriteFloat(const section, Key: string; Value: integer);
    procedure EXWriteTime(const section, Key: string; Value: TDateTime);
    procedure EXReadFont(const section, Key: string; Value: TFont);
    procedure EXWriteFont(const section, Key: string; Value: TFont);
     procedure EXWritecolor(const section, Key: string; Value: Tcolor);
    function EXReadcolor(const section, Key: string; default: Tcolor): Tcolor;
  end;

const
  PRROPERTIES: array [0 .. 3] of string = ('Tag', 'Caption', 'Hint', 'Text');
  FONTSPR: array [0 .. 4] of string = ('Name', 'CharSet', 'Color',
    'Size', 'Style');

implementation

{ TXMLConfig }

constructor TXMLConfig.Create(const Filename: string);
begin
  inherited Create;
  FBackup := false;
  FFileName := Filename;
  FXMLDoc := TXMLDocument.Create(Application);

  FXMLDoc.Options := [doNodeAutoIndent, doNodeAutoCreate, doAutoSave,
    doAttrNull, doAutoPrefix];
  FXMLDoc.ParseOptions :=
    [ { poResolveExternals, poPreserveWhiteSpace, } poAsyncLoad];
  if FileExists(FFileName) then
    FXMLDoc.LoadFromFile(FFileName)
  else
  begin
    FModified := True;
    FXMLDoc.Active := True;
    FXMLDoc.AddChild('Configuration');
  end;
end;

constructor TXMLConfig.Create;
begin
  Create(ChangeFileExt(Application.Exename, '_cfg.xml'));

end;

destructor TXMLConfig.Destroy;
begin
  Save;
  FXMLDoc.Destroy;
  inherited;
end;

function TXMLConfig.GetVersion: string;
begin
  Result := '2.0';
end;

function TXMLConfig.GetFilename: string;
begin
  Result := FFileName;
end;

Procedure TXMLConfig.SetFilename(const Filename: string);
begin
  Clear;
  FFileName := Filename;

end;

function TXMLConfig.ReadBoolean(const section, Key: string;
  default: Boolean): Boolean;
begin
  Result := Boolean(ReadInteger(section, Key, integer(default)));
end;

function TXMLConfig.ReadInteger(const section, Key: string;
  default: integer): integer;
begin
  Result := StrToInt(ReadString(section, Key, IntToStr(default)));
end;

function TXMLConfig.ReadString(const section, Key, default: string): string;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);

  if Assigned(Node) and Node.HasAttribute(Key) then
    Result := Node.Attributes[Key]

  else
    Result := default;

end;

function TXMLConfig.DeleteKeybyname(const section, Key: string): integer;
var
  i, NB: integer;
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  Result := 0;
  if Assigned(Node) then
  begin
    try
      NB := Node.AttributeNodes.Count;
      for i := 0 to NB - 1 do
        if CompareStr(uppercase(Key),
          uppercase(Node.AttributeNodes.Get(i).NodeName)) = 0 then

          Result := Node.AttributeNodes.Delete(i);
      FModified := True;

    except

    end;

  end
  else
    Result := 0;
end;

function TXMLConfig.EXDeleteKeybyname(const section, Key: string): integer;
var
  i, NB: integer;
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  Result := 0;
  if Assigned(Node) then
  begin
    try
      NB := Node.ChildNodes.Count;
      for i := 0 to NB - 1 do
        if CompareStr(uppercase(Key),
          uppercase(Node.ChildNodes.Get(i).NodeName)) = 0 then

          Result := Node.ChildNodes.Delete(i);
      FModified := True;

    except

    end;

  end
  else
    Result := 0;
end;

function TXMLConfig.ReadDate(const section, Key: string; default: TDateTime)
  : TDateTime;
var
  DateStr: string;
begin

  DateStr := ReadString(section, Key, '');

  Result := Default;
  if DateStr <> '' then
    try
      Result := StrToDate(DateStr);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

function TXMLConfig.EXReadDate(const section, Key: string; default: TDateTime)
  : TDateTime;
var
  DateStr: string;
begin

  DateStr := EXReadString(section, Key, '');

  Result := Default;
  if DateStr <> '' then
    try
      Result := StrToDate(DateStr);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

Procedure TXMLConfig.GetXmlasStream(STEARM: TMemoryStream);

begin
  try

    FXMLDoc.SaveToStream(STEARM);
    STEARM.Position := 0;

  finally

  end;

end;

function TXMLConfig.GetXmlasText: string;
begin

  FXMLDoc.SaveToXML(Result);

end;

Procedure TXMLConfig.SavetoFile(Filename: string);
begin

  FXMLDoc.SavetoFile(Filename);

end;

function TXMLConfig.ReadDateTime(const section, Key: string; default: TDateTime)
  : TDateTime;
var
  DateStr: string;
begin

  DateStr := ReadString(section, Key, '');

  Result := Default;
  if DateStr <> '' then
    try
      Result := StrToDateTime(DateStr);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

function TXMLConfig.EXReadDateTime(const section, Key: string;
  default: TDateTime): TDateTime;
var
  DateStr: string;
begin

  DateStr := EXReadString(section, Key, '');

  Result := Default;
  if DateStr <> '' then
    try
      Result := StrToDateTime(DateStr);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

function TXMLConfig.EXReadcolor(const section, Key: string;
  default: Tcolor): Tcolor;
var
  Color: string;
begin

  Color := EXReadString(section, Key, '');

  Result := Default;
  if Color <> '' then
    try
      Result := StringToColor(Color);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

function TXMLConfig.Readcolor(const section, Key: string;
  default: Tcolor): Tcolor;
var
  Color: string;
begin

  Color := ReadString(section, Key, '');

  Result := Default;
  if Color <> '' then
    try
      Result := StringToColor(Color);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

function TXMLConfig.ReadTime(const section, Key: string; default: TDateTime)
  : TDateTime;
var
  DateStr: string;
begin

  DateStr := ReadString(section, Key, '');

  Result := Default;
  if DateStr <> '' then
    try
      Result := StrToTime(DateStr);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

function TXMLConfig.EXReadTime(const section, Key: string; default: TDateTime)
  : TDateTime;
var
  DateStr: string;
begin

  DateStr := EXReadString(section, Key, '');

  Result := Default;
  if DateStr <> '' then
    try
      Result := StrToTime(DateStr);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

function TXMLConfig.ReadFloat(const section, Key: string;
  default: TDateTime): Double;
var
  DateStr: string;
begin

  DateStr := ReadString(section, Key, '');

  Result := Default;
  if DateStr <> '' then
    try
      Result := StrToFloat(DateStr);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

function TXMLConfig.EXReadFloat(const section, Key: string;
  default: TDateTime): Double;
var
  DateStr: string;
begin

  DateStr := EXReadString(section, Key, '');

  Result := Default;
  if DateStr <> '' then
    try
      Result := StrToFloat(DateStr);
    except
      on EConvertError do
        // Ignore EConvertError exceptions
      else
        raise;
    end;
end;

function TXMLConfig.EXReadBoolean(const section, Key: string;
  default: Boolean): Boolean;
begin
  Result := Boolean(EXReadInteger(section, Key, integer(default)));
end;

function TXMLConfig.EXReadInteger(const section, Key: string;
  default: integer): integer;
begin
  Result := StrToInt(EXReadString(section, Key, IntToStr(default)));
end;

function TXMLConfig.EXReadString(const section, Key, default: string): string;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  try
    if (Assigned(Node)) and (Node.ChildValues[Key] <> '') then
      Result := Node.ChildValues[Key]
    else
      Result := default;
  except
    Result := default;
  end;

end;

function TXMLConfig.KEYEXISTS(const section, Key: string): Boolean;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) and Node.HasAttribute(Key) then
    Result := True
  else
    Result := false;
end;

function TXMLConfig.EXKEYEXISTS(const section, Key: string): Boolean;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) and (Node.ChildValues[Key] <> '') then
    Result := True
  else
    Result := false;
end;

function TXMLConfig.SectionExists(const section: string): Boolean;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) then
    Result := True
  else
    Result := false;
end;

function TXMLConfig.Itemnamebyindex(const section: string;
  Index: integer): string;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) then
    Result := Node.AttributeNodes.Get(Index).NodeName
  else
    Result := '';
end;

function TXMLConfig.EXItemnamebyindex(const section: string;
  Index: integer): string;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) then
    Result := Node.ChildNodes.Get(Index).NodeName
  else
    Result := '';
end;

procedure TXMLConfig.Save;
begin
  if not FModified then
    Exit;
  if FBackup then

    CopyFile(PChar(FFileName), PChar(FFileName + '.bak'), false);
  FXMLDoc.SavetoFile(FFileName);
  FModified := false;
end;

procedure TXMLConfig.WriteBoolean(const section, Key: string; Value: Boolean);
begin
  WriteInteger(section, Key, integer(Value));
end;

procedure TXMLConfig.Writecolor(const section, Key: string; Value: Tcolor);
begin
  WriteString(section, Key, ColorToString(Value));
end;

procedure TXMLConfig.EXWritecolor(const section, Key: string; Value: Tcolor);
begin
  EXWriteString(section, Key, ColorToString(Value));
end;

procedure TXMLConfig.WriteInteger(const section, Key: string; Value: integer);
begin
  WriteString(section, Key, IntToStr(Value));
end;

procedure TXMLConfig.WriteDate(const section, Key: string; Value: TDateTime);
begin
  WriteString(section, Key, DateToStr(Value));
end;

procedure TXMLConfig.EXWriteDate(const section, Key: string; Value: TDateTime);
begin
  EXWriteString(section, Key, DateToStr(Value));
end;

procedure TXMLConfig.WriteDateTime(const section, Key: string;
  Value: TDateTime);
begin
  WriteString(section, Key, DateTimeToStr(Value));
end;

procedure TXMLConfig.EXWriteDateTime(const section, Key: string;
  Value: TDateTime);
begin
  EXWriteString(section, Key, DateTimeToStr(Value));
end;

procedure TXMLConfig.WriteFloat(const section, Key: string; Value: integer);
begin
  WriteString(section, Key, FloatToStr(Value));

end;

procedure TXMLConfig.EXWriteFloat(const section, Key: string; Value: integer);
begin
  EXWriteString(section, Key, FloatToStr(Value));

end;

procedure TXMLConfig.WriteTime(const section, Key: string; Value: TDateTime);
begin
  WriteString(section, Key, TimeToStr(Value));

end;

procedure TXMLConfig.WriteFont(const section, Key: string; Value: TFont);
var
  Nkey: string;
begin
  Nkey := Key + '_Font_';
  WriteString(section, Nkey + FONTSPR[0], Value.Name);
  WriteInteger(section, Nkey + FONTSPR[1], Value.CharSet);
  WriteInteger(section, Nkey + FONTSPR[2], Value.Color);
  WriteInteger(section, Nkey + FONTSPR[3], Value.Size);
  WriteInteger(section, Nkey + FONTSPR[4], Byte(Value.Style));

end;

procedure TXMLConfig.ReadFont(const section, Key: string; Value: TFont);
var
  Nkey: string;
begin
  Nkey := Key + '_Font_';
  Value.Name := ReadString(section, Nkey + FONTSPR[0], Value.Name);
  Value.CharSet := TFontCharSet(ReadInteger(section, Nkey + FONTSPR[1],
    Value.CharSet));
  Value.Color := Tcolor(ReadInteger(section, Nkey + FONTSPR[2], Value.Color));
  Value.Size := ReadInteger(section, Nkey + FONTSPR[3], Value.Size);
  Value.Style := TFontStyles(Byte(ReadInteger(section, Nkey + FONTSPR[4],
    Byte(Value.Style))));
end;

procedure TXMLConfig.EXWriteFont(const section, Key: string; Value: TFont);
var
  Nkey: string;
begin
  Nkey := Key + '_Font_';
  EXWriteString(section, Nkey + FONTSPR[0], Value.Name);
  EXWriteInteger(section, Nkey + FONTSPR[1], Value.CharSet);
  EXWriteInteger(section, Nkey + FONTSPR[2], Value.Color);
  EXWriteInteger(section, Nkey + FONTSPR[3], Value.Size);
  EXWriteInteger(section, Nkey + FONTSPR[4], Byte(Value.Style));

end;

procedure TXMLConfig.EXReadFont(const section, Key: string; Value: TFont);
var
  Nkey: string;
begin
  Nkey := Key + '_Font_';
  Value.Name := EXReadString(section, Nkey + FONTSPR[0], Value.Name);
  Value.CharSet := TFontCharSet(EXReadInteger(section, Key + FONTSPR[1],
    Value.CharSet));
  Value.Color := Tcolor(EXReadInteger(section, Nkey + FONTSPR[2], Value.Color));
  Value.Size := EXReadInteger(section, Nkey + FONTSPR[3], Value.Size);
  Value.Style := TFontStyles(Byte(EXReadInteger(section, Nkey + FONTSPR[4],
    Byte(Value.Style))));
end;

procedure TXMLConfig.EXWriteTime(const section, Key: string; Value: TDateTime);
begin
  EXWriteString(section, Key, TimeToStr(Value));

end;

procedure TXMLConfig.WriteString(const section, Key, Value: string);
var
  Node: IXMLNode;
begin
  if ReadString(section, Key, '') = Value then
    Exit;
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if not Assigned(Node) then
    Node := FXMLDoc.DocumentElement.AddChild(section);
  Node.Attributes[Key] := Value;
  FModified := True;
end;

procedure TXMLConfig.EXWriteBoolean(const section, Key: string; Value: Boolean);
begin
  EXWriteInteger(section, Key, integer(Value));
end;

procedure TXMLConfig.EXWriteInteger(const section, Key: string; Value: integer);
begin
  EXWriteString(section, Key, IntToStr(Value));
end;

procedure TXMLConfig.EXWriteString(const section, Key, Value: string);
var
  Node: IXMLNode;
begin
  if EXReadString(section, Key, '') = Value then
    Exit;
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if not Assigned(Node) then
    Node := FXMLDoc.DocumentElement.AddChild(section);
  Node.ChildValues[Key] := Value;
  FModified := True;
end;

// Get number of items
function TXMLConfig.Sectionitemscount(const section: string): integer;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) then
    Result := Node.AttributeNodes.Count
  else
    Result := 0;
end;

function TXMLConfig.EXSectionitemscount(const section: string): integer;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) then
    Result := Node.ChildNodes.Count
  else
    Result := 0;
end;

// Get number of sections
function TXMLConfig.Sectionscount: integer;
begin

  if Assigned(FXMLDoc) then
    Result := FXMLDoc.DocumentElement.ChildNodes.Count
  else
    Result := 0;
end;

// Get list of sections
procedure TXMLConfig.ReadSections(List: tstrings);
var
  i, NB: integer;
  Item: string;
begin
  NB := FXMLDoc.DocumentElement.ChildNodes.Count;
  List.Clear;
  for i := 0 to NB - 1 do
  begin
    Item := FXMLDoc.DocumentElement.ChildNodes.Get(i).LocalName;
    if Item <> '' then
      List.Add(Item);

  end;

end;

// delete all sections
procedure TXMLConfig.Clear;
var
  i, NB: integer;
  Item: string;
begin
  NB := 0;
  NB := FXMLDoc.DocumentElement.ChildNodes.Count;
  for i := 0 to NB - 1 do
  begin

    Item := FXMLDoc.DocumentElement.ChildNodes.Get(i).LocalName;
    if Item <> '' then
      EraseSection(Item);

  end;
  FModified := True;
end;

// delete a section
function TXMLConfig.EraseSection(const section: string): integer;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) then
  begin
    Result := FXMLDoc.DocumentElement.ChildNodes.Remove(Node);
    FModified := True;

  end
  else
    Result := 0;

end;

// Get list of items name
procedure TXMLConfig.ReadSection(const section: string; List: tstrings);
var
  i, NB: integer;
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  List.Clear;
  if Assigned(Node) then
  begin
    NB := Node.AttributeNodes.Count;

    for i := 0 to NB - 1 do
      List.Add(Node.AttributeNodes.Get(i).NodeName);

  end;
end;

procedure TXMLConfig.EXReadSection(const section: string; List: tstrings);
var
  i, NB: integer;
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  List.Clear;
  if Assigned(Node) then
  begin
    NB := Node.ChildNodes.Count;

    for i := 0 to NB - 1 do
      List.Add(Node.ChildNodes.Get(i).NodeName);

  end;
end;

// Get list of items values
procedure TXMLConfig.ReadSectionValues(const section: string; List: tstrings);
var
  i, NB: integer;
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  List.Clear;
  if Assigned(Node) then
  begin
    NB := Node.AttributeNodes.Count;

    for i := 0 to NB - 1 do
      List.Add(Node.AttributeNodes.Get(i).NodeValue);

  end;
end;

procedure TXMLConfig.EXReadSectionValues(const section: string; List: tstrings);
var
  i, NB: integer;
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  List.Clear;
  if Assigned(Node) then
  begin
    NB := Node.ChildNodes.Count;

    for i := 0 to NB - 1 do
      List.Add(Node.ChildNodes.Get(i).NodeValue);

  end;
end;

function TXMLConfig.Itemvaluebyindex(const section: string;
  Index: integer): string;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) then
    Result := Node.AttributeNodes.Get(Index).NodeValue
  else
    Result := '';
end;

function TXMLConfig.EXItemvaluebyindex(const section: string;
  Index: integer): string;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) then
    Result := Node.ChildNodes.Get(Index).NodeValue
  else
    Result := '';
end;

function TXMLConfig.DeleteKeyByindex(const section: string;
  Index: integer): integer;
var
  Node: IXMLNode;
begin
  Result := 0;
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  if Assigned(Node) then
    try

      Result := Node.AttributeNodes.Delete(Index);
      FModified := True;
    except

    end

end;

function TXMLConfig.EXDeleteKeyByindex(const section: string;
  Index: integer): integer;
var
  Node: IXMLNode;
begin
  Node := FXMLDoc.DocumentElement.ChildNodes.FindNode(section);
  Result := 0;
  if Assigned(Node) then

    try

      Result := Node.ChildNodes.Delete(Index);
      FModified := True;
    except

    end

end;



procedure TXMLConfig.INIFILETOXMLFILE(INIFILE: string);
var
  INI: tinifile;
  SECTIONS: tstringlist;
  SECTIONITEMS: tstringlist;
  i, j: integer;
  ITEMVALUE: string;

begin

  SECTIONS := tstringlist.Create;
  SECTIONITEMS := tstringlist.Create;

  INI := tinifile.Create(INIFILE);
  INI.ReadSections(SECTIONS);
  for i := 0 to SECTIONS.Count - 1 do
  begin

    INI.ReadSection(SECTIONS[i], SECTIONITEMS);
    for j := 0 to SECTIONITEMS.Count - 1 do
    begin

      ITEMVALUE := INI.ReadString(SECTIONS[i], SECTIONITEMS[j], ' ');
      EXWriteString(StringReplace(SECTIONS[i], ' ', '_', [rfReplaceAll]),
        StringReplace(SECTIONITEMS[j], ' ', '_', [rfReplaceAll]), ITEMVALUE);
    end;

  end;

  INI.free;
  SECTIONITEMS.free;
  SECTIONS.free;
end;

Procedure TXMLConfig.GETAPPSCOMPONENTS;
  procedure SetComponentProperty(COMPNT: TPersistent;
    const CompProp, PropValue: string);
  var
    C: TPersistent;
    Inf: PPropInfo;
  begin
    C := COMPNT;

    if C <> nil then
    begin
      if IsPublishedProp(COMPNT, CompProp) then
        try
          Inf := GetPropInfo(C.ClassInfo, CompProp);
          SetStrProp(C, Inf, PropValue);
        except

        end;

    end;
  end;

var
  SECTIONNAME, COMPONAME, VAL: string;
  i, k, j: integer;
begin
  for i := 0 to Application.ComponentCount - 1 do
  begin

    if (Application.Components[i] is TForm) then
    begin

      for k := low(PRROPERTIES) to High(PRROPERTIES) do
      begin

        SECTIONNAME := (Application.Components[i] as tcontrol).Name + '_' +
          PRROPERTIES[k];
        COMPONAME := (Application.Components[i] as tcontrol).Name;
        VAL := EXReadString(SECTIONNAME, COMPONAME, '');
        if VAL <> '' then
          SetComponentProperty(Application.Components[i], PRROPERTIES[k], VAL);

        for j := 0 to (Application.Components[i] as TForm).ComponentCount - 1 do
        begin

          COMPONAME := (Application.Components[i] as TForm).Components[j].Name;
          VAL := EXReadString(SECTIONNAME, COMPONAME, '');
          if VAL <> '' then
            SetComponentProperty((Application.Components[i] as TForm)
              .Components[j], PRROPERTIES[k], VAL);

        end;

      end;

    end;

  end;
end;

Procedure TXMLConfig.SAVEAPPSCOMPONENTS;
  function GetComponentProperty(COMPNT: TPersistent;
    const CompProp: string): string;
  var
    C: TPersistent;
    Inf: PPropInfo;
  begin
    Result := '';
    C := COMPNT;

    if C <> nil then
    begin
      if IsPublishedProp(COMPNT, CompProp) then
        try

          Inf := GetPropInfo(C, CompProp);

          Result := GetStrProp(C, Inf);
        except
        end;

    end;

  end;

var
  COMPONAME, SECTIONNAME: string;
  i, j, k: integer;
begin

  for i := 0 to Application.ComponentCount - 1 do
  begin

    if (Application.Components[i] is TForm) then
    begin
      for k := low(PRROPERTIES) to High(PRROPERTIES) do
      begin

        SECTIONNAME := (Application.Components[i] as tcontrol).Name + '_' +
          PRROPERTIES[k];
        if (k = 0) and (GetComponentProperty(Application.Components[i],
          PRROPERTIES[k]) <> '0') then
          EXWriteString(SECTIONNAME, (Application.Components[i] as TForm).Name,
            GetComponentProperty(Application.Components[i], PRROPERTIES[k]));

        for j := 0 to (Application.Components[i] as TForm).ComponentCount - 1 do
        begin
          COMPONAME := GetComponentProperty((Application.Components[i] as TForm)
            .Components[j], 'Name');

          if COMPONAME <> '' then
            if (k = 0) and
              (GetComponentProperty((Application.Components[i] as TForm)
              .Components[j], PRROPERTIES[k]) = '0') then
              continue;

          EXWriteString(SECTIONNAME, COMPONAME,
            GetComponentProperty((Application.Components[i] as TForm)
            .Components[j], PRROPERTIES[k]));

        end;

      end;

    end;

  end;
end;

end.
