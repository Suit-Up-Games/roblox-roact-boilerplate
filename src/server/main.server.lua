--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local Server = ServerScriptService.Server
local ServerPlayers = require(Server.ServerPlayers)
local ServerTargets = require(Server.ServerTargets)

local players = ServerPlayers.new()
local targets = ServerTargets.new()

players:start()
targets:start(players)
