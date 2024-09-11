local module = {}
module.__index = module

type Character = Model & {
	Head: BasePart,
	Humanoid: Humanoid,
	HumanoidRootPart: BasePart,
	Torso: BasePart
}

local MaxCombo = 4

local tweenService = game:GetService("TweenService")

local function Hit(power, instance, who, _wait)
	local BodyVelocity = Instance.new("BodyVelocity", instance)
	BodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
	BodyVelocity.Velocity = who.CFrame.LookVector * power

	game.Debris:AddItem(BodyVelocity, _wait)
end

local Functions = 
	{
		["Punch"] = function(self, HitPart)
			local HumanoidRootPart = self.Character.HumanoidRootPart
			local BlockedHumanoidRootPart = HitPart.Parent.PrimaryPart
			
			game:GetService("ReplicatedStorage").Shared.RemoteEvents.ClientListener:FireAllClients("Punch", HitPart, self.Status.Combo)

			BlockedHumanoidRootPart.Parent:SetPrimaryPartCFrame(CFrame.lookAt(BlockedHumanoidRootPart.Position, HumanoidRootPart.Position * Vector3.new(1, 0, 1) + BlockedHumanoidRootPart.Position * Vector3.new(0, 1, 0)))
			Hit(self.Status.Combo == MaxCombo and 20 or 10, HitPart.Parent.HumanoidRootPart, self.Character.HumanoidRootPart, 0.1)

			HitPart.Parent.Humanoid:TakeDamage(self.Status.Combo == MaxCombo and 7 or 5)
		end,

		["Blocked"] = function(self, HitPart)
			game:GetService("ReplicatedStorage").Shared.RemoteEvents.ClientListener:FireAllClients("BlockedPunch", HitPart, self.Status.Combo)
		end,
	}



function module.new(player)
	local self = setmetatable({}, module)
	self.Character = player.Character or player.CharacterAdded:Wait()

	self.Cooldown, self.IsCooldown = 0.5, false

	self.Status = {
		["IsBlocking"] = false,
		["InAction"] = false,
		["Knockback"] = 25,
		["Combo"] = 1
	}

	return self
end

function module:Attack()
	if self.Status.InAction or self.Character:GetAttribute("IsBlocking") or self.IsCooldown then return end

	self.Status.InAction = not self.Status.InAction
	self.Status.IsCooldown = not self.Status.IsCooldown

	local character: Character = self.Character
	local humanoid = character:WaitForChild("Humanoid")
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	game:GetService("ReplicatedStorage").Shared.RemoteEvents.ClientListener:FireAllClients("M1", self.Status.Combo)

	local params = OverlapParams.new()
	params.FilterDescendantsInstances = {character}

	local HitList = {}

	local Hitbox = workspace:GetPartBoundsInBox(character:GetPivot() * CFrame.new(0,0,-4), Vector3.new(4,4,6), params)

	for _, HitPart in Hitbox do
		if HitPart.Parent:FindFirstChildOfClass("Humanoid") and not table.find(HitList, HitPart.Parent) then
			table.insert(HitList, HitPart.Parent)

			if not HitPart.Parent:GetAttribute("IsBlocking") then
				Functions.Punch(self, HitPart)

				Hit(self.Status.Knockback - 10, humanoidRootPart, humanoidRootPart, 0.1)
			else
				Functions.Blocked(self, HitPart)
			end
		end
	end

	self.Status.Combo = self.Status.Combo == MaxCombo and 1 or self.Status.Combo + 1

	task.wait(self.Cooldown)

	self.Status.InAction = not self.Status.InAction
	self.Status.IsCooldown = not self.Status.IsCooldown
end

return module