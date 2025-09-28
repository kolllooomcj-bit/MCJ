-- // 🟢 MCJ Hub GUI 🟢 //
-- LocalScript (Executor hoặc StarterPlayerScripts)

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MCJ_MainGui"
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150) -- luôn giữa màn hình
frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "⚡ MCJ Hub ⚡"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Scrolling Container
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0,5,0,45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Auto size canvas
layout.Changed:Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

-- Function tạo nút
local function makeButton(name, callback)
	local btn = Instance.new("TextButton", scroll)
	btn.Size = UDim2.new(0,260,0,45)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.fromRGB(0,255,150)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = name
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
	btn.MouseButton1Click:Connect(callback)
end

-- =========================
-- NÚT 11: Fly + Mega Block
-- =========================
local flyBlockGui -- để lưu GUI phụ

makeButton("Fly + Mega Block", function()
    if flyBlockGui and flyBlockGui.Parent then
        flyBlockGui:Destroy()
        flyBlockGui = nil
        return
    end

    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- GUI gốc
    flyBlockGui = Instance.new("ScreenGui")
    flyBlockGui.Parent = player:WaitForChild("PlayerGui")
    flyBlockGui.Name = "MCJ_FlyBlock"
    flyBlockGui.ResetOnSpawn = false

    -- Frame chính
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 220, 0, 150)
    mainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = true
    mainFrame.Parent = flyBlockGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,10)

    -- Tiêu đề
    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1,0,0,30)
    title.Text = "🟢 MCJ Script"
    title.TextColor3 = Color3.fromRGB(0,255,150)
    title.BackgroundColor3 = Color3.fromRGB(40,40,40)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    Instance.new("UICorner", title).CornerRadius = UDim.new(0,8)

    -- Hàm tạo nút trong frame
    local function makeButton(name, posY, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,200,0,40)
        btn.Position = UDim2.new(0,10,0,posY)
        btn.Text = name
        btn.TextSize = 18
        btn.Font = Enum.Font.GothamBold
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Parent = mainFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Fly
    local flying = false
    local bodyVel
    local flyBtn
    flyBtn = makeButton("🚀 Fly Up", 40, function()
        flying = not flying
        if flying then
            bodyVel = Instance.new("BodyVelocity", hrp)
            bodyVel.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVel.Velocity = Vector3.new(0, 30, 0)
            flyBtn.Text = "⛔ Stop Fly"
        else
            if bodyVel then bodyVel:Destroy() bodyVel = nil end
            flyBtn.Text = "🚀 Fly Up"
        end
    end)

    -- Mega Block
    local blockActive = false
    local megaBlock
    local blockBtn = makeButton("🟦 Mega Block", 90, function()
        blockActive = not blockActive
        if blockActive then
            megaBlock = Instance.new("Part")
            megaBlock.Size = Vector3.new(10000, 1, 10000)
            megaBlock.Anchored = true
            megaBlock.Position = Vector3.new(hrp.Position.X, hrp.Position.Y - 5, hrp.Position.Z)
            megaBlock.Color = Color3.fromRGB(100, 100, 255)
            megaBlock.Transparency = 0.8
            megaBlock.Parent = workspace
            blockBtn.Text = "⛔ Remove Block"
        else
            if megaBlock then megaBlock:Destroy() megaBlock = nil end
            blockBtn.Text = "🟦 Mega Block"
        end
    end)
end)

