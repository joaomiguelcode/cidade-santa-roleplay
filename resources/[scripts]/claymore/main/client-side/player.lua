Player = {

    Ped = 0,

    Coords = vec3(0.0, 0.0, 0.0),

    Pid = 0,

    Set = function(self)
        
        self.Ped = PlayerPedId()

        self.Coords = GetEntityCoords(self.Ped)

        self.Pid = PlayerId()

        self.Source = GetPlayerServerId(self.Pid)

    end
}