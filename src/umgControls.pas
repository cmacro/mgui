unit umgControls;

interface

uses
  Classes, Controls, Messages, Types, Graphics, SysUtils, StdCtrls,
  GR32, GR32_Backends, GR32_Image;


{$define USE_AntiAliased}

type
  TcgCustomIcon = class;

  TFontPos = (fpTopLeft, fpTopCenter, fpTopRight, fpCenterLeft, fpCenterCenter, fpCenterRight, fpBottomLeft, fpBottomCenter, fpBottomRight);
  TcgColorStyle = (csDefault, csHover, csClick, csActive);
  TcgClickIconEvent = procedure (Sender: TObject; AID: Integer) of object;

  TIconScaleMode = (ismAuto,    // 自动缩放
                    ismDefault, // 默认尺寸，不处理
                    ismFit
                    );

  TResourceType = (rtFile, rtRes);


  TmgCustom = class(TCustomControl)
  private
    FDataPrt: Integer;
    FGroupIndex: Integer;

    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWmGetDlgCode); message WM_GETDLGCODE;
  protected
    FBuffer     : TBitmap32;
    FBufferValid: Boolean;
    CenterPT    : TFloatPoint;
    MinWH       : Integer;
    MinRadius   : Integer;
    WidgetRect  : TRect;

    procedure Paint; override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    class function iif<T>(const aValue: Boolean; const aTrue, aFalse: T): T; static; inline;

    procedure Invalidate; override;
    procedure Resize; override;
    procedure PaintControl; virtual;
  published
    property OnClick;
    property Font;
    property Caption;
    property Align;

    property DataPrt: Integer read FDataPrt write FDataPrt; // 挂接数据使用
    property GroupIndex: Integer read FGroupIndex write FGroupIndex;

  end;


  TCGButtonStyle = (cbsDefault, cbsDropDown);


  TcgButton = class(TmgCustom)
  private
    FBorderColor: TColor32;
    FBorderWidth: Integer;
    FButtonColor: TColor32;
    FButtonHover: TColor32;
    FButtonPush: TColor32;
    FCmdID: Integer;
    FCmdName: string;
    FCmdParam: string;
    FInvalidColor: TColor32;
    FMouseInDropDown: boolean;
    FIcon: TBitmap32;

    FButtonStyle: TCGButtonStyle;
    // 下拉菜单样式 cbsDropDown 需要这两个参数
    FDropdownIcon: Integer;
    FDropdownIconChar: string;
    FDropdownSize: Integer;
    FDropdownWidth: Integer;
    FOnClickDropdown: TcgClickIconEvent;
    FDropdownActID: Integer;  // 绘制宽度
    FIconSize: Integer;
    FScaleMode: TIconScaleMode;

    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;


    procedure SetBorderColor(const Value: TColor32);
    procedure SetBorderWidth(const Value: Integer);
    procedure SetButtonColor(const Value: TColor32);
    procedure SetButtonHover(const Value: TColor32);
    procedure SetButtonStyle(const Value: TCGButtonStyle);
    procedure SetDropdownIcon(const Value: Integer);
    procedure SetDropdownSize(const Value: Integer);

  protected
    procedure SetIconSize(const Value: Integer); virtual;
    procedure Click; override;
    procedure DrawUserIcon(dst: TBitmap32; const AName: string; AType: TResourceType);
    procedure LoadImg32FromRes(AImg: TBitmap32; const AName: String);
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadIcon(const AName: string; AType: TResourceType); virtual;
    procedure PaintControl; override;
    property IconSize: Integer read FIconSize write SetIconSize;
    property ScaleMode: TIconScaleMode read FScaleMode write FScaleMode;
  published

    property BorderColor: TColor32 read FBorderColor write SetBorderColor;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
    property ButtonColor: TColor32 read FButtonColor write SetButtonColor;
    property ButtonHover: TColor32 read FButtonHover write SetButtonHover;
    property ButtonPush: TColor32 read FButtonPush write FButtonPush;
    property InvalidColor: TColor32 read FInvalidColor write FInvalidColor;
    property ButtonStyle: TCGButtonStyle read FButtonStyle write SetButtonStyle;
    property DropdownIcon: Integer read FDropdownIcon write SetDropdownIcon;
    property DropdownSize: Integer read FDropdownSize write SetDropdownSize;
    property DropdownWidth: Integer read FDropdownWidth write FDropdownWidth;
    property DropdownActID: Integer read FDropdownActID write FDropdownActID;


    property OnClickDropdown: TcgClickIconEvent read FOnClickDropdown write FOnClickDropdown;
    property OnClick;

    property Font;
    property Caption;
    property Color;
    property CmdID: Integer read FCmdID write FCmdID;
    property CmdName: string read FCmdName write FCmdName;
    property CmdParam: string read FCmdParam write FCmdParam;

  end;

  TcgIconButton = class(TcgButton)
  private
    FIconChar: Char;
    FIconCharSize: Integer;
    FIndexIcon: Integer;
    FIconColor: TColor;
    procedure SetIndexIcon(const Value: Integer);
  protected
    procedure SetIconSize(const Value: Integer); override;

  public
    procedure PaintControl; override;
    constructor Create(AOwner: TComponent); override;
    property IndexIcon: Integer read FIndexIcon write SetIndexIcon;
  end;


  TProgressBarStyle = (pbsDefault, pbsRound);
  TcgProgressBarStaet = (pbsActive, pbsStop);
  TcgProgressBar = class(TmgCustom)
  private
    FBorderWidth: Integer;
    FPadding: TRect;
    FBarSize: Integer;
    FHoverColor: TColor32;
    FValueColor: TColor32;
    FBarColor: TColor32;
    FData: Integer;
    FProgress: Integer;
    FState: TcgProgressBarStaet;
    FStopValueColor: TColor32;
    FBatStyle: TProgressBarStyle;
    FBarWidth: Integer;
    procedure SetBarSize(const Value: Integer);
    procedure SetProgress(const Value: Integer);
    procedure SetState(const Value: TcgProgressBarStaet);
    procedure SetStopValueColor(const Value: TColor32);
    procedure SetValueColor(const Value: TColor32);
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintControl; override;
    property Data: Integer read FData write FData;
    property State: TcgProgressBarStaet read FState write SetState;

  published
    property OnClick;

    property Progress: Integer read FProgress write SetProgress;
    property HoverColor: TColor32 read FHoverColor write FHoverColor;
    property BarColor: TColor32 read FBarColor write FBarColor;
    property BarSize: Integer read FBarSize write SetBarSize;
    property BarWidth: Integer read FBarWidth write FBarWidth;
    property ValueColor: TColor32 read FValueColor write SetValueColor;
    property BatStyle: TProgressBarStyle read FBatStyle write FBatStyle;

    property Caption;
    property Font;
    property Color;
    property StopValueColor: TColor32 read FStopValueColor write SetStopValueColor;
  end;

  TcgSwitchBtn = class(TmgCustom)
  private
    FActive: Boolean;
    FBtnSize: Integer;
    FEnableColor: TColor;
    FDisableColor: TColor;
    procedure SetActive(const Value: Boolean);
    procedure SetBtnSize(const Value: Integer);
  protected
    procedure Click; override;

  public
    procedure PaintControl; override;
    constructor Create(AOwner: TComponent); override;
    property Active: Boolean read FActive write SetActive;
    property BtnSize: Integer read FBtnSize write SetBtnSize;
    property Color;
    property EnableColor: TColor read FEnableColor write FEnableColor;
    property DisableColor: TColor read FDisableColor write FDisableColor;
    property OnClick;
  end;


  TcgCustomIcon = class(TmgCustom)
  private
    FActive: Boolean;
    FActiveColor: TColor32;
    FHoverColor: TColor32;
    FIcon: TBitmap32;
    FIconSize: Integer;
    FPushColor: TColor32;
    FMaskIcon: Boolean;
    FScaleMode: TIconScaleMode;
    procedure SetActive(const Value: Boolean);
  protected
    procedure DrawBoundRound(dst: TBitmap32); virtual;
    procedure DrawUserIcon(dst: TBitmap32; const AName: string; AType: TResourceType);
    procedure LoadImg32FromRes(AImg: TBitmap32; const AName: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadIcon(const AName: string; AType: TResourceType); virtual;
    procedure PaintControl; override;
    property Active: Boolean read FActive write SetActive;
    property IconSize: Integer read FIconSize write FIconSize;
    property MaskIcon: Boolean read FMaskIcon write FMaskIcon;
    property PushColor: TColor32 read FPushColor write FPushColor;
    property HoverColor: TColor32 read FHoverColor write FHoverColor;
    property ActiveColor: TColor32 read FActiveColor write FActiveColor;
    property ScaleMode: TIconScaleMode read FScaleMode write FScaleMode;
  published
    property OnClick;
    property Caption;
    property Color;
  end;

  TcgIcon = class(TcgCustomIcon)
  end;



  //TcgSubActIcon = class()
  TcgProgressIcon = class(TcgCustomIcon)
  private
    FBarColor: TColor32;
    FValueColor: TColor32;
    FBarSize: Integer;
    FPadding: TRect;

    FProgress: Integer;
    procedure SetPadding(const Value: TRect);
    procedure SetProgress(const Value: Integer);
    procedure SetValueColor(const Value: TColor32);
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintControl; override;
    property Progress: Integer read FProgress write SetProgress;
  published
    property BarSize: Integer read FBarSize write FBarSize;

    property BarColor: TColor32 read FBarColor write FBarColor;
    property ValueColor: TColor32 read FValueColor write SetValueColor;
    property Font;
    property Color;
    property Caption;
    property Padding: TRect read FPadding write SetPadding;
  end;

  TcgTabItem = class(TcgProgressIcon)

  private
    FFrameColor: TColor32;
  public
    procedure PaintControl; override;
    constructor Create(AOwner: TComponent); override;
    property FrameColor: TColor32 read FFrameColor write FFrameColor;

  end;

  TcgUserIcon = class(TcgProgressIcon)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TcgStatusBar = class(TmgCustom)
  private
    FBorderColor: TColor32;
    FBorderWidth: Integer;
    FBracketWidth: Integer;
    FGap: Integer;
    FHoverColor: TColor32;
    procedure SetBorderColor(const Value: TColor32);
    procedure SetBracketWidth(const Value: Integer);
    procedure WMLMouseDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
  protected
    Bracket_Left : TRect;
    Bracket_Right : TRect;
    Bracket_Footer : TRect;
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintControl; override;
    procedure Resize; override;
    property BorderColor: TColor32 read FBorderColor write SetBorderColor;
    property BracketWidth: Integer read FBracketWidth write SetBracketWidth;
    property Gap: Integer read FGap write FGap;
  published
    property Caption;
    property OnClick;
    property Font;
    property Color;
    property HoverColor: TColor32 read FHoverColor write FHoverColor;
  end;

  TPngImg = class(TImage32)
  private
    FDataPrt: Integer;
    FThroughClick: Boolean;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;

    property DataPrt: Integer read FDataPrt write FDataPrt;
    property ThroughClick: Boolean read FThroughClick write FThroughClick;
  end;




  TcgList = class(TCustomListBox)

  end;


function LoadIconResourceFont: Boolean;
procedure RemoveIconResourceFont;


const
  STYELICON_DROPDOWN = 1;   // 870f
  SIconFontName = 'FontAwesome';
  IconIdx_Search = 1;       // fa-search
  IconIdx_CommentDots = 2;  // fa-comment-dots
  IconIdx_EllipsisV = 3;    // ellipsis-v

  FONTIconCnt = 4;

function IconIdxToFontAwesome(idx: Integer): Char;
function IconNameToIndex(const AName: string): integer;


implementation

uses
  Math, Windows, GR32_Polygons, GR32_VectorUtils, GR32_Resamplers,
  GR32_Filters,
  pngimage, GR32_Png, GR32_PortableNetworkGraphic, jpeg, ListActns, ActnList;



type
  TRenderHelper = class helper for TPolygonRenderer32VPR
  public
    function ArrayOfFloat(Values: array of TFloat): TArrayOfFloat;
    function VRectangle(const ACenter: TFloatPoint; AW, AH: Single): TArrayOfFloatPoint; overload;
    function VRectangle(const AR: TRect): TArrayOfFloatPoint; overload;
    function VLineFrame(const ACenter: TFloatPoint; AW, AH, ASize: Single; AStyle:
        TPenStyle = psSolid): TArrayOfArrayOfFloatPoint; overload;
    function  VRoundRect(const ACenter: TFloatPoint; W, H: Single; ARadius: Single = 8): TArrayOfFloatPoint;
    procedure DrawPolygon(AColor: TColor32; const APoints: TArrayOfArrayOfFloatPoint); overload;
    procedure DrawPolygon(AColor: TColor32; const APoints: TArrayOfFloatPoint); overload;
    procedure DrawText(X, Y: Integer; const s: String; AFont: TFont; AFontPos: TFontPos = fpCenterCenter; AAntiAliased: Boolean = False); overload;
    procedure DrawText(X, Y: Integer; const s: String; AColor: TColor = cldefault; AFontSize: Integer = 0; const AFontName: String = ''; AFontPos: TFontPos = fpCenterCenter; AFontStyle: TFontStyles = []; AntiAliased: Boolean = False); overload;
    procedure DrawText(const r: TRect; const s: String; AColor: TColor = cldefault; AFontSize: Integer = 0; const AFontName: String = ''; AFontPos: TFontPos = fpCenterCenter; AFontStyle: TFontStyles = []; AntiAliased: Boolean = False); overload;
    procedure DrawText(const ARect: TRect; const s: String; AFont: TFont; AFontPos: TFontPos = fpCenterCenter; AAntiAliased: Boolean = False); overload;
  end;

const
  SFONTNAME_ICON = 'fontawesome';
  ANTIALIAS_TEXTLEVEL = 5; // 字符抗拒锯齿

var
  hIconFont: THandle = 0;


function IconIdxToFontAwesome(idx: Integer): Char;
const
  FONTChars: array [0..FONTIconCnt] of char = (
    #$f06c,
    #$f002,  // IconIdx_Search
    #$f27b,  // IconIdx_CommentDots
    #$f142,  // IconIdx_EllipsisV
    #$f06c
    );

begin
  if (idx >= 0) and (idx <= FONTIconCnt) then
    Result := FONTChars[idx]
  else
    Result := FONTChars[0];
end;

function IconNameToIndex(const AName: string): integer;
begin
  if sameText(AName, 'Search') then Result := IconIdx_Search
  else if sameText(AName, 'CommentDots') then Result := IconIdx_CommentDots
  else if sameText(AName, 'EllipsisV') then Result := IconIdx_EllipsisV
  else result := 0
//
//    IconIdx_Search = 1;       // fa-search
//  IconIdx_CommentDots = 2;  // fa-comment-dots
//  IconIdx_EllipsisV = 3;    // ellipsis-v
end;


function LoadIconResourceFont: Boolean;
var
  iRes: THandle;
  iSize: Cardinal;
  hIns: THandle;
  hMem: HGLOBAL;
  pFontData: Pointer;
begin
  hIns := HInstance;
  iRes := FindResource(hIns, PChar(SFONTNAME_ICON), RT_RCDATA);
  iSize := 0; if iRes <> 0 then iSize := SizeofResource(hIns, iRes);
  hMem := 0; if iSize > 0 then hMem := LoadResource(hIns, iRes);

  if hMem <> 0 then
  begin
    pFontData := LockResource(hMem);
    if assigned(pFontData) then
      hIconFont := AddFontMemResourceEx(pFontData, iSize, nil, @hIconFont);
  end;
  Result := hIconFont <> 0;
end;

procedure RemoveIconResourceFont;
begin
  if hIconFont <> 0 then
  begin
    RemoveFontMemResourceEx(hIconFont);
    hIconFont := 0;
  end;
end;



function GetFontIcon(const AIdx: Integer): Char;
begin
  case AIdx of
    STYELICON_DROPDOWN: Result := #$F078;
    else Result := ' ';
  end;
end;


function TRenderHelper.ArrayOfFloat(Values: array of TFloat): TArrayOfFloat;
var
  Index: Integer;
begin
  SetLength(Result, Length(Values));
  for Index := Low(Values) to High(Values) do Result[Index] := Values[Index];
end;

function TRenderHelper.VRectangle(const ACenter: TFloatPoint; AW, AH: Single):
    TArrayOfFloatPoint;
var
  R: TFloatRect;
begin
  R.Left   := ACenter.X - (AW * 0.5);
  R.Right  := ACenter.X + (AW * 0.5);
  R.Top    := ACenter.Y - (AH * 0.5);
  R.Bottom := ACenter.Y + (AH * 0.5);
  Result := Rectangle(R);
end;

function TRenderHelper.VRectangle(const AR: TRect): TArrayOfFloatPoint;
var
  R: TFloatRect;
begin
  R.Left   := AR.Left;
  R.Right  := AR.Right;
  R.Top    := AR.Top;;
  R.Bottom := AR.Bottom;;
  Result := Rectangle(R);
end;

function TRenderHelper.VLineFrame(const ACenter: TFloatPoint; AW, AH, ASize:
    Single; AStyle: TPenStyle = psSolid): TArrayOfArrayOfFloatPoint;
var
  X, Y, W, H, Z: Single;
  pts: TArrayOfFloatPoint;
  Dash, Dot: Single;
begin
  if (ASize < 1) or (AW < 1) or (AH < 1) then
  begin
    SetLength(Result, 0);
    Exit;
  end;
  X := ACenter.X - (AW  * 0.5) + (ASize * 0.5);
  Y := ACenter.Y - (AH * 0.5) + (ASize * 0.5);;
  W := AW - ASize;
  H := AH - ASize;
  SetLength(pts, 5);
  pts[0] := FloatPoint(X, Y);
  pts[1] := FloatPoint(X + W, Y);
  pts[2] := FloatPoint(X + W, Y + H);
  pts[3] := FloatPoint(X, Y + H);
  pts[4] := FloatPoint(X, Y);
  Z := ASize;
  Dash := Z * 3;
  Dot  := Z * 1;
  case AStyle of
    psClear       : SetLength(Result, 0);
    psSolid       : Result := BuildPolyPolyline(BuildDashedLine(pts, ArrayOfFloat([Dash                             ])), False, ASize, jsRound, esRound); // BuildPolyline(pts, ASize, jsRound, esRound);
    psDash        : Result := BuildPolyPolyline(BuildDashedLine(pts, ArrayOfFloat([Dash, Dash                       ])), False, ASize, jsRound, esRound);
    psDot         : Result := BuildPolyPolyline(BuildDashedLine(pts, ArrayOfFloat([Dot , Dash                       ])), False, ASize, jsRound, esRound);
    psDashDot     : Result := BuildPolyPolyline(BuildDashedLine(pts, ArrayOfFloat([Dash, Dash, Dot, Dash            ])), False, ASize, jsRound, esRound);
    psDashDotDot  : Result := BuildPolyPolyline(BuildDashedLine(pts, ArrayOfFloat([Dash, Dash, Dot, Dash, Dot, Dash ])), False, ASize, jsRound, esRound);
    psInsideFrame : Result := BuildPolyPolyline(BuildDashedLine(pts, ArrayOfFloat([Dash                             ])), False, ASize, jsRound, esRound); // BuildPolyline(pts, ASize, jsBevel, esSquare);
    psUserStyle   : SetLength(Result, 0);
    psAlternate   : SetLength(Result, 0);
  end;
end;

{ TRenderHelper }

procedure TRenderHelper.DrawPolygon(AColor: TColor32; const APoints:
    TArrayOfArrayOfFloatPoint);
begin
  Color := AColor;
  PolyPolygonFS(APoints, FloatRect(Self.Bitmap.ClipRect));
end;

procedure TRenderHelper.DrawPolygon(AColor: TColor32; const APoints: TArrayOfFloatPoint);
begin
  Color := AColor;
  PolyPolygonFS(PolyPolygon(APoints), FloatRect(Self.Bitmap.ClipRect));
end;

function TRenderHelper.VRoundRect(const ACenter: TFloatPoint; W, H: Single; ARadius: Single
    = 8): TArrayOfFloatPoint;
var
  fr: TFloatRect;
begin
  fr.Left   := ACenter.X - (W * 0.5);
  fr.Right  := ACenter.X + (W * 0.5);
  fr.Top    := ACenter.Y - (H * 0.5);
  fr.Bottom := ACenter.Y + (H * 0.5);
  Result := RoundRect(fr, ARadius);
end;

procedure TRenderHelper.DrawText(const r: TRect; const s: String; AColor:
    TColor = cldefault; AFontSize: Integer = 0; const AFontName: String = '';
    AFontPos: TFontPos = fpCenterCenter; AFontStyle: TFontStyles = [];
    AntiAliased: Boolean = False);
var
  RX, RY, RW, RH, RW2, RH2: Integer;
  TX, TY, TW, TH, TW2, TH2: Integer;
  cBitmap: TBitmap32;
begin
  cBitmap := Self.Bitmap as TBitmap32;
  with cBitmap do
  begin
    //if (AColor <> 0)      then
    Font.Color := AColor;
    if (AFontSize <> 0)   then Font.Size := AFontSize;
    if (AFontName <> '')  then Font.Name := AFontName;
    Font.Style := AFontStyle;

    RX := r.Left;
    RY := r.Top;
    RW := r.Right;         RW2 := (RW div 2) + (RX div 2);
    RH := r.Bottom;        RH2 := (RH div 2) + (RY div 2);

    TX := 0;
    TY := 0;
    TW := TextWidth(s);  TW2 := (TW div 2);
    TH := TextHeight(s); TH2 := (TH div 2);

    case AFontPos of
      fpTopLeft      : begin TX := RX       ; TY := RY       ; end;
      fpTopCenter    : begin TX := RW2 - TW2; TY := RY       ; end;
      fpTopRight     : begin TX := RW  - TW ; TY := RY       ; end;

      fpCenterLeft   : begin TX := RX       ; TY := RH2 - TH2; end;
      fpCenterCenter : begin TX := RW2 - TW2; TY := RH2 - TH2; end;
      fpCenterRight  : begin TX := RW  - TW ; TY := RH2 - TH2; end;

      fpBottomLeft   : begin TX := RX       ; TY := RH  - TH ; end;
      fpBottomCenter : begin TX := RW2 - TW2; TY := RH  - TH ; end;
      fpBottomRight  : begin TX := RW  - TW ; TY := RH  - TH ; end;
    end;

    {$ifdef USE_AntiAliased}
    if AntiAliased then RenderText(TX, TY, s, ANTIALIAS_TEXTLEVEL, Color32(AColor) )
    else TextOut(TX, TY, s);
    {$else}
    TextOut(TX, TY, s);
    {$endif}
  end;
end;

procedure TRenderHelper.DrawText(X, Y: Integer; const s: String; AFont: TFont;
    AFontPos: TFontPos = fpCenterCenter; AAntiAliased: Boolean = False);
begin
  DrawText(X, Y, s, AFont.Color, AFont.Size, AFont.Name, AFontPos, AFont.Style, AAntiAliased);
end;

procedure TRenderHelper.DrawText(X, Y: Integer; const s: String;
    AColor: TColor = cldefault; AFontSize: Integer = 0; const AFontName: String = '';
    AFontPos: TFontPos = fpCenterCenter; AFontStyle: TFontStyles = [];
    AntiAliased: Boolean = False);
var
  w, h, w2, h2: Integer;
  Q: Integer;
  R: Integer;
  cBitmap: TBitmap32;
begin
  cBitmap := Self.Bitmap as TBitmap32;
  with cBitmap do
  begin
    //if (AColor <> 0)      then
    Font.Color := AColor;
    if (AFontSize <> 0)   then Font.Size := AFontSize;
    if (AFontName <> '')  then Font.Name := AFontName;
    Font.Style := AFontStyle;
    Q := 0;
    R := 0;
    w := TextWidth(s);  w2 := (w div 2);
    h := TextHeight(s); h2 := (h div 2);
    case AFontPos of
      fpTopLeft      : begin Q := X - w  ; R := Y - h  ; end; // ok
      fpTopCenter    : begin Q := X - w2 ; R := Y - h  ; end; // ok
      fpTopRight     : begin Q := X      ; R := Y - h  ; end; // ok
      fpCenterLeft   : begin Q := X - w  ; R := Y - h2 ; end; // ok
      fpCenterCenter : begin Q := X - w2 ; R := Y - h2 ; end; // ok
      fpCenterRight  : begin Q := X      ; R := Y - h2 ; end; // ok
      fpBottomLeft   : begin Q := X - w  ; R := Y      ; end; // ok
      fpBottomCenter : begin Q := X - w2 ; R := Y      ; end; // ok
      fpBottomRight  : begin Q := X      ; R := Y      ; end; // ok
    end;

    {$ifdef USE_AntiAliased}
    if AntiAliased then RenderText(Q, R, s, ANTIALIAS_TEXTLEVEL, Color32(AColor))
    else TextOut(Q, R, s);
    {$else}
    TextOut(Q, R, s);
    {$endif}
  end;
end;

procedure TRenderHelper.DrawText(const ARect: TRect; const s: String; AFont:
    TFont; AFontPos: TFontPos = fpCenterCenter; AAntiAliased: Boolean = False);
begin
  DrawText(ARect, s, AFont.Color, AFont.Size, AFont.Name, AFontPos, AFont.Style, AAntiAliased);
end;


{ TmgCustom }

constructor TmgCustom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle  := ControlStyle + [csOpaque];
  FBuffer       := TBitmap32.Create;
end;

destructor TmgCustom.Destroy;
begin
  FBuffer.Free;
  inherited Destroy;
end;

procedure TmgCustom.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

class function TmgCustom.iif<T>(const aValue: Boolean; const aTrue, aFalse: T): T;
begin
  Result := AFalse;
  if AValue then Exit(ATrue);
end;

procedure TmgCustom.Invalidate;
begin
  FBufferValid := False;
  inherited;
end;

procedure TmgCustom.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TmgCustom.WMGetDlgCode(var Message: TWmGetDlgCode);
begin
  with Message do Result := Result or DLGC_WANTARROWS;
end;

procedure TmgCustom.WndProc(var Message: TMessage);
begin
  inherited;
  case message.Msg of
    CM_MOUSEENTER: Invalidate;
    CM_MOUSELEAVE: Invalidate;
    WM_LBUTTONDOWN: Invalidate;
    WM_LBUTTONUP: Invalidate;
  end;
end;

procedure TmgCustom.Paint;
begin
  if not Assigned(Parent) then Exit;

  if not FBufferValid then
  begin
     (FBuffer.Backend as IPaintSupport).ImageNeeded;
      PaintControl;
     (FBuffer.Backend as IPaintSupport).CheckPixmap;
      FBufferValid := True;
  end;

  FBuffer.Lock;
  try
    (FBuffer.Backend as IDeviceContextSupport).DrawTo(Canvas.Handle, 0, 0);
  finally
    FBuffer.Unlock;
  end;
end;

procedure TmgCustom.PaintControl;
begin
end;

procedure TmgCustom.Resize;
begin
  inherited;
  MinWH := Min(Width, Height);
  MinRadius := MinWH div 2;
  CenterPT.X := Width  * 0.5;
  CenterPT.Y := Height * 0.5;
  FBufferValid := False;
  FBuffer.SetSize(Width, Height);
  WidgetRect.Top := 0;
  WidgetRect.Left := 0;
  WidgetRect.Right := Width;
  WidgetRect.Bottom := Height;
end;

constructor TcgButton.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csCaptureMouse];
  FInvalidColor := clLightGray32;
  FButtonColor := $FF00BFA4;
  FButtonHover := $FF00d3b5;
  FButtonPush :=  $FF00aa92;
  FBorderWidth := 1;
  FBorderColor := clGray32;

  FButtonStyle := cbsDefault;
  // 下拉菜单样式 cbsDropDown 需要这两个参数
  FDropdownIcon  := -1;
  FDropdownSize  := 0;       //  图标大小 0 -- 同字体大小 max（cx, cy）
  FDropdownWidth := 24;
  FDropdownActID := 0;