-- =========================
-- NÚT 1: Float + ESP (MCJ.lua)
-- =========================
makeButton("Float + ESP", function()
	loadstring([[-- MCJ.lua
-- MCJ Hub: Galaxy UI + Full ESP (Box/Outline/Body/Name/Studs/Line) + Small Float GUI (1 button)
-- Place as LocalScript in StarterPlayerScripts (client-side)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Appearance / utils
local UI_FONT = Enum.Font.GothamBold
local DEFAULT_ESP_COLOR = Color3.fromRGB(0, 200, 255)

local function safeDestroy(obj)
    if obj and obj.Parent then
        pcall(function() obj:Destroy() end)
    end
end

local function makeCorner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius or 8)
    return c
end

local function makeStroke(parent, thickness, color)
    local s = Instance.new("UIStroke", parent)
    s.Thickness = thickness or 1.2
    s.Color = color or Color3.new(1,1,1)
    s.Transparency = 0.35
    return s
end

local function applyGalaxyGradient(parent)
    local g = Instance.new("UIGradient", parent)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 64, 255)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 80, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
    }
    g.Rotation = 45
    return g
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MCJ_Hub"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Open button (small)
local openBtn = Instance.new("TextButton")
openBtn.Name = "MCJ_Open"
openBtn.Size = UDim2.new(0,120,0,40)
openBtn.BackgroundColor3 = Color3.fromRGB(18,18,20)
openBtn.Font = UI_FONT
openBtn.TextSize = 18
openBtn.TextColor3 = Color3.fromRGB(240,240,240)
openBtn.Text = "MCJ Hub"
openBtn.AutoButtonColor = true
openBtn.Parent = screenGui
makeCorner(openBtn,10)
makeStroke(openBtn,1,Color3.fromRGB(255,255,255))

-- Main panel (center)
local panel = Instance.new("Frame")
panel.Name = "MCJ_Panel"
panel.Size = UDim2.new(0,420,0,420) -- a bit taller to fit scroll
panel.Position = UDim2.new(0.5,0,0.5,0)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(18,18,24)
panel.Visible = false
panel.Parent = screenGui
makeCorner(panel,14)
makeStroke(panel,1.5,Color3.fromRGB(255,255,255))
applyGalaxyGradient(panel)

-- Header
local header = Instance.new("Frame", panel)
header.Name = "Header"
header.Size = UDim2.new(1,-20,0,56)
header.Position = UDim2.new(0,10,0,8)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.7,0,1,0)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "MCJ — ESP & Float"
title.Font = UI_FONT
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(245,245,250)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,70,0,36)
closeBtn.Position = UDim2.new(1,-74,0,10)
closeBtn.Text = "Close"
closeBtn.Font = UI_FONT
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(160,40,60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
makeCorner(closeBtn,8)
makeStroke(closeBtn,1,Color3.fromRGB(255,255,255))

-- SUB: right side info (unchanged)
local rightCol = Instance.new("Frame", panel)
rightCol.Size = UDim2.new(0,132,0,320)
rightCol.Position = UDim2.new(1,-144,0,72)
rightCol.BackgroundTransparency = 1

local infoLabel = Instance.new("TextLabel", rightCol)
infoLabel.Size = UDim2.new(1,0,0,220)
infoLabel.Position = UDim2.new(0,0,0,0)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = UI_FONT
infoLabel.TextSize = 13
infoLabel.TextColor3 = Color3.fromRGB(220,220,230)
infoLabel.Text = "Notes:\n• ESP runs client-side.\n• Line uses Beam (Head → HRP).\n• Float uses an anchored part under HRP.\n• Press F to toggle float popup."
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- LEFT column: now a ScrollingFrame (only change requested)
local leftCol = Instance.new("ScrollingFrame", panel)
leftCol.Name = "LeftScroll"
leftCol.Size = UDim2.new(0,260,0,320)
leftCol.Position = UDim2.new(0,12,0,72)
leftCol.BackgroundTransparency = 1
leftCol.ScrollBarThickness = 6
leftCol.ScrollBarImageColor3 = Color3.fromRGB(180,180,200)
leftCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
leftCol.CanvasSize = UDim2.new(0,0,0,0)
leftCol.Parent = panel

local listLayout = Instance.new("UIListLayout", leftCol)
listLayout.Padding = UDim.new(0,8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    leftCol.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y + 12)
end)

