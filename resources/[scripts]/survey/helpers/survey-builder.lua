--[[
    referencias: 
    https://surveyjs.io/form-library/documentation/design-survey/create-a-simple-survey
    https://surveyjs.io/form-library/examples/implement-conditional-logic-to-change-question-visibility/reactjs#content-code -> json
    https://surveyjs.io/form-library/documentation/api-reference/survey-data-model#backgroundImage
]]

---@alias survey.ElementType 'text' | 'comment' | 'boolean' | 'checkbox' | 'radiogroup' | 'dropdown' | 'rating'
---@alias survey.InputType 'text' | 'password' | 'email' | 'number' | 'tel' | 'url'
---@alias survey.ValidatorType 'email' | 'regex' | 'numeric' | 'text'

---@class survey.Choice
---@field value string
---@field text string

---@class survey.Validator
---@field type survey.ValidatorType
---@field text string Mensagem de erro
---@field regex? string Padrão regex (apenas para type = 'regex')
---@field minValue? number Valor mínimo (apenas para type = 'numeric')
---@field maxValue? number Valor máximo (apenas para type = 'numeric')

---@class survey.BaseElement
---@field type survey.ElementType
---@field name string
---@field title string
---@field isRequired? boolean
---@field placeholder? string
---@field validators? survey.Validator[]
---@field visible? boolean
---@field visibleIf? string

---@class survey.TextElement : survey.BaseElement
---@field type 'text'
---@field inputType? survey.InputType
---@field min? number
---@field max? number
---@field maxLength? number

---@class survey.CommentElement : survey.BaseElement
---@field type 'comment'
---@field rows? number
---@field cols? number
---@field maxLength? number

---@class survey.BooleanElement : survey.BaseElement
---@field type 'boolean'
---@field label? string
---@field valueTrue? any
---@field valueFalse? any

---@class survey.CheckboxElement : survey.BaseElement
---@field type 'checkbox'
---@field choices string[] | survey.Choice[]
---@field hasOther? boolean
---@field otherText? string
---@field colCount? number

---@class survey.RadiogroupElement : survey.BaseElement
---@field type 'radiogroup'
---@field choices string[] | survey.Choice[]
---@field hasOther? boolean
---@field otherText? string
---@field colCount? number

---@class survey.DropdownElement : survey.BaseElement
---@field type 'dropdown'
---@field choices string[] | survey.Choice[]
---@field hasOther? boolean
---@field otherText? string

---@class survey.RatingElement : survey.BaseElement
---@field type 'rating'
---@field rateMin? number
---@field rateMax? number
---@field minRateDescription? string
---@field maxRateDescription? string

---@alias survey.Element survey.TextElement | survey.CommentElement | survey.BooleanElement | survey.CheckboxElement | survey.RadiogroupElement | survey.DropdownElement | survey.RatingElement

---@class survey.Page
---@field name? string
---@field title? string
---@field description? string
---@field elements survey.Element[]
---@field navigationTitle? string
---@field navigationDescription? string

---@class survey.Survey
---@field title? string Título principal do survey
---@field description? string Descrição/subtítulo do survey
---@field pages survey.Page[] Array de páginas do survey
---@field showProgressBar? 'off' | 'top' | 'bottom' Posição da barra de progresso
---@field showQuestionNumbers? 'on' | 'off' Mostrar numeração das perguntas
---@field completeText? string Texto do botão de finalizar
---@field completedHtml? string HTML exibido após completar o survey
---@field requiredText? string Símbolo de campo obrigatório (padrão: *)
---@field backgroundImage? string URL da imagem de fundo
---@field backgroundImageFit? 'auto' | 'contain' | 'cover' Ajuste da imagem de fundo
---@field backgroundImageAttachment? 'fixed' | 'scroll' Comportamento do scroll da imagem
---@field backgroundOpacity? number Opacidade do background (0-1)
---@field nextStepText? string Texto do botão de próxima pergunta

---@class survey.Builder
---@field private _survey survey.Survey
---@field private _currentPage survey.Page
SurveyBuilderClass = {}
SurveyBuilderClass.__index = SurveyBuilderClass

