ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingKoda    = {}
local PlayersTransformingKoda  = {}
local PlayersSellingKoda       = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()
	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1500, CountCops)
end

CountCops()

--kodeina
local function HarvestKoda(source)

	SetTimeout(Config.TimeToFarm, function()
		if PlayersHarvestingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local koda = xPlayer.getInventoryItem('petroleum')

			if koda.limit ~= -1 and koda.count >= koda.limit then
				TriggerClientEvent('esx:showNotification', source, _U('mochila_full'))
			else
				xPlayer.addInventoryItem('petroleum', 1)
				HarvestKoda(source)
			end
		end
	end)
end

RegisterServerEvent('esx_petroleum:startHarvestKoda')
AddEventHandler('esx_petroleum:startHarvestKoda', function()
	local _source = source

	if not PlayersHarvestingKoda[_source] then
		PlayersHarvestingKoda[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('pegar_petroleobruto'))
		HarvestKoda(_source)
	else
		print(('esx_petroleum: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_petroleum:stopHarvestKoda')
AddEventHandler('esx_petroleum:stopHarvestKoda', function()
	local _source = source

	PlayersHarvestingKoda[_source] = false
end)

local function TransformKoda(source)

	SetTimeout(Config.TimeToProcess, function()
		if PlayersTransformingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local kodaQuantity = xPlayer.getInventoryItem('petroleum').count
			local pooch = xPlayer.getInventoryItem('petroleumgross')

			if pooch.limit ~= -1 and pooch.count >= pooch.limit then
				TriggerClientEvent('esx:showNotification', source, _U('nao_tens_petroleo_suficientes'))
			elseif kodaQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, _U('nao_tens_mais_petroleo'))
			else
				xPlayer.removeInventoryItem('petroleumgross', 2)
				xPlayer.addInventoryItem('petroleumgross', 1)

				TransformKoda(source)
			end
		end
	end)
end

RegisterServerEvent('esx_petroleum:startTransformKoda')
AddEventHandler('esx_petroleum:startTransformKoda', function()
	local _source = source

	if not PlayersTransformingKoda[_source] then
		PlayersTransformingKoda[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('producao_de_petroleobruto'))
		TransformKoda(_source)
	else
		print(('esx_petroleum: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_petroleum:stopTransformKoda')
AddEventHandler('esx_petroleum:stopTransformKoda', function()
	local _source = source

	PlayersTransformingKoda[_source] = false
end)

local function SellKoda(source)

	SetTimeout(Config.TimeToSell, function()
		if PlayersSellingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local poochQuantity = xPlayer.getInventoryItem('petroleumgross').count

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('nao_tens_petroleobruto'))
			else
				xPlayer.removeInventoryItem('petroleumgross', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('bank', 15)
					TriggerClientEvent('esx:showNotification', source, _U('vendeste_petroleo'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('bank', 15)
					TriggerClientEvent('esx:showNotification', source, _U('vendeste_petroleo'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('bank', 15)
					TriggerClientEvent('esx:showNotification', source, _U('vendeste_petroleo'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('bank', 15)
					TriggerClientEvent('esx:showNotification', source, _U('vendeste_petroleo'))
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('bank', 15)
					TriggerClientEvent('esx:showNotification', source, _U('vendeste_petroleo'))
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('bank', 15)
					TriggerClientEvent('esx:showNotification', source, _U('vendeste_petroleo'))
				end

				SellKoda(source)
			end
		end
	end)
end

RegisterServerEvent('esx_petroleum:startSellKoda')
AddEventHandler('esx_petroleum:startSellKoda', function()
	local _source = source

	if not PlayersSellingKoda[_source] then
		PlayersSellingKoda[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('venda_do_petroleo'))
		SellKoda(_source)
	else
		print(('esx_petroleum: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_petroleum:stopSellKoda')
AddEventHandler('esx_petroleum:stopSellKoda', function()
	local _source = source

	PlayersSellingKoda[_source] = false
end)

RegisterServerEvent('esx_petroleum:GetUserInventory')
AddEventHandler('esx_petroleum:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_petroleum:ReturnInventory',
		_source,
		xPlayer.getInventoryItem('petroleum').count,
		xPlayer.getInventoryItem('petroleumgross').count,
		xPlayer.job.name,
		currentZone
	)
end)

ESX.RegisterUsableItem('petroleum', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('petroleum', 1)

	TriggerClientEvent('esx_petroleum:onPot', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('used_one_koda'))
end)
