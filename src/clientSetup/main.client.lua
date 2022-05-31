--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Client = ReplicatedStorage:WaitForChild("Client")

local Camera = require(Client.Camera)
local ClientPlayers = require(Client.ClientPlayers)

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
character:WaitForChild("HumanoidRootPart")

local camera = Camera.new()
local players = ClientPlayers.new()

camera:start()
players:start()
