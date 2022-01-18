local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
	AddTextEntry("Hunting", "Hunting Spot")
	for k, v in pairs(Config.Hunting) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite(blip, 442)
		SetBlipColour(blip, 1)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("Hunting")
		EndTextCommandSetBlipName(blip)
	end
end)

CreateThread(function()
	AddTextEntry("Butcher", "Butcher Shop")
	for k, v in pairs(Config.Butcher) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite(blip, 463)
		SetBlipColour(blip, 25)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("Butcher")
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
 ScriptLoaded()
end)

local OnGoingHuntSession = false
local veh = nil

local cord = {x=-1492.86, y = 4971.34, z = 63.91}

CreateThread(function()
    while true do
		Wait(0)
local coords = GetEntityCoords(PlayerPedId())
local distance = Vdist(coords.x, coords.y, coords.z, cord.x, cord.y, cord.z)
if not OnGoingHuntSession and distance < 5 then
    DrawText3D(cord.x, cord.y, cord.z, "[E] Start Hunting")
    DrawMarker(27, cord.x, cord.y, cord.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 15, 150, false, false, 2, true, nil, nil, false)
end
if OnGoingHuntSession and distance < 5 then
    DrawText3D(cord.x, cord.y, cord.z, "[E] Stop Hunting")
    DrawMarker(27, cord.x, cord.y, cord.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 15, 150, false, false, 2, true, nil, nil, false)
end
if not OnGoingHuntSession and distance < 2 then
	if IsControlJustPressed(0, 38) then
        OnGoingHuntSession = true
		StartHuntingSession()
	    Wait(0)
	end
end

if OnGoingHuntSession and distance < 2 then
	if IsControlJustPressed(0, 38) then
        OnGoingHuntSession = false
        RemoveBlip(AnimalBlip)
        DeleteEntity(Animal)
	Wait(0)
end
end
	end
end)

local cordsell = {x=89.95, y = 6339.76, z = 31.38}

CreateThread(function()
    while true do
		Wait(0)
local coords = GetEntityCoords(PlayerPedId())
local distance = Vdist(coords.x, coords.y, coords.z, cordsell.x, cordsell.y, cordsell.z)
if distance < 5 then
    DrawText3D(cordsell.x, cordsell.y, cordsell.z, "[E] Sell Meat and Leather")
    DrawMarker(27, cordsell.x, cordsell.y, cordsell.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 15, 150, false, false, 2, true, nil, nil, false)
end

if distance < 2 then
    if IsControlJustPressed(0, 38) then
        SellItems()
	Wait(0)
end
end
	end
end)

function ScriptLoaded()
	Wait(1000)
	LoadMarkers()
end

local AnimalPositions = {
	{ x = -1505.2, y = 4887.39, z = 78.38 },
	{ x = -1164.68, y = 4806.76, z = 223.11 },
	{ x = -1410.63, y = 4730.94, z = 44.0369 },
	{ x = -1377.29, y = 4864.31, z = 134.162 },
	{ x = -1697.63, y = 4652.71, z = 22.2442 },
	{ x = -1259.99, y = 5002.75, z = 151.36 },
	{ x = -960.91, y = 5001.16, z = 183.0 },
}

local AnimalsInSession = {}

local Positions = {
	['StartHunting'] = { ['hint'] = '[E] Start Hunting', ['x'] = -1492.86, ['y'] = 4971.34, ['z'] = 63.91 },
	['Sell'] = { ['hint'] = '[E] Sell Meat', ['x'] = 89.95, ['y'] = 6339.76, ['z'] = 31.38 },
	-- ['SpawnATV'] = { ['hint'] = '[E] Spawn ATV', ['x'] = -1489.8, ['y'] = 4974.8, ['z'] = 63.75 },
}

local OnGoingHuntSession = false
local HuntCar = nil

function LoadMarkers()

	CreateThread(function()
		for k, v in ipairs(Positions) do
			if k ~= 'SpawnATV' then
				local StartBlip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(StartBlip, 442)
				SetBlipColour(StartBlip, 75)
				SetBlipScale(StartBlip, 0.7)
				SetBlipAsShortRange(StartBlip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Hunting Spot')
				EndTextCommandSetBlipName(StartBlip)
			end
		end
	end)

	LoadModel('blazer')
	LoadModel('a_c_deer')
	LoadAnimDict('amb@medic@standing@kneel@base')
    LoadAnimDict('anim@gangops@facility@servers@bodysearch@')

end

function StartHuntingSession()

	if OnGoingHuntSession then

		OnGoingHuntSession = false
		
		--[[RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_MUSKET"), true, true)
		RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), true, true)]]--
		
		DeleteEntity(HuntCar)

		for index, value in pairs(AnimalsInSession) do
			if DoesEntityExist(value.id) then
				DeleteEntity(value.id)
			end
		end

	else
		OnGoingHuntSession = true

		--Car
		--[[HuntCar = CreateVehicle(GetHashKey('blazer'), Positions['SpawnATV'].x, Positions['SpawnATV'].y, Positions['SpawnATV'].z, 169.79, true, false)

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_MUSKET"),0, true, false)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"),0, true, false)]]--
		
		--Animals

		CreateThread(function()

				
			for index, value in pairs(AnimalPositions) do
				local Animal = CreatePed(5, GetHashKey('a_c_deer'), value.x, value.y, value.z, 0.0, true, false)
				TaskWanderStandard(Animal, true, true)
				SetEntityAsMissionEntity(Animal, true, true)
			    --Blips

				local AnimalBlip = AddBlipForEntity(Animal)
				SetBlipSprite(AnimalBlip, 141)
				SetBlipColour(AnimalBlip, 5)
				SetBlipScale(AnimalBlip, 0.5)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Deer - Animal')
				EndTextCommandSetBlipName(AnimalBlip)

				table.insert(AnimalsInSession, {id = Animal, x = value.x, y = value.y, z = value.z, Blipid = AnimalBlip})
			end

			while OnGoingHuntSession do
				local sleep = 500
				for index, value in ipairs(AnimalsInSession) do
					if DoesEntityExist(value.id) then
						local AnimalCoords = GetEntityCoords(value.id)
						local PlyCoords = GetEntityCoords(PlayerPedId())
						local AnimalHealth = GetEntityHealth(value.id)
						
						local PlyToAnimal = GetDistanceBetweenCoords(PlyCoords, AnimalCoords, true)

						if AnimalHealth <= 0 then
							SetBlipColour(value.Blipid, 3)
							if PlyToAnimal < 2.0 then
								sleep = 5

								DrawText3D(AnimalCoords.x,AnimalCoords.y,AnimalCoords.z + 1, '[E] Skin Animal')

								if IsControlJustReleased(0, Keys['E']) then
									if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE')  then
										if DoesEntityExist(value.id) then
											table.remove(AnimalsInSession, index)
											SlaughterAnimal(value.id)
										end
                                    else
                                    Wait(100)
                                    QBCore.Functions.Notify("You need to use the knife!")
									end
								end

							end
						end
					end
				end

				Wait(sleep)

			end
				
		end)
	end
end

function SlaughterAnimal(AnimalId)

	TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

	Wait(5000)

	ClearPedTasksImmediately(PlayerPedId())

	local AnimalWeight = math.random(10, 160) / 10

    QBCore.Functions.Notify('You recieved meat & leather ')

	TriggerServerEvent('QBCore:Server:reward', AnimalWeight)

	DeleteEntity(AnimalId)
end

function SellItems()
	TriggerServerEvent('QBCore:Server:sellhunt')
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end    
end

function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Wait(10)
    end
end

function DrawM(type, x, y, z)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0110, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