end;

procedure TcgButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  bInDropDown: boolean;
begin
  inherited;
  bInDropDown := (FButtonStyle = cbsDropDown) and
                  (x > ClientWidth - FDropdownWidth);
  if bInDropDown <> FMouseInDropDown then
  begin
    FMouseInDropDown := bInDropDown;
    invalidate;
  end;
end;

procedure TcgButton.Click;
begin
  if FMouseInDropDown then
  begin
    if assigned(FOnClickDropdown) then
      FOnClickDropdown(Self, FDropdownActID);
  end
  else
    inherited;
end;

procedure TcgButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TcgButton.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then Click;
end;

procedure TcgButton.DrawUserIcon(dst: TBitmap32; const AName: string; AType:
    TResourceType);
  function IsPng: Boolean;
  begin
    Result := SameText(ExtractFileExt(AName), '.png');
  end;
  procedure LoadFromFile(ABmp: TBitmap32);
  begin
    if IsPng then
    begin
      LoadBitmap32FromPNG(ABmp, AName);
      TDraftResampler.Create(ABmp);
    end
    else
    begin
      ABmp.LoadFromFile(AName);
      TLinearResampler.Create(ABmp);
    end;
  end;
var
  bmp: TBitmap32;
  s: Integer;
  w,h, x, y: Integer;
  z: Extended;
  rDst: TRect;
  iScale: TIconScaleMode;
