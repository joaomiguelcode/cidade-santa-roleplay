---@enum character-creator.EnumCreationState
eCharacterCreatorCreationState = {
    NONE = 0 << 0,             -- não está criando ou editando
    CREATING = 1 << 1,         -- está criando um personagem
    EDITING = 1 << 2,          -- está editando um personagem
    USE_CREATOR_ITEM = 1 << 3, -- está usando o item do creator
}