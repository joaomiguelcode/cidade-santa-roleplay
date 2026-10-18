sx.event = { }

---@generic TEvent
---@param eventName string
---@param handler fun(): TEvent
---@return { subscribe: fun( self, handler: fun( event: TEvent ) ) } | fun( event: TEvent )
function sx.event.new( eventName, handler )

    local self = { }

    function self:subscribe( handler )

        AddEventHandler( eventName, handler )
    end

    function self:emit( event )

        TriggerEvent( eventName, event )
    end

    setmetatable( self, { __call = self.emit } )

    return self
end