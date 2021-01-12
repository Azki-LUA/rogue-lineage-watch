local gg=getgenv
if gg().RanAlreadyRLGUI then
	warn'Nope!'
	return
end
gg().RanAlreadyRLGUI=false
local RL=Instance.new'ScreenGui'
local Title=Instance.new'TextLabel'
local Frame=Instance.new'Frame'
local PlayerList=Instance.new'ScrollingFrame'
local UIListLayout=Instance.new'UIListLayout'
local BaseButton=Instance.new'TextButton'
local CS=Instance.new'TextLabel'
RL.ResetOnSpawn=false
Title.Active=true
Title.BackgroundColor3=Color3.new(.176,.176,.176)
Title.BorderColor3=Color3.new(.45,.45,.45)
Title.BorderSizePixel=2
local UserInputService = game:GetService("UserInputService")
local gui = Title
local dragging
local dragInput
local dragStart
local startPos
local function update(input)
	local delta = input.Position - dragStart
	gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
gui.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
Title.Position=UDim2.new(.7,0,0,0)
Title.Selectable=true
Title.Size=UDim2.new(.3,0,.075,0)
Title.Font=Enum.Font.GothamBold
Title.Text="Rogue Watch"
Title.TextColor3=Color3.new(.85,.85,.85)
Title.TextSize=34
Title.TextStrokeColor3=Color3.new(.35,.35,.35)
Title.TextStrokeTransparency=.5
Frame.Active=true
Frame.BackgroundTransparency=1
Frame.BorderColor3=Color3.new(.45,.45,.45)
Frame.BorderSizePixel=2
Frame.Position=UDim2.new(0,0,1,0)
Frame.Size=UDim2.new(1,0,12,0)
PlayerList.BackgroundColor3=Color3.new(.176,.176,.176)
PlayerList.BorderColor3=Color3.new(.45,.45,.45)
PlayerList.BorderSizePixel=2
PlayerList.Position=UDim2.new(0,0,0,0)
PlayerList.Size=UDim2.new(1,0,1,0)
PlayerList.CanvasSize=UDim2.new(0,0,15,0)
PlayerList.ScrollBarThickness=6
UIListLayout.Padding=UDim.new(0,4)
BaseButton.BackgroundColor3=Color3.new(.35,.35,.35)
BaseButton.BorderColor3=Color3.new(.45,.45,.45)
BaseButton.Size=UDim2.new(1,0,.0035,0)
BaseButton.Font=Enum.Font.SourceSansSemibold
BaseButton.TextColor3=Color3.new(.855,.855,.855)
BaseButton.TextScaled=true
BaseButton.TextStrokeColor3=Color3.new(.357,.357,.357)
BaseButton.TextWrapped=true
CS.AnchorPoint=Vector2.new(.5,0)
CS.BackgroundTransparency=1
CS.Position=UDim2.new(.5,0,0,0)
CS.Size=UDim2.new(.385,0,.0735,0)
CS.Visible=false
CS.Font=Enum.Font.SourceSansBold
CS.Text="Currently Spectating: N/A"
CS.TextColor3=Color3.new(0,0,0)
CS.TextScaled=true
CS.TextWrapped=true
UIListLayout.Parent=PlayerList
Frame.Parent=Title
Frame.Parent=Title
PlayerList.Parent=Frame
UIListLayout.Parent=PlayerList
Title.Parent=RL
CS.Parent=RL
local Players=game:GetService'Players'
local Air=Enum.Material.Air
local Nc=Enum.HumanoidStateType.None
local Sf=Enum.HumanoidStateType.StrafingNoPhysics
local function PIG(Part,Hum)
	local ObjPos=Part.Position+Vector3.new(0,4,0)
    local newRay=Ray.new(ObjPos,ObjPos-Vector3.new(0,3,0))
    local Hit,Pos=workspace:FindPartOnRay(newRay,Part.Parent)
	if(not Hit or Hit and Pos and(ObjPos-Pos).Magnitude>10)and Hum.FloorMaterial==Air or Hum:GetState()==Nc or Hum:GetState()==Sf then
		return true
	end
	return
