herelocal Configs_HUB = { 
  Cor_Hub = Color3.fromRGB(0, 0, 0), 
  Cor_Options = Color3.fromRGB(0, 0, 0), 
  Cor_Stroke = Color3.fromRGB(0, 255, 200), 
  Cor_Text = Color3.fromRGB(240, 240, 240), 
  Cor_DarkText = Color3.fromRGB(240, 240, 240), 
  Corner_Radius = UDim.new(0, 15), 
  Text_Font = Enum.Font.FredokaOne 
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- المتغيرات العامة
_G.walkSpeedValue = 16
_G.jumpPowerValue = 50
_G.infJumpOn = false
_G.noclip = false
_G.fling = false
_G.espBox = false
_G.espName = false
_G.espDist = false
_G.espHealth = false
_G.espTracer = false
_G.espHigh = false
_G.rainbowMode = false
_G.espColor = "أحمر 🔴"
_G.fovRadius = 140
_G.aimbotEnabled = false
_G.teamCheck = true
_G.wallCheck = true
_G.aimbotPart = "Head"
_G.FlyConnection = nil
_G.AutoBHop = false
_G.NoFog = false
_G.SavedPos = nil
_G.CrosshairEnabled = false
_G.CrosshairRainbow = false
_G.CrosshairColor = "أحمر"
_G.CrosshairShape = "صليب"
_G.CrosshairSpin = false

local function Create(instance, parent, props)
  local new = Instance.new(instance, parent)
  if props then
    table.foreach(props, function(prop, value)
      new[prop] = value
    end)
  end
  return new
end

local function SetProps(instance, props)
  if instance and props then
    table.foreach(props, function(prop, value)
      instance[prop] = value
    end)
  end
  return instance
end

local function Corner(parent, props)
  local new = Create("UICorner", parent)
  new.CornerRadius = Configs_HUB.Corner_Radius
  if props then
    SetProps(new, props)
  end
  return new
end

local function Stroke(parent, props)
  local new = Create("UIStroke", parent)
  new.Color = Configs_HUB.Cor_Stroke
  new.ApplyStrokeMode = "Border"
  new.Thickness = 2

  local gradient = Instance.new("UIGradient")
  gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 200))
  }
  gradient.Rotation = 0
  gradient.Parent = new

  coroutine.wrap(function()
    while new.Parent do
      gradient.Rotation = (gradient.Rotation + 1) % 360
      RunService.RenderStepped:Wait()
    end
  end)()

  if props then
    SetProps(new, props)
  end
  return new
end

local function CreateTween(instance, prop, value, time, tweenWait)
  local tween = TweenService:Create(instance,
  TweenInfo.new(time, Enum.EasingStyle.Linear),
  {[prop] = value})
  tween:Play()
  if tweenWait then
    tween.Completed:Wait()
  end
end

local function TextSetColor(instance)
  instance.MouseEnter:Connect(function()
    CreateTween(instance, "TextColor3", Color3.fromRGB(30, 140, 200), 0.4, true)
  end)
  instance.MouseLeave:Connect(function()
    CreateTween(instance, "TextColor3", Configs_HUB.Cor_Text, 0.4, false)
  end)
end

local ScreenGui = Create("ScreenGui", CoreGui, {
  Name = "REDz HUB library"
})

ScreenFind = CoreGui:FindFirstChild(ScreenGui.Name)
if ScreenFind and ScreenFind ~= ScreenGui then
  ScreenFind:Destroy()
end

function DestroyScript()
  ScreenGui:Destroy()
end

local Menu_Notifi = Create("Frame", ScreenGui, {
  Size = UDim2.new(0, 300, 1, 0),
  Position = UDim2.new(1, 0, 0, 0),
  AnchorPoint = Vector2.new(1, 0),
  BackgroundTransparency = 1
})

local Padding = Create("UIPadding", Menu_Notifi, {
  PaddingLeft = UDim.new(0, 25),
  PaddingTop = UDim.new(0, 25),
  PaddingBottom = UDim.new(0, 50)
})

local ListLayout = Create("UIListLayout", Menu_Notifi, {
  Padding = UDim.new(0, 15),
  VerticalAlignment = "Bottom"
})

function MakeNotifi(Configs)
  local Title = Configs.Title or "REDz HUB"
  local text = Configs.Text or "Notificação"
  local timewait = Configs.Time or 5

  local Frame1 = Create("Frame", Menu_Notifi, {
    Size = UDim2.new(2, 0, 0, 0),
    BackgroundTransparency = 1,
    AutomaticSize = "Y",
    Name = "Title"
  })

  local Frame2 = Create("Frame", Frame1, {
    Size = UDim2.new(0, Menu_Notifi.Size.X.Offset - 50, 0, 0),
    BackgroundColor3 = Configs_HUB.Cor_Hub,
    Position = UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0),
    AutomaticSize = "Y"
  })Corner(Frame2)

  local TextLabel = Create("TextLabel", Frame2, {
    Size = UDim2.new(1, 0, 0, 25),
    Font = Configs_HUB.Text_Font,
    BackgroundTransparency = 1,
    Text = Title,
    TextSize = 20,
    Position = UDim2.new(0, 20, 0, 5),
    TextXAlignment = "Left",
    TextColor3 = Configs_HUB.Cor_Text
  })

  local TextButton = Create("TextButton", Frame2, {
    Text = "X",
    Font = Configs_HUB.Text_Font,
    TextSize = 20,
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Position = UDim2.new(1, -5, 0, 5),
    AnchorPoint = Vector2.new(1, 0),
    Size = UDim2.new(0, 25, 0, 25)
  })

  local TextLabel = Create("TextLabel", Frame2, {
    Size = UDim2.new(1, -30, 0, 0),
    Position = UDim2.new(0, 20, 0, TextButton.Size.Y.Offset + 10),
    TextSize = 15,
    TextColor3 = Configs_HUB.Cor_DarkText,
    TextXAlignment = "Left",
    TextYAlignment = "Top",
    AutomaticSize = "Y",
    Text = text,
    Font = Configs_HUB.Text_Font,
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.Y,
    TextWrapped = true
  })

  local FrameSize = Create("Frame", Frame2, {
    Size = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = Configs_HUB.Cor_Stroke,
    Position = UDim2.new(0, 2, 0, 30),
    BorderSizePixel = 0
  })Corner(FrameSize)Create("Frame", Frame2, {
    Size = UDim2.new(0, 0, 0, 5),
    Position = UDim2.new(0, 0, 1, 5),
    BackgroundTransparency = 1
  })

  task.spawn(function()
    CreateTween(FrameSize, "Size", UDim2.new(0, 0, 0, 2), timewait, true)
  end)

  TextButton.MouseButton1Click:Connect(function()
    CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.1, true)
    CreateTween(Frame2, "Position", UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0), 0.5, true)
    Frame1:Destroy()
  end)

  task.spawn(function()
    CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.5, true)
    CreateTween(Frame2, "Position", UDim2.new(), 0.1, true)task.wait(timewait)
    if Frame2 then
      CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.1, true)
      CreateTween(Frame2, "Position", UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0), 0.5, true)
      Frame1:Destroy()
    end
  end)
end

