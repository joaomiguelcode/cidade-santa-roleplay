RegisterNUICallback("getTheme",function(Data,Callback)
  local theme = GetTheme()
  Callback(theme)
end)