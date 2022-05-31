--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)

-- Dev mode only
Roact.setGlobalConfig({
	typeChecks = true,
	propValidation = true,
})

local Shared = ReplicatedStorage.Shared
local PlayerTypes = require(Shared.PlayerTypes)
type PlayerData = PlayerTypes.PlayerData

local Client = ReplicatedStorage.Client
local Scoreboard = require(Client.Scoreboard)

local Events = ReplicatedStorage.Events
local OnJoin = Events.OnJoin
local OnLeave = Events.OnLeave
local OnScore = Events.OnScore

local ClientPlayers = {}

local STUB_PLAYER_A = {
	Name = "Player A",
}
local STUB_PLAYER_B = {
	Name = "Player B",
}
local STUB_DATA = {
	[STUB_PLAYER_A] = {player = STUB_PLAYER_A, score = 10},
	[STUB_PLAYER_B] = {player = STUB_PLAYER_B, score = 50},
}
local IS_TEST = true

local initialData = if IS_TEST then (STUB_DATA :: any) else {}

function ClientPlayers.new()
	local players = {
		data = initialData :: {[Player]: PlayerData},
		handle = nil :: {[string]: any}?,
	}
	return setmetatable(players, {__index = ClientPlayers})
end

function ClientPlayers:start()
	local self: ClientPlayers = self
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local screen = Instance.new("ScreenGui")
	self.handle = Roact.mount(Roact.createElement(Scoreboard, self:_getState()), screen)
	screen.Parent = playerGui

	OnJoin.OnClientEvent:Connect(function(playerData: PlayerData)
		self.data[playerData.player] = playerData
		self:_updateUi()
	end)
	OnScore.OnClientEvent:Connect(function(player: Player, newScore: number)
		local playerData = self.data[player]
		if playerData then
			playerData.score = newScore
		end
		self:_updateUi()
	end)
	OnLeave.OnClientEvent:Connect(function(player: Player)
		self.data[player] = nil
		self:_updateUi()
	end)
end

function ClientPlayers:_updateUi()
	Roact.update(self.handle, Roact.createElement(Scoreboard, self:_getState()))
end

function ClientPlayers:_getState()
	local playerList = {} :: {PlayerData}
	for _, playerData in pairs(self.data) do
		table.insert(playerList, playerData)
	end
	table.sort(playerList, function(a, b)
		return if a.score == b.score then a.player.Name < b.player.Name else a.score > b.score
	end)
	local names = {}
	local scores = {}
	for _, data in ipairs(playerList) do
		table.insert(names, data.player.Name)
		table.insert(scores, data.score)
	end
	return {
		names = names,
		scores = scores,
	}
end

export type ClientPlayers = typeof(ClientPlayers.new())

return ClientPlayers
