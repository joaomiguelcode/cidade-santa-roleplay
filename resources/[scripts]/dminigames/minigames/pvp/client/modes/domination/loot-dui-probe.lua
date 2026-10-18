local gRenderNatives = DminigamesRenderDiagnostics.Natives( 'loot' )

-- QA incremental: DUI, textura e plano estatico ativados separadamente por comando.
---@class DominationLootProbeQuad
---@field bottomLeft vector3
---@field bottomRight vector3
---@field topLeft vector3
---@field topRight vector3

---@class DominationLootDuiProbe
---@field dui number?
---@field texture number?
---@field quad DominationLootProbeQuad?
---@field content 'pattern'|'items'|'animated'|'splash'
DominationLootDuiProbe = class()

local LOOT_PROBE_SIZE = 512
local LOOT_PROBE_TXD = 'domination_loot_probe'
local LOOT_PROBE_TEXTURE = 'empty'
local CONTENT_MESSAGES = {
    pattern = '{"action":"probePattern"}',
    items = '{"action":"probeItems"}',
    animated = '{"action":"probeAnimated"}',
    splash = '{"action":"probeSplash"}',
}
local CONTENT_STAGES = { pattern = 3, items = 4, animated = 5, splash = 6 }
-- Sem native publica de unbind/destruicao da runtime texture. Uma tentativa por
-- resource evita acumular superficies ao repetir OFF/ON ou entrar/sair do modo.
local gTextureAttempted = false
---@type TickAbortSignal?
local gDrawTickAbort = nil
---@type DominationLootDuiProbe?
local gDrawOwner = nil
local gDiagnosticLoop = nil

---@param quad DominationLootProbeQuad
local function DrawQuad( quad )

    -- Mesmo UV do renderer de placas. Nenhum calculo/consulta/mensagem por frame.
    local bl, br, tl, tr = quad.bottomLeft, quad.bottomRight, quad.topLeft, quad.topRight
    DrawTexturedPoly(
        bl.x, bl.y, bl.z, br.x, br.y, br.z, tr.x, tr.y, tr.z,
        255, 255, 255, 255, LOOT_PROBE_TXD, LOOT_PROBE_TEXTURE,
        0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0
    )
    DrawTexturedPoly(
        bl.x, bl.y, bl.z, tr.x, tr.y, tr.z, tl.x, tl.y, tl.z,
        255, 255, 255, 255, LOOT_PROBE_TXD, LOOT_PROBE_TEXTURE,
        0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0
    )
end

function DominationLootDuiProbe:__init()

    self.dui = nil
    self.texture = nil
    self.quad = nil
    self.content = 'pattern'
end

---@return boolean
function DominationLootDuiProbe:Start()

    if self.dui then
        return true
    end

    local url = ('https://cfx-nui-%s/web/domination-loot-probe.html'):format( GetCurrentResourceName() )
    local success, dui = pcall( gRenderNatives.CreateDui, url, LOOT_PROBE_SIZE, LOOT_PROBE_SIZE )

    if not success or not dui or dui == 0 then
        sx.logger:error( ('[DominationLootProbe] Falha ao criar DUI: %s'):format( tostring( dui ) ) )
        return false
    end

    self.dui = dui
    sx.logger:info( '[DominationLootProbe] Etapa 1: DUI vazia 512x512 criada, sem textura ou desenho.' )
    return true
end

---@return boolean
function DominationLootDuiProbe:BindTexture()

    if self.texture then
        return true
    end

    if gTextureAttempted then
        sx.logger:warn( '[DominationLootProbe] Reinicie dminigames para repetir a etapa 2 sem acumular texturas.' )
        return false
    end

    if not self.dui then
        sx.logger:warn( '[DominationLootProbe] Ligue a DUI com testdominationlootdui on antes de vincular a textura.' )
        return false
    end

    local available = IsDuiAvailable( self.dui )

    if available ~= true and available ~= 1 then
        sx.logger:warn( '[DominationLootProbe] Navegador ainda indisponivel. Repita testdominationlootdui texture em instantes.' )
        return false
    end

    local success, texture = pcall( function()
        local handle = GetDuiHandle( self.dui )

        if not handle or handle == '' then
            return nil
        end

        gTextureAttempted = true
        local txd = gRenderNatives.CreateRuntimeTxd( LOOT_PROBE_TXD )

        if not txd or txd == 0 then
            return nil
        end

        return gRenderNatives.CreateRuntimeTextureFromDuiHandle( txd, LOOT_PROBE_TEXTURE, handle )
    end )

    if not success or not texture or texture == 0 then
        sx.logger:error( ('[DominationLootProbe] Falha ao vincular textura: %s'):format( tostring( texture ) ) )
        return false
    end

    self.texture = texture
    sx.logger:info( '[DominationLootProbe] Etapa 2: DUI vazia vinculada a textura runtime, sem desenho.' )
    return true
end

