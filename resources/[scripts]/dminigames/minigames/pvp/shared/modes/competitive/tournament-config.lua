---Configuracao compartilhada do sistema de torneios do competitivo.

---Liga o torneio em todas as cidades.
PVP_TOURNAMENT_ENABLED = true

---Teto tecnico interno para proteger payload/render do chaveamento.
---Nao aparece na interface do organizador.
PVP_TOURNAMENT_MAX_TEAMS = 256
PVP_TOURNAMENT_MIN_PLAYERS_PER_TEAM = 5

function PvpIsTournamentEnabled()
    return PVP_TOURNAMENT_ENABLED == true
end