begin
  s := min(dst.Width, dst.Height);
  bmp := TBitmap32.Create;
  try
    case AType of
      rtFile  : LoadFromFile(bmp);
      rtRes   :
      begin
        LoadImg32FromRes(bmp, AName);
        TDraftResampler.Create(bmp);
      end;
    end;

    iScale := ScaleMode;
    if iScale = ismFit then
      iScale := iif((bmp.Width > dst.Width) or (bmp.Height > dst.Height), ismAuto, ismDefault);

    if iScale = ismDefault then
    begin
      x := iif((dst.Width - bmp.Width) > 0, integer((dst.Width - bmp.Width) div 2), integer(0));
      y := iif((dst.Height - bmp.Height) > 0, integer((dst.Height - bmp.Height) div 2), integer(0));
      bmp.DrawTo(dst, x, y);
    end
    else
    begin
      z := s / Max(Bmp.Width, Bmp.Height);
      w := Trunc(bmp.Width * z);
      h := Trunc(bmp.Height * z);

      rDst := Rect(Trunc((s-W)/2),Trunc((s-H)/2), Trunc((s-W)/2)+W,Trunc((s-H)/2)+H);
      dst.Draw(rDst, bmp.BoundsRect, bmp);
    end;


  finally
    bmp.Free;
  end;
