Config = Config or {}



-- Config.Wall = {
--     command = "wall",
--     permission = "player.wall",
--     outline = false,
--     opacity = 245,
-- }

Config.PropManager = {
    command = "propmanager",
    permission = {
        ["Admin"] = 5,
        ["NameExperiencia"] = 1,
        ["Orgs"] = 4,
        ["Resenha"] = 4,
        ["Festival"] = 4,
        ["Eventos"] = 4,
        ["Entretenimento"] = 4,
        ["DP"] = 4,
        ["Legal"] = 4,
        ["Mentoria"] = 4,
        ["Discord"] = 4,
        ["Recrutamento"] = 4,
        ["FacxFac"] = 4,
        ["Ações"] = 4,
        ["Chamados"] = 4,
        ["Tickets"] = 4,
        ["AntiZaralho"] = 4,
        ["AntiHacker"] = 4,
        ["AntiRDM"] = 4,
        ["SocialMidia"] = 4,
        ["WallStreet"] = 3,
        ["gestaoinfluencer"] = 3,
        ["Afiliado"] = 2,
    },
}

Config.CleanArea = {
    command = "cleanarea",
    permission = {
        ["Admin"] = 5,
        ["NameExperiencia"] = 1,
        ["Afiliado"] = 5,
        ["gestaoinfluencer"] = 4,
        ["GestaoComercial"] = 1,
        ["CS"] = 1,
    },
}