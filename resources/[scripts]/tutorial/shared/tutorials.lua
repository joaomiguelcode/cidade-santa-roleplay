---@class tutorial.ui.TutorialStep
---@field target string -- seletor do elemento na NUI HTML
---@field placement? string -- ex: "bottom", "top", "left", "right"
---@field title string -- título já traduzido
---@field content string -- conteúdo já traduzido
---@field advanceOnCategory string? -- ex: "entry", "exit"
---@field advanceOnInputFill boolean?
---@field minInputValue number?
---@field inputDebounceMs number?
---@field advanceOnClick boolean?
---@field advanceOnDrop boolean?
---@field advanceOnDropFrom table<string, any>?
---@field advanceOnDropTo table<string, any>?
---@field closeOnEscape boolean?

---@class tutorial.ui.TutorialStepConfig: tutorial.ui.TutorialStep
---@field target string
---@field placement? string
---@field title table<string, string> -- mapa de locale -> texto traduzido
---@field content table<string, string> -- mapa de locale -> texto traduzido

---@class tutorial.ui.Tutorial
---@field id tutorial.ui.TutorialId
---@field steps tutorial.ui.TutorialStep[]

---@class tutorial.ui.TutorialConfig
---@field steps tutorial.ui.TutorialStepConfig[]

---@alias tutorial.ui.TutorialId sx.services.AccountsEventsService.TutorialUiEvents -- ex: 'tutorial.ui.bank'
---@alias tutorial.ui.ConfigData table<tutorial.ui.TutorialId, tutorial.ui.TutorialConfig>

---@type tutorial.ui.ConfigData
UI_TUTORIALS = {}

UI_TUTORIALS['tutorial.ui.bank'] = {
    steps = {
        {
            target            = '[data-tutorial-target="deposit-nav"]',
            placement         = "bottom",
            title             = {
                ['pt-pt'] = "Deposite o seu dinheiro",
                ['pt-br'] = "Deposite o seu dinheiro",
                ['en-us'] = "Deposit your money",
                ['es-es'] = "Deposita tu dinero",
                ['fr-fr'] = "Déposez votre argent",
                ['de-de'] = "Zahle dein Geld ein",
                ['ar-sa'] = "أودع أموالك",
            },
            content           = {
                ['pt-br'] = "Acesse a aba Depósito para guardar e proteger o seu dinheiro no banco",
                ['pt-pt'] = "Acede ao separador Depósito para guardar e proteger o teu dinheiro no banco",
                ['en-us'] = "Access the Deposit tab to save and protect your money in the bank",
                ['es-es'] = "Accede a la pestaña Depósito para guardar y proteger tu dinero en el banco",
                ['fr-fr'] = "Accédez à l'onglet Dépôt pour enregistrer et protéger votre argent dans la banque",
                ['de-de'] = "Öffne den Tab Einzahlung, um dein Geld in der Bank zu sichern",
                ['ar-sa'] = "ادخل إلى تبويب الإيداع لحفظ وحماية أموالك في البنك",
            },
            advanceOnCategory = "entry",
        },
        {
            target             = '[data-tutorial-target="deposit-input"]',
            placement          = "bottom",
            title              = {
                ['pt-pt'] = "Valor do Depósito",
                ['pt-br'] = "Valor do Depósito",
                ['en-us'] = "Deposit Value",
                ['es-es'] = "Valor del Depósito",
                ['fr-fr'] = "Valeur du Dépôt",
                ['de-de'] = "Einzahlungsbetrag",
                ['ar-sa'] = "قيمة الإيداع",
            },
            content            = {
                ['pt-br'] = "Insira o valor que deseja depositar. Depois, clique em qualquer lugar pra continuar.",
                ['pt-pt'] = "Insere o valor que queres depositar. Depois, clica em qualquer sítio para continuar.",
                ['en-us'] = "Enter the value you want to deposit. Then, click anywhere to continue.",
                ['es-es'] = "Introduce el valor que deseas depositar. Luego, haz clic en cualquier lugar para continuar.",
                ['fr-fr'] = "Entrez la valeur que vous souhaitez déposer. Ensuite, cliquez n'importe où pour continuer.",
                ['de-de'] = "Gib den Betrag ein, den du einzahlen möchtest. Klicke anschließend irgendwo hin, um fortzufahren.",
                ['ar-sa'] = "أدخل القيمة التي تريد إيداعها. ثم انقر في أي مكان للمتابعة.",
            },
            advanceOnClick = true,
            minInputValue      = 1,
            inputDebounceMs    = 100,
        },
        {
            target         = '[data-tutorial-target="deposit-submit"]',
            placement      = "bottom",
            title          = {
                ['pt-pt'] = "Clica para depositar",
                ['pt-br'] = "Clique para depositar",
                ['en-us'] = "Click to deposit",
                ['es-es'] = "Clic para depositar",
                ['fr-fr'] = "Cliquez pour déposer",
                ['de-de'] = "Klicke zum Einzahlen",
                ['ar-sa'] = "انقر للإيداع",
            },
            content        = {
                ['pt-br'] = "Clique no botão destacado para concluir o depósito na sua conta",
                ['pt-pt'] = "Clica no botão destacado para concluir o depósito na tua conta",
                ['en-us'] = "Click the highlighted button to complete the deposit in your account",
                ['es-es'] = "Haz clic en el botón destacado para completar el depósito en tu cuenta",
                ['fr-fr'] = "Cliquez sur le bouton mis en évidence pour terminer le dépôt dans votre compte",
                ['de-de'] = "Klicke auf die hervorgehobene Schaltfläche, um die Einzahlung auf dein Konto abzuschließen",
                ['ar-sa'] = "انقر على الزر المميّز لإتمام الإيداع في حسابك",
            },
            advanceOnClick = true,
        },
    },
}

