QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('QBCore:Server:reward', function(Weight)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Weight >= 1 then
       Player.Functions.AddItem('meat', 1)
       TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['meat'], "add")
    elseif Weight >= 9 then
        Player.Functions.AddItem('meat', 1)
       TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['meat'], "add")
    elseif Weight >= 15 then
        Player.Functions.AddItem('meat', 1)
       TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['meat'], "add")
    end


	Player.Functions.AddItem('leather', math.random(1, 2))
       TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['leather'], "add")

end)

RegisterServerEvent('QBCore:Server:sellhunt', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local MeatPrice = 20
	local MeatQuantity = getQuantity('meat')
        if MeatQuantity > 0  then
            Player.Functions.AddMoney("cash", MeatQuantity * MeatPrice, "sold-pawn-items")
                TriggerClientEvent('QBCore:Notify', src, 'you sold to the meat', "success")
            Player.Functions.RemoveItem("meat", MeatQuantity)
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['meat'], "remove")
        else
    TriggerClientEvent('QBCore:Notify', src, 'You don\'t have any meat', "error")
    end
end)

RegisterServerEvent('QBCore:Server:sellhunt', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local LeatherPrice = 40
    local LeatherQuantity = getQuantity('leather')

    if LeatherQuantity > 0 then
        Player.Functions.AddMoney("cash", LeatherQuantity * LeatherPrice, "sold-pawn-items")
		TriggerClientEvent('QBCore:Notify', src, 'you sold to the leather', "success")
        Player.Functions.RemoveItem("leather", LeatherQuantity)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['leather'], "remove")
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have any leather', "error")
    end

end)

function getQuantity(item)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if item == nil then return print("CRAFTING: An invalid item was passed into GetQuantity") end
    local quantity = player.Functions.GetItemByName(item)
    if quantity == nil then quantity = 0 else quantity = quantity.amount end

    return quantity
end

