local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, gpe)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		game:GetService("ReplicatedStorage").Shared.RemoteEvents.M1:FireServer()
	end
end)