---@param title? string
---@param description? string
---@return survey.Builder
function SurveyBuilderClass.new(title, description)
    local self = setmetatable({}, SurveyBuilderClass)
    
    self._survey = {
        title = title,
        description = description,
        pages = {},
        showProgressBar = "top",
        showQuestionNumbers = "off",
        completeText = "Enviar",
        requiredText = "*"
    }
    
    self._currentPage = {
        elements = {}
    }
    
    return self
end

---Adiciona uma nova página
---@param name? string
---@param title? string
---@return survey.Builder
function SurveyBuilderClass:addPage(name, title)
    if #self._currentPage.elements > 0 then
        table.insert(self._survey.pages, self._currentPage)
    end
    
    self._currentPage = {
        name = name,
        title = title,
        elements = {}
    }
    
    return self
end

---Cria um validador de regex
---@param pattern string Padrão regex
---@param errorMessage string Mensagem de erro
---@return survey.Validator
function SurveyBuilderClass.createRegexValidator(pattern, errorMessage)
    return {
        type = "regex",
        text = errorMessage,
        regex = pattern
    }
end

---Cria um validador de email
---@param errorMessage? string Mensagem de erro (opcional)
---@return survey.Validator
function SurveyBuilderClass.createEmailValidator(errorMessage)
    return {
        type = "email",
        text = errorMessage or "Por favor, insira um e-mail válido"
    }
end

---Cria um validador numérico
---@param minValue? number Valor mínimo
---@param maxValue? number Valor máximo
---@param errorMessage? string Mensagem de erro
---@return survey.Validator
function SurveyBuilderClass.createNumericValidator(minValue, maxValue, errorMessage)
    return {
        type = "numeric",
        text = errorMessage or "Por favor, insira um número válido",
        minValue = minValue,
        maxValue = maxValue
    }
end

---Adiciona um campo de texto
---@param name string
---@param title string
---@param options? { isRequired?: boolean, placeholder?: string, inputType?: survey.InputType, min?: number, max?: number, maxLength?: number, validators?: survey.Validator[], visibleIf?: string }
---@return survey.Builder
function SurveyBuilderClass:addText(name, title, options)
    options = options or {}
    
    ---@type survey.TextElement
    local element = {
        type = "text",
        name = name,
        title = title,
        isRequired = options.isRequired,
        placeholder = options.placeholder,
        inputType = options.inputType,
        min = options.min,
        max = options.max,
        maxLength = options.maxLength,
        validators = options.validators,
        visibleIf = options.visibleIf
    }
    
    table.insert(self._currentPage.elements, element)
    return self
end

---Adiciona um textarea
---@param name string
---@param title string
---@param options? { isRequired?: boolean, placeholder?: string, rows?: number, cols?: number, maxLength?: number, validators?: survey.Validator[], visibleIf?: string }
---@return survey.Builder
function SurveyBuilderClass:addTextarea(name, title, options)
    options = options or {}
    
    ---@type survey.CommentElement
    local element = {
        type = "comment",
        name = name,
        title = title,
        isRequired = options.isRequired,
        placeholder = options.placeholder,
        rows = options.rows or 5,
        cols = options.cols,
        maxLength = options.maxLength,
        validators = options.validators,
        visibleIf = options.visibleIf
    }
    
    table.insert(self._currentPage.elements, element)
    return self
end

---Adiciona um checkbox único (boolean)
---@param name string
---@param title string
---@param options? { isRequired?: boolean, label?: string, valueTrue?: any, valueFalse?: any, visibleIf?: string }
---@return survey.Builder
function SurveyBuilderClass:addBoolean(name, title, options)
    options = options or {}
    
    ---@type survey.BooleanElement
    local element = {
        type = "boolean",
        name = name,
        title = title,
        isRequired = options.isRequired,
        label = options.label,
        valueTrue = options.valueTrue,
        valueFalse = options.valueFalse,
        visibleIf = options.visibleIf
    }
    
    table.insert(self._currentPage.elements, element)
    return self
end

---Adiciona múltiplos checkboxes
---@param name string
---@param title string
---@param choices string[] | survey.Choice[]
---@param options? { isRequired?: boolean, hasOther?: boolean, otherText?: string, colCount?: number, visibleIf?: string, multiple?: boolean }
---@return survey.Builder
function SurveyBuilderClass:addCheckbox(name, title, choices, options)
    options = options or {}
    
    ---@type survey.CheckboxElement
    local element = {
        type = "checkbox",
        name = name,
        title = title,
        choices = choices,
        isRequired = options.isRequired,
        hasOther = options.hasOther,
        otherText = options.otherText,
        colCount = options.colCount,
        visibleIf = options.visibleIf,
        multiple = options.multiple or false
    }
    
    table.insert(self._currentPage.elements, element)
    return self
