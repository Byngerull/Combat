local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

local keybind = Enum.KeyCode.Q

local LeftSlide = Instance.new("Animation")
LeftSlide.AnimationId = "rbxassetid://18527177071"

local RightSlide = Instance.new("Animation")
RightSlide.AnimationId = "rbxassetid://18550983486"

ContentProvider:PreloadAsync({LeftSlide, RightSlide})

local debounce = false

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == keybind and not gpe then
		if not debounce then
			debounce = true

			local hrp = character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local velocity = Instance.new("BodyVelocity")
				velocity.MaxForce = Vector3.new(1, 0, 1) * 25000
				velocity.Velocity = hrp.CFrame.LookVector * 100
				velocity.Parent = hrp

				local animationTrack = humanoid.Animator:LoadAnimation(math.random(1, 2) == 1 and LeftSlide or RightSlide)
				animationTrack:Play()

				for i = 1, 8 do
					velocity.Velocity *= 0.7
					task.wait(0.1)
				end

				velocity:Destroy()
				animationTrack:Stop()
			end

			task.wait(1)
			debounce = not debounce
		end
	end
end)