-- Helper to create toggle rows inside leftCol
local function createToggleRow(parent, labelText, startOn)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10, 0, 44)
    container.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(0.68,0,1,0)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Font = UI_FONT
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(240,240,245)
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0.32, -6, 0, 34)
    btn.Position = UDim2.new(0.68, 6, 0, 5)
    btn.Font = UI_FONT
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    makeCorner(btn,8)
    makeStroke(btn,1,Color3.fromRGB(255,255,255))
    btn.BackgroundColor3 = startOn and Color3.fromRGB(20,170,100) or Color3.fromRGB(120,30,50)
    btn.Text = startOn and "ON" or "OFF"

    return lbl, btn, container
end

-- Create toggles
local masterLbl, masterBtn = createToggleRow(leftCol, "ESP Master", false)
local boxLbl, boxBtn = createToggleRow(leftCol, "Box ESP", false)
local outlineLbl, outlineBtn = createToggleRow(leftCol, "Outline (Highlight)", false)
local bodyLbl, bodyBtn = createToggleRow(leftCol, "Body Fill", false)
local nameLbl, nameBtn = createToggleRow(leftCol, "Name ESP", false)
local studsLbl, studsBtn = createToggleRow(leftCol, "Studs (distance)", false)
local lineLbl, lineBtn = createToggleRow(leftCol, "Line ESP (Beam)", false)
local floatLbl, floatBtn = createToggleRow(leftCol, "Float (open popup)", false)

-- Float popup small (hidden)
local floatGui = Instance.new("Frame")
floatGui.Name = "MCJ_FloatPopup"
floatGui.Size = UDim2.new(0,160,0,90)
floatGui.Position = UDim2.new(1,-180,0.5,-45)
floatGui.BackgroundColor3 = Color3.fromRGB(18,18,28)
floatGui.Visible = false
floatGui.Parent = screenGui
makeCorner(floatGui,10)
makeStroke(floatGui,1,Color3.fromRGB(255,255,255))
applyGalaxyGradient(floatGui)

local floatToggleBtn = Instance.new("TextButton", floatGui)
floatToggleBtn.Size = UDim2.new(0.9,0,0,40)
floatToggleBtn.Position = UDim2.new(0.05,0,0.2,0)
floatToggleBtn.Font = UI_FONT
floatToggleBtn.TextSize = 16
floatToggleBtn.Text = "Float: OFF"
floatToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
floatToggleBtn.BackgroundColor3 = Color3.fromRGB(110,16,60)
makeCorner(floatToggleBtn,8)
makeStroke(floatToggleBtn,1,Color3.fromRGB(255,255,255))

-- SETTINGS & storage
local SETTINGS = {
    Master = false,
    Box = false,
    Outline = false,
    Body = false,
    Name = false,
    Studs = false,
    Line = false,
}
local ESP_COLOR = DEFAULT_ESP_COLOR
local visuals = {} -- visuals[player] = table of created objects
local localAttach = nil

-- create/destroy local head attachment for beams
local function ensureLocalAttach()
    if localAttach and localAttach.Parent and localAttach.Parent:IsDescendantOf(LocalPlayer.Character or workspace) then
        return localAttach
    end
    safeDestroy(localAttach)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        localAttach = Instance.new("Attachment")
        localAttach.Name = "MCJ_LocalAttach"
        localAttach.Parent = LocalPlayer.Character.Head
    end
    return localAttach
end

