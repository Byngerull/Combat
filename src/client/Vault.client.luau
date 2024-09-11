local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Space then
        game:GetService("ReplicatedStorage").Shared.RemoteEvents:WaitForChild("Vault"):FireServer()
    end
end)