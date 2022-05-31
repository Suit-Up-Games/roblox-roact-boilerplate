--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Events = ReplicatedStorage.Events
local OnScore = Events.OnScore

local Shared = ReplicatedStorage.Shared
local Palette = require(Shared.Palette)

local Server = ServerScriptService.Server
local ServerPlayers = require(Server.ServerPlayers)
type ServerPlayers = ServerPlayers.ServerPlayers

local ServerTargets = {}

function ServerTargets.new()
	local targets = {
		players = nil :: ServerPlayers?,
	}
	return setmetatable(targets, {__index = ServerTargets})
end

function ServerTargets:start(players: ServerPlayers)
	self.players = players
	for i, child in Workspace:GetChildren() do
		if child.Name == "Target" then
			local target = child :: Part
			target.Touched:Connect(function(part: BasePart)
				self:_onTargetTouched(part, target)
			end)
		end
	end
end

function ServerTargets:_onTargetTouched(part: BasePart, target: Part)
	local model = part:FindFirstAncestorWhichIsA("Model")
	local player = Players:GetPlayerFromCharacter(model)
	if player and target.Color == Palette.RED then
		target.Color = Palette.GREEN
		self:_score(player)
	end
end

function ServerTargets:_score(player: Player)
	local self: ServerTargets = self
	local players = self.players
	if players then
		local playerData = players.data[player]
		if playerData then
			playerData.score += 10
			OnScore:FireAllClients(player, playerData.score)
		end
	end
end

export type ServerTargets = typeof(ServerTargets.new())

return ServerTargets
