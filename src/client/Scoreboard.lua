--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)

local Shared = ReplicatedStorage.Shared
local Palette = require(Shared.Palette)
local PlayerTypes = require(Shared.PlayerTypes)
type PlayerData = PlayerTypes.PlayerData

export type Props = {
	names: {string},
	scores: {number},
}

local Column = Roact.createElement("UIListLayout", {
	Padding = UDim.new(0, 10),
})
local Row = Roact.createElement("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	Padding = UDim.new(0, 10),
})
local function Padding(amount: number)
	return Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, amount),
		PaddingLeft = UDim.new(0, amount),
		PaddingRight = UDim.new(0, amount),
		PaddingBottom = UDim.new(0, amount),
	})
end
local function Label(order: number, text: string)
	return Roact.createElement("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = order,
		Text = text,
		TextColor3 = Palette.WHITE,
		Font = Enum.Font.GothamSemibold,
		TextSize = 18,
	})
end

local Scoreboard = Roact.PureComponent:extend("Scoreboard")

function Scoreboard:render()
	local props = self.props :: Props

	local names = {
		Layout = Column,
		Padding = Padding(5),
	}
	local scores = {
		Layout = Column,
		Padding = Padding(5),
	}
	for i, name in ipairs(props.names) do
		names[tostring(i)] = Label(i, name)
	end
	for i, score in ipairs(props.scores) do
		scores[tostring(i)] = Label(i, tostring(score))
	end

	return Roact.createElement("Frame", {
		BackgroundColor3 = Palette.GREY,
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(1, 1),
	}, {
		Layout = Row,
		Padding = Padding(10),
		Left = Roact.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
		}, names),
		Scores = Roact.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
		}, scores),
	})
end

return Scoreboard
