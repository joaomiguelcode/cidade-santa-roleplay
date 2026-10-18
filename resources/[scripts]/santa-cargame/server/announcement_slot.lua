-- cargame announcement slot server-side
AnnouncementSlots = {}

function ScheduleCargameAnnouncement(timeMs, callback)
    SetTimeout(timeMs, callback)
end