---@return boolean
function DominationLootDuiProbe:StartDrawing()

    if gDrawOwner == self then
        return true
    end

    if gDrawOwner or not self.dui or not self.texture then
        sx.logger:warn( '[DominationLootProbe] Ative primeiro testdominationlootdui texture; somente um plano por teste.' )
        return false
    end

    if GetRuntimeTextureWidth( self.texture ) ~= LOOT_PROBE_SIZE
        or GetRuntimeTextureHeight( self.texture ) ~= LOOT_PROBE_SIZE then
        sx.logger:warn( '[DominationLootProbe] Textura ainda indisponivel. Repita testdominationlootdui draw em instantes.' )
        return false
    end

    if not self.quad then
        local ped = PlayerPedId()

        if ped == 0 or not DoesEntityExist( ped ) then
            sx.logger:warn( '[DominationLootProbe] Ped indisponivel para posicionar o plano.' )
            return false
        end

        -- Plano vertical 1,5 x 1,5 m, 2,5 m a frente do ped; nao acompanha a camera.
        self.quad = {
            bottomLeft = GetOffsetFromEntityInWorldCoords( ped, -0.75, 2.5, -0.25 ),
            bottomRight = GetOffsetFromEntityInWorldCoords( ped, 0.75, 2.5, -0.25 ),
            topLeft = GetOffsetFromEntityInWorldCoords( ped, -0.75, 2.5, 1.25 ),
            topRight = GetOffsetFromEntityInWorldCoords( ped, 0.75, 2.5, 1.25 ),
        }
    end

    if self.content == 'splash' then
        -- Retomar desenho nao deve repetir um efeito de entrada.
        self.content = 'animated'
    end

    SendDuiMessage( self.dui, CONTENT_MESSAGES[ self.content ] )
    local quad = self.quad
    gDrawOwner = self
    gDrawTickAbort = sx.script.setTick( function() DrawQuad( quad ) end )
    gDiagnosticLoop = DminigamesRenderDiagnostics.LoopStarted( 'loot', self )
    sx.logger:info( '[DominationLootProbe] Plano estatico a frente do ped; 2 triangulos por frame. Use hide/draw para comparar FPS.' )
    return true
end

---@param content 'pattern'|'items'|'animated'|'splash'
---@return boolean
function DominationLootDuiProbe:SetContent( content )

    if not CONTENT_MESSAGES[ content ] or gDrawOwner ~= self then
        sx.logger:warn( '[DominationLootProbe] Ative testdominationlootdui draw antes de alternar o conteudo.' )
        return false
    end

    if (content == 'animated' or content == 'splash') and self.content == 'pattern' then
        sx.logger:warn( '[DominationLootProbe] Confira primeiro os itens com testdominationlootdui items.' )
        return false
    end

    if self.content == content and content ~= 'splash' then
        return true
    end

    self.content = content
    SendDuiMessage( self.dui, CONTENT_MESSAGES[ content ] )
    sx.logger:info( ('[DominationLootProbe] Conteudo solicitado: %s. Mesma DUI, textura e plano. Splash termina em flutuacao; still cancela o movimento.'):format( content ) )
    return true
end

function DominationLootDuiProbe:StopDrawing()

    if gDrawOwner ~= self then
        return
    end

    gDrawTickAbort()
    DminigamesRenderDiagnostics.LoopFinished( gDiagnosticLoop )
    gDiagnosticLoop = nil
    gDrawTickAbort = nil
    gDrawOwner = nil

    if self.content == 'animated' or self.content == 'splash' then
        -- Para a animacao enquanto oculto; draw reenvia o conteudo selecionado.
        SendDuiMessage( self.dui, CONTENT_MESSAGES.items )
    end
    -- Preserva textura, itens e vertices; animate/still isola o custo do movimento.
end

---@return boolean
function DominationLootDuiProbe:IsDrawing()

    return gDrawOwner == self
end

function DominationLootDuiProbe:Destroy()

    self:StopDrawing()
    local dui = self.dui
    self.dui = nil
    -- Descarta o handle Lua; nao afirma liberar a alocacao nativa da textura.
    self.texture = nil
    self.quad = nil
    self.content = 'pattern'

    if dui then
        gRenderNatives.DestroyDui( dui )
    end
end

function DominationLootDuiProbe:PrintStatus()

    -- Consulta somente ao executar o comando; nao existe polling de prontidao.
    local available = self.dui ~= nil and IsDuiAvailable( self.dui )
    local width = self.texture and GetRuntimeTextureWidth( self.texture ) or 0
    local height = self.texture and GetRuntimeTextureHeight( self.texture ) or 0
    local drawing = gDrawOwner == self

    sx.logger:info( ('[DominationLootProbe] etapa=%d dui=%s browserDisponivel=%s tamanho=512x512 textura=%s resolucao=%dx%d desenho=%s conteudoSolicitado=%s')
        :format( drawing and CONTENT_STAGES[ self.content ] or (self.texture and 2 or 1), self.dui and 'ON' or 'OFF', tostring( available ),
            self.texture and 'ON' or 'OFF', width, height, drawing and 'ON' or 'OFF', self.content ) )

    if gTextureAttempted and not self.texture then
        sx.logger:info( '[DominationLootProbe] Vinculo anterior descartado. Reinicie dminigames para repetir a etapa 2; OFF nao libera a runtime texture.' )
    end
end

---@param mode string
---@return boolean
function DominationLootDuiProbe:SetTestMode( mode )

    if mode == 'on' then
        if not self:Start() then
            return false
        end
    elseif mode == 'texture' then
        if not self:BindTexture() then
            return false
        end
    elseif mode == 'draw' then
        if not self:StartDrawing() then
            return false
        end
    elseif mode == 'hide' then
        self:StopDrawing()
    elseif mode == 'items' or mode == 'pattern' or mode == 'animate' or mode == 'still' or mode == 'splash' then
        local content = mode == 'animate' and 'animated' or (mode == 'still' and 'items' or mode)

        if not self:SetContent( content ) then
            return false
        end
    elseif mode == 'off' then
        self:Destroy()
    elseif mode ~= 'status' then
        sx.logger:warn( 'Uso: testdominationlootdui on|texture|draw|items|animate|splash|still|pattern|hide|off|status' )
        return false
    end

    self:PrintStatus()
    return true
end
