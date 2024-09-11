local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local contentProvider = game:GetService("ContentProvider")

contentProvider:PreloadAsync(script.M1Animations.M1:GetChildren())
contentProvider:PreloadAsync(script.M1Animations.Blocks:GetChildren())

local IdleAnimation = character:FindFirstChildWhichIsA("Humanoid"):WaitForChild("Animator"):LoadAnimation(script.M1Animations.Blocks.Idle)

local functions = {
	["Punch"] = function(...)
		local HitPart, combo = ...
		
		local Highlight = Instance.new("Highlight", HitPart.Parent)
		Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight.FillColor = Color3.fromRGB(199,0,0)
		Highlight.FillTransparency = 0
		Highlight.OutlineTransparency = 1

		local animation = HitPart.Parent.Humanoid:LoadAnimation(script.M1Animations.Hit:FindFirstChild("m" .. combo))
		animation:Play()

		for v, particle: ParticleEmitter in script.Vfx.Hit:GetChildren() do
			local new = particle:Clone()
			new.Parent = HitPart.Parent.HumanoidRootPart
			new:Emit(2)
		end

		game:GetService("TweenService"):Create(Highlight, TweenInfo.new(0.3), {FillTransparency = 1}):Play()

		game.Debris:AddItem(Highlight, 0.4)
	end,
	
	["Block"] = function(...)
		local action: string, character: Model = ...

		if action == "Start" then
			local animation = character:FindFirstChildWhichIsA("Humanoid").Animator:LoadAnimation(script.M1Animations.Blocks.Start)
			animation:Play()
			
			print("start")
			
			animation.Stopped:Wait()
			
			IdleAnimation:Play()
		elseif action == "End" then
			
			IdleAnimation:Stop()

			local animation = character:FindFirstChildWhichIsA("Humanoid").Animator:LoadAnimation(script.M1Animations.Blocks.End)
			animation:Play()
			
			print("end")
		end
	end,
	
	["BlockedPunch"] = function(...)
		local HitPart, combo = ...


		local animation = HitPart.Parent.Humanoid.Animator:LoadAnimation(script.M1Animations.Blocks:FindFirstChild("m" .. combo))
		animation:Play()

	end,
	
	["M1"] = function(...)
		local combo = ...
		
		local animation: AnimationTrack = character:FindFirstChildWhichIsA("Humanoid").Animator:LoadAnimation(script.M1Animations.M1:FindFirstChild("m" .. combo))
		animation:Play(0.1, 1, 1.5)

	end,
}

game:GetService("ReplicatedStorage").Shared.RemoteEvents.ClientListener.OnClientEvent:Connect(function(action, ...)
	if functions[action] then
		functions[action](...)
	end
end)