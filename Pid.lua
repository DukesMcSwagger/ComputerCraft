-- pid.lua
-- Simple reusable PID controller for CC:Tweaked
--
-- Usage:
-- local PID = require("pid")
--
-- local tempPID = PID.new(2, 0.1, 0.5)
-- local output = tempPID:update(currentTemp, targetTemp)

local PID = {}
PID.__index = PID

function PID.new(kp, ki, kd, options)
    options = options or {}

    local self = setmetatable({}, PID)

    self.kp = kp or 1
    self.ki = ki or 0
    self.kd = kd or 0

    self.integral = 0
    self.previousError = nil

    self.minOutput = options.minOutput or -math.huge
    self.maxOutput = options.maxOutput or math.huge

    self.integralMin = options.integralMin or -math.huge
    self.integralMax = options.integralMax or math.huge

    self.dt = options.dt or 1

    return self
end

function PID:update(current, target, dt)
    dt = dt or self.dt

    -- How far away we are from the target
    local error = target - current

    -- Integral
    self.integral = self.integral + error * dt

    -- Prevent integral windup
    self.integral = math.max(
        self.integralMin,
        math.min(self.integral, self.integralMax)
    )

    -- Derivative
    local derivative = 0

    if self.previousError ~= nil then
        derivative = (error - self.previousError) / dt
    end

    self.previousError = error

    -- PID calculation
    local output =
        (self.kp * error) +
        (self.ki * self.integral) +
        (self.kd * derivative)

    -- Limit output
    output = math.max(
        self.minOutput,
        math.min(output, self.maxOutput)
    )

    return output
end

function PID:reset()
    self.integral = 0
    self.previousError = nil
end

return PID
