PALETTE_COLORS = {
    hair = {},
    -- percebi em testes que os overlay's usam a mesma cor para todas as partes ( sim tive que testar muito isso para perceber kkk)
    overlay = {},
}


--[[
    dict de cores de overlay,
    1 for eyebrows,
    beards,
    makeup,
    and chest hair; 
    2 for blush and lipstick;
    and 0 otherwise, though not called in those cases.
]]
DICT_COLORS_OVERLAYS = {
    [eCharacterCreatorOverlays.EYEBROWS] = 1,
    [eCharacterCreatorOverlays.FACIAL_HAIR] = 1,
    [eCharacterCreatorOverlays.CHEST_HAIR] = 1,

    [eCharacterCreatorOverlays.MAKEUP] = 2,
    [eCharacterCreatorOverlays.BLUSH] = 2,
    [eCharacterCreatorOverlays.LIPSTICK] = 2,
    
    ['OTHER_OVERLAYS'] = 2
}

PALETTE_COLORS.eye = {
    { id = 0,  name = "black",                      color = 'rgb(20,20,20)' },
    { id = 1,  name = "very light blue/green",      color = 'rgb(180,255,240)' },
    { id = 2,  name = "dark blue",                  color = 'rgb(30,60,120)' },
    { id = 3,  name = "brown",                      color = 'rgb(80,50,20)' },
    { id = 4,  name = "darker brown",               color = 'rgb(50,30,10)' },
    { id = 5,  name = "light brown",                color = 'rgb(120,80,40)' },
    { id = 6,  name = "blue",                       color = 'rgb(70,100,180)' },
    { id = 7,  name = "light blue",                 color = 'rgb(140,180,250)' },
    { id = 8,  name = "pink",                       color = 'rgb(255,160,200)' },
    { id = 9,  name = "yellow",                     color = 'rgb(255,240,60)' },
    { id = 10, name = "purple",                     color = 'rgb(160,80,180)' },
    { id = 11, name = "black (duplicate)",          color = 'rgb(10,10,10)' },
    { id = 12, name = "dark green",                 color = 'rgb(20,80,40)' },
    { id = 13, name = "light brown (duplicate)",    color = 'rgb(130,90,50)' },
    { id = 14, name = "yellow/black pattern",       color = 'rgb(200,180,40)' },
    { id = 15, name = "light colored spiral",       color = 'rgb(180,220,180)' },
    { id = 16, name = "shiny red",                  color = 'rgb(200,20,20)' },
    { id = 17, name = "shiny half blue/half red",   color = 'rgb(120,60,120)' },
    { id = 18, name = "half black/half light blue", color = 'rgb(80,120,150)' },
    { id = 19, name = "white/red perimeter",        color = 'rgb(240,220,220)' },
    { id = 20, name = "green snake",                color = 'rgb(30,120,30)' },
    { id = 21, name = "red snake",                  color = 'rgb(150,20,20)' },
    { id = 22, name = "dark blue snake",            color = 'rgb(20,40,100)' },
    { id = 23, name = "dark yellow",                color = 'rgb(150,130,20)' },
    { id = 24, name = "bright yellow",              color = 'rgb(255,220,40)' },
    { id = 25, name = "all black",                  color = 'rgb(0,0,0)' },
    { id = 26, name = "red small pupil",            color = 'rgb(200,0,0)' },
    { id = 27, name = "devil blue/black",           color = 'rgb(40,40,80)' },
    { id = 28, name = "white small pupil",          color = 'rgb(255,255,255)' },
    { id = 29, name = "glossed over",               color = 'rgb(210,210,210)' },
}


for i = 0, GetNumHairColors() - 1 do
    table.insert(PALETTE_COLORS.hair, { id = i, color = string.format('rgb(%d,%d,%d)', GetPedHairRgbColor(i)) })
end

for i = 0, GetNumMakeupColors() - 1 do
    table.insert(PALETTE_COLORS.overlay, { id = i, color = string.format('rgb(%d,%d,%d)', GetPedMakeupRgbColor(i)) })
end

-- blush -> segue cor dos makeups?
-- batom -> segue cor dos makeups?
-- lipsticks -> segue cor dos makeups?