UI_TUTORIALS['tutorial.ui.chest'] = {
    steps = {
        {
            target            = '[data-tutorial-target="main-slot-6"]',
            placement         = 'right',
            title             = {
                ['pt-pt'] = "Arraste para guardar",
                ['pt-br'] = "Arraste para guardar",
                ['en-us'] = "Drag to store",
                ['es-es'] = "Arrastra para guardar",
                ['fr-fr'] = "Glissez pour ranger",
                ['de-de'] = "Zum Verstauen ziehen",
                ['ar-sa'] = "اسحب للتخزين",
            },
            content           = {
                ['pt-pt'] = "Para mover os itens do seu inventário, mantenha premido o botão esquerdo do rato para arrastar e guardar o item no baú.",
                ['pt-br'] = "Para mover os itens do seu inventário, segure o clique esquerdo do mouse para arrastar e guardar o item no baú.",
                ['en-us'] = "To move items from your inventory, hold the left mouse button and drag to place the item in the chest.",
                ['es-es'] = "Para mover objetos de tu inventario, mantén pulsado el botón izquierdo del ratón y arrástralos al cofre.",
                ['fr-fr'] = "Pour déplacer des objets de votre inventaire, maintenez le clic gauche de la souris et faites glisser l'objet vers le coffre.",
                ['de-de'] = "Um Gegenstände aus deinem Inventar zu bewegen, halte die linke Maustaste gedrückt und ziehe den Gegenstand in die Kiste.",
                ['ar-sa'] = "لنقل العناصر من مخزونك، اضغط مع الاستمرار على زر الفأرة الأيسر واسحب العنصر إلى الصندوق.",
            },
            advanceOnDrop     = true,
            advanceOnDropFrom = { fromType = 'main', fromSlot = 6 },
            advanceOnDropTo   = { toType = 'chest' },
            closeOnEscape     = true,
        },
    }
}

UI_TUTORIALS['tutorial.ui.store'] = {
    steps = {
        {
            target = '[data-tutorial-target="shop-slot-1"]',
            placement = "left",
            title = {
                ['pt-br'] = "Arraste para comprar",
                ['pt-pt'] = "Arrasta para comprar",
                ['en-us'] = "Drag to buy",
                ['es-es'] = "Arrastar para comprar",
                ['fr-fr'] = "Faire glisser pour acheter",
                ['de-de'] = "Zum Kaufen ziehen",
                ['ar-sa'] = "اسحب للشراء",
            },
            content = {
                ['pt-br'] = "Para comprar um item da loja, segure o clique esquerdo e arraste para seu inventário.",
                ['pt-pt'] = "Para comprar um item da loja, mantém premido o clique esquerdo e arrasta para o teu inventário.",
                ['en-us'] = "To buy an item from the store, hold the left click and drag to your inventory.",
                ['es-es'] = "Para comprar un item de la tienda, mantén presionado el clic izquierdo y arrástralo a tu inventario.",
                ['fr-fr'] = "Pour acheter un item de la boutique, maintenez le clic gauche et faites glisser vers votre inventaire.",
                ['de-de'] = "Um einen Gegenstand im Laden zu kaufen, halte die linke Maustaste gedrückt und ziehe ihn in dein Inventar.",
                ['ar-sa'] = "لشراء عنصر من المتجر، اضغط مع الاستمرار على زر الفأرة الأيسر واسحبه إلى مخزونك.",
            },
            advanceOnDrop = true,
            advanceOnDropFrom = { fromType = "shop", fromSlot = 1 },
            advanceOnDropTo = { toType = "main" },
        }
    }
}

UI_TUTORIALS['tutorial.ui.hub'] = { steps = {}, enabled = false }
UI_TUTORIALS['tutorial.mic.hub'] = { steps = {} }

---@type string
local LANGUAGE = GetConvar('language', 'pt-br')

---@param id tutorial.ui.TutorialId
---@return tutorial.ui.Tutorial?, tutorial.ui.TutorialId?
function GetTutorialById(id)
    local data = UI_TUTORIALS[id]
    if not data then
        return nil, nil
    end

    ---@type tutorial.ui.Tutorial
    local tutorial = {
        id    = id,
        steps = {},
    }

    for index, step in ipairs(data.steps) do
        tutorial.steps[index] = {
            title              = step.title[LANGUAGE] or step.title['pt-br'],
            content            = step.content[LANGUAGE] or step.content['pt-br'],
            target             = step.target,
            placement          = step.placement,

            advanceOnCategory  = step.advanceOnCategory,
            advanceOnClick     = step.advanceOnClick,
            inputDebounceMs    = step.inputDebounceMs,
            minInputValue      = step.minInputValue,
            advanceOnInputFill = step.advanceOnInputFill,

            advanceOnDrop      = step.advanceOnDrop,
            advanceOnDropFrom  = step.advanceOnDropFrom,
            advanceOnDropTo    = step.advanceOnDropTo,
            closeOnEscape      = step.closeOnEscape,
        }
    end

    return tutorial, id
end

exports('GetTutorialById', GetTutorialById)
