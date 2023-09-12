
local inventoryPath = game:GetService("ReplicatedStorage").InventorySystem.Remotes

local meditating = false
function autoMeditate()
    task.spawn(function()
        while task.wait() do
            if meditating == false then break end
            local player = game:GetService("Players").LocalPlayer
            local previousQI = player.DataValues.QI.Value
            
            task.wait(1.5)

            if game:GetService("Workspace")[player.Name] and game:GetService("Workspace")[player.Name]:FindFirstChild('Meditate') then
                if player.DataValues.QI.Value >= player.NextRealm.Requirement.Value or player.DataValues.QI.Value == previousQI then
                    game:GetService("Workspace")[player.Name].Meditate:Activate()
                else
                    task.wait(5)
                end
            elseif player.Backpack:FindFirstChild('Meditate') then
                player.Backpack.Meditate.Parent = player.Character
            end
            end
    end)
end

local anti = false;
function antiAfk()
    local Plrs = game:GetService("Players")
    local Run = game:GetService("RunService")

    local MyPlr = Plrs.LocalPlayer
    local MyChar = MyPlr.Character

    task.spawn(function()
    while task.wait() do
        if anti == false then break end
        MyChar = MyPlr.Character -- Player's character likes to go nil sometimes?
        
        if MyChar then
        local MyHum = MyChar:FindFirstChild("Humanoid")
        local MyTor = MyChar:FindFirstChild("HumanoidRootPart")

        if MyHum and MyTor then
        MyHum.WalkToPoint = MyTor.Position + Vector3.new(0, 0, 1)
        end
        end
        task.wait(30)
    end 
    end)
end

function getCurrentPlayerPOS()
    local currentPlayer = game.Players.LocalPlayer
    if currentPlayer.Character then
        return currentPlayer.Character.HumanoidRootPart.Position
    end
    return false
end

function teleportToPos(position)
    local currentPlayer = game.Players.LocalPlayer
    if currentPlayer.Character then
        local newPosition = Vector3.new(position.X, position.Y, position.Z)
        local newCFrame = CFrame.new(newPosition)
        currentPlayer.Character.HumanoidRootPart.CFrame = newCFrame
    end
end    

function teleportTo(placeCframe)
    local currentPlayer = game.Players.LocalPlayer
    if currentPlayer.Character then
            currentPlayer.Character.HumanoidRootPart.CFrame = placeCframe
    end
end

function teleportQiZone(zone)
    if game.Workspace.Interactables.Zones.QIZones:FindFirstChild(zone) then
        if zone == "10" then
            local targetPosition = Vector3.new(-6166.40137, 303.808716, 4773.20703)
            teleportToPos(targetPosition)
        else
            teleportTo(game.Workspace.Interactables.Zones.QIZones[zone].CFrame)
        end
    end
end

function teleportMob(mob)
    local mobWithSuffix = mob .. "_1"
    if game.Workspace.Mobs.Spawns:FindFirstChild(mobWithSuffix) then
            print(game.Workspace.Mobs.Spawns[mobWithSuffix].CFrame)
            teleportTo(game.Workspace.Mobs.Spawns[mobWithSuffix].CFrame)
    end
end

function teleportNpc(npc)
    if game:GetService("Workspace").Interactables.NPC:FindFirstChild(npc) then
        teleportTo(game:GetService("Workspace").Interactables.NPC[npc].HumanoidRootPart.CFrame)
    end
end

function holdButton(button, durationInSeconds)
    local virtualUser = game:GetService('VirtualUser')
    virtualUser:CaptureController()
    
    virtualUser:SetKeyDown(button)
    task.wait(durationInSeconds)
    virtualUser:SetKeyUp(button)
end


local function fireproximityprompt(Obj, Amount, Skip) 
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1 
        local PromptTime = Obj.HoldDuration 
        if Skip then Obj.HoldDuration = 0 
    end 
        for i = 1, Amount do 
            Obj:InputHoldBegin() 
            if not Skip then 
                task.wait(Obj.HoldDuration)
            end 
            Obj:InputHoldEnd() 
        end 
        Obj.HoldDuration = PromptTime 
    else 
        error("userdata<ProximityPrompt> expected") 
    end 
