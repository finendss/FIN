local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
 
local player = Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local moneyStat = leaderstats:WaitForChild("Money")
 
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ToggleMoneyGui"
toggleGui.ResetOnSpawn = false
toggleGui.IgnoreGuiInset = true
toggleGui.Parent = player:WaitForChild("PlayerGui")
 
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 44, 0, 44)
button.Position = UDim2.new(0, 20, 1, -64)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
button.Text = "🤑"
button.Font = Enum.Font.GothamBold
button.TextSize = 22
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.AutoButtonColor = false
button.Active = true
button.Draggable = true
button.Parent = toggleGui
Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)
 
local function createMoneyGui()
	if player.PlayerGui:FindFirstChild("MoneyChangerUI") then return end
 
	local gui = Instance.new("ScreenGui")
	gui.Name = "MoneyChangerUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = player.PlayerGui
 
	local scale = Instance.new("UIScale")
	scale.Scale = UserInputService.TouchEnabled and 1 or 1.1
	scale.Parent = gui
 
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 240, 0, 180)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	frame.Active = true
	frame.Draggable = true
	frame.Parent = gui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
 
	local layout = Instance.new("UIListLayout", frame)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)
 
	local padding = Instance.new("UIPadding", frame)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
 
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 28)
	title.Text = "FIN 修改金钱(买一次后再第一次)"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 20
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.LayoutOrder = 0
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame
 
	local input = Instance.new("TextBox")
	input.Size = UDim2.new(1, 0, 0, 34)
	input.PlaceholderText = "数值"
	input.Text = ""
	input.Font = Enum.Font.Gotham
	input.TextSize = 16
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	input.ClearTextOnFocus = false
	input.LayoutOrder = 1
	input.Parent = frame
	Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
 
	local confirm = Instance.new("TextButton")
	confirm.Size = UDim2.new(1, 0, 0, 34)
	confirm.Text = "启动"
	confirm.Font = Enum.Font.GothamBold
	confirm.TextSize = 16
	confirm.TextColor3 = Color3.fromRGB(255, 255, 255)
	confirm.BackgroundColor3 = Color3.fromRGB(0, 160, 120)
	confirm.LayoutOrder = 2
	confirm.Parent = frame
	Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 6)
 
	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0, 24, 0, 24)
	close.Position = UDim2.new(1, -10, 0, -10)
	close.AnchorPoint = Vector2.new(1, 0)
	close.Text = "✖"
	close.Font = Enum.Font.GothamBold
	close.TextSize = 14
	close.TextColor3 = Color3.fromRGB(255, 255, 255)
	close.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
	close.Parent = frame
	Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)
 
	close.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)
 
	confirm.MouseButton1Click:Connect(function()
		local amount = tonumber(input.Text)
		if amount then
			moneyStat.Value = amount
			input.Text = ""
			TweenService:Create(confirm, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(0, 200, 150)
			}):Play()
			task.delay(0.5, function()
				TweenService:Create(confirm, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(0, 160, 120)
				}):Play()
			end)
		else
			input.Text = "Invalid!"
			task.delay(1.2, function()
				input.Text = ""
			end)
		end
	end)
end
 
button.MouseButton1Click:Connect(function()
	local existing = player.PlayerGui:FindFirstChild("MoneyChangerUI")
	if existing then
		existing:Destroy()
	else
		createMoneyGui()
	end
end)