function MakeWindow(Configs)
  local title = Configs.Hub.Title or "REDz HUB"
  local Anim_Title = Configs.Hub.Animation or "by : FOLDARRE"

  local KeySystem = Configs.Key.KeySystem or false
  local KeyTitle = Configs.Key.Title or "Key System"
  local KeyDescription = Configs.Key.Description or ".-."
  local KeyKey = Configs.Key.Keys or {"123", "321"}
  local KeyLink = Configs.Key.KeyLink or ""
  local KeyNotifications = Configs.Key.Notifi.Notifications or true
  local KeyNotSuccess = Configs.Key.Notifi.Incorrectkey or "The key is incorrect"
  local KeySuccess = Configs.Key.Notifi.CorrectKey or "Running the Script..."
  local KeyCopyKeyLink = Configs.Key.Notifi.CopyKeyLink or "Copied to Clipboard"

  if KeySystem then
    local KeyMenu = Create("Frame", ScreenGui, {
      Size = UDim2.new(0, 400, 0, 220),
      Position = UDim2.new(0.5, 0, 0.5, 0),
      BackgroundColor3 = Configs_HUB.Cor_Hub,
      AnchorPoint = Vector2.new(0.5, 0.5),
      Active = true,
      Draggable = true
    })Corner(KeyMenu)

    local CloseButton = Create("TextButton", KeyMenu, {
      Size = UDim2.new(0, 30, 0, 30),
      Position = UDim2.new(1, -10, 0, 5),
      AnchorPoint = Vector2.new(1, 0),
      Text = "X",
      Font = Enum.Font.FredokaOne,
      TextScaled = true,
      TextColor3 = Color3.fromRGB(240, 0, 0),
      BackgroundTransparency = 1,
    })Corner(CloseButton)

    local Title = Create("TextLabel", KeyMenu, {
      Size = UDim2.new(1, -80, 0, 20),
      Position = UDim2.new(0, 20, 0, 5),
      Text = KeyTitle,
      Font = Configs_HUB.Text_Font,
      TextScaled = true,
      TextColor3 = Configs_HUB.Cor_Text,
      TextXAlignment = "Left",
      BackgroundTransparency = 1
    })

    local Description = Create("TextLabel", KeyMenu, {
      Size = UDim2.new(1, -80, 0, 0),
      Text = KeyDescription,
      TextSize = 17,
      TextColor3 = Configs_HUB.Cor_DarkText,
      Font = Configs_HUB.Text_Font,
      Position = UDim2.new(0, 20, 0, 25),
      TextXAlignment = "Left",
      AutomaticSize = "Y",
      TextYAlignment = "Top",
      BackgroundTransparency = 1
    })

    local ConfirmButton = Create("TextButton", KeyMenu, {
      Text = "Confirm",
      Font = Configs_HUB.Text_Font,
      TextSize = 20,
      TextColor3 = Configs_HUB.Cor_Text,
      Size = UDim2.new(0, 150, 0, 40),
      AnchorPoint = Vector2.new(1, 0),
      Position = UDim2.new(1, -35, 0, 140),
      BackgroundColor3 = Configs_HUB.Cor_Options
    })Corner(ConfirmButton)

    local GetKeyLink = Create("TextButton", KeyMenu, {
      Text = "Get Key Link",
      Font = Configs_HUB.Text_Font,
      TextSize = 20,
      TextColor3 = Configs_HUB.Cor_Text,
      Size = UDim2.new(0, 150, 0, 40),
      Position = UDim2.new(0, 35, 0, 140),
      BackgroundColor3 = Configs_HUB.Cor_Options
    })Corner(GetKeyLink)

    local TextBox = Create("TextBox", KeyMenu, {
      Size = UDim2.new(1, -70, 0, 40),
      Position = UDim2.new(0, 35, 0, 90),
      BackgroundColor3 = Configs_HUB.Cor_Options,
      PlaceholderText = "Put the Key here",
      Text = "",
      TextColor3 = Configs_HUB.Cor_Text,
      Font = Configs_HUB.Text_Font,
      TextSize = 25
    })Corner(TextBox)

    local KeyVerify = false
    CloseButton.MouseButton1Click:Connect(function()
      local UIScale = Create("UIScale", ScreenGui)
      CreateTween(UIScale, "Scale", 0, 0.20, true)
      ScreenGui:Destroy()
    end)

    ConfirmButton.MouseButton1Click:Connect(function()
      for _,v in pairs(KeyKey) do
        if TextBox.Text == v then
          KeyVerify = true
        end
      end
      if KeyNotifications and not KeyVerify then
        MakeNotifi({
          Title = KeyTitle,
          Text = KeyNotSuccess,
          Time = 5
        })
      elseif KeyNotifications then
        MakeNotifi({
          Title = KeyTitle,
          Text = KeySuccess,
          Time = 5
        })
      end
    end)

    GetKeyLink.MouseButton1Click:Connect(function()
      if KeyNotifications then
        setclipboard(KeyLink)
        MakeNotifi({
          Title = KeyTitle,
          Text = KeyCopyKeyLink,
          Time = 5
        })
      end
    end)

    repeat task.wait()
    until KeyVerify
    local UIScale = Create("UIScale", KeyMenu)
    CreateTween(UIScale, "Scale", 0, 0.40, true)
    KeyMenu:Destroy()
  end

  local Menu = Create("Frame", ScreenGui, {
    BackgroundColor3 = Configs_HUB.Cor_Hub,
    Position = UDim2.new(0.5, -500/2, 0.5, -270/2),
    Active = true,
    Draggable = true
  })
  Corner(Menu)
  Stroke(Menu)

  local TopBar = Create("Frame", Menu, {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 25),
    Visible = false
  })

  local ButtonsFrame = Create("Frame", TopBar, {
    Size = UDim2.new(0, 40, 1, -5),
    Position = UDim2.new(1, -10, 0, 2.5),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundTransparency = 1
  })

  local Title = Create("TextLabel", TopBar, {
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 20, 0, 0),
    TextColor3 = Configs_HUB.Cor_Text,
    Font = Configs_HUB.Text_Font,
    TextXAlignment = "Left",
    Text = title,
    TextSize = 20,
    BackgroundTransparency = 1
  })

  local Minimize_BTN = Create("TextButton", ButtonsFrame, {
    Text = "-",
    TextColor3 = Configs_HUB.Cor_Text,
    Size = UDim2.new(0.5, 0, 1, 0),
    BackgroundTransparency = 1,
    Font = Configs_HUB.Text_Font,
    TextYAlignment = "Bottom",
    TextSize = 25
  })

  IsMinimized = false
  Minimize_BTN.MouseButton1Click:Connect(function()
    Minimize_BTN.Text = not IsMinimized and "+" or "-"
    if IsMinimized then
      IsMinimized = false
      CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.15, false)
    else
      IsMinimized = true
      CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 25), 0.15, true)
    end
  end)

  local Close_Button = Create("TextButton", ButtonsFrame, {
    Text = "×",
    TextYAlignment = "Bottom",
    TextColor3 = Configs_HUB.Cor_Text,
    Size = UDim2.new(0.5, 0, 1, 0),
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    BackgroundTransparency = 1,
    Font = Configs_HUB.Text_Font,
    TextSize = 25
  })

  local function CreateClose()
    IsMinimized = false
    CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.3, false)
    local CloseGui = Create("TextButton", Menu, {
      BackgroundTransparency = 0.5,
      BackgroundColor3 = Configs_HUB.Cor_Hub,
      Size = UDim2.new(1, 0, 1, 0),
      AutoButtonColor = false,
      Text = "",
      BackgroundTransparency = 0.5,
      Visible = false
    })Corner(CloseGui)

    local CloseMenu = Create("Frame", CloseGui, {
      Size = UDim2.new(),
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.new(0.5, 0, 0.5, 0),
      Transparency = 1,
      BackgroundColor3 = Configs_HUB.Cor_Hub
    })Corner(CloseMenu)Stroke(CloseMenu)

    local Mensage = Create("TextLabel", CloseMenu, {
      Size = UDim2.new(0.8, 0, 0.25, 0),
      Text = "are you sure you want to close this script??",
      Position = UDim2.new(0.1, 0, 0.2),
      TextColor3 = Configs_HUB.Cor_Text,
      Font = Configs_HUB.Text_Font,
      TextScaled = true,
      BackgroundTransparency = 1
    })

    local Confirm = Create("TextButton", CloseMenu, {
      Size = UDim2.new(0.35, 0, 0.3, 0),
      Position = UDim2.new(0.1, 0, 0.5, 0),
      BackgroundColor3 = Configs_HUB.Cor_Hub,
      Text = "Close Script",
      Font = Configs_HUB.Text_Font,
      TextColor3 = Color3.fromRGB(240, 0, 0),
      TextSize = 20
    })Corner(Confirm)Stroke(Confirm)

    local Cancel = Create("TextButton", CloseMenu, {
      Size = UDim2.new(0.35, 0, 0.3, 0),
      Position = UDim2.new(0.9, 0, 0.5, 0),
      AnchorPoint = Vector2.new(1, 0),
      BackgroundColor3 = Configs_HUB.Cor_Hub,
      Text = "Cancel",
      Font = Configs_HUB.Text_Font,
      TextColor3 = Color3.fromRGB(0, 240, 0),
      TextSize = 20
    })Corner(Cancel)Stroke(Cancel)

    local function SetVisible()
      if Menu.Size.Y.Offset > 100 then
        CloseGui.Visible = true
      else
        CloseGui.Visible = false
      end
    end

    SetVisible()
    Menu:GetPropertyChangedSignal("Size"):Connect(SetVisible)

    CreateTween(CloseMenu, "Transparency", 0, 0.2, false)
    CreateTween(CloseMenu, "Size", UDim2.new(0.7, 0, 0.7, 0), 0.2, false)

    Cancel.MouseButton1Click:Connect(function()
      CreateTween(CloseMenu, "Transparency", 1, 0.3, false)
      CreateTween(CloseMenu, "Size", UDim2.new(), 0.2, true)
      CloseGui:Destroy()
    end)

    Confirm.MouseButton1Click:Connect(function()
      CloseGui:Destroy()
      CreateTween(Menu, "Size", UDim2.new(), 0.3, true)
      DestroyScript()
    end)

    CloseGui.MouseButton1Click:Connect(function()
      CreateTween(CloseMenu, "Transparency", 1, 0.3, false)
      CreateTween(CloseMenu, "Size", UDim2.new(), 0.2, true)
      CloseGui:Destroy()
    end)
  end

  Close_Button.MouseButton1Click:Connect(CreateClose)

  local AnimMenu = Create("Frame", ScreenGui, {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Configs_HUB.Cor_Hub
  })Corner(AnimMenu, {CornerRadius = UDim.new(0, 6)})

  local Anim_Credits = Create("TextLabel", AnimMenu, {
    Text = Anim_Title,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Visible = false,
    Font = Configs_HUB.Text_Font,
    TextTransparency = 1,
    TextColor3 = Configs_HUB.Cor_Text,
    Position = UDim2.new(0, 10, 0, 0),
    TextXAlignment = "Left",
    TextSize = 15
  })

  CreateTween(AnimMenu, "Size", UDim2.new(0, 0, 0, 35), 0.5, true)
  CreateTween(AnimMenu, "Size", UDim2.new(0, 150, 0, 35), 0.5, true)
  Anim_Credits.Visible = true
  task.wait(0.5)
  for i = 1, 0, -0.1 do task.wait()
    Anim_Credits.TextTransparency = i
  end
  task.wait(1)
  for i = 0, 1, 0.1 do task.wait()
    Anim_Credits.TextTransparency = i
  end
  Anim_Credits:Destroy()
  AnimMenu:Destroy()
  CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 35), 0.5, true)
  TopBar.Visible = true
  CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.3, true)
  Menu.Draggable = true

  local line_Containers = Create("Frame", Menu, {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0)
  })

  local ScrollBar = Create("ScrollingFrame", Menu, {
    Size = UDim2.new(0, 140, 1, -tonumber(TopBar.Size.Y.Offset + 2)),
    Position = UDim2.new(0, 0, 1, 0),
    AnchorPoint = Vector2.new(0, 1),
    CanvasSize = UDim2.new(),
    ScrollingDirection = "Y",
    AutomaticCanvasSize = "Y",
    BackgroundTransparency = 1,
    ScrollBarThickness = 2
  })Create("UIPadding", ScrollBar, {
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10)
  })Create("UIListLayout", ScrollBar, {
    Padding = UDim.new(0, 5)
  })

  local Containers = Create("Frame", Menu, {
    Size = UDim2.new(1, -tonumber(ScrollBar.Size.X.Offset + 2), 1, -tonumber(TopBar.Size.Y.Offset + 2)),
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1
  })Corner(Containers)

  local function Add_Line(props)
    local line = Create("Frame", line_Containers, props)
    line.BackgroundColor3 = Configs_HUB.Cor_Stroke
    line.BorderSizePixel = 0
  end

  Add_Line({Size = UDim2.new(1, 0, 0, 1),Position = UDim2.new(0, 0, 0, TopBar.Size.Y.Offset)})
  Add_Line({Size = UDim2.new(0, 1, 1, -tonumber(TopBar.Size.Y.Offset + 1)),
  Position = UDim2.new(0, ScrollBar.Size.X.Offset, 0, TopBar.Size.Y.Offset)})

  local firstVisible = true
  local FirstTab = true
  local textsize = 15
  local textcolor = Configs_HUB.Cor_Text

  Menu:GetPropertyChangedSignal("Size"):Connect(function()
    if Menu.Size.Y.Offset > 70 then
      ScrollBar.Visible = true
      Containers.Visible = true
      line_Containers.Visible = true
    else
      ScrollBar.Visible = false
      Containers.Visible = false
      line_Containers.Visible = false
    end
  end)

  function MakeTab(Configs)
    local TabName = Configs.Name or "Tab"
    local TabTitle = Configs.TabTitle or false
    local TabImage = Configs.Image or nil

    local Frame = Create("Frame", ScrollBar, {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1
    }) Corner(Frame) Stroke(Frame)

    local TextButton = Create("TextButton", Frame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    })

    if TabImage then
        Create("ImageLabel", Frame, {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0.5, -10),
            BackgroundTransparency = 1,
            Image = TabImage,
            Name = "TabIcon"
        })
    end

    local textOffset = TabImage and 30 or 5

    local TextLabel = Create("TextLabel", Frame, {
        Size = UDim2.new(1, -textOffset, 1, 0),
        Position = UDim2.new(0, textOffset, 0, 0),
        BackgroundTransparency = 1,
        Font = Configs_HUB.Text_Font,
        TextColor3 = textcolor,
        TextSize = textsize,
        Text = TabName,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Container = Create("ScrollingFrame", Containers, {
        Size = UDim2.new(1, 0, 1, 0),
        ScrollingDirection = "Y",
        AutomaticCanvasSize = "Y",
        CanvasSize = UDim2.new(),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        Visible = firstVisible
    }) 

    Create("UIPadding", Container, {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    }) 

    Create("UIListLayout", Container, {
        Padding = UDim.new(0, 5)
    })

    if TabTitle then
        Create("TextLabel", Container, {
            BackgroundTransparency = 1,
            Text = "#" .. string.gsub(TabName, " ", "-"),
            TextSize = 25,
            Font = Configs_HUB.Text_Font,
            TextXAlignment = "Left",
            TextColor3 = Configs_HUB.Cor_Text,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 30, 0, 0),
            Name = "Frame"
        })
    end

    TextButton.MouseButton1Click:Connect(function()
        for _, container in pairs(Containers:GetChildren()) do
            if container:IsA("ScrollingFrame") then
                container.Visible = false
            end
        end

        for _, frame in pairs(ScrollBar:GetChildren()) do
            if frame:IsA("Frame") and frame:FindFirstChild("TextLabel") and frame.TextLabel ~= TextLabel then
                CreateTween(frame.TextLabel, "TextColor3", Configs_HUB.Cor_DarkText, 0.3, false)
                frame.TextLabel.TextSize = 14
            end
        end

        Container.Visible = true
        CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.3, false)
        TextLabel.TextSize = 15
    end)

    firstVisible = false
    FirstTab = false
    textsize = 14
    textcolor = Configs_HUB.Cor_DarkText

    return Container
  end

  function AddButton(parent, Configs)
    local ButtonName = Configs.Name or "Button!!"
    local Callback = Configs.Callback or function() end

    local TextButton = Create("TextButton", parent, {
      Size = UDim2.new(1, 0, 0, 25),
      BackgroundColor3 = Configs_HUB.Cor_Options,
      Name = "Frame",
      Text = "",
      AutoButtonColor = false
    })Corner(TextButton)Stroke(TextButton)

    local TextLabel = Create("TextLabel", TextButton, {
      TextSize = 12,
      TextColor3 = Configs_HUB.Cor_Text,
      Text = ButtonName,
      Size = UDim2.new(1, 0, 1, 0),
      Position = UDim2.new(0, 35, 0, 0),
      BackgroundTransparency = 1,
      TextXAlignment = "Left",
      Font = Configs_HUB.Text_Font
    })

    local ImageLabel = Create("ImageLabel", TextButton, {
      Image = "rbxassetid://99956220697276",
      Size = UDim2.new(0, 20, 0, 20),
      Position = UDim2.new(0, 5, 0, 2.5),
      BackgroundTransparency = 1,
      ImageColor3 = Configs_HUB.Cor_Stroke
    })

    TextButton.MouseButton1Click:Connect(function()
      Callback("Click!!")
      CreateTween(ImageLabel, "ImageColor3", Color3.fromRGB(30, 140, 200), 0.2, true)
      CreateTween(ImageLabel, "ImageColor3", Configs_HUB.Cor_Stroke, 0.2, false)
    end)

    TextSetColor(TextLabel)
  end

  function AddToggle(parent, Configs)
    local ToggleName = Configs.Name or "Toggle!!"
    local Default = Configs.Default or false
    local Callback = Configs.Callback or function() end

    local TextButton = Create("TextButton", parent, {
      Size = UDim2.new(1, 0, 0, 25),
      BackgroundColor3 = Configs_HUB.Cor_Options,
      Name = "Frame",
      Text = "",
      AutoButtonColor = false
    })Corner(TextButton)Stroke(TextButton)

    local TextLabel = Create("TextLabel", TextButton, {
      TextSize = 12,
      TextColor3 = Configs_HUB.Cor_Text,
      Text = ToggleName,
      Size = UDim2.new(1, 0, 1, 0),
      Position = UDim2.new(0, 35, 0, 0),
      BackgroundTransparency = 1,
      TextXAlignment = "Left",
      Font = Configs_HUB.Text_Font
    })

    local Frame1 = Create("Frame", TextButton, {
      Size = UDim2.new(0, 25, 0, 15),
      Position = UDim2.new(0, 5, 0, 5),
      BackgroundTransparency = 1,
    })Corner(Frame1, {CornerRadius = UDim.new(1, 0)})
    local Stroke = Stroke(Frame1, {Thickness = 2})

    local Frame2 = Create("Frame", Frame1, {
      Size = UDim2.new(0, 13, 0, 13),
      Position = UDim2.new(0, 2, 0.5, 0),
      AnchorPoint = Vector2.new(0, 0.5),
      BackgroundColor3 = Configs_HUB.Cor_Stroke
    })Corner(Frame2, {CornerRadius = UDim.new(1, 0)})

    local OnOff = false
    if Default then
      OnOff = true
      CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false)
      CreateTween(Frame2, "BackgroundColor3", Color3.fromRGB(30, 140, 200), 0.2, false)
      CreateTween(Stroke, "Color", Color3.fromRGB(30, 140, 200), 0.2, false)
      CreateTween(TextLabel, "TextColor3", Color3.fromRGB(30, 140, 200), 0.2, false)
    end
    Callback(OnOff)
    TextButton.MouseButton1Click:Connect(function()
      if Frame2.Position.X.Offset < 5 then
        OnOff = true
        CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false)
        CreateTween(Frame2, "BackgroundColor3", Color3.fromRGB(30, 140, 200), 0.2, false)
        CreateTween(Stroke, "Color", Color3.fromRGB(30, 140, 200), 0.2, false)
        CreateTween(TextLabel, "TextColor3", Color3.fromRGB(30, 140, 200), 0.2, false)
        Callback(true)
      else
        OnOff = false
        CreateTween(Frame2, "Position", UDim2.new(0, 2, 0.5, 0), 0.2, false)
        CreateTween(Frame2, "BackgroundColor3", Configs_HUB.Cor_Stroke, 0.2, false)
        CreateTween(Stroke, "Color", Configs_HUB.Cor_Stroke, 0.2, false)
        CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.2, false)
        Callback(false)
      end
    end)
    return {Frame2, Stroke, OnOff, Callback}
  end

  function UpdateToggle(toggle, value)
    local Frame2 = toggle[1]
    local Stroke = toggle[2]
    local OnOff = value
    local Callback = toggle[4]

    if OnOff then
      Callback(true)
      CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false)
      CreateTween(Frame2, "BackgroundColor3", Color3.fromRGB(30, 140, 200), 0.2, false)
      CreateTween(Stroke, "Color", Color3.fromRGB(30, 140, 200), 0.2, false)
      CreateTween(TextLabel, "TextColor3", Color3.fromRGB(30, 140, 200), 0.2, false)
    else
      Callback(false)
      CreateTween(Frame2, "Position", UDim2.new(0, 2, 0.5, 0), 0.2, false)
      CreateTween(Frame2, "BackgroundColor3", Configs_HUB.Cor_Stroke, 0.2, false)
      CreateTween(Stroke, "Color", Configs_HUB.Cor_Stroke, 0.2, false)
      CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.2, false)
    end
  end

  function AddSlider(parent, Configs)
    local SliderName = Configs.Name or "Slider!!"
    local Increase = Configs.Increase or 1
    local MinValue = Configs.MinValue / Increase or 10 / Increase
    local MaxValue = Configs.MaxValue / Increase or 100 / Increase
    local Default = Configs.Default or 25
    local Callback = Configs.Callback or function() end

    local Frame = Create("TextButton", parent, {
      Size = UDim2.new(1, 0, 0, 25),
      BackgroundColor3 = Configs_HUB.Cor_Options,
      Name = "Frame",
      Text = 0
    })Corner(Frame)Stroke(Frame)

    local TextLabel = Create("TextButton", Frame, {
      TextSize = 12,
      TextColor3 = Configs_HUB.Cor_Text,
      Text = SliderName,
      Size = UDim2.new(1, 0, 1, 0),
      Position = UDim2.new(0, 150, 0, 0),
      BackgroundTransparency = 1,
      TextXAlignment = "Left",
      Font = Configs_HUB.Text_Font
    })TextSetColor(TextLabel)

    local TextLabelNumber = Create("TextLabel", Frame, {
      Font = Configs_HUB.Text_Font,
      Size = UDim2.new(0, 20, 0, 20),
      Text = "...",
      Position = UDim2.new(0, 5, 0, 2.5),
      TextScaled = true,
      TextColor3 = Configs_HUB.Cor_Text,
      BackgroundTransparency = 1
    })

    local SliderBar1 = Create("TextLabel", Frame, {
      Size = UDim2.new(0, 100, 0, 7.5),
      Position = UDim2.new(0, 35, 0.5, 0),
      AnchorPoint = Vector2.new(0, 0.5),
      BackgroundColor3 = Configs_HUB.Cor_Stroke,
      Text = ""
    })Corner(SliderBar1)

    local SavePos = Create("Frame", SliderBar1, {
      Size = UDim2.new(0, 1, 0, 0),
      Visible = false
    })

    local Slider = Create("Frame", SliderBar1, {
      BackgroundColor3 = Configs_HUB.Cor_Text,
      Size = UDim2.new(0, 7.5, 0, 15),
      Position = UDim2.new(0, 0, 0.5, 0),
      AnchorPoint = Vector2.new(0, 0.5),
      Active = true,
      Draggable = true
    })Corner(Slider)

    local SliderBar2 = Create("Frame", SliderBar1, {
      BackgroundColor3 = Color3.fromRGB(30, 140, 200),
      Size = UDim2.new(0, Slider.Position.X.Offset, 1, 0)
    })Corner(SliderBar2)

    local function UpdCounter(Value)
      local String = tostring(Value * Increase)
      if string.find(String, ".") then
        String = String:sub(1, 5)
      end
      TextLabelNumber.Text = String
      Callback(Value * Increase)
    end

    local MouseEnterOrLeave = false
    Frame.MouseButton1Down:Connect(function()
      MouseEnterOrLeave = true
      while MouseEnterOrLeave do task.wait()
        local MousePos = UserInputService:GetMouseLocation().X - SavePos.AbsolutePosition.X
        Slider.Position = UDim2.new(0, MousePos, 0.5, 0)
      end
    end)
    Frame.MouseLeave:Connect(function()
      MouseEnterOrLeave = false
    end)

    local function SliderSet(NewValue)
      local max, min = MaxValue * Increase, MinValue * Increase
      local SliderPos = (NewValue - min) / (max - min)
      local X_Offset = SliderPos * 100
      local SliderPosition = UDim2.new(0, X_Offset + 1, 0, 0)
      CreateTween(Slider, "Position", SliderPosition, 0.5, false)
    end
    SliderSet(Default)

    Slider.Changed:Connect(function(prop)
      if prop == "Position" then
        Slider.Position = UDim2.new(0, math.clamp(Slider.Position.X.Offset, 0, 100), 0.5, 0)
        SliderBar2.Size = UDim2.new(0, Slider.Position.X.Offset, 1, 0)
        local SliderPos = Slider.Position.X.Offset / 100
        local A_1 = math.floor(((SliderPos * MaxValue) / MaxValue) * (MaxValue - MinValue) + MinValue)
        UpdCounter(A_1)
      end
    end)
    return {Slider, Increase, MaxValue, MinValue}
  end

  function UpdateSlider(Slider, NewValue)
    local Frame = Slider[1]
    local Increase = Slider[2]
    local Max = Slider[3] * Increase
    local Min = Slider[4] * Increase

    local SliderPos = (NewValue - Min) / (Max - Min)
    local X_Offset = SliderPos * 100
    local SliderPosition = UDim2.new(0, X_Offset + 1, 0, 0)
    CreateTween(Frame, "Position", SliderPosition, 0.5, false)
  end

  function AddKeybind(parent, Configs)
    local KeybindName = Configs.Name or "Keybind!!"
    local KeyCode = Configs.KeyCode or "E"
    local Default = Configs.Default or false
    local Callback = Configs.Callback or function() end

    local Frame = Create("Frame", parent, {
      Size = UDim2.new(1, 0, 0, 25),
      BackgroundColor3 = Configs_HUB.Cor_Options,
      Name = "Frame"
    })Corner(Frame)Stroke(Frame)

    local TextLabel = Create("TextButton", Frame, {
      TextSize = 12,
      TextColor3 = Configs_HUB.Cor_Text,
      Text = KeybindName,
      Size = UDim2.new(1, 0, 1, 0),
      Position = UDim2.new(0, 35, 0, 0),
      BackgroundTransparency = 1,
      TextXAlignment = "Left",
      Font = Configs_HUB.Text_Font
    })

    local Keybind = Create("TextLabel", Frame, {
      Font = Configs_HUB.Text_Font,
      Size = UDim2.new(0, 18, 0, 18),
      Text = KeyCode,
      Position = UDim2.new(0, 5, 0, 3.5),
      TextScaled = true,
      TextColor3 = Configs_HUB.Cor_Text,
      BackgroundTransparency = 1
    })Corner(Keybind)Stroke(Keybind)

    local OnOff = Default
    UserInputService.InputBegan:Connect(function(input)
      if input.KeyCode == Enum.KeyCode[KeyCode] then
        OnOff = not OnOff
        Callback(OnOff)
      end
    end)
    TextSetColor(TextLabel)
  end

  function AddTextBox(parent, Configs)
    local TextBoxName = Configs.Name or "TextBox!!"
    local Default = Configs.Default or "TextBox"
    local placeholderText = Configs.PlaceholderText or "TextBox"
    local ClearText = Configs.ClearText or false
    local Callback = Configs.Callback or function() end

    local Frame = Create("Frame", parent, {
      Size = UDim2.new(1, 0, 0, 25),
      BackgroundColor3 = Configs_HUB.Cor_Options,
      Name = "Frame"
    })Corner(Frame)Stroke(Frame)

    local TextLabel = Create("TextButton", Frame, {
      TextSize = 12,
      TextColor3 = Configs_HUB.Cor_Text,
      Text = TextBoxName,
      Size = UDim2.new(1, 0, 1, 0),
      Position = UDim2.new(0, 150, 0, 0),
      BackgroundTransparency = 1,
      TextXAlignment = "Left",
      Font = Configs_HUB.Text_Font
    })
    TextSetColor(TextLabel)

    local TextBox = Create("TextBox", Frame, {
      Size = UDim2.new(0, 120, 0, 20),
      Position = UDim2.new(0, 15, 0, 2.5),
      TextColor3 = Configs_HUB.Cor_Text,
      Text = Default,
      ClearTextOnFocus = ClearText,
      PlaceholderText = placeholderText,
      TextScaled = true,
      Font = Configs_HUB.Text_Font,
      BackgroundTransparency = 1
    })

    local Line = Create("Frame", TextBox, {
      Size = UDim2.new(1, 0, 0, 1),
      Position = UDim2.new(0.5, 0, 1, 0),
      AnchorPoint = Vector2.new(0.5, 0.5),
      BackgroundColor3 = Configs_HUB.Cor_Stroke,
      BorderSizePixel = 0
    })

    TextBox.MouseEnter:Connect(function()
      CreateTween(Line, "Size", UDim2.new(0, 0, 0, 1), 0.3, true)
      CreateTween(Line, "Size", UDim2.new(1, 0, 0, 1), 0.3, true)
    end)

    TextBox.FocusLost:Connect(function()
      Callback(TextBox.Text)
    end)
  end

  function AddDropdown(parent, Configs)
    local DropdownName = Configs.Name or "Dropdown!!"
    local Default = Configs.Default or "TextBox"
    local Options = Configs.Options or {"1", "2", "3"}
    local Default = Configs.Default or "2"
    local Callback = Configs.Callback or function() end

    local TextButton = Create("TextButton", parent, {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundColor3 = Configs_HUB.Cor_Options,
        Name = "Frame",
        Text = "",
        AutoButtonColor = false
    }) 

    local dropdownStroke = Stroke(TextButton, {
        Color = Configs_HUB.Cor_Stroke,
        Thickness = 2
    })

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Configs_HUB.Cor_Stroke),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 255)),
        ColorSequenceKeypoint.new(1, Configs_HUB.Cor_Stroke)
    }
    gradient.Rotation = 0
    gradient.Parent = dropdownStroke

    coroutine.wrap(function()
        while dropdownStroke.Parent do
            gradient.Rotation = (gradient.Rotation + 1) % 360
            RunService.RenderStepped:Wait()
        end
    end)()

    Corner(TextButton)

    local TextLabel = Create("TextLabel", TextButton, {
        TextSize = 12,
        TextColor3 = Configs_HUB.Cor_Text,
        Text = DropdownName,
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = "Left",
        Font = Configs_HUB.Text_Font
    })TextSetColor(TextLabel)

    local Line = Create("Frame", TextButton, {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 25),
        BorderSizePixel = 0,
        BackgroundColor3 = Configs_HUB.Cor_Stroke,
        Visible = false
    })

    local Arrow = Create("ImageLabel", TextButton, {
        Image = "rbxassetid://6031090990",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1
    })

    local DefaultText = Create("TextLabel", TextButton, {
        BackgroundColor3 = Configs_HUB.Cor_Hub,
        BackgroundTransparency = 0.1,
        Position = UDim2.new(1, -20, 0, 2.5),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0, 100, 0, 20),
        TextColor3 = Configs_HUB.Cor_DarkText,
        TextScaled = true,
        Font = Configs_HUB.Text_Font,
        Text = "..."
    })

    local defaultTextStroke = Stroke(DefaultText, {
        Color = Configs_HUB.Cor_Stroke,
        Thickness = 1
    })

    local defaultGradient = Instance.new("UIGradient")
    defaultGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Configs_HUB.Cor_Stroke),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 255)),
        ColorSequenceKeypoint.new(1, Configs_HUB.Cor_Stroke)
    }
    defaultGradient.Rotation = 0
    defaultGradient.Parent = defaultTextStroke

    coroutine.wrap(function()
        while defaultTextStroke.Parent do
            defaultGradient.Rotation = (defaultGradient.Rotation + 1) % 360
            RunService.RenderStepped:Wait()
        end
    end)()

    Corner(DefaultText)

    local ScrollBar = Create("ScrollingFrame", TextButton, {
        Size = UDim2.new(1, 0, 1, -25),
        Position = UDim2.new(0, 0, 0, 25),
        CanvasSize = UDim2.new(),
        ScrollingDirection = "Y",
        AutomaticCanvasSize = "Y",
        BackgroundTransparency = 1,
        ScrollBarThickness = 2
    })Create("UIPadding", ScrollBar, {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    })Create("UIListLayout", ScrollBar, {
        Padding = UDim.new(0, 5)
    })

    local function AddOption(OptionName)
        local TextButton = Create("TextButton", ScrollBar, {
            Size = UDim2.new(1, 0, 0, 15),
            Text = OptionName,
            Font = Configs_HUB.Text_Font,
            TextSize = 12,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            BackgroundTransparency = 1
        })

        local optionStroke = Stroke(TextButton, {
            Color = Configs_HUB.Cor_Stroke,
            Thickness = 1,
            Transparency = 0.7
        })

        local optionGradient = Instance.new("UIGradient")
        optionGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Configs_HUB.Cor_Stroke),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 255)),
            ColorSequenceKeypoint.new(1, Configs_HUB.Cor_Stroke)
        }
        optionGradient.Rotation = 0
        optionGradient.Parent = optionStroke

        coroutine.wrap(function()
            while optionStroke.Parent do
                optionGradient.Rotation = (optionGradient.Rotation + 1) % 360
                RunService.RenderStepped:Wait()
            end
        end)()

        Corner(TextButton)

        local SelectTable = {}
        local OnOff = false
        if OptionName == Default then
            OnOff = true
            TextButton.BackgroundTransparency = 0.8
            TextButton.TextColor3 = Configs_HUB.Cor_Text
            DefaultText.Text = OptionName
            Callback(OptionName)
        end

        TextButton.MouseButton1Click:Connect(function()
            for _,v in pairs(ScrollBar:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundTransparency = 1
                    v.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            DefaultText.Text = OptionName
            Callback(OptionName)
            TextButton.BackgroundTransparency = 0.8
            TextButton.TextColor3 = Configs_HUB.Cor_Text
        end)
    end

    for _,v in pairs(Options) do
        AddOption(v)
    end

    local DropOnOff = false
    TextButton.MouseButton1Click:Connect(function()
        local OptionSize, OptionsNumber = 25, 0
        for _,v in pairs(ScrollBar:GetChildren()) do
            if v:IsA("TextButton") and OptionsNumber < 5 then
                OptionsNumber = OptionsNumber + 1
                OptionSize = OptionSize + tonumber(v.Size.Y.Offset + 10)
            end
        end
        if not DropOnOff then
            CreateTween(TextButton, "Size", UDim2.new(1, 0, 0, OptionSize), 0.3, false)
            CreateTween(Arrow, "Rotation", 180, 0.3, false)
            DropOnOff = true
            Line.Visible = true
        else
            CreateTween(TextButton, "Size", UDim2.new(1, 0, 0, 25), 0.3, false)
            CreateTween(Arrow, "Rotation", 0, 0.3, true)
            DropOnOff = false
            Line.Visible = false
        end
    end)
    return {ScrollBar, Default, Callback, DefaultText}
  end

  function UpdateDropdown(Dropdown, NewOptions)
    local ScrollBar = Dropdown[1]
    local Default = Dropdown[2]
    local Callback = Dropdown[3]
    local DefaultText = Dropdown[4]

    for _,v in pairs(ScrollBar:GetChildren()) do
      if v:IsA("TextButton") then
        v:Destroy()
      end
    end

    local function AddOption(OptionName)
      local TextButton = Create("TextButton", ScrollBar, {
        Size = UDim2.new(1, 0, 0, 15),
        Text = OptionName,
        Font = Configs_HUB.Text_Font,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        BackgroundTransparency = 1
      })Corner(TextButton)

      local SelectTable = {}
      local OnOff = false
      if OptionName == Default then
        OnOff = true
        TextButton.BackgroundTransparency = 0.8
        TextButton.TextColor3 = Configs_HUB.Cor_Text
        DefaultText.Text = OptionName
        Callback(OptionName)
      else
        DefaultText.Text = "..."
      end

      TextButton.MouseButton1Click:Connect(function()
        for _,v in pairs(ScrollBar:GetChildren()) do
          if v:IsA("TextButton") then
            v.BackgroundTransparency = 1
            v.TextColor3 = Color3.fromRGB(180, 180, 180)
          end
        end
        DefaultText.Text = OptionName
        Callback(OptionName)
        TextButton.BackgroundTransparency = 0.8
        TextButton.TextColor3 = Configs_HUB.Cor_Text
      end)
    end

    for _,v in pairs(NewOptions) do
      AddOption(v)
    end
  end

  return Menu
end

-- ==========================================
-- بناء واجهة FOLDARRE
-- ==========================================
local Window = MakeWindow({
  Hub = {
    Title = "FOLDARRE",
    Animation = "by : FOLDARRE"
  },
  Key = {
    KeySystem = false,
    Title = "Key System",
    Description = "أدخل المفتاح",
    Keys = {"FOLDARRE-KEY", "FOLDARRE"},
    KeyLink = "https://link-hub.net/6409359/gm01XUMC0rRy",
    Notifi = {
      Notifications = true,
      Incorrectkey = "المفتاح خاطئ",
      CorrectKey = "تم تفعيل السكربت...",
      CopyKeyLink = "تم نسخ الرابط"
    }
  }
})

-- ==========================================
-- 1. التبويب الرئيسي (Main)
-- ==========================================
local MainTab = MakeTab({Name = "الرئيسية"})

AddButton(MainTab, {
  Name = "تشغيل الطيران (مع الأنيميشن)",
  Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/4ikNRBAL/raw"))()
    MakeNotifi({Title = "FOLDARRE", Text = "تم تشغيل سكربت الطيران", Time = 3})
  end
})

getgenv().ResolutionEnabled = false
getgenv().Resolution = { [".gg/scripters"] = 0.53 }
RunService.RenderStepped:Connect(function()
    if getgenv().ResolutionEnabled then Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1) end
end)

