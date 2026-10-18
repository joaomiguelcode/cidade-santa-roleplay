-- deathstatue announcement slot server-side
AnnouncementSlots = {}

function ScheduleDeathstatueAnnouncement(timeMs, callback)
    SetTimeout(timeMs, callback)
end
