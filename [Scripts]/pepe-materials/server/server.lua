Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('pepe-materials:server:is:vehicle:owned', function(source, cb, plate)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

--RegisterServerEvent('pepe-materials:server:get:reward')
--AddEventHandler('pepe-materials:server:get:reward', function()
    
Framework.Functions.CreateCallback('pepe-materials:server:get:reward', function(source)
    local Player = Framework.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 100)
    local RandomItems = Config.BinItems[math.random(#Config.BinItems)]
    if RandomValue <= 55 then
     Player.Functions.AddItem(RandomItems, math.random(8, 20))
     TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items[RandomItems], 'add')
    elseif RandomValue >= 87 and RandomValue <= 89 then
        if math.random(1, 2) == 1 then
            Player.Functions.AddItem('rifle-body', 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['rifle-body'], 'add')
        else
            Player.Functions.AddItem('rifle-clip', 1)
            TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['rifle-clip'], 'add')
        end
    else
        TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'You did not find anything..', 'error')
    end
end)

--RegisterServerEvent('pepe-materials:server:scrap:reward')
--AddEventHandler('pepe-materials:server:scrap:reward', function()
    
Framework.Functions.CreateCallback('pepe-materials:server:scrap:reward', function(source)
  local Player = Framework.Functions.GetPlayer(source)
  for i = 1, math.random(4, 8), 1 do
      local Items = Config.CarItems[math.random(1, #Config.CarItems)]
      local RandomNum = math.random(60, 95)
      Player.Functions.AddItem(Items, RandomNum)
      TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items[Items], 'add')
      Citizen.Wait(500)
  end
  if math.random(1, 100) <= 35 then
    Player.Functions.AddItem('rubber', math.random(25, 55))
    TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['rubber'], 'add')
  end
end)