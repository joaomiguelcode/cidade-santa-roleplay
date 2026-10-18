vRP.Prepare('News/Add', 'INSERT INTO hub_news(title,subtitle,previewImage,content,author) VALUES(@title,@subtitle,@previewImage,@content,@author)')
vRP.Prepare('News/Get', 'SELECT * FROM hub_news ORDER BY id DESC LIMIT 10')
vRP.Prepare('News/Rem', 'DELETE FROM hub_news WHERE id = @id')

vRP.Prepare('HubTopRanks/Pop', 'SELECT id,name,name2 FROM characters ORDER BY id DESC LIMIT 10')
vRP.Prepare('battlepass/GetPlayerInfo', 'SELECT * FROM battlepass WHERE passport = @passport')
vRP.Prepare('battlepass/InsertPlayer', 'INSERT INTO battlepass(passport,experience,level,hasPremium,premium,free) VALUES(@passport,@experience,@level,@hasPremium,@premium,@free)')
vRP.Prepare('battlepass/UpdatePlayer', 'UPDATE battlepass SET experience = @experience, level = @level, hasPremium = @hasPremium, premium = @premium, free = @free WHERE passport = @passport')
vRP.Prepare('battlepass/SetCompleted', 'UPDATE battlepass SET completed = current_timestamp() WHERE passport = @passport')
