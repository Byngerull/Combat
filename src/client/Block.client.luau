local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		game:GetService("ReplicatedStorage").Shared.RemoteEvents.Block:FireServer("Start")
	end
end)

uis.InputEnded:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.F then
		game:GetService("ReplicatedStorage").Shared.RemoteEvents.Block:FireServer("End")
	end
end)