AddToggle(MainTab, {
  Name = "تغيير شكل الشاشة (تمدد)",
  Default = false,
  Callback = function(v)
    getgenv().ResolutionEnabled = v
  end
})

AddButton(MainTab, {
  Name = "+18 Script",
  Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))("FOLDARRE Script")
    MakeNotifi({Title = "FOLDARRE", Text = "تم تشغيل +18", Time = 3})
  end
})

-- ==========================================
-- 2. التبويب الاحترافي (PRO)
-- ==========================================
local ProTab = MakeTab({Name = "FOLDARRE PRO"})

-- الموسيقى
local sound = Instance.new("Sound", SoundService)
sound.Name = "FOLDARRE_BG"
sound.Looped = true

local songList = {
    "Numb (Slowed + Reverb)",
    "Desprezo (Aggressive Phonk)",
    "Dark Fantasy (Slowed + Reverb)",
    "vivid (slowed + reverb)",
    "MONTAGEM DRESCE (Slowed)"
}

AddDropdown(ProTab, {
  Name = "اختر أغنية جاهزة",
  Options = songList,
  Default = "Numb (Slowed + Reverb)",
  Callback = function(v)
    local urls = {
        ["Numb (Slowed + Reverb)"] = "rbxassetid://100950173819164",
        ["Desprezo (Aggressive Phonk)"] = "rbxassetid://140667339171815",
        ["Dark Fantasy (Slowed + Reverb)"] = "rbxassetid://134479750307568",
        ["vivid (slowed + reverb)"] = "rbxassetid://138996343442704",
        ["MONTAGEM DRESCE (Slowed)"] = "rbxassetid://138968496511779"
    }
    sound.SoundId = urls[v] or ""
  end
})

