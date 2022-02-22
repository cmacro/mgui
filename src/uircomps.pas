unit uirComps;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LCLClasses, Controls, ExtCtrls;


type
  TirSidebar = class;
  { TirDataPanel }
  TirDataPanel = class(TPanel)
  public
    constructor Create(TheOwner: TComponent); override;
  end;

  TirControl = class(TirDataPanel)

  end;


  { TirSidebarItem }

  TirSidebarItem = class(TPersistent)
  private
    FOwner: TirSidebar;
    FAction: TBasicAction;
    function GetAction: TBasicAction;
    procedure SetAction(AValue: TBasicAction);
  protected

    property Action: TBasicAction read GetAction write SetAction;
  public
    property Owner: TirSidebar read FOwner;
  end;

  TirSIButton = class(TirSidebarItem)


  end;

  TirSIImage = class(TirSidebarItem)

  end;

  TirSILable = class(TirSidebarItem)

  end;

  TSidebarItemType = (sitImage,     // 图标类 如 logo
                      sitCaption,   // 标题类 如 主菜单下面的分类
                      sitButton,    // 功能按钮类，如功能菜单

                      sitCustom
                      );
  { TirSidebar }

  TirSidebar = class(TirControl)
  private
    //FItems: TObjectList;

  public
     constructor Create(TheOwner: TComponent); override;

     function Add(const AName: string; const AType: TSidebarItemType): TirSidebarItem;

     //function AddItem(const AName: string; AType: TSidebarItemType;
     //         const ACaption: string; Action: TBasicAction; const APrams: string = '' ):TirSidebarItem;
  end;

  { TirNavbar }

  TirNavbar = class(TirDataPanel)
  public
    constructor Create(TheOwner: TComponent); override;
  end;

  { TirFooter }

  TirFooter = class(TirDataPanel)
  public
    constructor Create(TheOwner: TComponent); override;

  end;

  TirContainer = class(TirDataPanel)
  public
  end;

implementation

{ TirSidebarItem }

function TirSidebarItem.GetAction: TBasicAction;
begin
  Result := FAction;
end;

procedure TirSidebarItem.SetAction(AValue: TBasicAction);
begin
  FAction := AValue;
end;

{ TirFooter }

constructor TirFooter.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Align := alBottom;
  Height := 40;
end;

{ TirNavbar }

constructor TirNavbar.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Align := alTop;
  Height := 60;
end;

{ TirSidebar }

constructor TirSidebar.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Align := alLeft;
  width := 80;
end;

function TirSidebar.Add(const AName: string;
  const AType: TSidebarItemType): TirSidebarItem;
begin
  Result := nil;
end;



{ TirDataPanel }

constructor TirDataPanel.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  BevelOuter := bvNone;
  Caption := '';
end;

end.