end

local collectToggle = false
function autoCollectTrinket()
    task.spawn(function()
        local currentPlayer = game.Players.LocalPlayer
        for i, v in pairs(game:GetService("Workspace").Interactables.Trinklet:GetChildren()) do
            local handle = v:FindFirstChild("Handle")
            local ProximityPrompt = v:FindFirstChild("ProximityPrompt")
            if ProximityPrompt and currentPlayer.Character and handle then
                if collectToggle then
                    currentPlayer.Character.HumanoidRootPart.CFrame = v.CFrame 
                    task.wait(1)
                    fireproximityprompt(ProximityPrompt, 1, false)
                    task.wait(1)
                else
                    break
                end
            end
        end
    end)
end




-- local currentPOS = getCurrentPlayerPOS()
-- if currentPOS then
--     print('continue')
-- end

-- function meditate()
--     inventoryPath.EquipTool:InvokeServer("Meditate")
-- end



-- Ui Lib
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Pacifist Hub",
	LoadingTitle = "Loading Script...",
    LoadingSubtitle = "by Pacifist",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = "PacifistHub",
		FileName = "Pacifist"
	},
	-- KeySystem = false, -- Set this to true to use their key system
	-- KeySettings = {
	-- 	Title = "Pacifist Hub",
	-- 	Subtitle = "Key System",
	-- 	Note = "Join the discord (discord.gg/sirius)",
	-- 	SaveKey = true,
	-- 	Key = "ABCDEF"
	-- }
})

-- Rayfield:Notify("Pacifist Hub", "Loaded!") -- Notfication -- Title, Content, Image

-- Windows

if game.GameId == 4737765103 then

local autoFarm = Window:CreateTab("Auto-Farm", 4483362458) -- Title, Image
local teleports = Window:CreateTab("Teleports", 4483362458) -- Title, Image
local player = Window:CreateTab("Player", 4483362458) -- Title, Image
local settings = Window:CreateTab("Settings", 4483362458) -- Title, Image

--  End

-- Auto-Farm Section

local Section = autoFarm:CreateSection("Farming")

-- local Button = autoFarm:CreateButton({
-- 	Name = "Button Example",
-- 	Callback = function()
-- 		-- The function that takes place when the button is pressed
-- 	end,
-- })

local ToggleCollectTrinkets = autoFarm:CreateToggle({
	Name = "Collect Trinkets",
	CurrentValue = false,
	Flag = "ToggleTrinket1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
        collectToggle = Value
        if Value then
            autoCollectTrinket()
        end
	end,
})

local ToggleAutoMeditate = autoFarm:CreateToggle({
	Name = "Auto-Meditate and Breakthrough",
	CurrentValue = false,
	Flag = "ToggleMeditate1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
        meditating = Value
        if Value then
            autoMeditate()
        end
	end,
})

local ToggleAntiAfk = autoFarm:CreateToggle({
	Name = "Anti-Afk",
	CurrentValue = false,
	Flag = "ToggleAnti1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
        anti = Value
        if Value then
            antiAfk()
        end
	end,
})


-- local Label = autoFarm:CreateLabel("Label Example")

-- local Paragraph = autoFarm:CreateParagraph({Title = "Paragraph Example", Content = "Paragraph Example"})

-- local Input = autoFarm:CreateInput({
-- 	Name = "Input Example",
-- 	PlaceholderText = "Input Placeholder",
-- 	RemoveTextAfterFocusLost = false,
-- 	Callback = function(Text)
-- 		-- The function that takes place when the input is changed
--     		-- The variable (Text) is a string for the value in the text box
-- 	end,
-- })

-- local Keybind = autoFarm:CreateKeybind({
-- 	Name = "Keybind Example",
-- 	CurrentKeybind = "Q",
-- 	HoldToInteract = false,
-- 	Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
-- 	Callback = function(Keybind)
-- 		-- The function that takes place when the keybind is pressed
--     		-- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
-- 	end,
-- })

