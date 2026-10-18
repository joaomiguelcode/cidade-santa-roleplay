cityName = GetConvar("cityName", "")
GroupCoords = {
    ["Militar"] = vector3(2567.58,-358.4,92.88),
    ["Civil"] = vector3(-444.09,6001.79,43.93),
    ["Tatica"] = vector3(-825.44,-1220.29,17.91),
    ["Exercito"] = vector3(-2329.46,3266.47,32.77),
    ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
    ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
    ["Juridico"] = vector3(-518.0,-251.84,35.52),
    ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
}

if cityName == "CidadeNobre" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Boomerang" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Grande" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(-295.77,-624.77,34.36),
        ["Mechanic"] = vector3(548.34,-175.90,55.96),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Fronteira" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Malta" then
        GroupCoords = {
            ["Militar"] = vector3(439.24,-983.91,30.69),
            ["Civil"] = vector3(-444.09,6001.79,43.93),
            ["Tatica"] = vector3(-825.44,-1220.29,17.91),
            ["Exercito"] = vector3(-2329.46,3266.47,32.77),
            ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
            ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
            ["Juridico"] = vector3(-518.0,-251.84,35.52),
            ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
        }
elseif cityName == "Universo" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Federal"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Santa" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Maresia" then
    GroupCoords = {

        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Militar"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Alexandria" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Kingdom" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Imperium" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "GoatRP" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "District99" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }    
elseif cityName == "Krown" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }    
elseif cityName == "Orizon" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }    
elseif cityName == "Liberty99" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }    
elseif cityName == "Royal" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Real" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
elseif cityName == "Prime" then
    GroupCoords = {
        ["Militar"] = vector3(2567.58,-358.4,92.88),
        ["Civil"] = vector3(-444.09,6001.79,43.93),
        ["Tatica"] = vector3(-825.44,-1220.29,17.91),
        ["Exercito"] = vector3(-2329.46,3266.47,32.77),
        ["Paramedic"] = vector3(1152.97,-1526.05,34.12),
        ["Mechanic"] = vector3(-1098.62,-2046.20,13.29),
        ["Juridico"] = vector3(-518.0,-251.84,35.52),
        ["Bombeiros"] = vector3(-663.45,-73.46,38.43),
    }
end