end;

procedure TcgButton.LoadIcon(const AName: string; AType: TResourceType);
var
  cIcon: TBitmap32;
begin
  cIcon := FIcon;
  cIcon.DrawMode := dmBlend;
  cIcon.Clear(clWhite32);
  cIcon.SetSize(FIconSize, FIconSize);
  DrawUserIcon(cIcon, AName, AType);
  //if FMaskIcon then DrawBoundRound(cIcon);
  Invalidate;
end;

procedure TcgButton.LoadImg32FromRes(AImg: TBitmap32; const AName: String);
var
  cResSrc: TStream;
begin
  cResSrc := TResourceStream.Create(Hinstance, AName, RT_RCDATA);
  try
    with TPortableNetworkGraphic32.Create do
    try
      LoadFromStream(cResSrc);
      AssignTo(AImg);
    finally
      Free;
    end;
  finally
    cResSrc.Free;
  end;
end;

procedure TcgButton.PaintControl;
var
  cRender : TPolygonRenderer32VPR;
  iBtnBk : TColor32;
  iBorderWidth: Integer;
  idw, ids: Integer;
  rTxt, rc, rd: TRect;
  iDBK: TColor32;
begin
  Resize;
  cRender := TPolygonRenderer32VPR.Create;
  cRender.Filler   := nil;
  cRender.FillMode := pfWinding;
  cRender.Bitmap   := Self.FBuffer;
  cRender.Bitmap.Clear(Color32(Color));

  iBorderWidth := BorderWidth;

  if Enabled then
  begin
    iBtnBk := FButtonColor;
    iDBK := iBtnBk;
    if MouseInClient then
    begin
      if  not FMouseInDropDown then
      begin
        if MouseCapture then iBtnBk := FButtonPush
        else if MouseInClient then iBtnBk :=  FButtonHover;
      end
      else
      begin
        if MouseCapture then iDBK := FButtonPush
        else if MouseInClient then iDBK :=  FButtonHover;
      end;
    end;
  end
  else
  begin
    iBtnBk := FInvalidColor;
    iDBK := iBtnBk;
  end;

  idw := 0; if (FButtonStyle = cbsDropDown) and (FDropdownIcon >= 0) then idw := FDropdownWidth;
  rc := ClientRect;
  rTxt := rc;
  rTxt.Right := rTxt.Right - idw;

  if iBorderWidth > 0 then
    cRender.DrawPolygon(FBorderColor, cRender.VRoundRect(CenterPT, Width, Height, 5));
  cRender.DrawPolygon(iBtnBk, cRender.VRoundRect(CenterPT, Width - iBorderWidth, Height - iBorderWidth, 5));
  cRender.DrawText(rTxt, Caption, Font, fpCenterCenter);

  if idw > 0 then
  begin
    rd := rc;
    rd.Left := rTxt.Right;
    InflateRect(rd, -1, -1);

    cRender.DrawPolygon(iDBK, RoundRect(FloatRect(rd), 4));
    ids := FDropdownSize; if ids <= 0 then ids := Font.Size;
    cRender.DrawText(rd, FDropdownIconChar, Font.Color, ids, SFONTNAME_ICON, fpCenterCenter);
  end;

  cRender.Free;
