--!strict
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer 
local playerGui = player:WaitForChild("PlayerGui")

local MIN_LOAD_SECONDS = 3

ReplicatedFirst:RemoveDefaultLoadingScreen()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local screen = Instance.new("ScreenGui")
screen.IgnoreGuiInset = true

local label = Instance.new("TextLabel")
label.BackgroundColor3 = Color3.new(0, 0, 0)
label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
label.Text = "Loading Screen"
label.Font = Enum.Font.GothamSemibold
label.TextSize = 32
label.Size = UDim2.fromScale(1, 1)
label.Parent = screen

screen.Parent = playerGui

wait(MIN_LOAD_SECONDS)
if not game:IsLoaded() then
	game.Loaded:Wait()
end
screen:Destroy()