-- create visuals for a player according to SETTINGS
local function createVisualsFor(plr)
    if not plr or not plr.Character or not plr.Character.Parent then return end
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not hrp then return end

    local v = visuals[plr]
    if not v then v = {}; visuals[plr] = v end

    -- SelectionBox (Box)
    if SETTINGS.Master and SETTINGS.Box then
        if not v.selectionBox then
            local sb = Instance.new("SelectionBox")
            sb.Name = "MCJ_SelectionBox"
            sb.Adornee = hrp
            sb.LineThickness = 0.02
            sb.SurfaceTransparency = 1
            sb.Parent = hrp
            v.selectionBox = sb
        else
            v.selectionBox.Adornee = hrp
        end
        if v.selectionBox then v.selectionBox.Color3 = ESP_COLOR end
    else
        if v.selectionBox then safeDestroy(v.selectionBox); v.selectionBox = nil end
    end

    -- Highlight (Outline + Body)
    if SETTINGS.Master and (SETTINGS.Outline or SETTINGS.Body) then
        if not v.highlight then
            local hl = Instance.new("Highlight")
            hl.Name = "MCJ_Highlight"
            hl.Adornee = char
            hl.Parent = workspace
            v.highlight = hl
        end
        if v.highlight then
            v.highlight.OutlineColor = ESP_COLOR
            v.highlight.FillColor = ESP_COLOR
            v.highlight.OutlineTransparency = SETTINGS.Outline and 0 or 1
            v.highlight.FillTransparency = SETTINGS.Body and 0.6 or 1
        end
    else
        if v.highlight then safeDestroy(v.highlight); v.highlight = nil end
    end

    -- Billboard (Name + Studs)
    if SETTINGS.Master and (SETTINGS.Name or SETTINGS.Studs) then
        if not v.billboard then
            local bb = Instance.new("BillboardGui")
            bb.Name = "MCJ_Billboard"
            bb.Adornee = hrp
            bb.Size = UDim2.new(0,180,0,40)
            bb.StudsOffset = Vector3.new(0,2.6,0)
            bb.AlwaysOnTop = true
            bb.Parent = screenGui

            local nameLab = Instance.new("TextLabel", bb)
            nameLab.Name = "MCJ_Name"
            nameLab.Size = UDim2.new(1,0,0.55,0)
            nameLab.BackgroundTransparency = 1
            nameLab.Font = UI_FONT
            nameLab.TextSize = 16
            nameLab.TextColor3 = ESP_COLOR
            nameLab.TextStrokeTransparency = 0.8

            local distLab = Instance.new("TextLabel", bb)
            distLab.Name = "MCJ_Dist"
            distLab.Size = UDim2.new(1,0,0.45,0)
            distLab.Position = UDim2.new(0,0,0.55,0)
            distLab.BackgroundTransparency = 1
            distLab.Font = UI_FONT
            distLab.TextSize = 14
            distLab.TextColor3 = ESP_COLOR
            distLab.TextStrokeTransparency = 0.8

            v.billboard = bb
            v.nameLab = nameLab
            v.distLab = distLab
        end
        if v.billboard then
            v.billboard.Adornee = hrp
            v.nameLab.Text = SETTINGS.Name and plr.Name or ""
        end
    else
        if v.billboard then safeDestroy(v.billboard); v.billboard=nil; v.nameLab=nil; v.distLab=nil end
    end

    -- Beam (Line) from local head -> target hrp
    if SETTINGS.Master and SETTINGS.Line and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        ensureLocalAttach()
        if localAttach then
            if not v.attach1 then
                local a1 = Instance.new("Attachment")
                a1.Name = "MCJ_Attach_"..plr.Name
                a1.Parent = hrp
                v.attach1 = a1
            end
            if not v.beam then
                local beam = Instance.new("Beam")
                beam.Name = "MCJ_Beam"
                beam.Attachment0 = localAttach
                beam.Attachment1 = v.attach1
                beam.FaceCamera = true
                beam.LightEmission = 0.9
                beam.Width0 = 0.06
                beam.Width1 = 0.06
                beam.Color = ColorSequence.new(ESP_COLOR)
                beam.Parent = workspace
                v.beam = beam
            else
                v.beam.Attachment0 = localAttach
                if v.beam then v.beam.Color = ColorSequence.new(ESP_COLOR) end
            end
        end
    else
        if v.beam then safeDestroy(v.beam); v.beam=nil end
        if v.attach1 then safeDestroy(v.attach1); v.attach1=nil end
    end