end;

procedure TcgButton.SetBorderColor(const Value: TColor32);
begin
  FBorderColor := Value;
end;

procedure TcgButton.SetBorderWidth(const Value: Integer);
begin
  FBorderWidth := Value;
end;

procedure TcgButton.SetButtonColor(const Value: TColor32);
begin
  FButtonColor := Value; Invalidate;
end;

procedure TcgButton.SetButtonHover(const Value: TColor32);
begin
  FButtonHover := Value; Invalidate;
end;

procedure TcgButton.SetButtonStyle(const Value: TCGButtonStyle);
begin
  FButtonStyle := Value; Invalidate;
end;

procedure TcgButton.SetDropdownIcon(const Value: Integer);
begin
  FDropdownIcon := Value;
  FDropdownIconChar := GetFontIcon(FDropdownIcon);
  Invalidate;
end;

procedure TcgButton.SetDropdownSize(const Value: Integer);
begin
  FDropdownSize := Value; Invalidate;
end;

procedure TcgButton.SetIconSize(const Value: Integer);
begin
  FIconSize := Value;
end;

{ TcgProgressBar }

constructor TcgProgressBar.Create(AOwner: TComponent);
begin
  inherited;
  FBorderWidth      := 0;
  FHoverColor       := $FFfcfefe;
  FBarColor         := $FFE0D4CA;
  FValueColor       := $FF5233DC;
  FStopValueColor   := clGray32;
  Color := clWhite;
  Font.Color :=  $303030;
  Font.Size := 9;
  FBarSize := 8;
  FPadding := Rect(8, 8, 8, 8);
