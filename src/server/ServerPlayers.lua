--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Events = ReplicatedStorage.Events
local OnJoin = Events.OnJoin
local OnLeave = Events.OnLeave

local Shared = ReplicatedStorage.Shared
local PlayerTypes = require(Shared.PlayerTypes)
type PlayerData = PlayerTypes.PlayerData

local ServerPlayers = {}

function ServerPlayers.new()
	local players = {
		data = {} :: {[Player]: PlayerData}
	}
	return setmetatable(players, {__index = ServerPlayers})
end

function ServerPlayers:start()
	local Players = game:GetService("Players")
 
	Players.PlayerAdded:Connect(function(player: Player)
		self:_connectPlayer(player)
	end)
	Players.PlayerRemoving:Connect(function(player: Player)
		self:_disconnectPlayer(player)
	end)
end

function ServerPlayers:_connectPlayer(player: Player)
	local playerData = {
		player = player,
		score = 0,
	}
	self.data[player] = playerData
	OnJoin:FireAllClients(playerData)
end

function ServerPlayers:_disconnectPlayer(player: Player)
	self.data[player] = nil
	OnLeave:FireAllClients(player)
end

export type ServerPlayers = typeof(ServerPlayers.new())

return ServerPlayers