end
local LP=Players.LocalPlayer
local Cam=workspace.CurrentCamera
local Tab=Players:GetPlayers()
for Idx=1,#Tab do
	local Obj=Tab[Idx]
	local Ch=Obj.Character
	if Obj.Name~=LP.Name then
		if Ch and Ch.Parent then
			local Bu=BaseButton:Clone()
			Bu.Text=Obj.Name..': N/A /s'
			Bu.Name=Obj.Name
			spawn(function()
				local Head=Ch:WaitForChild'Head'
				local OPS=Head.Position
				local Hum=Ch:WaitForChild'Humanoid'
				while wait(.5)and Ch.Parent do
					if PIG(Head,Hum)then
						Bu.TextColor3=Color3.new(1,0,0)
					else
						Bu.TextColor3=Color3.new(1,1,1)
					end
					Bu.Text=Obj.Name..': '..math.ceil((OPS-Head.Position).Magnitude)..' /s'
					OPS=Head.Position
				end
				Bu:Destroy()
			end)
			local Clicked=false
			Bu.MouseButton1Click:Connect(function()
				if not Clicked and Ch and Ch.Parent then
					Clicked=true
					CS.Visible=true
					CS.Text='Currently Spectating: '..Obj.Name
					if Ch and Ch.Parent then
						Cam.CameraSubject=Ch:WaitForChild'Humanoid'
					end
				else
					Clicked=false
					if LP.Character then
						Cam.CameraSubject=LP.Character:WaitForChild'Humanoid'
					end
					CS.Visible=false
				end
			end)
			Bu.Parent=PlayerList
		end
		Obj.CharacterAdded:Connect(function(Ch)
			local Obj2=PlayerList:FindFirstChild(Obj.Name)
			if Obj2 then
				Obj2:Destroy()
			end
			local Bu=BaseButton:Clone()
			Bu.Text=Obj.Name..': N/A /s'
			spawn(function()
				local Head=Ch:WaitForChild'Head'
				local OPS=Head.Position
				local Hum=Ch:WaitForChild'Humanoid'
				while wait(.5)and Ch.Parent do
					if PIG(Head,Hum)then
						Bu.TextColor3=Color3.new(1,0,0)
					else
						Bu.TextColor3=Color3.new(1,1,1)
					end
					Bu.Text=Obj.Name..': '..math.ceil((OPS-Head.Position).Magnitude)..' /s'
					OPS=Head.Position
				end
				Bu:Destroy()
			end)
			local Clicked=false
			Bu.MouseButton1Click:Connect(function()
				if not Clicked then
					Clicked=true
					CS.Visible=true
					CS.Text='Currently Spectating: '..Obj.Name
					if Ch and Ch.Parent then
						Cam.CameraSubject=Ch:WaitForChild'Humanoid'
					end
				else
					Clicked=false
					if LP.Character then
						Cam.CameraSubject=LP.Character:WaitForChild'Humanoid'
					end
					CS.Visible=false
				end
			end)
			Bu.Parent=PlayerList
		end)
	end
end
Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Ch)
		local Obj=PlayerList:FindFirstChild(Player.Name)
		if Obj then
			Obj:Destroy()
		end
		local Bu=BaseButton:Clone()
		Bu.Text=Player.Name..': N/A /s'
		spawn(function()
			local Head=Ch:WaitForChild'Head'
			local OPS=Head.Position
			local Hum=Ch:WaitForChild'Humanoid'
			while wait(.5)and Ch.Parent do
				if PIG(Head,Hum)then
					Bu.TextColor3=Color3.new(1,0,0)
				else
					Bu.TextColor3=Color3.new(1,1,1)
				end
				Bu.Text=Player.Name..': '..math.ceil((OPS-Head.Position).Magnitude)..' /s'
				OPS=Head.Position
			end
			Bu:Destroy()
		end)
		local Clicked=false
		Bu.MouseButton1Click:Connect(function()
			if not Clicked then
				Clicked=true
				CS.Visible=true
				CS.Text='Currently Spectating: '..Player.Name
				if Ch and Ch.Parent then
					local Head=Ch:WaitForChild'Head'
					Cam.CameraSubject=Head
				end
			else
				Clicked=false
				if LP.Character then
					Cam.CameraSubject=LP.Character:WaitForChild'Humanoid'
				end
				CS.Visible=false
			end
		end)
		Bu.Parent=PlayerList
	end)
end)
RL.Parent=game:GetService'CoreGui'