-- local AutoFarmDropdown = autoFarm:CreateDropdown({
-- 	Name = "Dropdown Example",
-- 	Options = {"Option 1","Option 2"},
-- 	CurrentOption = "Option 1",
-- 	Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
-- 	Callback = function(Option)
-- 	  	  -- The function that takes place when the selected option is changed
--     	  -- The variable (Option) is a string for the value that the dropdown was changed to
-- 	end,
-- })

-- End

-- Teleport Section

local Section = teleports:CreateSection("Qi")

local selectedQiZone = "2"

local TeleportQiDropdown = teleports:CreateDropdown({
	Name = "Qi Zones",
	Options = {"2","5","10","25","50"},
	CurrentOption = "2",
	Flag = "TeleportDropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
        selectedQiZone = Option[1]
	end,
})

local TeleportQiSelected = teleports:CreateButton({
	Name = "Teleport to selected",
	Callback = function()
		teleportQiZone(selectedQiZone)
	end,
})


local Section = teleports:CreateSection("Mobs")

local selectedMob = "Bandit"
local TeleportMobDropdown = teleports:CreateDropdown({
	Name = "Mob Zones",
	Options = {"Bandit","Treeling","Dwarf","Giant","Heavenly Martial Master","Demonic Cultivation Overlord"},
	CurrentOption = "Bandit",
	Flag = "TeleportDropdown2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
        selectedMob = Option[1]
	end,
})

local TeleportMobSelected = teleports:CreateButton({
	Name = "Teleport to selected",
	Callback = function()
		teleportMob(selectedMob)
	end,
})

local Section = teleports:CreateSection("NPCs")

local selectedNPC = "Baker"
local TeleportMobDropdown = teleports:CreateDropdown({
	Name = "NPC Location",
	Options = {"Baker","BlackSmith","Farmer","QiPalmTrainer","InnKeeper","NekoClanSkillTrainer", "DragonClanTrainer"},
	CurrentOption = "Baker",
	Flag = "TeleportDropdown3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
        selectedNPC = Option[1]
	end,
})

local TeleportNpcSelected = teleports:CreateButton({
	Name = "Teleport to selected",
	Callback = function()
		teleportNpc(selectedNPC)
	end,
})


-- End

-- Player Section

local Section = player:CreateSection("Personal")


-- ff:Slider("WalkSpeed", 16, 503, function(currentValue)
--     game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = currentValue 
-- end)

local walkSpeed = 16
local walkToggle = false
local ToggleWalkspeed = player:CreateToggle({
	Name = "Toggle Walkspeed",
	CurrentValue = false,
	Flag = "ToggleWalk1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
        walkToggle = Value
        if Value then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
	end,
})

local SliderWalkSpeed = player:CreateSlider({
	Name = "Walkspeed Slider",
	Range = {16, 500},
	Increment = 10,
	Suffix = "Walkspeed",
	CurrentValue = 16,
	Flag = "Walkspeed1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		walkSpeed = Value
        if walkToggle then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
        end
	end,
})

-- End


-- Settings Section

local SettingsButton = settings:CreateButton({
	Name = "Destroy GUI",
	Callback = function()
		Rayfield:Destroy()
	end,
})

-- End

else

    local unsupportedGame = Window:CreateTab("Unsupported Game", 4483362458) -- Title, Image
    local Label = unsupportedGame:CreateLabel("This game is not supported, if you want support for this game then please contact Pacifist")

end



-- Extras

getgenv().SecureMode = true -- Only Set To True If Games Are Detecting/Crashing The UI

-- Rayfield:Destroy() -- Destroys UI

-- Rayfield:LoadConfiguration() -- Enables Configuration Saving

-- Section:Set("Section Example") -- Use To Update Section Text

-- Button:Set("Button Example") -- Use To Update Button Text

-- Toggle:Set(false) -- Use To Update Toggle

-- Slider:Set(10) -- Use To Update Slider Value

-- Label:Set("Label Example") -- Use To Update Label Text

-- Paragraph:Set({Title = "Paragraph Example", Content = "Paragraph Example"}) -- Use To Update Paragraph Text

-- Keybind:Set("RightCtrl") -- Keybind (string) -- Use To Update Keybind

-- Dropdown:Set("Option 2") -- The new option value -- Use To Update/Set New Dropdowns
-- End