end;

procedure TcgProgressBar.PaintControl;
var
  iBW, TH, w,h: Integer;
  PL, PT, PR, PB  : Integer;
  iBarWidth, iBarHeight          : Single;
  TR              : TRect;
  dRate            : Single;
  FR, MR          : TFloatPoint;
  cReader          : TPolygonRenderer32VPR;
  iValColor: TColor32;
  s: string;
begin
  cReader          := TPolygonRenderer32VPR.Create;
  cReader.Filler   := nil;
  cReader.FillMode := pfWinding;
  cReader.Bitmap   := Self.FBuffer;

  if MouseInClient then cReader.Bitmap.Clear(FHoverColor)
  else cReader.Bitmap.Clear(Color32(Color));

  w := ClientWidth;
  h := ClientHeight;
  MR := CenterPT;
  FR := CenterPT;
  PL := FPadding.Left;
  PT := FPadding.Top;
  PR := FPadding.Right;
  PB := FPadding.Bottom;
  iBW:= FBorderWidth;

  TH := h - (iBW*2) - PT - PB - FBarSize;
  TR := Rect  (PL, PT , w - PL - PR - (iBW * 2) , TH );
  iBarHeight := FBarSize;
  if FBarWidth <= 1 then iBarWidth := w - PL - PR - (iBW*2)
  else iBarWidth := Min(FBarWidth, w - PL - PR - (iBW*2));

  FR.X := w * 0.5;
  FR.Y := iBW + PT + TH + (iBarHeight / 2);

  dRate := (Progress * iBarWidth) / 100;
  MR.X := (dRate / 2) + iBW + PL + 1;

  cReader.DrawPolygon(Color32(Color), cReader.VLineFrame(CenterPT, w, h, iBW));

  MR.Y := FR.Y;

  case BatStyle of
    pbsDefault:
    begin
      cReader.DrawPolygon( FBarColor, cReader.VRectangle( FR, iBarWidth, iBarHeight));
      iValColor := iif(State = pbsActive, FValueColor, FStopValueColor);
      cReader.DrawPolygon(iValColor,  cReader.VRectangle( MR, dRate, iBarHeight));
    end;
    pbsRound:
    begin
      cReader.DrawPolygon( FBarColor, cReader.VRoundRect( FR, iBarWidth, iBarHeight, 4));
      iValColor := iif(State = pbsActive, FValueColor, FStopValueColor);
      cReader.DrawPolygon(iValColor,  cReader.VRoundRect( MR, dRate, iBarHeight, 4));
    end;
  end;

  s := iif(State = pbsActive, string(Caption), '(Stop)'+ Caption);
  cReader.DrawText( TR, s, Font.Color, Font.Size, Font.Name, fpTopLeft, Font.Style);
  cReader.Free;
end;

procedure TcgProgressBar.SetBarSize(const Value: Integer);
begin
  FBarSize := Value; Invalidate;
end;

procedure TcgProgressBar.SetProgress(const Value: Integer);
begin
  FProgress := Value; Invalidate;
end;

procedure TcgProgressBar.SetState(const Value: TcgProgressBarStaet);
begin
  FState := Value; Invalidate;
end;

procedure TcgProgressBar.SetStopValueColor(const Value: TColor32);
begin
  FStopValueColor := Value;
end;

procedure TcgProgressBar.SetValueColor(const Value: TColor32);
begin
  FValueColor := Value;
end;

constructor TcgProgressIcon.Create(AOwner: TComponent);
begin
  inherited;
  Color := $EBE8E3;
  FBarColor     := $FFE0D4CA;
  FValueColor   := $FF5233DC;
  Font.Color    := $303030;
  FPadding      := Rect(5, 0, 5, 0);
  Font.Size     := 9;
  FBarSize      := 2;
end;

procedure TcgProgressIcon.PaintControl;
var
  cReader: TPolygonRenderer32VPR;
  rF, rM, ptI: TFloatPoint;
  rT: TRect;
  dRate: Single;
  w, h: Integer;
begin
  cReader := TPolygonRenderer32VPR.Create;
  cReader.Filler := nil;
  cReader.FillMode := pfWinding;
  cReader.Bitmap := Self.FBuffer;

  if MouseInClient then cReader.Bitmap.Clear(FHoverColor)
  else if Active then cReader.Bitmap.Clear(FActiveColor)
  else cReader.Bitmap.Clear(Color32(Color));

  w := ClientWidth;
  h := ClientHeight;

  //   IconSize
  ptI := CenterPT;
  ptI.X := FPadding.Left;
  rT := Rect(Round(ptI.X + IconSize) + 2 , FPadding.Top, w, h - FPadding.Bottom);

  FIcon.DrawTo(cReader.Bitmap, Round(ptI.X), Round(ptI.Y - IconSize / 2) );
  cReader.DrawText(rT, Caption, Font.Color, Font.Size, Font.Name, fpCenterLeft, Font.Style);

  // 绘制执行进度
  if (BarSize > 0) and (FProgress > 0) and (FProgress < 100) then
  begin
    rF := CenterPT;
    rF.X := w * 0.5;
    rF.Y := h - BarSize / 2;
    dRate := (Progress * w) / 100;
    rM.X := (dRate / 2) + 1;
    rM.Y := rF.Y;
    cReader.DrawPolygon(FBarColor,    cReader.VRectangle(rF, w, BarSize));
    cReader.DrawPolygon(FValueColor,  cReader.VRectangle(rM, dRate, BarSize));
  end;

  cReader.Free;
end;

procedure TcgProgressIcon.SetPadding(const Value: TRect);
begin
  FPadding := Value;
end;

procedure TcgProgressIcon.SetProgress(const Value: Integer);
begin
  FProgress := Value; Invalidate;
end;

procedure TcgProgressIcon.SetValueColor(const Value: TColor32);
begin
  FValueColor := Value;
end;

constructor TcgCustomIcon.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csCaptureMouse];

  FMaskIcon := False;
  Width := 50;
  Height := 50;
  FActiveColor  := clWhite32;// Color32($FFFFFF);
  FHoverColor   := $FFF6F8F9;// Color32($F9F8F6); //$FFfcfefe;
  FPushColor    := $FFE3E8EB;  //$FFF6F8F9;
  FIconSize     := 40;

  FIcon:= TBitmap32.Create(FIconSize, FIconSize);
end;

destructor TcgCustomIcon.Destroy;
begin
  FIcon.Free;
  inherited;
end;

procedure TcgCustomIcon.DrawBoundRound(dst: TBitmap32);
var
  cMask: TBitmap32;
  s: Integer;
  Polys: TArrayOfArrayOfFloatPoint;
