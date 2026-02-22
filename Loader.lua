local url = "https://raw.githubusercontent.com/SimpleSpeedHub/OPWash/refs/heads/main/Main.lua"

local ok, err = pcall(function()
	loadstring(game:HttpGet(url))()
end)

if not ok then
	warn("OPWash failed to load:", err)
end