AddTextBox(ProTab, {
  Name = "أو ضع ID / رابط مخصص",
  PlaceholderText = "ضع ID أو رابط هنا",
  Callback = function(v)
    if string.find(v, "http") then sound.SoundId = v else sound.SoundId = "rbxassetid://" .. v end
  end
})

AddButton(ProTab, {
  Name = "▶️ تشغيل الموسيقى",
  Callback = function() sound:Play() end
})

AddButton(ProTab, {
  Name = "⏹️ إيقاف الموسيقى",
  Callback = function() sound:Stop() end
})

-- الكاميرا والزوم
local freeCamEnabled = false
local zoomAmount = 0

AddToggle(ProTab, {
  Name = "تفعيل الكاميرا الحرة (Infinite Zoom)",
  Default = false,
  Callback = function(v)
    freeCamEnabled = v
    if not v then Camera.CameraType = Enum.CameraType.Custom Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid") end
  end
})

AddSlider(ProTab, {
  Name = "مدى البعد (Zoom)",
  MinValue = 0,
  MaxValue = 500,
  Default = 0,
  Increase = 10,
  Callback = function(v) zoomAmount = v end
})

RunService.RenderStepped:Connect(function()
    if freeCamEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Camera.CameraType = Enum.CameraType.Scriptable
        local targetPos = LocalPlayer.Character.HumanoidRootPart.Position - (Camera.CFrame.LookVector * zoomAmount)
        Camera.CFrame = CFrame.new(targetPos, LocalPlayer.Character.HumanoidRootPart.Position)
    end
end)

