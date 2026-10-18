
---@alias TickAbortSignal fun()

sx.script = { }

---TODO: Mover para sx
---@param fn fun()
---@return TickAbortSignal
function sx.script.setTick( fn )

    local abort = false

    CreateThread(
        function()
            while not abort do

                fn()

                Wait(0)
            end
        end
    )

    return function()

        abort = true
    end
end

sx.async = { }

---@param pA promise
---@param timeoutMsec number
---@param timeoutMessage? string
---@return promise
function sx.async.withTimeout( pA, timeoutMsec, timeoutMessage )

    timeoutMessage = timeoutMessage or 'Timeout'

    local pT = promise.new()

    local timeoutId = SetTimeout( timeoutMsec, function()

        pT:reject( timeoutMessage )
    end)

    local p = promise.first({ pA, pT })

    p:next(
        function( result )

            ClearTimeout( timeoutId )
        end
    )

    return p
end