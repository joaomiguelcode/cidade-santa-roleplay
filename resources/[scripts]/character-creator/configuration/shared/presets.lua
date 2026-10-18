---@type table<string, character-creator.PresetAppearance[]>
CREATOR_PRESETS = {}
---@type table<number, character-creator.PresetCustomization>
CREATOR_PRESET_CUSTOMIZATION = {}


-- ==================== PRESETS PADRÃO GTA V ====================
-- Customizações padrão baseadas nos modelos mp_m_freemode_01 e mp_f_freemode_01
-- Valores neutros sem modificações extremas

---@type table Array no formato Barber com valores padrão do GTA V para o modelo masculino
local maleDefault = {
    0,          -- [1] SHAPE_FIRST_ID (Pai)
    0,          -- [2] SHAPE_SECOND_ID (Mãe)
    0.5,        -- [3] SHAPE_MIX (Mistura de formato facial 50%)
    0,          -- [4] EYE_COLOR (Cor dos olhos)
    0,          -- [5] SKIN_FIRST_ID (Tom de pele do pai)
    0,          -- [6] COMPLEXION_INDEX (Textura da pele)
    -1,         -- [7] BLEMISHES_INDEX (Manchas/imperfeições)
    -1,         -- [8] MOLES_FRECKLES_INDEX (Sinais e sardas)
    -1,         -- [9] AGEING_INDEX (Envelhecimento)
    0,          -- [10] HAIR_DRAWABLE_ID (Cabelo)
    0,          -- [11] HAIR_COLOR_ID (Cor do cabelo)
    0,          -- [12] HAIR_HIGHLIGHT_COLOR_ID (Cor secundária)
    -1,         -- [13] MAKEUP_INDEX (Maquiagem)
    0.0,        -- [14] MAKEUP_OPACITY
    0,          -- [15] MAKEUP_COLOR_ID
    -1,         -- [16] LIPSTICK_INDEX (Batom)
    0.0,        -- [17] LIPSTICK_OPACITY
    0,          -- [18] LIPSTICK_COLOR_ID
    0,          -- [19] EYEBROWS_INDEX (Sobrancelhas)
    1.0,        -- [20] EYEBROWS_OPACITY
    0,          -- [21] EYEBROWS_COLOR_ID
    -1,         -- [22] FACIAL_HAIR_INDEX (Barba)
    0.0,        -- [23] FACIAL_HAIR_OPACITY
    0,          -- [24] FACIAL_HAIR_COLOR_ID
    -1,         -- [25] BLUSH_INDEX (Blush)
    0.0,        -- [26] BLUSH_OPACITY
    0,          -- [27] BLUSH_COLOR_ID
    0.0,        -- [28] NOSE_WIDTH
    0.0,        -- [29] NOSE_PEAK
    0.0,        -- [30] NOSE_LENGTH
    0.0,        -- [31] NOSE_BONE_CURVENESS
    0.0,        -- [32] NOSE_TIP
    0.0,        -- [33] NOSE_BONE_TWIST
    0.0,        -- [34] EYEBROW_DEPTH
    0.0,        -- [35] CHEEK_BONES_HEIGHT
    0.0,        -- [36] CHEEK_BONES_WIDTH
    0.0,        -- [37] JAW_BONE_SHAPE
    0.0,        -- [38] CHIN_HEIGHT
    0.0,        -- [39] CHIN_SHAPE
    0.0,        -- [40] CHIN_LENGTH
    0.0,        -- [41] CHIN_HOLE
    0.0,        -- [42] LIP_THICKNESS
    0.0,        -- [43] NECK_THICKNESS
    0.0,        -- [44] EYEBROW_HEIGHT
    0.0,        -- [45] CHEEK_WIDTH
    0.0,        -- [46] JAW_BONE_WIDTH
    0.0,        -- [47] EYE_OPENING
    -1,         -- [48] CHEST_HAIR_INDEX (Pelos no peito)
    0.0,        -- [49] CHEST_HAIR_OPACITY
    0,          -- [50] CHEST_HAIR_COLOR_ID
    0,          -- [51] CHEST_HAIR_SECOND_COLOR_ID
    nil,        -- [52-59] Reservado
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    0,          -- [60] SHAPE_THIRD_ID
    0,          -- [61] SKIN_SECOND_ID
    0,          -- [62] SKIN_THIRD_ID
    0.5,        -- [63] SKIN_MIX (Mistura de tom de pele 50%)
    0.0,        -- [64] THIRD_MIX
    false,      -- [65] IS_PARENT
    0,          -- [66] NEW_FATHER
    0           -- [67] NEW_MOTHER
}

---@type table Array no formato Barber com valores padrão do GTA V para o modelo feminino
local femaleDefault = {
    0,          -- [1] SHAPE_FIRST_ID (Pai)
    0,          -- [2] SHAPE_SECOND_ID (Mãe)
    0.5,        -- [3] SHAPE_MIX (Mistura de formato facial 50%)
    0,          -- [4] EYE_COLOR (Cor dos olhos)
    0,          -- [5] SKIN_FIRST_ID (Tom de pele do pai)
    0,          -- [6] COMPLEXION_INDEX (Textura da pele)
    -1,         -- [7] BLEMISHES_INDEX (Manchas/imperfeições)
    -1,         -- [8] MOLES_FRECKLES_INDEX (Sinais e sardas)
    -1,         -- [9] AGEING_INDEX (Envelhecimento)
    0,          -- [10] HAIR_DRAWABLE_ID (Cabelo)
    0,          -- [11] HAIR_COLOR_ID (Cor do cabelo)
    0,          -- [12] HAIR_HIGHLIGHT_COLOR_ID (Cor secundária)
    -1,         -- [13] MAKEUP_INDEX (Maquiagem)
    0.0,        -- [14] MAKEUP_OPACITY
    0,          -- [15] MAKEUP_COLOR_ID
    -1,         -- [16] LIPSTICK_INDEX (Batom)
    0.0,        -- [17] LIPSTICK_OPACITY
    0,          -- [18] LIPSTICK_COLOR_ID
    0,          -- [19] EYEBROWS_INDEX (Sobrancelhas)
    1.0,        -- [20] EYEBROWS_OPACITY
    0,          -- [21] EYEBROWS_COLOR_ID
    -1,         -- [22] FACIAL_HAIR_INDEX (Barba - não aplicável)
    0.0,        -- [23] FACIAL_HAIR_OPACITY
    0,          -- [24] FACIAL_HAIR_COLOR_ID
    -1,         -- [25] BLUSH_INDEX (Blush)
    0.0,        -- [26] BLUSH_OPACITY
    0,          -- [27] BLUSH_COLOR_ID
    0.0,        -- [28] NOSE_WIDTH
    0.0,        -- [29] NOSE_PEAK
    0.0,        -- [30] NOSE_LENGTH
    0.0,        -- [31] NOSE_BONE_CURVENESS
    0.0,        -- [32] NOSE_TIP
    0.0,        -- [33] NOSE_BONE_TWIST
    0.0,        -- [34] EYEBROW_DEPTH
    0.0,        -- [35] CHEEK_BONES_HEIGHT
    0.0,        -- [36] CHEEK_BONES_WIDTH
    0.0,        -- [37] JAW_BONE_SHAPE
    0.0,        -- [38] CHIN_HEIGHT
    0.0,        -- [39] CHIN_SHAPE
    0.0,        -- [40] CHIN_LENGTH
    0.0,        -- [41] CHIN_HOLE
    0.0,        -- [42] LIP_THICKNESS
    0.0,        -- [43] NECK_THICKNESS
    0.0,        -- [44] EYEBROW_HEIGHT
    0.0,        -- [45] CHEEK_WIDTH
    0.0,        -- [46] JAW_BONE_WIDTH
    0.0,        -- [47] EYE_OPENING
    -1,         -- [48] CHEST_HAIR_INDEX (Não aplicável para feminino)
    0.0,        -- [49] CHEST_HAIR_OPACITY
    0,          -- [50] CHEST_HAIR_COLOR_ID
    0,          -- [51] CHEST_HAIR_SECOND_COLOR_ID
    nil,        -- [52-59] Reservado
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    0,          -- [60] SHAPE_THIRD_ID
    0,          -- [61] SKIN_SECOND_ID
    0,          -- [62] SKIN_THIRD_ID
    0.5,        -- [63] SKIN_MIX (Mistura de tom de pele 50%)
    0.0,        -- [64] THIRD_MIX
    false,      -- [65] IS_PARENT
    0,          -- [66] NEW_FATHER
    0           -- [67] NEW_MOTHER
}

