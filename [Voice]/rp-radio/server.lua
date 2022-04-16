Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateUseableItem('radio', function(source)
    TriggerClientEvent('Radio.Set', source, true)
	TriggerClientEvent('Radio.Toggle', source)
end)

