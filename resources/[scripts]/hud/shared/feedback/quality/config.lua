---@type QualityFeedbackConfig
QUALITY_FEEDBACK_CONFIG = {
    timing = {
        initialDelay = "5m",
        displayDuration = "20s",
        postActionDelayMin = "15m",
        postActionDelayMax = "20m",
        recurrenceByState = {
            excellent = "45m",
            good = "45m",
            medium = "35m",
            low = "25m",
            bad = "20m",
            very_bad = "20m",
        },
    },
    sounds = {
        positive = {
            url = "https://cdn.santagroup.gg/feedback-ranking/aviso_de_qualidade___n_veis_bons.mp3",
            volume = 0.1,
        },
        negative = {
            url = "https://cdn.santagroup.gg/feedback-ranking/negativo.wav",
            volume = 0.1,
        },
    },
}
