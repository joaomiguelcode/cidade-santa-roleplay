-- Marcas inline <b>/<g>/<a>/<r> numa string traduzida viram <span> coloridos, sem partir a frase em
-- pedaços — assim outro idioma pode mover o destaque livremente dentro da tradução. Compartilhado
-- por todos os textos do slot principal (aviso de qualidade, cards de punição por recrutamento).
---@class GamifiedFeedbackHighlightStyle
---@field className string
---@field color string
---@field weight integer

---@type table<string, GamifiedFeedbackHighlightStyle>
FEEDBACK_HIGHLIGHT_STYLES = {
    b = { className = "accent-white", color = "#FFFFFF", weight = 700 },
    g = { className = "accent-green", color = "#4ADE80", weight = 700 },
    a = { className = "accent-gold", color = "#FACC15", weight = 700 },
    r = { className = "accent-red", color = "#EF4444", weight = 800 },
}

---@param text string
---@return string formatted
function FormatFeedbackHighlights( text )
    for tag, style in pairs( FEEDBACK_HIGHLIGHT_STYLES ) do
        local pattern = ( "<%s>(.-)</%s>" ):format( tag, tag )
        local replacement = ( '<span class="%s" style="color:%s;font-weight:%d">%%1</span>' ):format(
            style.className,
            style.color,
            style.weight
        )
        text = text:gsub( pattern, replacement )
    end

    return text
end

---@param key string
---@return string translated
function TranslateFeedbackHighlighted( key )
    return FormatFeedbackHighlights( _t( key ) )
end
