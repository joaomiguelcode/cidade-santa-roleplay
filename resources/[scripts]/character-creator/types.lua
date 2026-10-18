---@class character-creator.CameraTransition
---@field targetPos vector3
---@field duration number

---@class character-creator.PresetAppearance
---@field id number
---@field image string
---@field preset table Array no formato Barber (índices 1-51+)

-- feito para aplicar customização de skinshop e barbershop
---@class character-creator.PresetCustomization
---@field skinshop table
---@field barbershop table

---@class character-creator.CreationState
---@field userModelHash number
---@field flag character-creator.EnumCreationState
---@field startAt number
---@field clothes table
---@field tattoos table
---@field appearance character-creator.CustomizationData
---@field position vector4
---@field hasAlreadyImportedAppearance boolean caso true, ele não adiciona score ao importar aparencia (sistema de suspeitos)

---@enum character-creator.EnumOverlays
eCharacterCreatorOverlays = {
    BLEMISHES = 0,          -- Manchas de pele (acne, marcas, imperfeições)
    FACIAL_HAIR = 1,        -- Barba e bigode
    EYEBROWS = 2,           -- Sobrancelhas
    AGEING = 3,             -- Marcas de envelhecimento (rugas, olheiras)
    MAKEUP = 4,             -- Maquiagem (geral)
    BLUSH = 5,              -- Blush (bochechas)
    COMPLEXION = 6,         -- Textura da pele (tom, brilho, oleosidade)
    SUN_DAMAGE = 7,         -- Danos solares (vermelhidão, queimaduras leves)
    LIPSTICK = 8,           -- Batom
    MOLES_FRECKLES = 9,     -- Sinais e sardas
    CHEST_HAIR = 10,        -- Pelos no peito
    BODY_BLEMISHES = 11,    -- Imperfeições corporais (cicatrizes, manchas)
    ADD_BODY_BLEMISHES = 12 -- Imperfeições extras (camada secundária)
}

---@enum character-creator.EnumComponentVariations
eCharacterCreatorComponentVariations = {
    INVALID = 0xFFFFFFFF,
    FACE = 0,
    MASK = 1,
    HAIR = 2,
    TORSO = 3,
    LEG = 4,
    PARACHUTE = 5,
    SHOES = 6,
    ACCESSORY = 7,
    UNDERSHIRT = 8,
    KEVLAR = 9,
    BADGE = 10
}

---@enum character-creator.EnumFaceFeatures
eCharacterCreatorFaceFeatures = {
    NOSE_WIDTH = 0,          -- Largura do nariz (Fino/Largo)
    NOSE_PEAK = 1,           -- Pico do nariz (Cima/Baixo)
    NOSE_LENGTH = 2,         -- Comprimento do nariz (Longo/Curto)
    NOSE_BONE_CURVENESS = 3, -- Curvatura do osso do nariz (Torto/Curvo)
    NOSE_TIP = 4,            -- Ponta do nariz (Cima/Baixo)
    NOSE_BONE_TWIST = 5,     -- Torção do osso do nariz (Esquerda/Direita)
    EYEBROW_HEIGHT = 6,      -- Sobrancelha (Cima/Baixo)
    EYEBROW_DEPTH = 7,       -- Sobrancelha (Dentro/Fora)
    CHEEK_BONES_HEIGHT = 8,  -- Maçãs do rosto (Cima/Baixo)
    CHEEK_BONES_WIDTH = 9,   -- Largura lateral das maçãs (Dentro/Fora)
    CHEEK_WIDTH = 10,        -- Largura das bochechas (Inchado/Magro)
    EYE_OPENING = 11,        -- Abertura dos olhos (Arregalado/Fechado)
    LIP_THICKNESS = 12,      -- Espessura dos lábios (Grosso/Fino)
    JAW_BONE_WIDTH = 13,     -- Largura do maxilar (Estreito/Largo)
    JAW_BONE_SHAPE = 14,     -- Formato do maxilar (Redondo/Quadrado)
    CHIN_HEIGHT = 15,        -- Queixo (Cima/Baixo)
    CHIN_LENGTH = 16,        -- Comprimento do queixo (Dentro/Fora)
    CHIN_SHAPE = 17,         -- Formato do queixo (Pontudo/Quadrado)
    CHIN_HOLE = 18,          -- Covinha do queixo
    NECK_THICKNESS = 19      -- Espessura do pescoço (Fino/Grosso)
}