begin
  cMask := TBitmap32.Create(dst.Width, dst.Height);
  try
    cMask.Clear(clBlack32);
    s := Min(cMask.Width, cMask.Height) div 2 - 2;  //Min(cMask.Width, cMask.Height) div 2;
    Polys := PolyPolygon(Ellipse(FloatPoint(cMask.Width / 2, cMask.Height/2), FloatPoint(s,s)));
    PolyPolygonFS(cMask, Polys, clWhite32);
    IntensityToAlpha(dst, cMask);
  finally
    cMask.Free;
  end;
end;

procedure TcgCustomIcon.DrawUserIcon(dst: TBitmap32; const AName: string; AType: TResourceType);
  function IsPng: Boolean;
  begin
    Result := SameText(ExtractFileExt(AName), '.png');
  end;
  procedure LoadFromFile(ABmp: TBitmap32);
  begin
    if IsPng then
    begin
      LoadBitmap32FromPNG(ABmp, AName);
      TDraftResampler.Create(ABmp);
    end
    else
    begin
      ABmp.LoadFromFile(AName);
      TLinearResampler.Create(ABmp);
    end;
  end;
var
  bmp: TBitmap32;
  s: Integer;
  w,h, x, y: Integer;
  z: Extended;
  rDst: TRect;
  iScale: TIconScaleMode;
begin                                 +
  s := min(dst.Width, dst.Height);
  bmp := TBitmap32.Create;
  try
    case AType of
      rtFile  : LoadFromFile(bmp);
      rtRes   :
      begin
        LoadImg32FromRes(bmp, AName);
        TDraftResampler.Create(bmp);
      end;
    end;

    iScale := ScaleMode;
    if iScale = ismFit then
      iScale := iif((bmp.Width > dst.Width) or (bmp.Height > dst.Height), ismAuto, ismDefault);

    if iScale = ismDefault then
    begin
      x := iif((dst.Width - bmp.Width) > 0, integer((dst.Width - bmp.Width) div 2), integer(0));
      y := iif((dst.Height - bmp.Height) > 0, integer((dst.Height - bmp.Height) div 2), integer(0));
      bmp.DrawTo(dst, x, y);
    end
    else
    begin
      z := s / Max(Bmp.Width, Bmp.Height);
      w := Trunc(bmp.Width * z);
      h := Trunc(bmp.Height * z);

      rDst := Rect(Trunc((s-W)/2),Trunc((s-H)/2), Trunc((s-W)/2)+W,Trunc((s-H)/2)+H);
      dst.Draw(rDst, bmp.BoundsRect, bmp);
    end;


  finally
    bmp.Free;
  end;
end;

procedure TcgCustomIcon.LoadIcon(const AName: string; AType: TResourceType);
var
  cIcon: TBitmap32;
begin
  cIcon := FIcon;
  cIcon.DrawMode := dmBlend;
  cIcon.Clear(clWhite32);
  cIcon.SetSize(FIconSize, FIconSize);
  DrawUserIcon(cIcon, AName, AType);
  if FMaskIcon then DrawBoundRound(cIcon);
  Invalidate;
end;

procedure TcgCustomIcon.LoadImg32FromRes(AImg: TBitmap32; const AName: String);
var
  cResSrc: TStream;
begin
  cResSrc := TResourceStream.Create(Hinstance, AName, RT_RCDATA);
  try
    with TPortableNetworkGraphic32.Create do
    try
      LoadFromStream(cResSrc);
      AssignTo(AImg);
    finally
      Free;
    end;
  finally
    cResSrc.Free;
  end;
end;

procedure TcgCustomIcon.PaintControl;
var
  cReader: TPolygonRenderer32VPR;
  c: TFloatPoint;
  iBk: TColor32;
  sw, sh: Integer;
begin
  cReader := TPolygonRenderer32VPR.Create;
  cReader.Filler := nil;
  cReader.FillMode := pfWinding;
  cReader.Bitmap := Self.FBuffer;

  if MouseCapture then iBk := FPushColor
  else if MouseInClient then iBk := FHoverColor
  else if Active then iBk := FActiveColor
  else iBk := Color32(Color);
  cReader.Bitmap.Clear(iBk);

  sw := FIcon.Width;
  sh := FIcon.Height;
  c := CenterPT;
  FIcon.DrawTo(cReader.Bitmap, Round(c.X - sw / 2), Round(c.Y - sh / 2) );

  cReader.Free;
end;

procedure TcgCustomIcon.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value; Invalidate;
  end;
end;

{ TcgUserIcon }

constructor TcgUserIcon.Create(AOwner: TComponent);
begin
  inherited;
  FMaskIcon := True;
end;

{ TcgStatusBar }

constructor TcgStatusBar.Create(AOwner: TComponent);
begin
  inherited;
  Color := clSilver;
  FHoverColor := clLightGray32;// clWhite32;
  FBorderColor := clGray32;
  Height := 18;
  Align := alBottom;
  FBorderWidth := 0;
  FBracketWidth := 5;
end;

procedure TcgStatusBar.PaintControl;
var
  cReader : TPolygonRenderer32VPR;
begin
  //Resize;
  cReader := TPolygonRenderer32VPR.Create;
  cReader.Filler := nil;
  cReader.FillMode := pfWinding;
  cReader.Bitmap   := Self.FBuffer;
  if MouseInClient then cReader.Bitmap.Clear(FHoverColor)
  else cReader.Bitmap.Clear(Color32(Color));

  cReader.DrawText(Bracket_Footer, Caption, Font , fpCenterLeft);
  cReader.DrawPolygon(FBorderColor , cReader.VRectangle(Bracket_Left));
  cReader.DrawPolygon(FBorderColor, cReader.VRectangle(Bracket_Right));
  if FBorderWidth > 0 then
    cReader.DrawPolygon(FBorderColor, cReader.VLineFrame(CenterPT, Width, Height, FBorderWidth));
  cReader.Free;
end;

procedure TcgStatusBar.Resize;
  procedure SetR(var r: TRect; l, t, w, h: Integer);
  begin
    r.Left := l; r.Top := t; r.Right := r.Left + w; r.Bottom := r.Top + h;
  end;
begin
  inherited;
  SetR(Bracket_Left, 0, 0, FBracketWidth, Height);
  SetR(Bracket_Right, Width - BracketWidth, 0, BracketWidth, Height);
  SetR(Bracket_Footer, Bracket_Left.Right + FGap + 1,0, Bracket_Right.Left + FGap, Height);
end;

procedure TcgStatusBar.SetBorderColor(const Value: TColor32);
begin
  FBorderColor := Value;
end;

procedure TcgStatusBar.SetBracketWidth(const Value: Integer);
begin
  FBracketWidth := Value;
end;

procedure TcgStatusBar.WMLMouseDown(var Message: TWMLButtonDown);
var
  pt: TPoint;
const
  sc_SizeLeft            = $F001;  { these are the variations }
  sc_SizeRight           = $F002;  { on the SC_SIZE value }
  sc_SizeTop             = $F003;
  sc_SizeTopLeft         = $F004;
  sc_SizeTopRight        = $F005;
  sc_SizeBottom          = $F006;
  sc_SizeBottomRight     = $F008;
  sc_SizeBottomLeft      = $F007;
  sc_DragMove            = $F012;