AddSlider(ProTab, {
  Name = "زاوية الرؤية (FOV)",
  MinValue = 70,
  MaxValue = 120,
  Default = 70,
  Increase = 1,
  Callback = function(v) Camera.FieldOfView = v end
})

AddButton(ProTab, {
  Name = "إعادة ضبط الكاميرا",
  Callback = function()
    freeCamEnabled = false
    Camera.CameraType = Enum.CameraType.Custom
    Camera.FieldOfView = 70
  end
})

-- Hitbox
local hitboxEnabled = false
AddToggle(ProTab, {
  Name = "تكبير الرؤوس (Hitbox)",
  Default = false,
  Callback = function(v) hitboxEnabled = v end
})

RunService.Stepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            if hitboxEnabled then
                head.Size = Vector3.new(10, 10, 10)
                head.Transparency = 0.5
                head.CanCollide = false
                head.Massless = true
            else
                head.Size = Vector3.new(2, 1, 1)
                head.Transparency = 0
                head.CanCollide = true
                head.Massless = false
            end
        end
    end
end)

-- Fake Lag
local fakeLagEnabled = false
AddToggle(ProTab, {
  Name = "تقطيع وهمي (Fake Lag)",
  Default = false,
  Callback = function(v) fakeLagEnabled = v end
})

