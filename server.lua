ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('nevo_clothes:save')
AddEventHandler('nevo_clothes:save', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET `nevoskin` = @data WHERE identifier = @identifier',
	{
		['@data']       = json.encode(data),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('nevo_clothes:loadclothes')
AddEventHandler('nevo_clothes:loadclothes', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user = users[1]
		local nevoskin = nil

		if user.nevoskin ~= nil then
			nevoskin = json.decode(user.nevoskin)
		end

		TriggerClientEvent('nevo_clothes:loadclothes', nevoskin)
	end)


end)

ESX.RegisterServerCallback('nevo_clothes:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user = users[1]
		local nevoskin = nil


		if user.nevoskin ~= nil then
			nevoskin = json.decode(user.nevoskin)
		end

		cb(nevoskin)
	end)
end)