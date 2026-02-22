local url = "PON_AQUI_LA_URL_DE_MAIN.lua"

local ok, err = pcall(function()
	loadstring(game:HttpGet(url))()
end)

if not ok then
	warn("OPWash failed to load:", err)
end