task.spawn(function()
    while task.wait(0.5) do
        if fakeLagEnabled and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local oldPos = hrp.Position
                hrp.Position = oldPos + Vector3.new(0, 20, 0)
                task.wait(0.1)
                hrp.Position = oldPos
            end
        end
    end
end)

-- السيرفرات
AddToggle(ProTab, {
  Name = "مقاومة الطرد (Auto-Rejoin)",
  Default = false,
  Callback = function(v)
    if v then
        game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
            if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end
        end)
    end
  end
})

AddButton(ProTab, {
  Name = "🌐 التنقل لسيرفر خالي (Server Hop)",
  Callback = function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers - 2 and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            return
        end
    end
  end
})

-- حفظ المواقع
AddButton(ProTab, {
  Name = "📍 حفظ الموقع الحالي (مفتاح Z)",
  Callback = function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        _G.SavedPos = char.HumanoidRootPart.CFrame
        MakeNotifi({Title = "Waypoints", Text = "تم حفظ الموقع بنجاح!", Time = 3})
    end
  end
})

AddButton(ProTab, {
  Name = "🚀 العودة للموقع المحفوظ (مفتاح X)",
  Callback = function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and _G.SavedPos then
        char.HumanoidRootPart.CFrame = _G.SavedPos
        MakeNotifi({Title = "Waypoints", Text = "تم الانتقال للموقع!", Time = 3})
    else
        MakeNotifi({Title = "Waypoints", Text = "لم تقم بحفظ موقع بعد!", Time = 3})
    end
  end
})

