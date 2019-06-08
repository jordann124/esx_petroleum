Config              = {}
Config.MarkerType   = 0
Config.DrawDistance = 100.0
Config.ZoneSize     = {x = 1.0, y = 2.0, z = 1.0}
Config.MarkerColor  = {r = 2, g = 246, b = 0}
Config.ShowBlips   = true  -- Blip Mapa

Config.RequiredCopsKoda  = 0

Config.TimeToFarm    = 1 * 1000
Config.TimeToProcess = 1 * 1000
Config.TimeToSell    = 1  * 1000

Config.Locale = 'en'

Config.Zones = {
	CatchPetroleum =		{x = 1714.89,	y = -1621.52,	z = 112.48,	name = _U('catch_petroleum'),		sprite = 361,	color = 1},
	ProductionPetroleum =	{x = 1526.11,	y = -2063.12,	z = 77.28,	name = _U('production_petroleum'),	sprite = 473,	color = 1},
	SellPetroleum =		    {x = -708.31,	y = -903.52,	z = 19.22,	name = _U('sell_petroleum'),		sprite = 361,	color = 1}
}