begin
  pt := Self.ScreenToClient(Mouse.CursorPos);
  if (PtInRect(Bracket_Left, pt) = True) then
  begin
    ReleaseCapture;
    Self.Parent.Perform(WM_SYSCOMMAND, sc_SizeBottomLeft, 0);
  end
  else
  begin
    if (PtInRect(Bracket_Right, pt) = True) then
    begin
      ReleaseCapture;
      Self.Parent.Perform(WM_SYSCOMMAND, sc_SizeBottomRight, 0);
    end;
  end;
end;

procedure TcgStatusBar.WMMouseMove(var Message: TWMMouseMove);
var
  pt: TPoint;
begin
  inherited;
  pt := Self.ScreenToClient(Mouse.CursorPos);
  if PtInRect(Bracket_Left, pt) then
    Cursor := crSizeNESW
  else if PtInRect(Bracket_Right, pt) then
    Cursor := crSizeNWSE
  else
    Cursor := crDefault;
end;

{ TPngImg }

constructor TPngImg.Create(AOwner: TComponent);
begin
  inherited;
  FThroughClick := False;
  BitmapAlign := baCenter;
  Bitmap.DrawMode := dmBlend;
  ScaleMode := smOptimal;
end;

{ TPngImg }

procedure TPngImg.WndProc(var Message: TMessage);
begin
  inherited;
  if Message.Msg = WM_NCHITTEST then
  begin
    if FThroughClick then
      Message.Result := HTTRANSPARENT;
  end;

end;

constructor TcgTabItem.Create(AOwner: TComponent);
begin
  inherited;
  FFrameColor := $FFDFE2E4; //#F5F2F0
//  Color := mx
end;

procedure TcgTabItem.PaintControl;
var
  cReader: TPolygonRenderer32VPR;
  ptI: TFloatPoint;
  rT: TRect;
  iFrame: TColor32;
  w, h: Integer;
begin
  cReader := TPolygonRenderer32VPR.Create;
  cReader.Filler := nil;
  cReader.FillMode := pfWinding;
  cReader.Bitmap := Self.FBuffer;
  cReader.Bitmap.Clear(Color32(Color));

  if MouseInClient then iFrame := FHoverColor
  else if Active then iFrame := FActiveColor
  else  iFrame := FrameColor;

  w := ClientWidth;
  h := ClientHeight;

  ptI := CenterPT;

  cReader.DrawPolygon(iFrame, cReader.VRectangle(ptI, w, h));

  ptI.Y := ptI.Y - 2;
  cReader.DrawPolygon(Color32(Color), cReader.VRectangle(ptI, w - 2, h - 6));

  ptI := CenterPT;
  rT := Rect(Round(CenterPT.X) - w div 2,
            Round(CenterPT.Y) - h div 2,
            Round(CenterPT.X) + w div 2,
            Round(CenterPT.Y) + h div 2);
  InflateRect(rt, -1, -1);
  OffsetRect(rt, 0, -1);

  cReader.DrawText(rT, Caption, Font.Color, Font.Size, Font.Name, fpCenterCenter, Font.Style);

  // 绘制执行进度
//  if (BarSize > 0) and (FProgress > 0) and (FProgress < 100) then
//  begin
//    rF := CenterPT;
//    rF.X := w * 0.5;
//    rF.Y := h - BarSize / 2;
//    dRate := (Progress * w) / 100;
//    rM.X := (dRate / 2) + 1;
//    rM.Y := rF.Y;
//    cReader.DrawPolygon(FBarColor,    cReader.VRectangle(rF, w, BarSize));
//    cReader.DrawPolygon(FValueColor,  cReader.VRectangle(rM, dRate, BarSize));
//  end;

  cReader.Free;
end;

constructor TcgIconButton.Create(AOwner: TComponent);
begin
  inherited;
  Color := clWhite;
  FIconColor := clGray;// $454545;
  FButtonHover := $454545;
  FIconChar :=  #0;
  FIconCharSize := 12; //FONTID_faSearch #xf002
end;

procedure TcgIconButton.PaintControl;
var
  cRender : TPolygonRenderer32VPR;
  iBtnBk : TColor;
  rTxt: TRect;
  s: string;
begin
  Resize;
  cRender := TPolygonRenderer32VPR.Create;
  cRender.Filler   := nil;
  cRender.FillMode := pfWinding;
  cRender.Bitmap   := Self.FBuffer;
  cRender.Bitmap.Clear(Color32(Color));

  iBtnBk := FIconColor;
  if Enabled and MouseInClient then
  begin
    if MouseCapture then iBtnBk := FButtonPush
    else if MouseInClient then iBtnBk :=  FButtonHover;
  end;

  rTxt := ClientRect;
  s := FIconChar;
  cRender.DrawText(rTxt, s ,iBtnBk, FIconCharSize, SIconFontName, fpCenterCenter, [], True);

  cRender.Free;
end;

procedure TcgIconButton.SetIconSize(const Value: Integer);
begin
  inherited;
//  if Value <  then

end;

procedure TcgIconButton.SetIndexIcon(const Value: Integer);
begin
  FIndexIcon := Value;
  FIconChar := IconIdxToFontAwesome(FIndexIcon);
  invalidate;
end;

{ TcgSwitchBtn }

procedure TcgSwitchBtn.Click;
begin
  Active := not Active;
  inherited;
end;

constructor TcgSwitchBtn.Create(AOwner: TComponent);
begin
  inherited;
  Width := 60;
  Height := 40;
  BtnSize := 24;
  Color := clWhite;
  EnableColor := $A4BF00;
  DisableColor := $c0c0c0;
end;

procedure TcgSwitchBtn.PaintControl;
var
  c: TFloatPoint;
  cRender : TPolygonRenderer32VPR;
  h: Integer;
  ibk: TColor;
  l: Integer;
  r: Integer;
begin
  Resize;
  cRender := TPolygonRenderer32VPR.Create;
  cRender.Filler   := nil;
  cRender.FillMode := pfWinding;
  cRender.Bitmap   := Self.FBuffer;
  cRender.Bitmap.Clear(Color32(Color));

  iBk := DisableColor;
  if Active then
    iBk := EnableColor;

  h := BtnSize;
  if h > Height - 6 then
    h := Height - 6;
  l := Width - 6;
  r := h div 2;

  c := CenterPT;
  cRender.DrawPolygon(Color32(iBk), cRender.VRoundRect(c, l, h, r));

  if Active then c.X := Width - 3 - r
  else c.X := 3 + r;
  cRender.DrawPolygon(Color32(Color), Circle(c, r -2));

  cRender.Free;

end;

procedure TcgSwitchBtn.SetActive(const Value: Boolean);
begin
  FActive := Value;
  Invalidate;
end;

procedure TcgSwitchBtn.SetBtnSize(const Value: Integer);
begin
  FBtnSize := Value;
  Invalidate;
end;

initialization

finalization
  RemoveIconResourceFont;

end.