-- إزالة الضباب
AddToggle(ProTab, {
  Name = "إزالة الضباب (No-Fog)",
  Default = false,
  Callback = function(v)
    if v then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") then obj.Density = 0 end
        end
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end
  end
})

-- ==========================================
-- 3. تبويب اللاعب (Player)
-- ==========================================
local PlayerTab = MakeTab({Name = "اللاعب"})

local walkSpeedValue = 16
local jumpPowerValue = 50
local infJumpOn = false

AddSlider(PlayerTab, {
  Name = "سرعة المشي",
  MinValue = 16,
  MaxValue = 200,
  Default = 16,
  Increase = 1,
  Callback = function(v) walkSpeedValue = v end
})

AddSlider(PlayerTab, {
  Name = "قوة القفز",
  MinValue = 50,
  MaxValue = 300,
  Default = 50,
  Increase = 5,
  Callback = function(v) jumpPowerValue = v end
})

AddToggle(PlayerTab, {
  Name = "قفز لا نهائي",
  Default = false,
  Callback = function(v) infJumpOn = v end
})

RunService.RenderStepped:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = walkSpeedValue
        hum.JumpPower = jumpPowerValue
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpOn then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

-- ==========================================
-- 4. تبويب القتال (Combat)
-- ==========================================
local CombatTab = MakeTab({Name = "القتال"})

AddToggle(CombatTab, {
  Name = "فحص الفريق",
  Default = true,
  Callback = function(v) _G.teamCheck = v end
})

AddToggle(CombatTab, {
  Name = "فحص الجدران",
  Default = true,
  Callback = function(v) _G.wallCheck = v end
})

AddToggle(CombatTab, {
  Name = "تفعيل الايمبوت",
  Default = false,
  Callback = function(v) _G.aimbotEnabled = v end
})

AddDropdown(CombatTab, {
  Name = "مكان استهداف الايمبوت",
  Options = {"Head", "HumanoidRootPart"},
  Default = "Head",
  Callback = function(v) _G.aimbotPart = v end
})

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 64
fovCircle.Filled = false
fovCircle.Visible = false

AddToggle(CombatTab, {
  Name = "إظهار دائرة النطاق",
  Default = false,
  Callback = function(v) fovCircle.Visible = v end
})

AddSlider(CombatTab, {
  Name = "حجم دائرة النطاق",
  MinValue = 50,
  MaxValue = 500,
  Default = 140,
  Increase = 1,
  Callback = function(v) _G.fovRadius = v end
})

local function isVisible(part, char)
    if not _G.wallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local filterList = {LocalPlayer.Character}
    if char then table.insert(filterList, char) end
    raycastParams.FilterDescendantsInstances = filterList
    return Workspace:Raycast(origin, direction, raycastParams) == nil
end

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fovCircle.Radius = _G.fovRadius
    if _G.aimbotEnabled then
        local closest, minDist = nil, _G.fovRadius
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                if not _G.teamCheck or plr.Team ~= LocalPlayer.Team then
                    local part = plr.Character:FindFirstChild(_G.aimbotPart)
                    if part and isVisible(part, plr.Character) then
                        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                            if mag < minDist then minDist, closest = mag, part end
                        end
                    end
                end
            end
        end
        if closest then Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position) end
    end
end)

-- ==========================================
-- 5. تبويب كشف الأماكن (ESP)
-- ==========================================
local EspTab = MakeTab({Name = "كشف الأماكن"})

local espBox, espName, espDist, espHealth, espTracer, espHigh = false, false, false, false, false, false
local currentEspColor = "أحمر"
local rainbowMode = false

AddToggle(EspTab, { Name = "مربعات", Default = false, Callback = function(v) espBox = v end })
AddToggle(EspTab, { Name = "الأسماء", Default = false, Callback = function(v) espName = v end })
AddToggle(EspTab, { Name = "المسافة", Default = false, Callback = function(v) espDist = v end })
AddToggle(EspTab, { Name = "الصحة", Default = false, Callback = function(v) espHealth = v end })
AddToggle(EspTab, { Name = "خطوط التتبع", Default = false, Callback = function(v) espTracer = v end })
AddToggle(EspTab, { Name = "التظليل", Default = false, Callback = function(v) espHigh = v end })
AddToggle(EspTab, { Name = "رينبو", Default = false, Callback = function(v) rainbowMode = v end })
AddDropdown(EspTab, { Name = "لون الكشف", Options = {"أحمر", "أخضر", "أزرق", "أصفر", "أبيض", "وردي"}, Default = "أحمر", Callback = function(v) currentEspColor = v end })

local function getSelectedColor(hue)
    if rainbowMode then return Color3.fromHSV(hue, 1, 1) end
    if currentEspColor == "أخضر" then return Color3.fromRGB(0, 255, 0)
    elseif currentEspColor == "أزرق" then return Color3.fromRGB(0, 150, 255)
    elseif currentEspColor == "أصفر" then return Color3.fromRGB(255, 255, 0)
    elseif currentEspColor == "أبيض" then return Color3.fromRGB(255, 255, 255)
    elseif currentEspColor == "وردي" then return Color3.fromRGB(255, 0, 255)
    else return Color3.fromRGB(255, 0, 0) end
end

local ESP_Data = {}
local rainbowHue = 0

