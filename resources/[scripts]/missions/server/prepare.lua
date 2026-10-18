-- missions sql prepare
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

vRP.prepare('missions/getUserMissions', 'SELECT * FROM player_missions WHERE passport = @passport')
vRP.prepare('missions/updateMission', 'INSERT INTO player_missions (passport, mission_id, progress, completed) VALUES (@passport, @mission_id, @progress, @completed) ON DUPLICATE KEY UPDATE progress = @progress, completed = @completed')
vRP.prepare('missions/getUserSkills', 'SELECT * FROM player_skills WHERE passport = @passport')
vRP.prepare('missions/updateSkill', 'INSERT INTO player_skills (passport, skill_id, xp) VALUES (@passport, @skill_id, @xp) ON DUPLICATE KEY UPDATE xp = @xp')