end

local function removeVisualsFor(plr)
    local v = visuals[plr]
    if not v then return end
    if v.selectionBox then safeDestroy(v.selectionBox) end
    if v.highlight then safeDestroy(v.highlight) end
    if v.billboard then safeDestroy(v.billboard) end
    if v.beam then safeDestroy(v.beam) end
    if v.attach1 then safeDestroy(v.attach1) end
    visuals[plr] = nil
end

-- Update all players visuals (called when toggles change)
local function updateAllPlayers()
    -- remove visuals for players that left
    for pl,_ in pairs(visuals) do
        if not Players:FindFirstChild(pl.Name) then
            removeVisualsFor(pl)
        end
    end
    if not SETTINGS.Master then
        -- remove everything if master off
        for pl,_ in pairs(visuals) do
            removeVisualsFor(pl)
        end
        return
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Character and plr.Character.Parent and (plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Torso")) then
                createVisualsFor(plr)
            else
                removeVisualsFor(plr)
            end
        end
    end
end

-- Continuous update (distance labels, beam color)
RunService.RenderStepped:Connect(function()
    if SETTINGS.Master then
        for plr,v in pairs(visuals) do
            if plr and v and plr.Character and plr.Character.Parent and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Torso")
                -- studs distance
                if v.distLab and SETTINGS.Studs and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local mypos = LocalPlayer.Character.HumanoidRootPart.Position
                    local theirpos = hrp.Position
                    v.distLab.Text = string.format("%.1f studs", (mypos - theirpos).Magnitude)
                elseif v.distLab then
                    v.distLab.Text = ""
                end
                -- beam color update
                if v.beam then
                    v.beam.Color = ColorSequence.new(ESP_COLOR)
                    if (not v.attach1) or (not v.attach1.Parent) then
                        safeDestroy(v.beam); v.beam=nil
                        if v.attach1 then safeDestroy(v.attach1); v.attach1=nil end
                    end
                end
            end
        end
    end
end)

-- Player join/leave handlers
Players.PlayerRemoving:Connect(function(plr)
    removeVisualsFor(plr)
end)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.25)
        if SETTINGS.Master then createVisualsFor(plr) end
    end)
end)

-- UI toggle wiring (change btn UI and SETTINGS, then update visuals)
local function setToggleUI(btn, state)
    btn.BackgroundColor3 = state and Color3.fromRGB(20,170,100) or Color3.fromRGB(120,30,50)
    btn.Text = state and "ON" or "OFF"
end

-- Helper to wire toggles
local function wireToggle(btn, settingKey, extra)
    btn.MouseButton1Click:Connect(function()
        SETTINGS[settingKey] = not SETTINGS[settingKey]
        setToggleUI(btn, SETTINGS[settingKey])
        -- if master toggled off -> remove visuals
        if settingKey == "Master" then
            if not SETTINGS.Master then
                -- remove all visuals
                for pl,_ in pairs(visuals) do removeVisualsFor(pl) end
            end
        end
        -- special cases
        if settingKey == "Line" and SETTINGS.Line then
            ensureLocalAttach()
        end
        updateAllPlayers()
    end)
end

wireToggle(masterBtn, "Master")
wireToggle(boxBtn, "Box")
wireToggle(outlineBtn, "Outline")
wireToggle(bodyBtn, "Body")
wireToggle(nameBtn, "Name")
wireToggle(studsBtn, "Studs")
wireToggle(lineBtn, "Line")

-- Float toggle opens small popup
floatBtn.MouseButton1Click:Connect(function()
    floatGui.Visible = not floatGui.Visible
    setToggleUI(floatBtn, floatGui.Visible)
end)

-- Float implementation (small popup button handles enabling float)
local floatActive = false
local floatPart = nil
local floatConn = nil
local FLOAT_HEIGHT = 3

