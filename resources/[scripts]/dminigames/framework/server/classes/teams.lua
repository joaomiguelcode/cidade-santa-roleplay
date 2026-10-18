MinigameTeams = class()

function MinigameTeams:__init(teamA, teamB)
    self.teamA = teamA or {}
    self.teamB = teamB or {}
end