RunService.RenderStepped:Connect(function(dt)
    rainbowHue = (rainbowHue + dt * 0.5) % 1
    local activeColor = getSelectedColor(rainbowHue)

    for plr, data in pairs(ESP_Data) do
        if not plr or not plr.Parent or not plr.Character then
            if data.Box then data.Box:Remove() end
            if data.Text then data.Text:Remove() end
            if data.Tracer then data.Tracer:Remove() end
            ESP_Data[plr] = nil
        end
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if char and hrp and head and hum and hum.Health > 0 then
                if not ESP_Data[plr] then
                    ESP_Data[plr] = {Box = Drawing.new("Square"), Text = Drawing.new("Text"), Tracer = Drawing.new("Line")}
                    ESP_Data[plr].Box.Thickness, ESP_Data[plr].Box.Filled = 1.5, false
                    ESP_Data[plr].Text.Size, ESP_Data[plr].Text.Center, ESP_Data[plr].Text.Outline = 14, true, true
                    ESP_Data[plr].Tracer.Thickness = 1.5
                end

                local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local dist = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
                local hp = math.floor((hum.Health / hum.MaxHealth) * 100)

                local data = ESP_Data[plr]

                if onScreen then
                    if espBox then
                        local h = math.abs(headPos.Y - legPos.Y)
                        local w = h / 1.5
                        data.Box.Size = Vector2.new(w, h)
                        data.Box.Position = Vector2.new(hrpPos.X - w/2, hrpPos.Y - h/2)
                        data.Box.Color = activeColor
                        data.Box.Visible = true
                    else data.Box.Visible = false end

                    if espName or espDist or espHealth then
                        local str = plr.Name
                        if espDist then str = str .. " [" .. dist .. "m]" end
                        if espHealth then str = str .. " - " .. hp .. "%" end
                        data.Text.Text = str
                        data.Text.Position = Vector2.new(hrpPos.X, headPos.Y - 18)
                        data.Text.Color = activeColor
                        data.Text.Visible = true
                    else data.Text.Visible = false end

                    if espTracer then
                        data.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        data.Tracer.To = Vector2.new(hrpPos.X, hrpPos.Y)
                        data.Tracer.Color = activeColor
                        data.Tracer.Visible = true
                    else data.Tracer.Visible = false end
                else
                    data.Box.Visible = false
                    data.Text.Visible = false
                    data.Tracer.Visible = false
                end

                if espHigh then
                    if not char:FindFirstChild("ESP_Highlight") then
                        local hl = Instance.new("Highlight", char)
                        hl.Name, hl.FillTransparency = "ESP_Highlight", 0.5
                    end
                    if char:FindFirstChild("ESP_Highlight") then char.ESP_Highlight.FillColor = activeColor end
                elseif char:FindFirstChild("ESP_Highlight") then 
                    char.ESP_Highlight:Destroy() 
                end
            else
                if ESP_Data[plr] then
                    ESP_Data[plr].Box.Visible = false
                    ESP_Data[plr].Text.Visible = false
                    ESP_Data[plr].Tracer.Visible = false
                end
                if char and char:FindFirstChild("ESP_Highlight") then char.ESP_Highlight:Destroy() end
            end
        end
    end
end)

-- ==========================================
-- 6. تبويب التنقل (Teleport)
-- ==========================================
local TeleportTab = MakeTab({Name = "التنقل"})

local selectedPlr = nil
local function getNames()
    local t = {}
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(t, p.Name) end end
    if #t == 0 then table.insert(t, "لا يوجد لاعبين") end
    return t
end

AddDropdown(TeleportTab, { Name = "اختر اللاعب", Options = getNames(), Default = "اختر اللاعب", Callback = function(v) selectedPlr = v end })
AddButton(TeleportTab, { Name = "تحديث القائمة", Callback = function() end })
AddButton(TeleportTab, { 
  Name = "الانتقال إلى اللاعب", 
  Callback = function()
    if selectedPlr and selectedPlr ~= "اختر اللاعب" and selectedPlr ~= "لا يوجد لاعبين" then
        local p = Players:FindFirstChild(selectedPlr)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
  end
})

AddButton(TeleportTab, {
  Name = "الحصول على أداة Click TP",
  Callback = function()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    if not backpack:FindFirstChild("Click Teleport") then
        local Tool = Instance.new("Tool")
        Tool.Name = "Click Teleport"
        Tool.RequiresHandle = false
        Tool.Parent = backpack
        local Mouse = LocalPlayer:GetMouse()
        Tool.Activated:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and Mouse.Target then hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end
        end)
    end
  end
})

-- ==========================================
-- 7. تبويب الترول (Troll)
-- ==========================================
local TrollTab = MakeTab({Name = "الترول"})

local noclip, fling = false, false
AddToggle(TrollTab, { Name = "اختفاء التصادم (Noclip)", Default = false, Callback = function(v) noclip = v end })
AddToggle(TrollTab, { Name = "طرد اللاعبين (Fling)", Default = false, Callback = function(v) fling = v end })

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

RunService.Heartbeat:Connect(function()
    if fling and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local v = hrp.Velocity
        hrp.Velocity = Vector3.new(10000, 10000, 10000)
        RunService.RenderStepped:Wait()
        hrp.Velocity = v
    end
end)

-- ==========================================
-- 8. تبويب البيئة (World)
-- ==========================================
local WorldTab = MakeTab({Name = "البيئة"})

AddButton(WorldTab, { Name = "إعادة الاتصال (Rejoin)", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end })

AddSlider(WorldTab, {
  Name = "الوقت",
  MinValue = 0,
  MaxValue = 24,
  Default = 12,
  Increase = 0.5,
  Callback = function(v) Lighting.ClockTime = v Lighting.TimeOfDay = string.format("%02d:00:00", math.floor(v)) end
})

AddSlider(WorldTab, {
  Name = "سطوع الشمس",
  MinValue = 0,
  MaxValue = 5,
  Default = 1,
  Increase = 0.1,
  Callback = function(v) Lighting.Brightness = v end
})

-- ==========================================
-- 9. تبويب الإعدادات (Settings)
-- ==========================================
local SettingsTab = MakeTab({Name = "الإعدادات"})

AddButton(SettingsTab, {
  Name = "زر إخفاء/إظهار الواجهة (RightCtrl)",
  Callback = function()
    -- هذه الميزة موجودة في MakeWindow تلقائياً
  end
})

local perfGui = Instance.new("ScreenGui")
perfGui.Name = "FOLDARREPerfDisplay"
perfGui.ResetOnSpawn = false
perfGui.DisplayOrder = 9999999
perfGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local perfLabel = Instance.new("TextLabel", perfGui)
perfLabel.Size = UDim2.new(0, 190, 0, 30)
perfLabel.Position = UDim2.new(0.015, 0, 0.015, 0)
perfLabel.BackgroundTransparency = 0.3
perfLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
perfLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
perfLabel.TextSize = 13
perfLabel.Font = Enum.Font.FredokaOne
perfLabel.Visible = false
perfLabel.Text = " FPS: 0 | Ping: 0ms"
Instance.new("UICorner", perfLabel).CornerRadius = UDim.new(0, 6)

AddToggle(SettingsTab, {
  Name = "عرض FPS والـ Ping",
  Default = false,
  Callback = function(v) perfLabel.Visible = v end
})

local lastUpdate = 0
RunService.RenderStepped:Connect(function(dt)
    if perfLabel.Visible then
        lastUpdate = lastUpdate + dt
        if lastUpdate >= 0.15 then
            lastUpdate = 0
            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            perfLabel.Text = " FPS: " .. math.floor(1/dt) .. " | Ping: " .. ping .. "ms"
        end
    end
end)

-- الشعار العائم
local watermarkGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
watermarkGui.Name = "FOLDARREWatermark"
watermarkGui.ResetOnSpawn = false
watermarkGui.DisplayOrder = 9999999
watermarkGui.IgnoreGuiInset = true

local watermark = Instance.new("TextLabel", watermarkGui)
watermark.Size = UDim2.new(0, 250, 0, 30)
watermark.Position = UDim2.new(1, -260, 0, 20)
watermark.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
watermark.BackgroundTransparency = 0.3
watermark.Text = "FOLDARRE Hub | @MUJTABACOMEZ1 | FPS: 0"
watermark.TextColor3 = Color3.fromRGB(34, 197, 94)
watermark.Font = Enum.Font.FredokaOne
watermark.TextSize = 12
watermark.Visible = true
Instance.new("UICorner", watermark).CornerRadius = UDim.new(0, 6)

local frames = 0
RunService.RenderStepped:Connect(function() frames = frames + 1 end)
task.spawn(function()
    while watermarkGui.Parent do
        task.wait(0.5)
        watermark.Text = "FOLDARRE Hub | @MUJTABACOMEZ1 | FPS: " .. frames * 2
        frames = 0
    end
end)

AddToggle(SettingsTab, {
  Name = "إظهار الشعار العائم (Watermark)",
  Default = true,
  Callback = function(v) watermark.Visible = v end
})

MakeNotifi({Title = "FOLDARRE", Text = "تم تحميل السكربت بنجاح!", Time = 5})
