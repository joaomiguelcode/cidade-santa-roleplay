vRP.Prepare('dashboard/GetPlayerStats', 'SELECT * FROM characters WHERE id = @passport')
vRP.Prepare('dashboard/GetTickets', 'SELECT * FROM dashboard_tickets WHERE status = "open" ORDER BY id DESC')
vRP.Prepare('dashboard/InsertTicket', 'INSERT INTO dashboard_tickets (passport, subject, message, status) VALUES (@passport, @subject, @message, "open")')
vRP.Prepare('dashboard/CloseTicket', 'UPDATE dashboard_tickets SET status = "closed", staff_passport = @staff_passport WHERE id = @id')
