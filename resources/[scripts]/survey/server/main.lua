local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS survey_submissions (
            id INT AUTO_INCREMENT PRIMARY KEY,
            passport INT NOT NULL,
            survey_key VARCHAR(100) NOT NULL,
            rating INT NOT NULL,
            answers LONGTEXT,
            created_at BIGINT NOT NULL,
            INDEX idx_pass (passport),
            INDEX idx_key (survey_key)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

CreateThread(function()
    SurveyScheduler.Init()
    print('[survey] Server initialized.')
end)