local function enableFloat()
    if floatActive then return end
    floatActive = true
    if not floatPart then
        floatPart = Instance.new("Part")
        floatPart.Name = "MCJ_FloatPart"
        floatPart.Size = Vector3.new(6,1,6)
        floatPart.Anchored = true
        floatPart.CanCollide = true
        floatPart.Transparency = 0.45
        floatPart.Parent = workspace
    end
    if floatConn then floatConn:Disconnect() end
    floatConn = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and floatPart then
            floatPart.Position = char.HumanoidRootPart.Position - Vector3.new(0, FLOAT_HEIGHT, 0)
        end
    end)
end

local function disableFloat()
    if floatConn then
        pcall(function() floatConn:Disconnect() end)
        floatConn = nil
    end
    if floatPart then safeDestroy(floatPart); floatPart = nil end
    floatActive = false
end

floatToggleBtn.MouseButton1Click:Connect(function()
    if not floatActive then
        enableFloat()
        floatToggleBtn.Text = "Float: ON"
        floatToggleBtn.BackgroundColor3 = Color3.fromRGB(20,170,100)
    else
        disableFloat()
        floatToggleBtn.Text = "Float: OFF"
        floatToggleBtn.BackgroundColor3 = Color3.fromRGB(110,16,60)
    end
end)

-- Toggle float popup with F
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        floatGui.Visible = not floatGui.Visible
        setToggleUI(floatBtn, floatGui.Visible)
    end
end)

-- Dragging panel (header)
do
    local dragging, dragInput, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Open/close UI
openBtn.MouseButton1Click:Connect(function()
    panel.Visible = true
    openBtn.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    openBtn.Visible = true
end)

-- Cleanup on respawn
LocalPlayer.CharacterRemoving:Connect(function()
    if localAttach then safeDestroy(localAttach); localAttach = nil end
    for pl,_ in pairs(visuals) do removeVisualsFor(pl) end
    disableFloat()
end)

-- Initialize visuals for existing players if master on
for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        -- ensure we create visuals only when toggled on
        plr.CharacterAdded:Connect(function()
            task.wait(0.25)
            if SETTINGS.Master then createVisualsFor(plr) end
        end)
    end
end

-- Final ready message
print("[MCJ] Loaded: Full ESP + Float (Scroll support).")

openBtn.Position = UDim2.new(0,18,0.48,-180)
		print("[MCJ] ESP + Float executed.")
	]])()
end)

-- =========================
-- NÚT 2: Float VIP
-- =========================
makeButton("Float VIP", function()
	loadstring([[local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")

		local player = Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		local humanoid = char:WaitForChild("Humanoid")

		local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
		gui.Name = "FloatNewlGui"
		gui.ResetOnSpawn = false

		local btn = Instance.new("TextButton", gui)
		btn.Size = UDim2.new(0,200,0,50)
		btn.Position = UDim2.new(0.05,0,0.2,0)
		btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
		btn.TextColor3 = Color3.fromRGB(0,255,150)
		btn.Text = "MCJ FLOAT"
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 22
		btn.Active = true
		btn.Draggable = true
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

		local enabled = false
		local block
		local moveConn
		local floatConn

		local function enableWalk()
			if enabled then return end
			enabled = true
			btn.Text = "Float ON"

			humanoid.JumpPower = 0  
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)  

			block = Instance.new("Part")  
			block.Size = Vector3.new(10000,1,10000)  
			block.Anchored = true  
			block.CanCollide = true  
			block.Transparency = 1  
			block.Position = Vector3.new(hrp.Position.X, hrp.Position.Y - 3, hrp.Position.Z)  
			block.Parent = workspace  

			moveConn = RunService.RenderStepped:Connect(function()  
				local cam = workspace.CurrentCamera  
				local look = cam.CFrame.LookVector  
				local dir = Vector3.new(look.X, 0, look.Z).Unit  
				humanoid:Move(dir, false)  
			end)  

			floatConn = RunService.Heartbeat:Connect(function(dt)  
				if block and block.Parent then  
					block.Position = block.Position - Vector3.new(0, 1 * dt, 0)  
				end  
			end)
		end

		local function disableWalk()
			enabled = false
			btn.Text = "Float OFF"
			humanoid.JumpPower = 50  
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)  
			if moveConn then moveConn:Disconnect() end  
			if floatConn then floatConn:Disconnect() end  
			if block then block:Destroy() end
		end

		btn.MouseButton1Click:Connect(function()
			if enabled then disableWalk() else enableWalk() end
		end)

		player.CharacterAdded:Connect(function(c)
			char = c
			hrp = c:WaitForChild("HumanoidRootPart")
			humanoid = c:WaitForChild("Humanoid")
		end)
		print("[MCJ] Float VIP executed.")
		-- Float VIP script ở đây
		print("[MCJ] Float VIP executed.")
	]])()