CREATOR_PRESETS['default'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/male_default.png",
            preset = maleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_0.png",
            preset = {0,0,0.08,5,12,0,-1,-1,-1,97,61,0,-1,1.0,56,-1,0,56,23,0.99,56,28,0.99,56,-1,0,56,-0.93,0.78,1.0,0.04,-0.01,0,-1,-0.3,-1,-0.58,-0.16,0.12,0.57,1.0,0.66,0.6,0.02,-0.51,0.3,0.17,-1,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_1.png",
            preset = {0,0,0.65,12,5,0,-1,4,-1,44,60,60,0,0,63,0,0,63,13,0.99,63,3,1.0,63,-1,0,63,-0.72,-0.18,0.68,-0.08,0.12,0,0.3,-0.14,0,-0.65,-0.17,-0.63,0.21,-1.0,0.08,0.6,0.71,-0.68,-1.0,0.87,0,0,63,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_2.png",
            preset = {21,19,0.7,2,7,0,0,-1,1,63,29,26,0,0,53,0,0,53,29,0.99,54,18,0.99,53,-1,0,53,0.55,0.11,0.07,-0.17,0.0,0,-0.55,0.63,-1,-1.0,-0.45,-0.65,0.56,1.0,0.31,0.6,0.07,0.32,-1.0,1.0,0,0,53,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.0,0.0,false,42,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_3.png",
            preset = {16,19,0.65,5,35,0,-1,4,-1,79,59,29,0,0,63,0,0,63,30,0.99,63,4,0.88,63,-1,0,63,-1,0.84,0.72,0.46,0,0,-0.06,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,-0.04,0.6,0.01,0.43,-0.7,-0.26,0,0,63,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_4.png",
            preset = {0,18,0.62,3,38,0,-1,-1,-1,92,0,0,0,0,56,0,0,56,10,0.99,63,22,0.99,56,31,0.68,56,-0.2,1.0,1.0,1.0,-0.22,0,1.0,0,-0.19,0.25,-0.63,-0.53,0.32,0.37,-0.38,0.16,0.31,0.07,-0.37,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,39},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_5.png",
            preset = {13,0,0.5,12,28,0,-1,-1,-1,50,29,0,0,0,56,0,0.09,56,25,0.99,52,7,0.88,52,0,0,52,-1.0,-0.66,1.0,1.0,0.8,0,1.0,0.22,-0.2,-0.81,1.0,1.0,1.0,-1.0,-0.41,0.99,1.0,-1,0.76,0,0,0,52,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_6.png",
            preset = {0,0,0.18,8,45,0,-1,-1,-1,15,61,0,0,0,56,0,0,56,32,0.99,56,16,0.88,56,23,0.99,56,-0.5,-0.26,0.18,-0.08,0.36,0,0.35,-0.24,0,0,0.72,0.03,0.31,0.86,0.04,0.77,-0.34,0,0.36,-0.97,6,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_7.png",
            preset = {13,19,0.5,7,1,0,-1,-1,-1,100,29,29,-1,1.0,0,0,0.09,35,33,0.99,57,7,1.0,56,-1,1.0,0,-1,0,0.43,-0.24,0,0,0,0.7,-0.2,0.57,0.49,0.25,0.37,0.99,-0.41,0.99,0,-1,-0.1,0,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_8.png",
            preset = {13,21,0.65,5,2,0,-1,-1,-1,129,0,0,0,0,0,0,0.09,35,10,0.99,56,10,1.0,56,0,0,0,-1,0,0.71,-0.24,0,0,0.11,0.7,-0.2,0.57,0.49,0.25,0.37,0.99,-0.41,0.99,-0.44,-1,-0.1,0.15,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_9.png",
            preset = {17,0,0.58,3,34,0,1,-1,1,146,55,0,0,0,56,0,0.17,56,32,0.99,63,20,1.0,63,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.59,0,-0.03,0.81,0.86,0.96,1.0,-0.02,0.99,0.77,0.99,0.08,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,17,17},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_10.png",
            preset = {12,19,0.45,0,24,0,14,-1,-1,71,55,0,0,0,0,0,0.17,35,30,0.99,56,2,0.88,56,0,0,0,0.26,-0.4,0.65,0.16,0.04,0,-0.7,-0.63,0,1.0,-0.57,-1.0,-1.0,-0.24,-0.22,0.99,-1.0,0.99,-1.0,0.53,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,12,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_11.png",
            preset = {6,18,0.3,0,0,0,-1,-1,-1,122,61,0,-1,1.0,0,-1,1.0,0,33,1.0,56,6,1.0,56,6,0,0,-1,0,-0.23,0.58,0,0,-1,-1,-1,-1,0,0,-0.4,-1,0.99,-1,0.99,-1,-1,0,0,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,6,39},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_12.png",
            preset = {13,21,0.66,0,3,0,-1,-1,-1,173,60,0,0,0,0,0,0,0,25,0.99,56,-1,0.99,56,-1,0,0,-0.01,0.54,0.49,-0.44,0.3,0,1.0,0.31,0,-0.41,-0.67,-0.34,-0.31,-1.0,-0.32,-1,0.71,-0.87,-0.16,0.28,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_13.png",
            preset = {8,0,0.21,0,23,0,-1,-1,-1,172,20,3,-1,1.0,0,-1,1.0,0,33,1.0,56,6,1.0,63,6,0,0,-1,0,-0.23,0.58,0,0,-1,-1,-1,-1,0,0,-0.4,-1,0.99,-1,0.99,-1,-1,0,0,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,8,0,0.0,0.0,false,8,42},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_14.png",
            preset = {0,0,0.61,7,12,0,-1,0,-1,45,61,61,0,0,0,1,0.0,0,30,1.0,56,1,0.0,52,-1,0,0,-1.0,0.74,1.0,0.46,0,0,0.0,0.5,0,0.08,-0.73,-0.52,0.21,0.0,0.24,0.6,0.0,0.43,0.35,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/female_default.png",
            preset = femaleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_0.png",
            preset = {0,0,1.0,0,12,0,3,-1,-1,107,28,28,7,0,0,5,0,0,3,0.99,63,-1,0,0,1,0,10,0.12,0.07,0.76,0.47,-0.12,0.99,-1,-0.14,-0.13,-0.4,0.04,-0.24,-0.32,0.18,0.24,-1,-0.38,0.23,0.28,1,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_1.png",
            preset = {0,19,0.25,0,12,0,-1,-1,-1,168,61,35,-1,0.25,33,5,0.3,18,18,0.99,56,-1,1.0,0,-1,1.0,34,-1.0,0.37,0.34,0.19,-0.31,0,0.18,-1.0,-0.87,0.09,0.17,-0.28,-0.32,-0.25,-0.84,-1,0.29,0.38,0.16,-0.01,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,39,0,0.0,0.0,false,21,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_2.png",
            preset = {23,21,0.65,2,0,0,-1,-1,-1,42,54,54,1,1.0,56,4,0,23,11,1.0,56,0,0,52,-1,1.0,56,-0.89,0,0.84,0.57,-0.37,0,-1.0,-0.29,-0.54,0.12,-0.84,-0.19,-0.18,0.24,-0.29,-1,0.16,-1,-0.33,-0.12,-1,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_3.png",
            preset = {15,2,0.94,11,9,0,-1,-1,-1,139,61,55,7,0,0,5,0.65,56,17,0.54,56,-1,0,0,3,0,10,-0.29,-0.65,-0.19,1.0,-0.55,0.99,-0.39,-0.27,-0.13,-0.62,-0.42,-0.64,-0.32,-0.03,-0.38,-1,-0.21,-0.26,0.42,1,-1,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.92,0.0,false,15,23},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_4.png",
            preset = {23,21,0.65,5,6,0,-1,-1,-1,134,0,0,15,0.99,56,5,0,24,16,1.0,56,0,0,56,0,0,0,-0.89,0,0.84,0.57,-0.37,0,-0.28,-0.29,-0.54,0.12,-0.84,-0.19,-0.18,0.24,-0.29,-1,0.13,-1,-0.33,0.08,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_5.png",
            preset = {0,0,0.67,13,0,0,-1,6,0,301,61,28,-1,0.25,33,7,0.33,23,13,0.99,56,-1,1.0,0,-1,1.0,34,-1.0,0.0,0.55,0.0,-0.18,0,0.0,-1.0,-0.87,0.13,-0.12,-0.03,-0.42,0.0,-1.0,-1,-0.06,-0.06,0.02,0.13,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.21,0.0,false,22,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_6.png",
            preset = {23,0,1.0,7,12,0,-1,0,-1,143,29,61,3,0.25,33,1,1.0,0,30,1.0,54,-1,1.0,7,-1,0.6,18,-1.0,0.84,0.0,-0.52,0.0,0,-1.0,-0.14,-0.87,-0.04,-0.87,0.0,0.08,0.23,-1.0,-1,0.0,0.99,-0.02,0.13,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_7.png",
            preset = {17,0,0.9,0,1,0,-1,-1,-1,18,61,53,14,1.0,56,4,1.0,56,18,1.0,56,-1,1.0,0,-1,1.0,63,-0.89,0,0.71,0.45,-0.09,0,0,-0.62,0,-0.47,-0.38,0.02,-0.73,0.53,-0.41,-1,0,0,-0.67,1,4,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,17,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_8.png",
            preset = {16,0,0.82,5,36,0,-1,-1,-1,182,61,61,3,0.25,33,2,0.45,21,32,0.99,56,0,0,0,1,0.6,34,-0.03,0.52,0.11,-0.06,-0.33,0,-1.0,-0.17,-0.87,-1.0,0.04,-0.48,-0.1,0.41,-1.0,-1,0.22,-0.51,0.42,0.53,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_9.png",
            preset = {16,0,1.0,0,0,0,0,0,-1,191,5,3,3,0.25,33,9,0.28,24,16,0.99,56,0,0,56,1,0.6,56,-0.73,0.44,0.35,0,-0.28,0,-1,0.99,-0.87,-0.2,-0.03,-0.23,-0.41,0.56,-0.34,-1,0.85,-0.5,0.43,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_10.png",
            preset = {0,0,1.0,1,2,0,-1,-1,-1,48,0,4,14,1.0,55,5,0.99,20,3,0.99,63,0,0,0,1,1.0,10,-0.32,0,-1,0,0.2,0,-0.1,-0.35,0,-0.24,0.04,0.02,-0.28,0,-1,0,-0.38,-0.08,0.18,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_11.png",
            preset = {16,0,0.67,2,4,0,-1,-1,-1,50,44,57,4,1.0,55,5,0.99,20,4,0.99,63,0,0,0,1,1.0,10,-0.62,-0.42,-1,0.33,-0.08,0,-0.1,-0.48,0,-0.3,0.04,-0.25,0.33,0,0.46,0,-0.38,0.01,0.03,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,13,0,1.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_12.png",
            preset = {0,19,0.84,12,12,0,-1,-1,-1,198,61,61,0,1.0,56,4,0,0,1,0.99,63,0,0,0,1,0,10,-0.19,-0.17,1.0,1.0,-0.55,0.99,-1,0.64,-0.13,-0.09,0.04,-0.47,0.08,-0.08,-0.75,-1,-0.38,-0.32,-0.39,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,37,40},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_13.png",
            preset = {23,21,0.8,1,45,0,-1,-1,-1,70,0,61,15,0.99,0,-1,1.0,0,25,1.0,63,0,0,0,0,0,0,0.04,0.04,1.0,1.0,-0.14,0,-0.94,-0.21,-0.54,0.91,-1.0,0.88,0.56,-0.11,-1.0,-1,-0.31,-1.0,-0.48,1,0,0,18,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_14.png",
            preset = {23,4,1.0,3,26,0,-1,-1,-1,97,60,0,0,0,0,1,1.0,0,28,0.99,56,-1,1.0,56,0,0,0,-1.0,0.84,0.0,0.6,0.0,-0.28,0.0,-0.08,0.21,-0.16,-0.7,-0.25,-0.04,0.14,-1.0,-1,0.0,0.81,0.53,0.43,0,0,19,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,1.0,0.0,false,44,25},
        },
    }
}

CREATOR_PRESETS['Santa'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['CidadeNobre'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['District99'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/male_default.png",
            preset = maleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_0.png",
            preset = {0,0,0.08,5,12,0,-1,-1,-1,97,61,0,-1,1.0,56,-1,0,56,23,0.99,56,28,0.99,56,-1,0,56,-0.93,0.78,1.0,0.04,-0.01,0,-1,-0.3,-1,-0.58,-0.16,0.12,0.57,1.0,0.66,0.6,0.02,-0.51,0.3,0.17,-1,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_1.png",
            preset = {0,0,0.65,12,5,0,-1,4,-1,44,60,60,0,0,63,0,0,63,13,0.99,63,3,1.0,63,-1,0,63,-0.72,-0.18,0.68,-0.08,0.12,0,0.3,-0.14,0,-0.65,-0.17,-0.63,0.21,-1.0,0.08,0.6,0.71,-0.68,-1.0,0.87,0,0,63,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_2.png",
            preset = {21,19,0.7,2,7,0,0,-1,1,63,29,26,0,0,53,0,0,53,29,0.99,54,18,0.99,53,-1,0,53,0.55,0.11,0.07,-0.17,0.0,0,-0.55,0.63,-1,-1.0,-0.45,-0.65,0.56,1.0,0.31,0.6,0.07,0.32,-1.0,1.0,0,0,53,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.0,0.0,false,42,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_3.png",
            preset = {16,19,0.65,5,35,0,-1,4,-1,79,59,29,0,0,63,0,0,63,30,0.99,63,4,0.88,63,-1,0,63,-1,0.84,0.72,0.46,0,0,-0.06,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,-0.04,0.6,0.01,0.43,-0.7,-0.26,0,0,63,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_4.png",
            preset = {0,18,0.62,3,38,0,-1,-1,-1,92,0,0,0,0,56,0,0,56,10,0.99,63,22,0.99,56,31,0.68,56,-0.2,1.0,1.0,1.0,-0.22,0,1.0,0,-0.19,0.25,-0.63,-0.53,0.32,0.37,-0.38,0.16,0.31,0.07,-0.37,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,39},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_5.png",
            preset = {13,0,0.5,12,28,0,-1,-1,-1,50,29,0,0,0,56,0,0.09,56,25,0.99,52,7,0.88,52,0,0,52,-1.0,-0.66,1.0,1.0,0.8,0,1.0,0.22,-0.2,-0.81,1.0,1.0,1.0,-1.0,-0.41,0.99,1.0,-1,0.76,0,0,0,52,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_6.png",
            preset = {0,0,0.18,8,45,0,-1,-1,-1,15,61,0,0,0,56,0,0,56,32,0.99,56,16,0.88,56,23,0.99,56,-0.5,-0.26,0.18,-0.08,0.36,0,0.35,-0.24,0,0,0.72,0.03,0.31,0.86,0.04,0.77,-0.34,0,0.36,-0.97,6,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_7.png",
            preset = {13,19,0.5,7,1,0,-1,-1,-1,100,29,29,-1,1.0,0,0,0.09,35,33,0.99,57,7,1.0,56,-1,1.0,0,-1,0,0.43,-0.24,0,0,0,0.7,-0.2,0.57,0.49,0.25,0.37,0.99,-0.41,0.99,0,-1,-0.1,0,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_8.png",
            preset = {13,21,0.65,5,2,0,-1,-1,-1,129,0,0,0,0,0,0,0.09,35,10,0.99,56,10,1.0,56,0,0,0,-1,0,0.71,-0.24,0,0,0.11,0.7,-0.2,0.57,0.49,0.25,0.37,0.99,-0.41,0.99,-0.44,-1,-0.1,0.15,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_9.png",
            preset = {17,0,0.58,3,34,0,1,-1,1,146,55,0,0,0,56,0,0.17,56,32,0.99,63,20,1.0,63,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.59,0,-0.03,0.81,0.86,0.96,1.0,-0.02,0.99,0.77,0.99,0.08,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,17,17},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_10.png",
            preset = {12,19,0.45,0,24,0,14,-1,-1,71,55,0,0,0,0,0,0.17,35,30,0.99,56,2,0.88,56,0,0,0,0.26,-0.4,0.65,0.16,0.04,0,-0.7,-0.63,0,1.0,-0.57,-1.0,-1.0,-0.24,-0.22,0.99,-1.0,0.99,-1.0,0.53,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,12,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_11.png",
            preset = {6,18,0.3,0,0,0,-1,-1,-1,122,61,0,-1,1.0,0,-1,1.0,0,33,1.0,56,6,1.0,56,6,0,0,-1,0,-0.23,0.58,0,0,-1,-1,-1,-1,0,0,-0.4,-1,0.99,-1,0.99,-1,-1,0,0,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,6,39},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_12.png",
            preset = {13,21,0.66,0,3,0,-1,-1,-1,173,60,0,0,0,0,0,0,0,25,0.99,56,-1,0.99,56,-1,0,0,-0.01,0.54,0.49,-0.44,0.3,0,1.0,0.31,0,-0.41,-0.67,-0.34,-0.31,-1.0,-0.32,-1,0.71,-0.87,-0.16,0.28,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_13.png",
            preset = {8,0,0.21,0,23,0,-1,-1,-1,172,20,3,-1,1.0,0,-1,1.0,0,33,1.0,56,6,1.0,63,6,0,0,-1,0,-0.23,0.58,0,0,-1,-1,-1,-1,0,0,-0.4,-1,0.99,-1,0.99,-1,-1,0,0,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,8,0,0.0,0.0,false,8,42},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_14.png",
            preset = {0,0,0.61,7,12,0,-1,0,-1,45,61,61,0,0,0,1,0.0,0,30,1.0,56,1,0.0,52,-1,0,0,-1.0,0.74,1.0,0.46,0,0,0.0,0.5,0,0.08,-0.73,-0.52,0.21,0.0,0.24,0.6,0.0,0.43,0.35,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/female_default.png",
            preset = femaleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_0.png",
            preset = {0,0,1.0,0,12,0,3,-1,-1,107,28,28,7,0,0,5,0,0,3,0.99,63,-1,0,0,1,0,10,0.12,0.07,0.76,0.47,-0.12,0.99,-1,-0.14,-0.13,-0.4,0.04,-0.24,-0.32,0.18,0.24,-1,-0.38,0.23,0.28,1,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_1.png",
            preset = {0,19,0.25,0,12,0,-1,-1,-1,168,61,35,-1,0.25,33,5,0.3,18,18,0.99,56,-1,1.0,0,-1,1.0,34,-1.0,0.37,0.34,0.19,-0.31,0,0.18,-1.0,-0.87,0.09,0.17,-0.28,-0.32,-0.25,-0.84,-1,0.29,0.38,0.16,-0.01,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,39,0,0.0,0.0,false,21,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_2.png",
            preset = {23,21,0.65,2,0,0,-1,-1,-1,42,54,54,1,1.0,56,4,0,23,11,1.0,56,0,0,52,-1,1.0,56,-0.89,0,0.84,0.57,-0.37,0,-1.0,-0.29,-0.54,0.12,-0.84,-0.19,-0.18,0.24,-0.29,-1,0.16,-1,-0.33,-0.12,-1,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_3.png",
            preset = {15,2,0.94,11,9,0,-1,-1,-1,139,61,55,7,0,0,5,0.65,56,17,0.54,56,-1,0,0,3,0,10,-0.29,-0.65,-0.19,1.0,-0.55,0.99,-0.39,-0.27,-0.13,-0.62,-0.42,-0.64,-0.32,-0.03,-0.38,-1,-0.21,-0.26,0.42,1,-1,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.92,0.0,false,15,23},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_4.png",
            preset = {23,21,0.65,5,6,0,-1,-1,-1,134,0,0,15,0.99,56,5,0,24,16,1.0,56,0,0,56,0,0,0,-0.89,0,0.84,0.57,-0.37,0,-0.28,-0.29,-0.54,0.12,-0.84,-0.19,-0.18,0.24,-0.29,-1,0.13,-1,-0.33,0.08,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_5.png",
            preset = {0,0,0.67,13,0,0,-1,6,0,301,61,28,-1,0.25,33,7,0.33,23,13,0.99,56,-1,1.0,0,-1,1.0,34,-1.0,0.0,0.55,0.0,-0.18,0,0.0,-1.0,-0.87,0.13,-0.12,-0.03,-0.42,0.0,-1.0,-1,-0.06,-0.06,0.02,0.13,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.21,0.0,false,22,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_6.png",
            preset = {23,0,1.0,7,12,0,-1,0,-1,143,29,61,3,0.25,33,1,1.0,0,30,1.0,54,-1,1.0,7,-1,0.6,18,-1.0,0.84,0.0,-0.52,0.0,0,-1.0,-0.14,-0.87,-0.04,-0.87,0.0,0.08,0.23,-1.0,-1,0.0,0.99,-0.02,0.13,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_7.png",
            preset = {17,0,0.9,0,1,0,-1,-1,-1,18,61,53,14,1.0,56,4,1.0,56,18,1.0,56,-1,1.0,0,-1,1.0,63,-0.89,0,0.71,0.45,-0.09,0,0,-0.62,0,-0.47,-0.38,0.02,-0.73,0.53,-0.41,-1,0,0,-0.67,1,4,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,17,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_8.png",
            preset = {16,0,0.82,5,36,0,-1,-1,-1,182,61,61,3,0.25,33,2,0.45,21,32,0.99,56,0,0,0,1,0.6,34,-0.03,0.52,0.11,-0.06,-0.33,0,-1.0,-0.17,-0.87,-1.0,0.04,-0.48,-0.1,0.41,-1.0,-1,0.22,-0.51,0.42,0.53,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_9.png",
            preset = {16,0,1.0,0,0,0,0,0,-1,191,5,3,3,0.25,33,9,0.28,24,16,0.99,56,0,0,56,1,0.6,56,-0.73,0.44,0.35,0,-0.28,0,-1,0.99,-0.87,-0.2,-0.03,-0.23,-0.41,0.56,-0.34,-1,0.85,-0.5,0.43,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_10.png",
            preset = {0,0,1.0,1,2,0,-1,-1,-1,48,0,4,14,1.0,55,5,0.99,20,3,0.99,63,0,0,0,1,1.0,10,-0.32,0,-1,0,0.2,0,-0.1,-0.35,0,-0.24,0.04,0.02,-0.28,0,-1,0,-0.38,-0.08,0.18,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_11.png",
            preset = {16,0,0.67,2,4,0,-1,-1,-1,50,44,57,4,1.0,55,5,0.99,20,4,0.99,63,0,0,0,1,1.0,10,-0.62,-0.42,-1,0.33,-0.08,0,-0.1,-0.48,0,-0.3,0.04,-0.25,0.33,0,0.46,0,-0.38,0.01,0.03,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,13,0,1.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_12.png",
            preset = {0,19,0.84,12,12,0,-1,-1,-1,198,61,61,0,1.0,56,4,0,0,1,0.99,63,0,0,0,1,0,10,-0.19,-0.17,1.0,1.0,-0.55,0.99,-1,0.64,-0.13,-0.09,0.04,-0.47,0.08,-0.08,-0.75,-1,-0.38,-0.32,-0.39,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,37,40},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_13.png",
            preset = {23,21,0.8,1,45,0,-1,-1,-1,70,0,61,15,0.99,0,-1,1.0,0,25,1.0,63,0,0,0,0,0,0,0.04,0.04,1.0,1.0,-0.14,0,-0.94,-0.21,-0.54,0.91,-1.0,0.88,0.56,-0.11,-1.0,-1,-0.31,-1.0,-0.48,1,0,0,18,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_14.png",
            preset = {23,4,1.0,3,26,0,-1,-1,-1,97,60,0,0,0,0,1,1.0,0,28,0.99,56,-1,1.0,56,0,0,0,-1.0,0.84,0.0,0.6,0.0,-0.28,0.0,-0.08,0.21,-0.16,-0.7,-0.25,-0.04,0.14,-1.0,-1,0.0,0.81,0.53,0.43,0,0,19,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,1.0,0.0,false,44,25},
        },
    }
}
CREATOR_PRESETS['Real'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/male_default.png",
            preset = maleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1100.png",
            preset = { 23, 0, 0.3, 5, 0, 0, -1, -1, -1, 21, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0.99, 0, 28, 0.99, 0, 0, 0, 0, 0.99, 0.84, 0.9, 0.65, 0, -0.15, -1, -1, -0.2, -0.39, -0.15, -0.05, 0.21, -1, 0.79, 0.6, 0.99, -0.08, -0.01, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1098.png",
            preset = { 2, 0, 0.65, 26, 0, 0, -1, -1, -1, 12, 29, 28, 0, 0, 0, 0, 0.09, 35, 33, 0.99, 0, 1, 0.99, 29, 0, 0, 0, -0.4, -0.16, 0.14, 0.21, -0.34, 0, -0.1, 0.62, -0.01, 0.61, -0.11, -0.22, 0.03, 0.52, -0.68, 0.29, 0.01, -0.04, 0.02, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1084.png",
            preset = { 23, 12, 0.85, 1, 0, 0, -1, -1, -1, 12, 27, 7, 8, 0, 0, 0, 0, 0, 14, 0.99, 0, 3, 0.99, 0, 0, 0, 0, -0.17, 0.3, -0.23, 0.58, 0, 0, -1, -1, -1, -1, 0.13, 0.72, 0.33, -0.97, -1, -1, 0.99, -1, -0.01, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1048.png",
            preset = { 17, 10, 0, 7, 0, 0, -1, -1, -1, 12, 23, 23, 8, 0, 0, 0, 0, 0, 30, 0.99, 0, 19, 0.99, 22, 32, 0.99, 0, -0.33, 0.84, 0.72, -0.2, 0, 0, 0.99, 0.37, 0.41, 0.49, 0.25, 0.39, -0.39, 0.51, -0.44, -0.14, 0.99, -0.15, 0.09, 0, 3, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1046.png",
            preset = { 7, 4, 0.8, 2, 45, 0, -1, -1, -1, 21, 29, 29, 43, 0, 0, 10, 0.99, 57, 30, 0.99, 0, 3, 0.99, 29, 0, 0, 0, -1, 0.52, 0.57, 0.99, -0.52, 0, -0.25, -1, 0.53, -1, 0.04, -0.48, 0, -1, -1, -1, 0.17, -1, -1, 0, 9, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1039.png",
            preset = { 0, 21, 0.4, 2, 13, 0, -1, -1, -1, 21, 63, 0, 0, 0, 0, 0, 0, 0, 33, 0.99, 0, 1, 0.99, 15, 8, 0, 0, -1, 0, -0.23, 0.58, 0, 0, -1, -1, -1, -1, -0.08, 0.99, -0.31, 0.99, -1, -1, 0.99, -1, -0.01, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1042.png",
            preset = { 0, 21, 0.15, 12, 2, 0, -1, -1, -1, 14, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0.99, 0, 0, 0.99, 0, 28, 0, 0, -1, 0.46, 0.51, 0.99, 0.06, -0.15, 0.3, 0, -0.19, 0.25, -0.1, -0.58, -0.97, -1, -0.94, 0.16, 0.99, 0.07, -1, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1036_2.png",
            preset = { 8, 21, 0.3, 3, 10, 0, -1, -1, -1, 105, 0, 5, 0, 0, 0, 1, 0.05, 5, 1, 0.8, 0, 0, 0, 0, 7, 0.1, 9, -0.61, 0.59, -0.05, 0.29, 0.21, -0.01, -0.1, 0.06, 0.51, -0.34, 0.36, -0.18, 0.04, 0.23, 0.31, 0.99, 0.99, -0.41, -0.69, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1034.png",
            preset = { 0, 20, 0.25, 2, 10, 0, -1, -1, -1, 97, 63, 12, 0, 0, 0, 0, 0, 0, 2, 0.99, 0, 1, 0.99, 15, 8, 0, 0, -1, 0, -0.23, 0.58, 0, 0, -1, -1, -1, -1, -0.08, 0.99, -0.31, 0.99, -1, -1, 0.99, -1, -0.01, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1031.png",
            preset = { 7, 20, 0.45, 12, 5, 0, -1, -1, -1, 71, 55, 0, 0, 0, 0, 0, 0.06, 35, 33, 0.99, 0, 9, 0.99, 59, 0, 0, 0, 0.99, 0.69, 0, -1, 0.99, 0, 0.99, -1, 0.2, -0.39, -0.28, 0.82, 0.93, -1, -1, 0.99, 0, 0, 0.62, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1029.png",
            preset = { 8, 1, 0.65, 4, 11, 23, -1, -1, -1, 79, 59, 0, 0, 0, 0, 0, 0, 0, 2, 0.99, 0, 0, 0.88, 0, 0, 0, 0, -0.92, 0.65, 0.74, 0.85, 0, 0, -0.08, 0.07, -0.42, -1, 0, 0, -0.4, -1, -0.45, 0.77, 0.99, 0.03, 0, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1027.png",
            preset = { 0, 6, 0.5, 12, 6, 14, -1, -1, -1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 3, 0.99, 0, 10, 0.99, 0, -0.99, 0.52, 0.45, 0.32, -0.11, 0, -0.41, 0, -1, -0.17, 0.27, -0.05, 0.07, -1, 0.04, 0.6, 0.99, 0, 0, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1025_2.png",
            preset = { 0, 0, 0.3, 8, 9, 0, -1, -1, -1, 79, 0, 0, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 3, 0.88, 0, 11, 0.99, 0, -0.03, 0.65, 0.9, 0.72, -0.29, 0, -0.12, 0, 0, 0, -0.63, -0.14, 0.21, 0.37, -0.99, 0.77, 0.99, 0, 0, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1024.png",
            preset = { 0, 0, 0.8, 5, 28, 0, -1, -1, -1, 12, 29, 27, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 3, 0.99, 29, -1, 0, 0, 0.01, 0.24, 0.77, 0.25, -0.17, 0, -0.32, 0.18, 0, 0.08, -0.15, 0.2, 0.21, 0.05, 0.02, 0.08, 0.04, -0.08, -0.01, 0, 5, 0.99, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1020.png",
            preset = { 23, 18, 0.7, 5, 45, 0, -1, -1, -1, 47, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0.99, 0, 0, 0, 0, 8, 0, 0, -1, 0, -0.23, 0.58, 0, 0, -1, -1, -1, -1, 0, 0, -0.4, -1, 0.99, -1, 0.99, -1, -1, 0, 0, 0, 0 },
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/female_default.png",
            preset = femaleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1099.png",
            preset = { 23, 6, 1, 3, 10, 0, -1, -1, -1, 25, 61, 26, 0, 0, 0, 2, 0, 0, 14, 0.99, 0, 0, 0, 0, 0, 0, 10, -0.89, 0.52, 0.84, 0.45, -0.27, 0, -0.25, -1, -0.76, -1, 0.28, -0.67, 0.4, 0.24, -1, -1, 0, -1, -1, 1, 16, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1095.png",
            preset = { 0, 0, 1, 31, 12, 0, -1, -1, -1, 107, 0, 0, 0, 0, 0, 5, 0.99, 25, 1, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.97, 0.52, 0.99, 0.99, -0.49, 0, -0.12, -0.22, -0.42, -0.84, -0.49, -0.18, -0.41, -0.22, -1, -0.9, 0, -0.37, -0.86, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1050.png",
            preset = { 23, 21, 0.65, 0, 7, 0, -1, -1, -1, 105, 3, 0, 15, 0.99, 0, 4, 0, 0, 0, 0.99, 6, 0, 0, 0, 32, 0, 63, -0.89, 0, 0.84, 0.57, -0.37, 0, -0.28, -0.29, -0.54, 0.12, -0.84, -0.19, -0.18, 0.24, -0.29, -1, 0.02, -1, -0.33, 1, 2, 0.99, 18 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1047.png",
            preset = { 23, 21, 0.65, 2, 19, 0, -1, -1, -1, 48, 21, 21, 21, 0.99, 0, 4, 0, 0, 10, 0.99, 0, 0, 0, 0, 29, 0.99, 34, -0.89, 0, 0.84, 0.57, -0.37, 0, 0.99, -0.29, -1, -1, -0.84, -0.19, -0.18, 0.24, -1, -1, 0.13, -1, -0.33, 1, 3, 0.99, 18 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1045.png",
            preset = { 20, 6, 0.9, 13, 7, 0, -1, -1, -1, 3, 0, 37, 14, 0.65, 22, 0, 0.96, 20, 17, 0.2, 18, 0, 0, 36, 0, 0, 39, -0.89, 0, 0.71, 0.45, -0.09, 0, 0, 0, 0, -0.73, 0.04, 0.02, 0.41, 0, -1, -1, 0, 0, -0.72, 1, 10, 0.57, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1044.png",
            preset = { 22, 4, 1, 5, 3, 0, -1, -1, -1, 119, 0, 6, 0, 0, 0, 5, 0.39, 53, 8, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.73, 0.26, -0.21, 0.64, -0.27, 0.06, 0.77, 0.99, 0.72, -0.36, -1, -0.62, 0.04, -1, -1, -1, 0.99, 0.99, -0.63, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1043.png",
            preset = { 23, 21, 0.5, 12, 42, 0, -1, 3, -1, 105, 0, 0, 0, 0.91, 0, 10, 0.99, 0, 21, 0.99, 0, 0, 0, 0, 20, 0.82, 25, -0.89, 0, 0.84, 0.57, -0.37, 0, -0.28, -0.29, -0.54, 0.12, -0.84, -0.19, -0.18, 0.24, 0.64, -1, -0.22, -1, -0.33, 1, 3, 0.75, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1037.png",
            preset = { 7, 0, 1, 12, 3, 0, -1, -1, -1, 68, 61, 21, 0, 0, 0, 0, 0.87, 0, 16, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.99, 0.35, 0.99, 0.99, -0.6, 0, -0.59, -0.21, -0.76, 0, -0.05, -0.53, -0.15, -0.11, -0.96, -0.98, 0, -0.86, -0.79, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1038.png",
            preset = { 18, 21, 1, 12, 6, 23, -1, -1, -1, 69, 0, 5, 41, 0, 0, 0, 0, 0, 2, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.32, 0, -1, 0, 0.2, 0, -0.1, -0.14, 0, -0.04, 0.04, 0.02, 0.48, 0, -1, 0, 0.53, -0.08, -0.02, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1040.png",
            preset = { 17, 0, 0.8, 2, 45, 2, -1, -1, -1, 17, 49, 30, 22, 0.92, 0, 0, 0.96, 20, 33, 0.99, 0, 0, 0, 0, 0, 0, 63, -0.89, 0, 0.71, 0.45, -0.09, 0, 0, 0, 0, -0.73, 0.5, 0, 0.41, 0, -1, -1, 0, 0, -0.72, 1, 10, 0.99, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1041.png",
            preset = { 21, 19, 0.85, 7, 11, 0, -1, -1, -1, 176, 36, 16, 15, 0.99, 0, 3, 0.99, 36, 10, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.89, 0, 0.84, 0.57, -0.37, 0, -0.28, -0.29, -0.54, 0.12, -0.84, -0.19, -0.18, 0.24, -0.29, -1, 0.13, -1, -0.33, 1, 0, 0, 18 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1033.png",
            preset = { 7, 4, 0.8, 2, 45, 0, -1, -1, -1, 55, 29, 29, 43, 0.99, 0, 10, 0.99, 57, 14, 0.99, 28, 0, 0, 0, 0, 0, 0, -1, 0.52, 0.57, 0.99, -0.52, 0, -0.25, -1, 0.53, -1, 0.04, -0.48, 0, -1, -1, -1, 0.17, -1, -1, 1, 9, 0.99, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1030.png",
            preset = { 15, 6, 1, 12, 9, 0, -1, -1, -1, 169, 0, 0, 0, 0, 24, 0, 0.72, 34, 8, 0.99, 26, 0, 0, 0, 0, 0, 0, -0.99, 0.1, -0.26, 0.91, -0.32, 0, -1, 0, 0, 0.21, 0.28, -0.59, -0.31, -1, -1, -1, -0.38, 0.99, -1, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1023.png",
            preset = { 7, 0, 1, 1, 8, 0, -1, -1, -1, 76, 29, 29, 0, 0, 0, 0, 0.33, 25, 9, 0.99, 0, 0, 0, 0, 0, 0.34, 0, -1, 0.52, 0.57, 0.99, -0.52, 0, -0.59, -0.21, -0.76, 0, -0.23, -0.53, 0, 0, -0.96, -0.98, 0, -0.86, -0.79, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1021.png",
            preset = { 23, 21, 0.65, 2, 19, 0, -1, -1, -1, 48, 21, 21, 21, 0, 0, 10, 0, 0, 10, 0.99, 0, 0, 0, 0, 29, 0.99, 34, -0.89, 0, 0.84, 0.57, -0.37, 0, 0.99, -0.29, -1, -1, -0.84, -0.19, -0.18, 0.24, -1, -1, 0.13, -1, -0.33, 1, 3, 0, 18 },
        },
    }
}
CREATOR_PRESETS['Fronteira'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/male_default.png",
            preset = maleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_0.png",
            preset = {0,0,0.08,5,12,0,-1,-1,-1,97,61,0,-1,1.0,56,-1,0,56,23,0.99,56,28,0.99,56,-1,0,56,-0.93,0.78,1.0,0.04,-0.01,0,-1,-0.3,-1,-0.58,-0.16,0.12,0.57,1.0,0.66,0.6,0.02,-0.51,0.3,0.17,-1,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_1.png",
            preset = {0,0,0.65,12,5,0,-1,4,-1,44,60,60,0,0,63,0,0,63,13,0.99,63,3,1.0,63,-1,0,63,-0.72,-0.18,0.68,-0.08,0.12,0,0.3,-0.14,0,-0.65,-0.17,-0.63,0.21,-1.0,0.08,0.6,0.71,-0.68,-1.0,0.87,0,0,63,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_2.png",
            preset = {21,19,0.7,2,7,0,0,-1,1,63,29,26,0,0,53,0,0,53,29,0.99,54,18,0.99,53,-1,0,53,0.55,0.11,0.07,-0.17,0.0,0,-0.55,0.63,-1,-1.0,-0.45,-0.65,0.56,1.0,0.31,0.6,0.07,0.32,-1.0,1.0,0,0,53,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.0,0.0,false,42,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_3.png",
            preset = {16,19,0.65,5,35,0,-1,4,-1,79,59,29,0,0,63,0,0,63,30,0.99,63,4,0.88,63,-1,0,63,-1,0.84,0.72,0.46,0,0,-0.06,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,-0.04,0.6,0.01,0.43,-0.7,-0.26,0,0,63,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_4.png",
            preset = {0,18,0.62,3,38,0,-1,-1,-1,92,0,0,0,0,56,0,0,56,10,0.99,63,22,0.99,56,31,0.68,56,-0.2,1.0,1.0,1.0,-0.22,0,1.0,0,-0.19,0.25,-0.63,-0.53,0.32,0.37,-0.38,0.16,0.31,0.07,-0.37,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,39},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_5.png",
            preset = {13,0,0.5,12,28,0,-1,-1,-1,50,29,0,0,0,56,0,0.09,56,25,0.99,52,7,0.88,52,0,0,52,-1.0,-0.66,1.0,1.0,0.8,0,1.0,0.22,-0.2,-0.81,1.0,1.0,1.0,-1.0,-0.41,0.99,1.0,-1,0.76,0,0,0,52,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_6.png",
            preset = {0,0,0.18,8,45,0,-1,-1,-1,15,61,0,0,0,56,0,0,56,32,0.99,56,16,0.88,56,23,0.99,56,-0.5,-0.26,0.18,-0.08,0.36,0,0.35,-0.24,0,0,0.72,0.03,0.31,0.86,0.04,0.77,-0.34,0,0.36,-0.97,6,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_7.png",
            preset = {13,19,0.5,7,1,0,-1,-1,-1,100,29,29,-1,1.0,0,0,0.09,35,33,0.99,57,7,1.0,56,-1,1.0,0,-1,0,0.43,-0.24,0,0,0,0.7,-0.2,0.57,0.49,0.25,0.37,0.99,-0.41,0.99,0,-1,-0.1,0,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_8.png",
            preset = {13,21,0.65,5,2,0,-1,-1,-1,129,0,0,0,0,0,0,0.09,35,10,0.99,56,10,1.0,56,0,0,0,-1,0,0.71,-0.24,0,0,0.11,0.7,-0.2,0.57,0.49,0.25,0.37,0.99,-0.41,0.99,-0.44,-1,-0.1,0.15,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_9.png",
            preset = {17,0,0.58,3,34,0,1,-1,1,146,55,0,0,0,56,0,0.17,56,32,0.99,63,20,1.0,63,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.59,0,-0.03,0.81,0.86,0.96,1.0,-0.02,0.99,0.77,0.99,0.08,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,17,17},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_10.png",
            preset = {12,19,0.45,0,24,0,14,-1,-1,71,55,0,0,0,0,0,0.17,35,30,0.99,56,2,0.88,56,0,0,0,0.26,-0.4,0.65,0.16,0.04,0,-0.7,-0.63,0,1.0,-0.57,-1.0,-1.0,-0.24,-0.22,0.99,-1.0,0.99,-1.0,0.53,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,12,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_11.png",
            preset = {6,18,0.3,0,0,0,-1,-1,-1,122,61,0,-1,1.0,0,-1,1.0,0,33,1.0,56,6,1.0,56,6,0,0,-1,0,-0.23,0.58,0,0,-1,-1,-1,-1,0,0,-0.4,-1,0.99,-1,0.99,-1,-1,0,0,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,6,39},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_12.png",
            preset = {13,21,0.66,0,3,0,-1,-1,-1,173,60,0,0,0,0,0,0,0,25,0.99,56,-1,0.99,56,-1,0,0,-0.01,0.54,0.49,-0.44,0.3,0,1.0,0.31,0,-0.41,-0.67,-0.34,-0.31,-1.0,-0.32,-1,0.71,-0.87,-0.16,0.28,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_13.png",
            preset = {8,0,0.21,0,23,0,-1,-1,-1,172,20,3,-1,1.0,0,-1,1.0,0,33,1.0,56,6,1.0,63,6,0,0,-1,0,-0.23,0.58,0,0,-1,-1,-1,-1,0,0,-0.4,-1,0.99,-1,0.99,-1,-1,0,0,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,8,0,0.0,0.0,false,8,42},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_14.png",
            preset = {0,0,0.61,7,12,0,-1,0,-1,45,61,61,0,0,0,1,0.0,0,30,1.0,56,1,0.0,52,-1,0,0,-1.0,0.74,1.0,0.46,0,0,0.0,0.5,0,0.08,-0.73,-0.52,0.21,0.0,0.24,0.6,0.0,0.43,0.35,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/female_default.png",
            preset = femaleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_0.png",
            preset = {0,0,1.0,0,12,0,3,-1,-1,107,28,28,7,0,0,5,0,0,3,0.99,63,-1,0,0,1,0,10,0.12,0.07,0.76,0.47,-0.12,0.99,-1,-0.14,-0.13,-0.4,0.04,-0.24,-0.32,0.18,0.24,-1,-0.38,0.23,0.28,1,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_1.png",
            preset = {0,19,0.25,0,12,0,-1,-1,-1,168,61,35,-1,0.25,33,5,0.3,18,18,0.99,56,-1,1.0,0,-1,1.0,34,-1.0,0.37,0.34,0.19,-0.31,0,0.18,-1.0,-0.87,0.09,0.17,-0.28,-0.32,-0.25,-0.84,-1,0.29,0.38,0.16,-0.01,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,39,0,0.0,0.0,false,21,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_2.png",
            preset = {23,21,0.65,2,0,0,-1,-1,-1,42,54,54,1,1.0,56,4,0,23,11,1.0,56,0,0,52,-1,1.0,56,-0.89,0,0.84,0.57,-0.37,0,-1.0,-0.29,-0.54,0.12,-0.84,-0.19,-0.18,0.24,-0.29,-1,0.16,-1,-0.33,-0.12,-1,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_3.png",
            preset = {15,2,0.94,11,9,0,-1,-1,-1,139,61,55,7,0,0,5,0.65,56,17,0.54,56,-1,0,0,3,0,10,-0.29,-0.65,-0.19,1.0,-0.55,0.99,-0.39,-0.27,-0.13,-0.62,-0.42,-0.64,-0.32,-0.03,-0.38,-1,-0.21,-0.26,0.42,1,-1,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.92,0.0,false,15,23},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_4.png",
            preset = {23,21,0.65,5,6,0,-1,-1,-1,134,0,0,15,0.99,56,5,0,24,16,1.0,56,0,0,56,0,0,0,-0.89,0,0.84,0.57,-0.37,0,-0.28,-0.29,-0.54,0.12,-0.84,-0.19,-0.18,0.24,-0.29,-1,0.13,-1,-0.33,0.08,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_5.png",
            preset = {0,0,0.67,13,0,0,-1,6,0,301,61,28,-1,0.25,33,7,0.33,23,13,0.99,56,-1,1.0,0,-1,1.0,34,-1.0,0.0,0.55,0.0,-0.18,0,0.0,-1.0,-0.87,0.13,-0.12,-0.03,-0.42,0.0,-1.0,-1,-0.06,-0.06,0.02,0.13,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.21,0.0,false,22,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_6.png",
            preset = {23,0,1.0,7,12,0,-1,0,-1,143,29,61,3,0.25,33,1,1.0,0,30,1.0,54,-1,1.0,7,-1,0.6,18,-1.0,0.84,0.0,-0.52,0.0,0,-1.0,-0.14,-0.87,-0.04,-0.87,0.0,0.08,0.23,-1.0,-1,0.0,0.99,-0.02,0.13,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_7.png",
            preset = {17,0,0.9,0,1,0,-1,-1,-1,18,61,53,14,1.0,56,4,1.0,56,18,1.0,56,-1,1.0,0,-1,1.0,63,-0.89,0,0.71,0.45,-0.09,0,0,-0.62,0,-0.47,-0.38,0.02,-0.73,0.53,-0.41,-1,0,0,-0.67,1,4,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,17,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_8.png",
            preset = {16,0,0.82,5,36,0,-1,-1,-1,182,61,61,3,0.25,33,2,0.45,21,32,0.99,56,0,0,0,1,0.6,34,-0.03,0.52,0.11,-0.06,-0.33,0,-1.0,-0.17,-0.87,-1.0,0.04,-0.48,-0.1,0.41,-1.0,-1,0.22,-0.51,0.42,0.53,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_9.png",
            preset = {16,0,1.0,0,0,0,0,0,-1,191,5,3,3,0.25,33,9,0.28,24,16,0.99,56,0,0,56,1,0.6,56,-0.73,0.44,0.35,0,-0.28,0,-1,0.99,-0.87,-0.2,-0.03,-0.23,-0.41,0.56,-0.34,-1,0.85,-0.5,0.43,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_10.png",
            preset = {0,0,1.0,1,2,0,-1,-1,-1,48,0,4,14,1.0,55,5,0.99,20,3,0.99,63,0,0,0,1,1.0,10,-0.32,0,-1,0,0.2,0,-0.1,-0.35,0,-0.24,0.04,0.02,-0.28,0,-1,0,-0.38,-0.08,0.18,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_11.png",
            preset = {16,0,0.67,2,4,0,-1,-1,-1,50,44,57,4,1.0,55,5,0.99,20,4,0.99,63,0,0,0,1,1.0,10,-0.62,-0.42,-1,0.33,-0.08,0,-0.1,-0.48,0,-0.3,0.04,-0.25,0.33,0,0.46,0,-0.38,0.01,0.03,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,13,0,1.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_12.png",
            preset = {0,19,0.84,12,12,0,-1,-1,-1,198,61,61,0,1.0,56,4,0,0,1,0.99,63,0,0,0,1,0,10,-0.19,-0.17,1.0,1.0,-0.55,0.99,-1,0.64,-0.13,-0.09,0.04,-0.47,0.08,-0.08,-0.75,-1,-0.38,-0.32,-0.39,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,37,40},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_13.png",
            preset = {23,21,0.8,1,45,0,-1,-1,-1,70,0,61,15,0.99,0,-1,1.0,0,25,1.0,63,0,0,0,0,0,0,0.04,0.04,1.0,1.0,-0.14,0,-0.94,-0.21,-0.54,0.91,-1.0,0.88,0.56,-0.11,-1.0,-1,-0.31,-1.0,-0.48,1,0,0,18,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_14.png",
            preset = {23,4,1.0,3,26,0,-1,-1,-1,97,60,0,0,0,0,1,1.0,0,28,0.99,56,-1,1.0,56,0,0,0,-1.0,0.84,0.0,0.6,0.0,-0.28,0.0,-0.08,0.21,-0.16,-0.7,-0.25,-0.04,0.14,-1.0,-1,0.0,0.81,0.53,0.43,0,0,19,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,1.0,0.0,false,44,25},
        },
    }
}
CREATOR_PRESETS['Grande'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['Malta'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['Royal'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}

CREATOR_PRESETS['Orizon'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['Maresia'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['Liberty99'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['Krown'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['Kingdom'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['GoatRP'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_0.png",
            preset = {0,21,0.37,22,35,0,-1,6,-1,5,0,3,-1,1.0,56,-1,1.0,11,24,1.0,3,16,1.0,3,-1,1.0,63,-0.5,0.05,0.25,0.0,-0.16,0.0,0.42,0.48,0.0,-0.26,0.0,0.0,0.45,0.0,0.39,0.0,0.0,0.72,0.17,0.75,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,37,0,0.07,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_1.png",
            preset = {13,21,0.66,24,1,0,-1,-1,-1,7,15,15,0,0,0,0,0,0,19,0.99,61,-1,1.0,61,-1,0,0,-0.16,0.36,0.1,-0.27,0.15,0,0.57,0.24,0,0.07,-0.22,0.79,-0.34,1.0,0.28,-1,1.0,1.0,-0.47,1.0,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_2.png",
            preset = {21,0,0.59,18,25,0,-1,-1,-1,118,58,20,14,0.1,56,0,0.15,0,24,1.0,61,12,0.88,0,0,0.0,24,-1.0,0.87,0.48,-0.23,-0.02,0,0.7,-0.97,0,0.61,-0.95,0.43,0.72,0.59,0.13,0.6,0.76,0.0,-1.0,1.0,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.51,0.0,false,42,12},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_3.png",
            preset = {23,4,0.06,0,7,0,-1,-1,-1,129,14,29,-1,1.0,56,8,0.56,24,33,1.0,0,5,1.0,29,1,1.0,5,-0.36,0.53,0.0,-0.05,-0.07,0.0,-0.24,0.09,0.0,0.68,0.05,-0.35,-0.07,0.02,-0.37,0.0,0.57,0.0,0.36,0.31,3,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,0.5,0.0,false,44,25},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_4.png",
            preset = {0,0,0.6,0,34,0,-1,-1,-1,159,61,61,38,1.0,56,1,0.41,0,24,1.0,61,3,1.0,61,10,1.0,56,-0.7,0.14,0.45,0.8,0.21,0,0.05,0.28,0,0.73,-0.46,0.03,0.19,-0.02,-0.2,0.6,0.6,0.13,-0.4,0.6,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,39,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_5.png",
            preset = {7,6,0.6,0,22,0,1,2,-1,97,3,58,-1,1.0,56,0,0.3,0,27,0.99,59,20,1.0,5,9,1.0,63,-0.22,0.1,0.36,0.3,0.0,0,-0.44,-1.0,0,0.2,0.16,-0.4,0.14,-0.01,-0.2,0.6,1.0,0.3,-0.4,-0.2,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,9,0,0.16,0.0,false,7,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_6.png",
            preset = {0,19,0.05,0,35,0,-1,-1,-1,7,0,13,0,0,56,0,0,53,30,0.99,56,16,0.99,63,-1,0,0,-0.72,0.78,0.0,0.0,0,0,0.0,-0.24,-0.19,-0.12,0.28,-0.52,0.21,-1.0,0.04,0.99,0.63,0.23,0.65,0.54,0,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,35,0,0.0,0.0,false,0,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_7.png",
            preset = {0,0,0.0,20,0,0,-1,-1,-1,61,33,29,38,0.63,24,8,0.4,25,4,1.0,29,20,1.0,29,19,1.0,26,-1.0,0.59,0.72,0.77,-0.26,0.0,0.22,0.01,0.0,0.06,0.38,0.0,0.43,0.69,0.05,0.0,0.75,-0.88,-0.11,0.29,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,24,0,1.0,0.0,false,0,3},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_8.png",
            preset = {2,0,0.68,14,20,0,-1,6,-1,159,61,1,-1,0,0,-1,1.0,0,30,0.99,0,3,0.88,0,-1,1.0,0,-1.0,0.62,0.72,0.01,0,0,0.11,-0.54,0,0.27,-0.08,0.18,-0.07,-0.6,0.34,0.6,0.71,0.66,-0.25,0.54,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,27,0,0.39,0.0,false,2,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_9.png",
            preset = {0,10,0.5,13,21,0,-1,-1,-1,149,56,56,-1,1.0,0,-1,0.0,0,2,1.0,61,20,1.0,61,9,1.0,56,-0.56,0.57,0.79,0.08,-0.17,0.0,0.25,-0.42,0.0,0.46,0.19,0.95,0.02,0.0,0.15,0.0,0.44,-0.64,0.27,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,20,0,0.0,0.0,false,0,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_10.png",
            preset = {0,21,0.18,1,34,0,-1,-1,-1,10,16,62,0,0,56,8,0.3,21,29,0.99,61,3,1.0,62,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.57,0,-0.03,0.6,0.86,-0.52,-1.0,-1.0,0.99,0.77,-1.0,0.35,0.56,0,0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,1.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_11.png",
            preset = {21,0,0.58,4,29,0,-1,-1,-1,79,10,12,14,0.1,56,0,0.15,0,30,1.0,61,5,1.0,61,0,0.0,24,-0.32,1.0,-0.05,1.0,-0.13,0,-0.26,-0.35,0,-0.73,-0.38,0.43,1.0,0.59,-0.23,0.6,0.36,-0.41,0.2,0.59,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.63,0.0,false,42,44},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_12.png",
            preset = { 0,21,0.55,5,12,0,-1,0,-1,150,56,58,0,0,0,3,0.44,11,24,1.0,61,7,1.0,61,4,0.2,16,-1.0,0.6,1.0,0.03,0.08,0,0.2,0.13,0,-0.3,-0.1,-0.09,0.55,0.4,-0.8,0.6,1.0,0.84,-0.39,1.0,0,0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_13.png",
            preset = { 0,0,0.6,0,45,0,-1,-1,-1,113,28,29,0,0,56,0,0,56,16,0.99,61,16,0.88,29,4,0.99,7,0.65,0.4,0.18,-0.26,-0.44,0,-0.2,-1.0,0,0,0.26,-0.5,-0.07,-1.0,-1.0,-0.3,0.77,0.75,-1.0,0.36,0.67,6,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/fatherface/father_male_14.png",
            preset = {0,0,0.5,0,36,0,-1,-1,-1,139,29,29,28,0.0,56,2,0.22,22,2,1.0,61,3,1.0,29,19,1.0,56,-0.57,0.57,0.79,0.08,-0.17,0,-0.06,-0.42,-0.2,-0.46,0.19,0.95,0.02,0.75,-1.0,0.99,0.44,-0.64,0.27,0.59,3,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,26,0,1.0,0.0,false,31,0},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_default.png",
            preset = {0,0,0.5,0,0,0,-1,-1,-1,0,0,0,-1,0.0,0,-1,0.0,0,0,1.0,0,-1,0.0,0,-1,0.0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.5,0.0,false,0,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_0.png",
            preset = {6,0,0.72,0,12,0,-1,-1,-1,182,55,61,49,1.0,56,8,0.92,20,24,1.0,56,0,0,52,6,0.18,22,-0.29,0.1,0.84,1.0,-0.37,0,-1.0,-0.12,-0.54,0.11,-0.46,-0.42,-0.13,0.24,-0.35,-1,-0.65,-0.44,-0.44,1.0,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.74,0.0,false,6,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_1.png",
            preset = {18,6,0.87,0,3,0,-1,-1,-1,200,61,61,53,1.0,56,8,0.92,20,33,1.0,56,0,0,52,6,0.18,22,0.04,0.39,0.25,0.58,-0.14,0,-0.4,1.0,-0.54,-0.56,0.0,-1.0,-0.13,-1.0,0.33,-1,0.27,-0.14,-0.75,0.11,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.49,0.0,false,18,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_2.png",
            preset = {1,21,0.88,16,3,0,-1,7,-1,196,24,61,37,1.0,56,8,0.47,24,22,1.0,25,0,0,52,1,0.47,24,-0.7,0.23,0.81,0.72,0.0,0,-0.4,0.12,-0.54,-0.97,-1.0,0.06,-1.0,-1.0,0.24,-1,-0.07,-0.95,-0.7,0.59,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,7,0,0.8,0.0,false,1,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_3.png",
            preset = {0,0,0.18,0,8,0,-1,5,-1,200,28,29,59,0.0,56,3,0.54,2,2,0.99,5,-1,1.0,0,7,0.0,56,-0.98,0.48,1.0,0.03,-0.12,0.25,-0.1,-0.01,-0.72,-1.0,-0.33,-0.62,-0.22,-1.0,-0.28,0,-0.38,0.33,0.17,-0.53,2,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.0,0.0,false,21,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_4.png",
            preset = {6,6,0.67,0,20,0,-1,3,-1,150,61,61,4,0.54,56,5,0.77,16,3,1.0,61,-1,0,61,4,1.0,15,-1.0,0.23,0.75,0.37,-0.13,0,-0.58,0.12,-0.55,-0.95,0.02,-0.01,0.19,-1.0,-1.0,-1,0.32,-0.95,-0.34,1.0,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,17,0,0.0,0.0,false,6,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_5.png",
            preset = {0,21,0.65,0,1,0,-1,-1,-1,201,61,3,54,1.0,56,8,0.77,21,32,1.0,61,0,0,14,29,1.0,63,-0.73,0.03,1.0,1.0,-0.17,0,-0.55,-0.18,-0.75,-1.0,-1.0,-0.41,-1.0,-1.0,0.25,-1,0.1,0.7,-1.0,0.12,-1,1.0,12,12,nil,nil,nil,nil,nil,nil,nil,nil,0,14,0,0.79,0.0,false,32,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_6.png",
            preset = {0,19,0.73,13,33,0,-1,-1,-1,102,0,8,27,0.48,29,1,1.0,21,17,1.0,61,0,0,0,4,0.18,4,-0.07,0.26,0.51,0.32,0.02,0.25,-0.14,-1.0,-0.72,-1.0,-1.0,-0.25,0.34,-1.0,-1.0,0,0.43,-1.0,-1.0,0.02,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,36,0,0.84,0.0,false,45,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_7.png",
            preset = {0,0,0.43,0,0,0,-1,3,-1,155,21,61,14,1.0,24,8,0.48,24,13,1.0,20,-1,0.0,0,4,0.6,23,-1.0,0.22,0.69,0.34,-0.44,0.0,0.24,-0.87,0.0,0.19,-0.14,-0.27,-0.65,-0.83,-0.53,0.0,0.36,0.05,-0.94,0.82,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.27,0.0,false,45,0},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_8.png",
            preset = {0,21,0.65,3,16,0,-1,8,-1,6,0,61,4,0.43,56,5,0.51,24,4,1.0,61,-1,0,61,29,1.0,56,-0.7,0.23,0.75,0.08,-0.13,0,0.05,0.12,-0.55,-0.95,-0.6,-0.27,-0.07,-1.0,-1.0,-1,0.4,-0.95,-0.7,0.59,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.3,0.0,false,21,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_9.png",
            preset = {0,0,0.48,0,0,0,-1,7,-1,184,30,29,32,1.0,0,8,0.66,22,33,1.0,30,-1,0.0,0,0,0.86,21,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_10.png",
            preset = {0,10,0.76,0,45,0,-1,-1,-1,180,11,13,3,0.51,2,8,0.48,17,2,0.99,26,0,0,0,4,0.48,20,-1.0,0.29,0.59,0.53,-0.32,0.25,0.13,-0.44,-0.72,-1.0,-0.39,-0.42,-0.34,-0.03,-1.0,0,0.08,0.54,-0.91,0.4,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.57,0.0,false,45,31},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_11.png",
            preset = {18,21,0.75,13,0,0,-1,3,-1,170,59,59,4,1.0,56,2,0.67,20,24,1.0,59,-1,1.0,52,29,1.0,63,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,-0.1,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,18,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_12.png",
            preset = {0,21,0.73,22,0,0,-1,-1,-1,186,61,61,0,1.0,24,2,0.67,20,24,1.0,61,-1,1.0,52,29,1.0,56,-0.89,0,0.84,0.57,-0.17,0,-0.75,-0.6,-0.54,-0.2,-0.3,-0.19,-0.1,0.24,-0.4,-1,0.49,-0.1,-1.0,0.2,-1,1.0,61,61,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,29,45},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_13.png",
            preset = {0,6,0.72,0,25,0,-1,-1,-1,21,61,25,93,1.0,21,5,1.0,20,24,1.0,56,0,0,52,29,1.0,56,-0.18,0.73,-0.07,-0.09,-0.23,0,-0.05,0.22,-0.54,-0.11,-0.3,-0.34,-0.05,-1.0,-0.68,-1,0.56,-1.0,-0.86,0.2,-1,1.0,56,56,nil,nil,nil,nil,nil,nil,nil,nil,0,22,0,0.21,0.0,false,40,27},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Fronteira/motherface/mother_female_14.png",
            preset = {0,0,0.48,19,0,0,-1,7,-1,189,29,28,53,1.0,0,8,0.66,22,32,1.0,3,-1,0.0,0,4,0.57,24,-0.73,0.35,1.0,0.54,-0.37,0.0,-0.78,0.1,0.0,0.01,-0.1,0.05,-1.0,-1.0,-0.54,0.0,0.03,-1.0,-0.54,0.68,-1,0.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,32,0,0.5,0.0,false,45,21},
        },
    }
}
CREATOR_PRESETS['Prime'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/male_default.png",
            preset = maleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1100.png",
            preset = { 23, 0, 0.3, 5, 0, 0, -1, -1, -1, 21, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0.99, 0, 28, 0.99, 0, 0, 0, 0, 0.99, 0.84, 0.9, 0.65, 0, -0.15, -1, -1, -0.2, -0.39, -0.15, -0.05, 0.21, -1, 0.79, 0.6, 0.99, -0.08, -0.01, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1098.png",
            preset = { 2, 0, 0.65, 26, 0, 0, -1, -1, -1, 12, 29, 28, 0, 0, 0, 0, 0.09, 35, 33, 0.99, 0, 1, 0.99, 29, 0, 0, 0, -0.4, -0.16, 0.14, 0.21, -0.34, 0, -0.1, 0.62, -0.01, 0.61, -0.11, -0.22, 0.03, 0.52, -0.68, 0.29, 0.01, -0.04, 0.02, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1084.png",
            preset = { 23, 12, 0.85, 1, 0, 0, -1, -1, -1, 12, 27, 7, 8, 0, 0, 0, 0, 0, 14, 0.99, 0, 3, 0.99, 0, 0, 0, 0, -0.17, 0.3, -0.23, 0.58, 0, 0, -1, -1, -1, -1, 0.13, 0.72, 0.33, -0.97, -1, -1, 0.99, -1, -0.01, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1048.png",
            preset = { 17, 10, 0, 7, 0, 0, -1, -1, -1, 12, 23, 23, 8, 0, 0, 0, 0, 0, 30, 0.99, 0, 19, 0.99, 22, 32, 0.99, 0, -0.33, 0.84, 0.72, -0.2, 0, 0, 0.99, 0.37, 0.41, 0.49, 0.25, 0.39, -0.39, 0.51, -0.44, -0.14, 0.99, -0.15, 0.09, 0, 3, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1046.png",
            preset = { 7, 4, 0.8, 2, 45, 0, -1, -1, -1, 21, 29, 29, 43, 0, 0, 10, 0.99, 57, 30, 0.99, 0, 3, 0.99, 29, 0, 0, 0, -1, 0.52, 0.57, 0.99, -0.52, 0, -0.25, -1, 0.53, -1, 0.04, -0.48, 0, -1, -1, -1, 0.17, -1, -1, 0, 9, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1039.png",
            preset = { 0, 21, 0.4, 2, 13, 0, -1, -1, -1, 21, 63, 0, 0, 0, 0, 0, 0, 0, 33, 0.99, 0, 1, 0.99, 15, 8, 0, 0, -1, 0, -0.23, 0.58, 0, 0, -1, -1, -1, -1, -0.08, 0.99, -0.31, 0.99, -1, -1, 0.99, -1, -0.01, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1042.png",
            preset = { 0, 21, 0.15, 12, 2, 0, -1, -1, -1, 14, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0.99, 0, 0, 0.99, 0, 28, 0, 0, -1, 0.46, 0.51, 0.99, 0.06, -0.15, 0.3, 0, -0.19, 0.25, -0.1, -0.58, -0.97, -1, -0.94, 0.16, 0.99, 0.07, -1, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1036_2.png",
            preset = { 8, 21, 0.3, 3, 10, 0, -1, -1, -1, 105, 0, 5, 0, 0, 0, 1, 0.05, 5, 1, 0.8, 0, 0, 0, 0, 7, 0.1, 9, -0.61, 0.59, -0.05, 0.29, 0.21, -0.01, -0.1, 0.06, 0.51, -0.34, 0.36, -0.18, 0.04, 0.23, 0.31, 0.99, 0.99, -0.41, -0.69, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1034.png",
            preset = { 0, 20, 0.25, 2, 10, 0, -1, -1, -1, 97, 63, 12, 0, 0, 0, 0, 0, 0, 2, 0.99, 0, 1, 0.99, 15, 8, 0, 0, -1, 0, -0.23, 0.58, 0, 0, -1, -1, -1, -1, -0.08, 0.99, -0.31, 0.99, -1, -1, 0.99, -1, -0.01, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1031.png",
            preset = { 7, 20, 0.45, 12, 5, 0, -1, -1, -1, 71, 55, 0, 0, 0, 0, 0, 0.06, 35, 33, 0.99, 0, 9, 0.99, 59, 0, 0, 0, 0.99, 0.69, 0, -1, 0.99, 0, 0.99, -1, 0.2, -0.39, -0.28, 0.82, 0.93, -1, -1, 0.99, 0, 0, 0.62, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1029.png",
            preset = { 8, 1, 0.65, 4, 11, 23, -1, -1, -1, 79, 59, 0, 0, 0, 0, 0, 0, 0, 2, 0.99, 0, 0, 0.88, 0, 0, 0, 0, -0.92, 0.65, 0.74, 0.85, 0, 0, -0.08, 0.07, -0.42, -1, 0, 0, -0.4, -1, -0.45, 0.77, 0.99, 0.03, 0, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1027.png",
            preset = { 0, 6, 0.5, 12, 6, 14, -1, -1, -1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 3, 0.99, 0, 10, 0.99, 0, -0.99, 0.52, 0.45, 0.32, -0.11, 0, -0.41, 0, -1, -0.17, 0.27, -0.05, 0.07, -1, 0.04, 0.6, 0.99, 0, 0, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1025_2.png",
            preset = { 0, 0, 0.3, 8, 9, 0, -1, -1, -1, 79, 0, 0, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 3, 0.88, 0, 11, 0.99, 0, -0.03, 0.65, 0.9, 0.72, -0.29, 0, -0.12, 0, 0, 0, -0.63, -0.14, 0.21, 0.37, -0.99, 0.77, 0.99, 0, 0, 0, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1024.png",
            preset = { 0, 0, 0.8, 5, 28, 0, -1, -1, -1, 12, 29, 27, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 3, 0.99, 29, -1, 0, 0, 0.01, 0.24, 0.77, 0.25, -0.17, 0, -0.32, 0.18, 0, 0.08, -0.15, 0.2, 0.21, 0.05, 0.02, 0.08, 0.04, -0.08, -0.01, 0, 5, 0.99, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/masculino/1020.png",
            preset = { 23, 18, 0.7, 5, 45, 0, -1, -1, -1, 47, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0.99, 0, 0, 0, 0, 8, 0, 0, -1, 0, -0.23, 0.58, 0, 0, -1, -1, -1, -1, 0, 0, -0.4, -1, 0.99, -1, 0.99, -1, -1, 0, 0, 0, 0 },
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/female_default.png",
            preset = femaleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1099.png",
            preset = { 23, 6, 1, 3, 10, 0, -1, -1, -1, 25, 61, 26, 0, 0, 0, 2, 0, 0, 14, 0.99, 0, 0, 0, 0, 0, 0, 10, -0.89, 0.52, 0.84, 0.45, -0.27, 0, -0.25, -1, -0.76, -1, 0.28, -0.67, 0.4, 0.24, -1, -1, 0, -1, -1, 1, 16, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1095.png",
            preset = { 0, 0, 1, 31, 12, 0, -1, -1, -1, 107, 0, 0, 0, 0, 0, 5, 0.99, 25, 1, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.97, 0.52, 0.99, 0.99, -0.49, 0, -0.12, -0.22, -0.42, -0.84, -0.49, -0.18, -0.41, -0.22, -1, -0.9, 0, -0.37, -0.86, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1050.png",
            preset = { 23, 21, 0.65, 0, 7, 0, -1, -1, -1, 105, 3, 0, 15, 0.99, 0, 4, 0, 0, 0, 0.99, 6, 0, 0, 0, 32, 0, 63, -0.89, 0, 0.84, 0.57, -0.37, 0, -0.28, -0.29, -0.54, 0.12, -0.84, -0.19, -0.18, 0.24, -0.29, -1, 0.02, -1, -0.33, 1, 2, 0.99, 18 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1047.png",
            preset = { 23, 21, 0.65, 2, 19, 0, -1, -1, -1, 48, 21, 21, 21, 0.99, 0, 4, 0, 0, 10, 0.99, 0, 0, 0, 0, 29, 0.99, 34, -0.89, 0, 0.84, 0.57, -0.37, 0, 0.99, -0.29, -1, -1, -0.84, -0.19, -0.18, 0.24, -1, -1, 0.13, -1, -0.33, 1, 3, 0.99, 18 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1045.png",
            preset = { 20, 6, 0.9, 13, 7, 0, -1, -1, -1, 3, 0, 37, 14, 0.65, 22, 0, 0.96, 20, 17, 0.2, 18, 0, 0, 36, 0, 0, 39, -0.89, 0, 0.71, 0.45, -0.09, 0, 0, 0, 0, -0.73, 0.04, 0.02, 0.41, 0, -1, -1, 0, 0, -0.72, 1, 10, 0.57, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1044.png",
            preset = { 22, 4, 1, 5, 3, 0, -1, -1, -1, 119, 0, 6, 0, 0, 0, 5, 0.39, 53, 8, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.73, 0.26, -0.21, 0.64, -0.27, 0.06, 0.77, 0.99, 0.72, -0.36, -1, -0.62, 0.04, -1, -1, -1, 0.99, 0.99, -0.63, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1043.png",
            preset = { 23, 21, 0.5, 12, 42, 0, -1, 3, -1, 105, 0, 0, 0, 0.91, 0, 10, 0.99, 0, 21, 0.99, 0, 0, 0, 0, 20, 0.82, 25, -0.89, 0, 0.84, 0.57, -0.37, 0, -0.28, -0.29, -0.54, 0.12, -0.84, -0.19, -0.18, 0.24, 0.64, -1, -0.22, -1, -0.33, 1, 3, 0.75, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1037.png",
            preset = { 7, 0, 1, 12, 3, 0, -1, -1, -1, 68, 61, 21, 0, 0, 0, 0, 0.87, 0, 16, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.99, 0.35, 0.99, 0.99, -0.6, 0, -0.59, -0.21, -0.76, 0, -0.05, -0.53, -0.15, -0.11, -0.96, -0.98, 0, -0.86, -0.79, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1038.png",
            preset = { 18, 21, 1, 12, 6, 23, -1, -1, -1, 69, 0, 5, 41, 0, 0, 0, 0, 0, 2, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.32, 0, -1, 0, 0.2, 0, -0.1, -0.14, 0, -0.04, 0.04, 0.02, 0.48, 0, -1, 0, 0.53, -0.08, -0.02, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1040.png",
            preset = { 17, 0, 0.8, 2, 45, 2, -1, -1, -1, 17, 49, 30, 22, 0.92, 0, 0, 0.96, 20, 33, 0.99, 0, 0, 0, 0, 0, 0, 63, -0.89, 0, 0.71, 0.45, -0.09, 0, 0, 0, 0, -0.73, 0.5, 0, 0.41, 0, -1, -1, 0, 0, -0.72, 1, 10, 0.99, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1041.png",
            preset = { 21, 19, 0.85, 7, 11, 0, -1, -1, -1, 176, 36, 16, 15, 0.99, 0, 3, 0.99, 36, 10, 0.99, 0, 0, 0, 0, 0, 0, 0, -0.89, 0, 0.84, 0.57, -0.37, 0, -0.28, -0.29, -0.54, 0.12, -0.84, -0.19, -0.18, 0.24, -0.29, -1, 0.13, -1, -0.33, 1, 0, 0, 18 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1033.png",
            preset = { 7, 4, 0.8, 2, 45, 0, -1, -1, -1, 55, 29, 29, 43, 0.99, 0, 10, 0.99, 57, 14, 0.99, 28, 0, 0, 0, 0, 0, 0, -1, 0.52, 0.57, 0.99, -0.52, 0, -0.25, -1, 0.53, -1, 0.04, -0.48, 0, -1, -1, -1, 0.17, -1, -1, 1, 9, 0.99, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1030.png",
            preset = { 15, 6, 1, 12, 9, 0, -1, -1, -1, 169, 0, 0, 0, 0, 24, 0, 0.72, 34, 8, 0.99, 26, 0, 0, 0, 0, 0, 0, -0.99, 0.1, -0.26, 0.91, -0.32, 0, -1, 0, 0, 0.21, 0.28, -0.59, -0.31, -1, -1, -1, -0.38, 0.99, -1, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1023.png",
            preset = { 7, 0, 1, 1, 8, 0, -1, -1, -1, 76, 29, 29, 0, 0, 0, 0, 0.33, 25, 9, 0.99, 0, 0, 0, 0, 0, 0.34, 0, -1, 0.52, 0.57, 0.99, -0.52, 0, -0.59, -0.21, -0.76, 0, -0.23, -0.53, 0, 0, -0.96, -0.98, 0, -0.86, -0.79, 1, 0, 0, 0 },
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Real/feminino/1021.png",
            preset = { 23, 21, 0.65, 2, 19, 0, -1, -1, -1, 48, 21, 21, 21, 0, 0, 10, 0, 0, 10, 0.99, 0, 0, 0, 0, 29, 0.99, 34, -0.89, 0, 0.84, 0.57, -0.37, 0, 0.99, -0.29, -1, -1, -0.84, -0.19, -0.18, 0.24, -1, -1, 0.13, -1, -0.33, 1, 3, 0, 18 },
        },
    }
}

CREATOR_PRESETS['Universo'] = {
    [`mp_m_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/male_default.png",
            preset = maleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_0.png",
            preset = {0,0,0.08,5,12,0,-1,-1,-1,97,61,0,-1,1.0,56,-1,0,56,23,0.99,56,28,0.99,56,-1,0,56,-0.93,0.78,1.0,0.04,-0.01,0,-1,-0.3,-1,-0.58,-0.16,0.12,0.57,1.0,0.66,0.6,0.02,-0.51,0.3,0.17,-1,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_1.png",
            preset = {0,0,0.65,12,5,0,-1,4,-1,44,60,60,0,0,63,0,0,63,13,0.99,63,3,1.0,63,-1,0,63,-0.72,-0.18,0.68,-0.08,0.12,0,0.3,-0.14,0,-0.65,-0.17,-0.63,0.21,-1.0,0.08,0.6,0.71,-0.68,-1.0,0.87,0,0,63,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_2.png",
            preset = {21,19,0.7,2,7,0,0,-1,1,63,29,26,0,0,53,0,0,53,29,0.99,54,18,0.99,53,-1,0,53,0.55,0.11,0.07,-0.17,0.0,0,-0.55,0.63,-1,-1.0,-0.45,-0.65,0.56,1.0,0.31,0.6,0.07,0.32,-1.0,1.0,0,0,53,0,nil,nil,nil,nil,nil,nil,nil,nil,0,34,0,0.0,0.0,false,42,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_3.png",
            preset = {16,19,0.65,5,35,0,-1,4,-1,79,59,29,0,0,63,0,0,63,30,0.99,63,4,0.88,63,-1,0,63,-1,0.84,0.72,0.46,0,0,-0.06,-0.3,0,-0.58,-0.72,-0.52,0.21,0.37,-0.04,0.6,0.01,0.43,-0.7,-0.26,0,0,63,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_4.png",
            preset = {0,18,0.62,3,38,0,-1,-1,-1,92,0,0,0,0,56,0,0,56,10,0.99,63,22,0.99,56,31,0.68,56,-0.2,1.0,1.0,1.0,-0.22,0,1.0,0,-0.19,0.25,-0.63,-0.53,0.32,0.37,-0.38,0.16,0.31,0.07,-0.37,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,39},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_5.png",
            preset = {13,0,0.5,12,28,0,-1,-1,-1,50,29,0,0,0,56,0,0.09,56,25,0.99,52,7,0.88,52,0,0,52,-1.0,-0.66,1.0,1.0,0.8,0,1.0,0.22,-0.2,-0.81,1.0,1.0,1.0,-1.0,-0.41,0.99,1.0,-1,0.76,0,0,0,52,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,6},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_6.png",
            preset = {0,0,0.18,8,45,0,-1,-1,-1,15,61,0,0,0,56,0,0,56,32,0.99,56,16,0.88,56,23,0.99,56,-0.5,-0.26,0.18,-0.08,0.36,0,0.35,-0.24,0,0,0.72,0.03,0.31,0.86,0.04,0.77,-0.34,0,0.36,-0.97,6,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,45,0,0.92,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_7.png",
            preset = {13,19,0.5,7,1,0,-1,-1,-1,100,29,29,-1,1.0,0,0,0.09,35,33,0.99,57,7,1.0,56,-1,1.0,0,-1,0,0.43,-0.24,0,0,0,0.7,-0.2,0.57,0.49,0.25,0.37,0.99,-0.41,0.99,0,-1,-0.1,0,0,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_8.png",
            preset = {13,21,0.65,5,2,0,-1,-1,-1,129,0,0,0,0,0,0,0.09,35,10,0.99,56,10,1.0,56,0,0,0,-1,0,0.71,-0.24,0,0,0.11,0.7,-0.2,0.57,0.49,0.25,0.37,0.99,-0.41,0.99,-0.44,-1,-0.1,0.15,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_9.png",
            preset = {17,0,0.58,3,34,0,1,-1,1,146,55,0,0,0,56,0,0.17,56,32,0.99,63,20,1.0,63,0,0,56,-0.58,-0.25,0.52,0.14,-0.49,0,-0.61,0.59,0,-0.03,0.81,0.86,0.96,1.0,-0.02,0.99,0.77,0.99,0.08,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,17,17},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_10.png",
            preset = {12,19,0.45,0,24,0,14,-1,-1,71,55,0,0,0,0,0,0.17,35,30,0.99,56,2,0.88,56,0,0,0,0.26,-0.4,0.65,0.16,0.04,0,-0.7,-0.63,0,1.0,-0.57,-1.0,-1.0,-0.24,-0.22,0.99,-1.0,0.99,-1.0,0.53,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,12,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_11.png",
            preset = {6,18,0.3,0,0,0,-1,-1,-1,122,61,0,-1,1.0,0,-1,1.0,0,33,1.0,56,6,1.0,56,6,0,0,-1,0,-0.23,0.58,0,0,-1,-1,-1,-1,0,0,-0.4,-1,0.99,-1,0.99,-1,-1,0,0,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,6,39},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_12.png",
            preset = {13,21,0.66,0,3,0,-1,-1,-1,173,60,0,0,0,0,0,0,0,25,0.99,56,-1,0.99,56,-1,0,0,-0.01,0.54,0.49,-0.44,0.3,0,1.0,0.31,0,-0.41,-0.67,-0.34,-0.31,-1.0,-0.32,-1,0.71,-0.87,-0.16,0.28,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.37,0.0,false,13,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_13.png",
            preset = {8,0,0.21,0,23,0,-1,-1,-1,172,20,3,-1,1.0,0,-1,1.0,0,33,1.0,56,6,1.0,63,6,0,0,-1,0,-0.23,0.58,0,0,-1,-1,-1,-1,0,0,-0.4,-1,0.99,-1,0.99,-1,-1,0,0,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,8,0,0.0,0.0,false,8,42},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/fatherface/father_male_14.png",
            preset = {0,0,0.61,7,12,0,-1,0,-1,45,61,61,0,0,0,1,0.0,0,30,1.0,56,1,0.0,52,-1,0,0,-1.0,0.74,1.0,0.46,0,0,0.0,0.5,0,0.08,-0.73,-0.52,0.21,0.0,0.24,0.6,0.0,0.43,0.35,0,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
    },
    [`mp_f_freemode_01`] = {
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/default/female_default.png",
            preset = femaleDefault,
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_0.png",
            preset = {0,0,1.0,0,12,0,3,-1,-1,107,28,28,7,0,0,5,0,0,3,0.99,63,-1,0,0,1,0,10,0.12,0.07,0.76,0.47,-0.12,0.99,-1,-0.14,-0.13,-0.4,0.04,-0.24,-0.32,0.18,0.24,-1,-0.38,0.23,0.28,1,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_1.png",
            preset = {0,19,0.25,0,12,0,-1,-1,-1,168,61,35,-1,0.25,33,5,0.3,18,18,0.99,56,-1,1.0,0,-1,1.0,34,-1.0,0.37,0.34,0.19,-0.31,0,0.18,-1.0,-0.87,0.09,0.17,-0.28,-0.32,-0.25,-0.84,-1,0.29,0.38,0.16,-0.01,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,39,0,0.0,0.0,false,21,40},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_2.png",
            preset = {23,21,0.65,2,0,0,-1,-1,-1,42,54,54,1,1.0,56,4,0,23,11,1.0,56,0,0,52,-1,1.0,56,-0.89,0,0.84,0.57,-0.37,0,-1.0,-0.29,-0.54,0.12,-0.84,-0.19,-0.18,0.24,-0.29,-1,0.16,-1,-0.33,-0.12,-1,1.0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_3.png",
            preset = {15,2,0.94,11,9,0,-1,-1,-1,139,61,55,7,0,0,5,0.65,56,17,0.54,56,-1,0,0,3,0,10,-0.29,-0.65,-0.19,1.0,-0.55,0.99,-0.39,-0.27,-0.13,-0.62,-0.42,-0.64,-0.32,-0.03,-0.38,-1,-0.21,-0.26,0.42,1,-1,1.0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,23,0,0.92,0.0,false,15,23},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_4.png",
            preset = {23,21,0.65,5,6,0,-1,-1,-1,134,0,0,15,0.99,56,5,0,24,16,1.0,56,0,0,56,0,0,0,-0.89,0,0.84,0.57,-0.37,0,-0.28,-0.29,-0.54,0.12,-0.84,-0.19,-0.18,0.24,-0.29,-1,0.13,-1,-0.33,0.08,0,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_5.png",
            preset = {0,0,0.67,13,0,0,-1,6,0,301,61,28,-1,0.25,33,7,0.33,23,13,0.99,56,-1,1.0,0,-1,1.0,34,-1.0,0.0,0.55,0.0,-0.18,0,0.0,-1.0,-0.87,0.13,-0.12,-0.03,-0.42,0.0,-1.0,-1,-0.06,-0.06,0.02,0.13,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,21,0,0.21,0.0,false,22,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_6.png",
            preset = {23,0,1.0,7,12,0,-1,0,-1,143,29,61,3,0.25,33,1,1.0,0,30,1.0,54,-1,1.0,7,-1,0.6,18,-1.0,0.84,0.0,-0.52,0.0,0,-1.0,-0.14,-0.87,-0.04,-0.87,0.0,0.08,0.23,-1.0,-1,0.0,0.99,-0.02,0.13,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_7.png",
            preset = {17,0,0.9,0,1,0,-1,-1,-1,18,61,53,14,1.0,56,4,1.0,56,18,1.0,56,-1,1.0,0,-1,1.0,63,-0.89,0,0.71,0.45,-0.09,0,0,-0.62,0,-0.47,-0.38,0.02,-0.73,0.53,-0.41,-1,0,0,-0.67,1,4,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,17,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_8.png",
            preset = {16,0,0.82,5,36,0,-1,-1,-1,182,61,61,3,0.25,33,2,0.45,21,32,0.99,56,0,0,0,1,0.6,34,-0.03,0.52,0.11,-0.06,-0.33,0,-1.0,-0.17,-0.87,-1.0,0.04,-0.48,-0.1,0.41,-1.0,-1,0.22,-0.51,0.42,0.53,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_9.png",
            preset = {16,0,1.0,0,0,0,0,0,-1,191,5,3,3,0.25,33,9,0.28,24,16,0.99,56,0,0,56,1,0.6,56,-0.73,0.44,0.35,0,-0.28,0,-1,0.99,-0.87,-0.2,-0.03,-0.23,-0.41,0.56,-0.34,-1,0.85,-0.5,0.43,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_10.png",
            preset = {0,0,1.0,1,2,0,-1,-1,-1,48,0,4,14,1.0,55,5,0.99,20,3,0.99,63,0,0,0,1,1.0,10,-0.32,0,-1,0,0.2,0,-0.1,-0.35,0,-0.24,0.04,0.02,-0.28,0,-1,0,-0.38,-0.08,0.18,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_11.png",
            preset = {16,0,0.67,2,4,0,-1,-1,-1,50,44,57,4,1.0,55,5,0.99,20,4,0.99,63,0,0,0,1,1.0,10,-0.62,-0.42,-1,0.33,-0.08,0,-0.1,-0.48,0,-0.3,0.04,-0.25,0.33,0,0.46,0,-0.38,0.01,0.03,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,13,0,1.0,0.0,false,16,21},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_12.png",
            preset = {0,19,0.84,12,12,0,-1,-1,-1,198,61,61,0,1.0,56,4,0,0,1,0.99,63,0,0,0,1,0,10,-0.19,-0.17,1.0,1.0,-0.55,0.99,-1,0.64,-0.13,-0.09,0.04,-0.47,0.08,-0.08,-0.75,-1,-0.38,-0.32,-0.39,1,0,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,37,40},
        },        
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_13.png",
            preset = {23,21,0.8,1,45,0,-1,-1,-1,70,0,61,15,0.99,0,-1,1.0,0,25,1.0,63,0,0,0,0,0,0,0.04,0.04,1.0,1.0,-0.14,0,-0.94,-0.21,-0.54,0.91,-1.0,0.88,0.56,-0.11,-1.0,-1,-0.31,-1.0,-0.48,1,0,0,18,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,44,45},
        },
        {
            image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/creator/Universo/motherface/mother_female_14.png",
            preset = {23,4,1.0,3,26,0,-1,-1,-1,97,60,0,0,0,0,1,1.0,0,28,0.99,56,-1,1.0,56,0,0,0,-1.0,0.84,0.0,0.6,0.0,-0.28,0.0,-0.08,0.21,-0.16,-0.7,-0.25,-0.04,0.14,-1.0,-1,0.0,0.81,0.53,0.43,0,0,19,0,nil,nil,nil,nil,nil,nil,nil,nil,0,25,0,1.0,0.0,false,44,25},
        },
    }
}

CREATOR_PRESETS['Grande'] = CREATOR_PRESETS['Grande']
CREATOR_PRESETS['Maresia'] = CREATOR_PRESETS['Grande']
CREATOR_PRESETS['CidadeNobre'] = CREATOR_PRESETS['Grande']
CREATOR_PRESETS['Kingdom'] = CREATOR_PRESETS['Grande']
CREATOR_PRESETS['District99'] = CREATOR_PRESETS['District99']
CREATOR_PRESETS['Krown'] = CREATOR_PRESETS['Grande']
CREATOR_PRESETS['Liberty99'] = CREATOR_PRESETS['Grande']
CREATOR_PRESETS['Royal'] = CREATOR_PRESETS['Grande']
CREATOR_PRESETS['Malta'] = CREATOR_PRESETS['Grande']
CREATOR_PRESETS['Orizon'] = CREATOR_PRESETS['Grande']

CREATOR_PRESET_CUSTOMIZATION['Maresia'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 31, texture = 0 },
            ["arms"] = { item = 198, texture = 0 },
            ["tshirt"] = { item = 15, texture = 0 },
            ["torso"] = { item = 22, texture = 0 },
            ["vest"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 26, texture = 2 },
            ["mask"] = { item = 0, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["hat"] = { item = -1, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 },
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 148, texture = 0 },
            ["arms"] = { item = 14, texture = 0 },
            ["tshirt"] = { item = 15, texture = 0 },
            ["torso"] = { item = 23, texture = 0 },
            ["vest"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 171, texture = 0 },
            ["mask"] = { item = 0, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["hat"] = { item = -1, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}

CREATOR_PRESET_CUSTOMIZATION['default'] = CREATOR_PRESET_CUSTOMIZATION['Maresia']

CREATOR_PRESET_CUSTOMIZATION['Universo'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 4, texture = 2 },
            ["arms"] = { item = 0, texture = 0 },
            ["tshirt"] = { item = 15, texture = 0 },
            ["torso"] = { item = 22, texture = 0 },
            ["vest"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 14, texture = 7 },
            ["mask"] = { item = 0, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["hat"] = { item = -1, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0,0,0.0,0,0,0,-1,-1,-1,-1,61,0,-1,1.0,56,-1,0,56,0,1.0,56,-1,0.99,56,-1,0,56,0.0,0.0,0.0,0.0,0.0,0,-1,-1.0,-1,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,0.6,-1.0,-1.0,0.0,-1.0,-1,0,56,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,0,21 },
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 0, texture = 8 },
            ["arms"] = { item = 9, texture = 0 },
            ["tshirt"] = { item = 15, texture = 0 },
            ["torso"] = { item = 23, texture = 0 },
            ["vest"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 160, texture = 0 },
            ["mask"] = { item = 0, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["hat"] = { item = -1, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 17,0,1.0,0,0,0,-1,-1,-1,-1,61,44,-1,1.0,56,-1,1.0,56,0,1.0,56,-1,1.0,0,-1,1.0,63,0.0,0.0,0.0,0.0,0.0,0,0,-1.0,0,-1.0,-1.0,-1.0,-1.0,-1.0,0.0,-1,0,-1.0,-1.0,-1.0,-1,0,0,0,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0.0,0.0,false,17,21 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['CidadeNobre'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 206, texture = 4 },   -- calças
            ["arms"] = { item = 0, texture = 0 },     -- mãos
            ["tshirt"] = { item = 15, texture = 0 },  -- blusa
            ["torso"] = { item = 22, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 31, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 194, texture = 1 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['Kingdom'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 28, texture = 0 },   -- calças
            ["arms"] = { item = 12, texture = 0 },     -- mãos
            ["tshirt"] = { item = 11, texture = 0 },  -- blusa
            ["torso"] = { item = 142, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 10, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = 7, texture = 2 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 32, texture = 0 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['Malta'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 206, texture = 4 },   -- calças
            ["arms"] = { item = 0, texture = 0 },     -- mãos
            ["tshirt"] = { item = 15, texture = 0 },  -- blusa
            ["torso"] = { item = 22, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 31, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 194, texture = 1 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['District99'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 206, texture = 4 },   -- calças
            ["arms"] = { item = 0, texture = 0 },     -- mãos
            ["tshirt"] = { item = 15, texture = 0 },  -- blusa
            ["torso"] = { item = 22, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 31, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 32, texture = 1 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['Krown'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 206, texture = 4 },   -- calças
            ["arms"] = { item = 0, texture = 0 },     -- mãos
            ["tshirt"] = { item = 15, texture = 0 },  -- blusa
            ["torso"] = { item = 22, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 31, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 32, texture = 1 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['Orizon'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 206, texture = 4 },   -- calças
            ["arms"] = { item = 0, texture = 0 },     -- mãos
            ["tshirt"] = { item = 15, texture = 0 },  -- blusa
            ["torso"] = { item = 22, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 31, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 32, texture = 1 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['Liberty99'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 206, texture = 4 },   -- calças
            ["arms"] = { item = 0, texture = 0 },     -- mãos
            ["tshirt"] = { item = 15, texture = 0 },  -- blusa
            ["torso"] = { item = 22, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 31, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 32, texture = 1 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['Santa'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 206, texture = 4 },   -- calças
            ["arms"] = { item = 0, texture = 0 },     -- mãos
            ["tshirt"] = { item = 15, texture = 0 },  -- blusa
            ["torso"] = { item = 22, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 31, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 194, texture = 1 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['Grande'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 206, texture = 4 },   -- calças
            ["arms"] = { item = 0, texture = 0 },     -- mãos
            ["tshirt"] = { item = 15, texture = 0 },  -- blusa
            ["torso"] = { item = 22, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 31, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 194, texture = 1 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}
CREATOR_PRESET_CUSTOMIZATION['Royal'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 206, texture = 4 },   -- calças
            ["arms"] = { item = 0, texture = 0 },     -- mãos
            ["tshirt"] = { item = 15, texture = 0 },  -- blusa
            ["torso"] = { item = 22, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 31, texture = 2 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 }
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 78, texture = 2 },   -- calças
            ["arms"] = { item = 14, texture = 0 },     -- mãos
            ["tshirt"] = { item = 6, texture = 0 },   -- blusa
            ["torso"] = { item = 23, texture = 0 },   -- jaqueta
            ["vest"] = { item = 0, texture = 0 },     -- colete
            ["shoes"] = { item = 194, texture = 1 },   -- sapatos
            ["mask"] = { item = 0, texture = 0 },     -- mascara
            ["backpack"] = { item = 0, texture = 0 }, -- mochila
            ["hat"] = { item = -1, texture = 0 },     -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}

CREATOR_PRESET_CUSTOMIZATION['Boomerang'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { texture = 4, item = 263 },
            ["ear"] = { texture = 0, item = -1 },
            ["tshirt"] = { texture = 0, item = 15 },
            ["glass"] = { texture = 0, item = 0 },
            ["bracelet"] = { texture = 0, item = -1 },
            ["vest"] = { texture = 0, item = 0 },
            ["watch"] = { texture = 0, item = -1 },
            ["backpack"] = { texture = 0, item = 0 },
            ["decals"] = { texture = 0, item = 0 },
            ["hat"] = { texture = 0, item = -1 },
            ["mask"] = { texture = 0, item = 0 },
            ["accessory"] = { texture = 0, item = 0 },
            ["shoes"] = { texture = 1, item = 31 },
            ["torso"] = { texture = 0, item = 22 },
            ["arms"] = { texture = 0, item = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 },
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["arms"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["tshirt"] = { item = 6, texture = 0 },
            ["hat"] = { item = -1, texture = 0 },
            ["shoes"] = { item = 32, texture = 3 },
            ["mask"] = { item = 0, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["vest"] = { item = 0, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["torso"] = { item = 23, texture = 0 },
            ["pants"] = { item = 209, texture = 3 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}

CREATOR_PRESET_CUSTOMIZATION['Real'] = {
    [`mp_m_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 159, texture = 0 },
            ["arms"] = { item = 11, texture = 0 },
            ["tshirt"] = { item = 15, texture = 0 },
            ["torso"] = { item = 22, texture = 0 },
            ["vest"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 152, texture = 0 },
            ["mask"] = { item = 0, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["hat"] = { item = -1, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 0, 0, 0.65, 2, 12, 0, -1, 4, -1, 45, 29, 29, 0, 0, 0, 0, 0, 0, 30, 0.99, 0, 1, 0.88, 0, -1, 0, 0, -1, 0.84, 0.72, 0.46, 0, 0, 0.3, -0.3, 0, -0.58, -0.72, -0.52, 0.21, 0.37, 0.79, 0.6, 0.71, 0.43, -0.7, 0 },
    },
    [`mp_f_freemode_01`] = {
        ["skinshop"] = {
            ["pants"] = { item = 233, texture = 2 },      -- calças
            ["arms"] = { item = 9, texture = 0 },         -- mãos
            ["tshirt"] = { item = 2, texture = 0 },       -- blusa
            ["torso"] = { item = 23, texture = 0 },       -- jaqueta
            ["vest"] = { item = 0, texture = 0 },         -- colete
            ["shoes"] = { item = 32, texture = 2 },       -- sapatos
            ["mask"] = { item = 0, texture = 0 },         -- mascara
            ["backpack"] = { item = 0, texture = 0 },     -- mochila
            ["hat"] = { item = -1, texture = 0 },         -- chapeu
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["accessory"] = { item = 0, texture = 0 },
            ["decals"] = { item = 0, texture = 0 }
        },
        ["barbershop"] = { 3, 6, 1, 0, 12, 0, -1, -1, -1, 74, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0.99, 26, 0, 0, 0, 0, 0, 0, -1, -1, -0.94, -0.31, 0.24, 0.25, -0.1, -0.79, -0.72, -1, -0.32, -0.61, -0.25, 0, -1, 0, -0.38, -0.65, -1, 1, 0, 0, 0 }
    },
}

CREATOR_PRESET_CUSTOMIZATION['default'] = CREATOR_PRESET_CUSTOMIZATION['Maresia']

for _, city in pairs(CREATOR_PRESETS) do
    for _, presetData in ipairs(city[`mp_m_freemode_01`]) do
        presetData.preset[13], presetData.preset[14], presetData.preset[15] = -1, 0.0, 0
        presetData.preset[16], presetData.preset[17], presetData.preset[18] = -1, 0.0, 0
        presetData.preset[25], presetData.preset[26], presetData.preset[27] = -1, 0.0, 0
    end
end

--- para pegar as listas de aparencias para a criação de personagem
function GetAppearancePresets()
    return CREATOR_PRESETS[CITY_NAME] or CREATOR_PRESETS['default']
end

--- para pegar as roupas iniciais do personagem quando for iniciar a customização.
---@param model number
---@return character-creator.PresetCustomization
function GetCustomizationPreset(model)
    return (CREATOR_PRESET_CUSTOMIZATION[CITY_NAME] or CREATOR_PRESET_CUSTOMIZATION['default'])[model]
end