end

---Adiciona radiogroup (seleção única)
---@param name string
---@param title string
---@param choices string[] | survey.Choice[]
---@param options? { isRequired?: boolean, hasOther?: boolean, otherText?: string, colCount?: number, visibleIf?: string }
---@return survey.Builder
function SurveyBuilderClass:addRadiogroup(name, title, choices, options)
    options = options or {}
    
    ---@type survey.RadiogroupElement
    local element = {
        type = "radiogroup",
        name = name,
        title = title,
        choices = choices,
        isRequired = options.isRequired,
        hasOther = options.hasOther,
        otherText = options.otherText,
        colCount = options.colCount,
        visibleIf = options.visibleIf
    }
    
    table.insert(self._currentPage.elements, element)
    return self
end

---Adiciona um dropdown
---@param name string
---@param title string
---@param choices string[] | survey.Choice[]
---@param options? { isRequired?: boolean, placeholder?: string, hasOther?: boolean, otherText?: string, visibleIf?: string }
---@return survey.Builder
function SurveyBuilderClass:addDropdown(name, title, choices, options)
    options = options or {}
    
    ---@type survey.DropdownElement
    local element = {
        type = "dropdown",
        name = name,
        title = title,
        choices = choices,
        isRequired = options.isRequired,
        placeholder = options.placeholder,
        hasOther = options.hasOther,
        otherText = options.otherText,
        visibleIf = options.visibleIf
    }
    
    table.insert(self._currentPage.elements, element)
    return self
end

---Adiciona um rating
---@param name string
---@param title string
---@param options? { isRequired?: boolean, rateMin?: number, rateMax?: number, minRateDescription?: string, maxRateDescription?: string, visibleIf?: string }
---@return survey.Builder
function SurveyBuilderClass:addRating(name, title, options)
    options = options or {}
    
    ---@type survey.RatingElement
    local element = {
        type = "rating",
        name = name,
        title = title,
        isRequired = options.isRequired,
        rateMin = options.rateMin or 1,
        rateMax = options.rateMax or 5,
        minRateDescription = options.minRateDescription,
        maxRateDescription = options.maxRateDescription,
        visibleIf = options.visibleIf
    }
    
    table.insert(self._currentPage.elements, element)
    return self
end

---Configura as opções do survey
---@param options { showProgressBar?: 'off' | 'top' | 'bottom', nextStepText?: string, showQuestionNumbers?: 'on' | 'off', completeText?: string, completedHtml?: string, requiredText?: string, backgroundImage?: string, backgroundImageFit?: 'auto' | 'contain' | 'cover', backgroundImageAttachment?: 'fixed' | 'scroll', backgroundOpacity?: number }
---@return survey.Builder
function SurveyBuilderClass:setOptions(options)
    if options.showProgressBar then
        self._survey.showProgressBar = options.showProgressBar
    end
    if options.showQuestionNumbers then
        self._survey.showQuestionNumbers = options.showQuestionNumbers
    end
    if options.completeText then
        self._survey.completeText = options.completeText
    end
    if options.completedHtml then
        self._survey.completedHtml = options.completedHtml
    end
    if options.requiredText then
        self._survey.requiredText = options.requiredText
    end
    if options.backgroundImage then
        self._survey.backgroundImage = options.backgroundImage
    end
    if options.backgroundImageFit then
        self._survey.backgroundImageFit = options.backgroundImageFit
    end
    if options.backgroundImageAttachment then
        self._survey.backgroundImageAttachment = options.backgroundImageAttachment
    end
    if options.backgroundOpacity ~= nil then
        self._survey.backgroundOpacity = options.backgroundOpacity
    end

    if options.nextStepText then
        self._survey.nextStepText = options.nextStepText
    end
    
    return self
end

function SurveyBuilderClass:addElement(element)
    table.insert(self._currentPage.elements, element)
    return self
end

---@return survey.Survey
function SurveyBuilderClass:build()
    if #self._currentPage.elements > 0 then
        table.insert(self._survey.pages, self._currentPage)
    end
    
    return self._survey
end