---@enum barbershop.EnumAppearance
eBarbershopAppearance = {
    SHAPE_FIRST_ID = 1,
    SHAPE_SECOND_ID = 2,
    SHAPE_MIX = 3,
    SKIN_FIRST_ID = 5,

    EYE_COLOR = 4,

    HAIR_DRAWABLE_ID = 10,
    HAIR_COLOR_ID = 11,
    HAIR_HIGHLIGHT_COLOR_ID = 12,

    COMPLEXION_INDEX = 6,
    BLEMISHES_INDEX = 7,
    MOLES_FRECKLES_INDEX = 8,
    AGEING_INDEX = 9,

    MAKEUP_INDEX = 13,
    MAKEUP_OPACITY = 14,
    MAKEUP_COLOR_ID = 15,

    LIPSTICK_INDEX = 16,
    LIPSTICK_OPACITY = 17,
    LIPSTICK_COLOR_ID = 18,

    EYEBROWS_INDEX = 19,
    EYEBROWS_OPACITY = 20,
    EYEBROWS_COLOR_ID = 21,

    FACIAL_HAIR_INDEX = 22,
    FACIAL_HAIR_OPACITY = 23,
    FACIAL_HAIR_COLOR_ID = 24,

    BLUSH_INDEX = 25,
    BLUSH_OPACITY = 26,
    BLUSH_COLOR_ID = 27,

    NOSE_WIDTH = 28,
    NOSE_PEAK = 29,
    NOSE_LENGTH = 30,
    NOSE_BONE_CURVENESS = 31,
    NOSE_TIP = 32,
    NOSE_BONE_TWIST = 33,

    EYEBROW_DEPTH = 34,
    EYEBROW_HEIGHT = 44,
    EYE_OPENING = 47,

    CHEEK_BONES_HEIGHT = 35,
    CHEEK_BONES_WIDTH = 36,
    CHEEK_WIDTH = 45,

    JAW_BONE_SHAPE = 37,
    CHIN_HEIGHT = 38,
    CHIN_SHAPE = 39,
    CHIN_LENGTH = 40,
    CHIN_HOLE = 41,
    JAW_BONE_WIDTH = 46,

    LIP_THICKNESS = 42,
    NECK_THICKNESS = 43,

    CHEST_HAIR_INDEX = 48,
    CHEST_HAIR_OPACITY = 49,
    CHEST_HAIR_COLOR_ID = 50,
    CHEST_HAIR_SECOND_COLOR_ID = 51,

    -- NEW FEATURES
    SHAPE_THIRD_ID = 60,
    SKIN_SECOND_ID = 61,
    SKIN_THIRD_ID = 62,
    SKIN_MIX = 63,
    THIRD_MIX = 64,
    IS_PARENT = 65,

    -- NEW FATHER AND MOTHER 

    NEW_FATHER = 66,
    NEW_MOTHER = 67,
}

---@class character-creator.Overlay
---@field index number
---@field opacity number

---@class character-creator.OverlayColor
---@field colorType number
---@field colorId number
---@field secondColorId number

---@class character-creator.ComponentVariation
---@field drawableId integer
---@field textureId integer
---@field paletteId integer

---@class character-creator.HeadBlendData
---@field shapeFirstID integer ID do pai (0-45)
---@field shapeSecondID integer ID da mãe (0-45)
---@field shapeThirdID integer ID do terceiro shape (geralmente 0)
---@field skinFirstID integer ID da skin do pai (0-45)
---@field skinSecondID integer ID da skin da mãe (0-45)
---@field skinThirdID integer ID da terceira skin (geralmente 0)
---@field shapeMix number Mistura de formato facial entre pai/mãe (0.0 - 1.0)
---@field skinMix number Mistura de tom de pele entre pai/mãe (0.0 - 1.0)
---@field thirdMix number Mistura com o terceiro (geralmente 0.0)
---@field isParent boolean Se é um preset de pai/mãe

---@class character-creator.HairColor
---@field colorId integer
---@field highlightColorId integer

---@alias character-creator.Overlays table<character-creator.EnumOverlays, character-creator.Overlay>
---@alias character-creator.FaceFeatures table<character-creator.EnumFaceFeatures, number>
---@alias character-creator.OverlayColors table<character-creator.EnumOverlays, character-creator.OverlayColor>
---@alias character-creator.ComponentVariations table<character-creator.EnumComponentVariations, character-creator.ComponentVariation>

---@class character-creator.CustomizationData
---@field FACE_FEATURES character-creator.FaceFeatures
---@field OVERLAYS character-creator.Overlays
---@field OVERLAY_COLORS character-creator.OverlayColors
---@field COMPONENT_VARIATIONS character-creator.ComponentVariations
---@field HEAD_BLEND_DATA character-creator.HeadBlendData
---@field HAIR_COLOR character-creator.HairColor
---@field EYE_COLOR integer Cor dos olhos (0-31)

---@alias character-creator.CreatorFeaturesData table<character-creator.EnumCreationState, string[]>