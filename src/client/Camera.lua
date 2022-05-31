--!strict
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local DEFAULT_CAMERA_OFFSET = Vector3.new(4, 2, 5)
local VERTICAL_SENSITIVITY = 0.2
local HORIZONTAL_SENSITIVITY = 0.25
local MIN_VERTICAL = math.rad(-60)
local MAX_VERTICAL = math.rad(60)
local COLLISION_THRESHOLD = 0.5
local BODY_REACT_LERP_ALPHA = 0.1

local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

local Camera = {}

function Camera.new()
	local camera = {
		rootPart = nil :: BasePart?,
		angleHorizontal = 0,
		angleVertical = 0,
		onUserInputChangedConnection = nil :: RBXScriptSignal?
	}
	return setmetatable(camera, {__index = Camera})
end

function Camera:start()
	Camera:updateRoot()
	local rootPart = (self :: Camera).rootPart
	if rootPart then
		local direction = rootPart.Position - camera.CFrame.Position
		self.angleHorizontal = math.atan2(direction.X, direction.Z) + math.pi
		self.angleVertical = 0

		camera.CameraType = Enum.CameraType.Scriptable

		RunService:BindToRenderStep("Camera", Enum.RenderPriority.Camera.Value, function()
			self:_update()
		end)

		local function onUserInputChanged(property)
			if property == "MouseBehavior" then
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
			end
		end

		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

		self.onUserInputChangedConnection = UserInputService.Changed:Connect(onUserInputChanged)
	end
end

function Camera:stop()
	RunService:UnbindFromRenderStep("Camera")

	camera.CameraType = Enum.CameraType.Custom

	self.onUserInputChangedConnection:Disconnect()
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function Camera:updateRoot()
	local character = localPlayer.Character
	self.rootPart = character and character:FindFirstChild("HumanoidRootPart") or nil
end

function Camera:_checkCollision(cameraCFrame: CFrame)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = {self.rootPart.Parent}

	local rayCastResult =
		game.Workspace:Raycast(self.rootPart.Position, cameraCFrame.Position - self.rootPart.Position, raycastParams)

	if not rayCastResult then
		return cameraCFrame
	end

	local cameraOffset = (rayCastResult.Position - cameraCFrame.Position)
	local collisionRatio = cameraOffset.magnitude
	local collisionSpace =
		(math.clamp(collisionRatio - COLLISION_THRESHOLD, 0, COLLISION_THRESHOLD) / COLLISION_THRESHOLD) *
		Vector3.new(1.2, 0, 0)

	return cameraCFrame * CFrame.new(collisionSpace) + cameraOffset
end

function Camera:_update()
	local self: Camera = self
	local rootPart = self.rootPart
	if rootPart and rootPart.Parent then
		local mouseDelta = UserInputService:GetMouseDelta() * UserGameSettings.MouseSensitivity

		self.angleHorizontal -= (math.rad(mouseDelta.X) * HORIZONTAL_SENSITIVITY)
		self.angleVertical =
			math.clamp(self.angleVertical - (math.rad(mouseDelta.Y) * VERTICAL_SENSITIVITY), MIN_VERTICAL, MAX_VERTICAL)

		local rotation = CFrame.Angles(0, self.angleHorizontal, 0) * CFrame.Angles(self.angleVertical, 0, 0)
		local cameraCFrame = CFrame.new(rootPart.Position) * rotation * CFrame.new(DEFAULT_CAMERA_OFFSET)
		local targetCFrame = self:_checkCollision(cameraCFrame)

		camera.CFrame = targetCFrame
		camera.Focus = rootPart.CFrame

		local cameraLookVector = targetCFrame.LookVector
		local cameraRotation = math.atan2(-cameraLookVector.X, -cameraLookVector.Z)
		local rootPartGoalCFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, cameraRotation, 0)

		rootPart.CFrame = rootPart.CFrame:Lerp(rootPartGoalCFrame, BODY_REACT_LERP_ALPHA)
	else
		self:updateRoot()
	end
end

export type Camera = typeof(Camera.new())

return Camera
