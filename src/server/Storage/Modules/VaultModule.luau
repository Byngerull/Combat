local module = {}

type Character = Model & {
    Head: BasePart,
    Humanoid: Humanoid,
    HumanoidRootPart: BasePart,
    Torso: BasePart
}

local ContentProvider = game:GetService("ContentProvider")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://18530224040"

ContentProvider:PreloadAsync({animation})

function module.Vault()
    game:GetService("ReplicatedStorage").Shared.RemoteEvents.Vault.OnServerEvent:Connect(function(player) 
        local character: Character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart: BasePart = character:FindFirstChild("HumanoidRootPart")

        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {}
        params.FilterType = Enum.RaycastFilterType.Exclude

        local ray = workspace:Raycast(humanoidRootPart.CFrame.Position, humanoidRootPart.CFrame.LookVector * 5)

        if ray then
            if ray.Instance.Size.Y < 5 then
                local bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
                bodyVelocity.MaxForce = Vector3.one * 999999999999
				bodyVelocity.Velocity = (humanoidRootPart.AssemblyLinearVelocity/25  + humanoidRootPart.CFrame.LookVector) * 25 + humanoidRootPart.CFrame.UpVector * 5
				
				local animationTrack = character:FindFirstChildWhichIsA("Humanoid").Animator:LoadAnimation(animation)
				animationTrack:Play()
				
				game:GetService("Debris"):AddItem(bodyVelocity, .3)

				for i=1, 8 do
					bodyVelocity.Velocity *= .99
					task.wait(.04)
                end
            end
        end
    end)
end

return module