end)

-- =========================
-- NÚT 3: FLOAT Gui (Pastefy)
-- =========================
makeButton("FLOAT Gui", function()
	loadstring(game:HttpGet("https://pastefy.app/YkHHDqR2/raw"))()
end)

-- =========================
-- NÚT 4: KurdHub
-- =========================
makeButton("KurdHub", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Ninja10908/S4/refs/heads/main/Kurdhub"))()
end)

-- =========================
-- NÚT 5: Lonnon
-- =========================
makeButton("Lonnon", function()
	loadstring(game:HttpGet("https://pastefy.app/MJw2J4T6/raw"))()
end)

-- =========================
-- NÚT 6: Delfi
-- =========================
makeButton("Delfi", function()
	loadstring(game:HttpGet("https://pastefy.app/UTq45GC2/raw"))()
end)

-- =========================
-- NÚT 7: Chilli Hub
-- =========================
makeButton("Chilli Hub", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
end)

-- =========================
-- Hide/Show Button (luôn góc trên phải)
-- =========================
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,120,0,40)
toggleBtn.Position = UDim2.new(1, -130, 0, 10) -- sát góc phải trên
toggleBtn.AnchorPoint = Vector2.new(0,0)
toggleBtn.Text = "Hide GUI"
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,8)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleBtn.Text = frame.Visible and "Hide GUI" or "Show GUI"
end)

-- =========================
-- NÚT 8: Maranda
-- =========================
makeButton("Maranda", function()
    loadstring(game:HttpGet("https://pastefy.app/JJVhs3rK/raw"))()
end)

-- =========================
-- NÚT 9: Anti Kick
-- =========================
makeButton("Anti Kick", function()
    -- Ngăn chặn việc bị kick (hook Kick/Destroy)
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            warn("[MCJ] Anti Kick chặn Kick!")
            return nil
        end
        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
    print("[MCJ] Anti Kick đã bật.")
end)

-- =========================
-- NÚT 10: Kick Button
-- =========================
makeButton("Kick Button", function()
    local player = game.Players.LocalPlayer
    local gui = player:WaitForChild("PlayerGui")

    -- nếu GUI ẩn chưa tồn tại thì tạo
    local kickGui = gui:FindFirstChild("MCJ_KickGui")
    if not kickGui then
        kickGui = Instance.new("ScreenGui", gui)
        kickGui.Name = "MCJ_KickGui"
        kickGui.Enabled = false

        local btn = Instance.new("TextButton", kickGui)
        btn.Size = UDim2.new(0,200,0,50)
        btn.Position = UDim2.new(0.5,-100,0.5,-200)
        btn.Text = "Kick Me"
        btn.TextSize = 20
        btn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        btn.TextColor3 = Color3.new(1,1,1)

        btn.MouseButton1Click:Connect(function()
            player:Kick("Ngon thí.")
        end)
    end

    -- Bật/tắt gui
    kickGui.Enabled = not kickGui.Enabled
end)
