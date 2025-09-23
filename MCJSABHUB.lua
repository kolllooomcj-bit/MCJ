-- // 🟢 MCJ Hub GUI 🟢 //
-- LocalScript (Executor hoặc StarterPlayerScripts)

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MCJ_MainGui"
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
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

-- Hide/Show Button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,100,0,35)
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
-- NÚT 1: Float + ESP (MCJ.lua)
-- =========================
makeButton("Float + ESP", function()
	loadstring([[
		-- ⚡ MCJ ESP + Float ⚡
		-- (Thay đoạn code ESP + Float bạn muốn vào đây)
		print("[MCJ] ESP + Float executed.")
	]])()
end)

-- =========================
-- NÚT 2: Float VIP
-- =========================
makeButton("Float VIP", function()
	loadstring([[
		local Players = game:GetService("Players")
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

toggleBtn.Position = UDim2.new(0,800,0.8,-350)
