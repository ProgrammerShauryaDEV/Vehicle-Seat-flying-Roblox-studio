local vehicle = script.Parent
local input = game:GetService("UserInputService")
local gyro = vehicle.Gyro

local throttle = 0
local maxThrottle = 5000
local minThrottle = 0
local throttleIncrement = 100

local rollSpeed = 0.5
local pitchSpeed = 0.5
local yawSpeed = 0.5

local function updateThrottle()
    if input:IsKeyDown(Enum.KeyCode.Space) then
        throttle = math.min(throttle + throttleIncrement, maxThrottle)
    elseif input:IsKeyDown(Enum.KeyCode.LeftControl) then
        throttle = math.max(throttle - throttleIncrement, minThrottle)
    end
end

local function updateRotation()
    local pitch = input:GetGamepadState(Enum.UserInputType.Gamepad1).Thumbstick2.y * pitchSpeed
    local roll = input:GetGamepadState(Enum.UserInputType.Gamepad1).Thumbstick2.x * rollSpeed
    local yaw = input:GetGamepadState(Enum.UserInputType.Gamepad1).Thumbstick1.x * yawSpeed

    local orientation = gyro.CFrame:ToObjectSpace(vehicle.PrimaryPart.CFrame)

    local newOrientation = CFrame.fromOrientation(math.rad(-pitch), math.rad(roll), math.rad(yaw))

    orientation = orientation * newOrientation

    gyro.CFrame = vehicle.PrimaryPart.CFrame * CFrame.new(orientation:ToVector3() * 10)
end

local function updateVehicle()
    updateThrottle()
    updateRotation()

    local force = vehicle.PrimaryPart.CFrame:VectorToWorldSpace(Vector3.new(0, 0, throttle))

    vehicle:SetPrimaryPartCFrame(vehicle.PrimaryPart.CFrame + force)
end

game:GetService("RunService").Heartbeat:Connect(updateVehicle)
