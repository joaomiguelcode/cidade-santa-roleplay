if not Config.Enabled then return end

-- `@sx/linker.lua` cede a execucao enquanto espera o filesystem da biblioteca ficar pronto,
-- entao no primeiro join os client scripts deste resource chegam a rodar com `sx` ainda nil.
-- Registrar tick direto no escopo do arquivo aborta o carregamento nessa linha e deixa tudo
-- que vem depois sem definir. Use este helper no lugar de `sx.script.setTick` no topo do arquivo.

---@param fn fun()
function CargameSetTick(fn)

    CreateThread(function()
        while not (sx and sx.script and sx.script.setTick) do
            Wait(50)
        end

        sx.script.setTick(fn)
    end)
end
