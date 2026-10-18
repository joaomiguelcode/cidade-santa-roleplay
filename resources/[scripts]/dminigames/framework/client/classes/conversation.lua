---@alias vector4 {x: number, y: number, z: number, w: number}

---@class ConversationData
---@field name string Nome da conversa
---@field tag string Tag da conversa
---@field visible? boolean Se a conversa está visível (padrão: true)
---@field escText? string Texto exibido na tecla de fechar (ex: "para fechar")
---@field description? string Descrição da conversa
---@field backgroundImage? string URL da imagem de fundo
---@field coords? vector4 Coordenadas da conversa
---@field icon? string Ícone da conversa
---@field buckets? table<number, boolean> Buckets da conversa
---@field ped? PedData Dados do ped da conversa
---@field buttons? ButtonData[] Array de botões da conversa

---@class PedData
---@field model string Modelo do ped
---@field animationStages? AnimationStageData[] Array de estágios de animação

---@class AnimationStageData
---@field dict string Dicionário da animação
---@field anim string Nome da animação
---@field timeout? number Tempo limite da animação em milissegundos

---@class ButtonData
---@field label string Texto do botão
---@field icon? string Ícone do botão
---@field enabled? boolean Se o botão está habilitado (padrão: true)
---@field onCallback fun(currentConversationId: any): nil Função callback quando o botão é clicado

---@class ConversationManager
---@field conversation table Export do recurso conversation
---@field currentConversation any|nil ID da conversa atual
ConversationManager = class()

---Inicializa o ConversationManager
function ConversationManager:__init()
    repeat Wait(1) until exports.conversation
    self.conversation = exports.conversation
    self.currentConversation = nil
    self.oldCoords = nil
end

---Adiciona uma nova conversa
---@param data ConversationData Dados da conversa a ser criada
---@return any ID da conversa criada
function ConversationManager:addConversation(data)
    data.backgroundImage = data.backgroundImage or 'https://santaimagens.roleplayrp.com/img/hud/Vector.webp'

    data.theme = data.theme or 'default'

    self.oldCoords = data.coords

    self.currentConversation = self.conversation:CreateConversation(data)

    return self.currentConversation
end

---Fecha a conversa atual
function ConversationManager:closeConversation()
    self.conversation:CloseConversation()
    self.currentConversation = nil
end

---Define a descrição da conversa atual
---@param description string Nova descrição da conversa
function ConversationManager:setDescription(description)
    self.conversation:SetDescription(self.currentConversation, description)
end
