--- Visibility é responsável por gerenciar os dados compartilhados
--- entre resources para saber se há uma VisibilityManagerHost ativa e quais
--- informações estão sendo usadas.

sx.client.visibility.state = --[[ sx.lazy(
    function()
        return --]] sx.globalstorage.new( 'visibility', {

            ---@type boolean
            hasOverride = false,

            ---@type number[] | nil
            excludePlayerIds = nil,
        })