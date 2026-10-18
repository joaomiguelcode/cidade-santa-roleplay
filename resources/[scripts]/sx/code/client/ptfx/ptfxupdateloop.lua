-- Update thread: spawned on the first effect (CreatePtfx), drains itself when the last entry is freed. Each
-- tick: reset the per-tick start budget, then (1) keep-alive every active entry (cheap), and (2) process a
-- round-robin slice so ped-acquire / LOD update / new handle starts are bounded and spread across frames
-- rather than bursting one frame. When gActiveCount hits 0 the loop ends and gThreadRunning resets.

---@return nil
function StartPtfxUpdateThread()

    gThreadRunning = true

    CreateThread( function()

        while gActiveCount > 0 do

            Wait( PTFX_TICK_MS )

            -- refresh once per tick so `setr sx_ptfx_profiler 1` toggles live; held constant for the whole
            -- tick, which keeps every Enter/Exit below balanced.
            gPtfxProfilerEnabled = GetConvarInt( 'sx_ptfx_profiler', 0 ) == 1

            gStartsThisTick = 0
            local focusCoords = sx.client.player.getFocusPosition()

            EnterPtfxProfilerScope( 'ptfx:keepalive' )
            for i = 1, MAX_PTFX_SLOTS do
                local ptfx = gPtfx[ i ]
                if ptfx.isValid then
                    PtfxKeepAlive( ptfx, focusCoords )
                end
            end
            ExitPtfxProfilerScope()

            EnterPtfxProfilerScope( 'ptfx:process' )
            local evaluated, examined = 0, 0
            while evaluated < PTFX_EVAL_PER_TICK and examined < MAX_PTFX_SLOTS do

                gEvalCursor = gEvalCursor % MAX_PTFX_SLOTS + 1
                examined = examined + 1

                local ptfx = gPtfx[ gEvalCursor ]
                if ptfx.isValid then
                    ProcessPtfx( ptfx, focusCoords )
                    evaluated = evaluated + 1
                end
            end
            ExitPtfxProfilerScope()
        end

        gThreadRunning = false
    end )
end
