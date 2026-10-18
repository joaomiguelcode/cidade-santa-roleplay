COUPONS_CONFIG = {
    COMMANDS = {
        ADMIN = 'staffcupom',
        PLAYER = 'coupons.commands.player',
    },
    PERMISSIONS = {
        Admin = 1,
        CS = 1,
        GestaoComercial = 1,
        Afiliado = 1,
    },
    CATEGORIES = {
        {
            VALUE = 'allStore',
            TRANSLATION = 'coupons.categories.allStore',
        },
        {
            VALUE = 'vips',
            TRANSLATION = 'coupons.categories.vips',
        },
        {
            VALUE = 'cars',
            TRANSLATION = 'coupons.categories.cars',
        },
        {
            VALUE = 'armoredVehicles',
            TRANSLATION = 'coupons.categories.armoredVehicles',
        },
        {
            VALUE = 'houses',
            TRANSLATION = 'coupons.categories.houses',
        },
        {
            VALUE = 'mansions',
            TRANSLATION = 'coupons.categories.mansions',
        },
        {
            VALUE = 'exclusives',
            TRANSLATION = 'coupons.categories.exclusives',
        },
        {
            VALUE = 'flash',
            TRANSLATION = 'coupons.categories.flash',
        },
        {
            VALUE = 'vipLastThreeDays',
            TRANSLATION = 'coupons.categories.vipLastThreeDays',
        },
        {
            VALUE = 'wipe',
            TRANSLATION = 'coupons.categories.wipe',
        },
        {
            VALUE = 'vipLaunch',
            TRANSLATION = 'coupons.categories.vipLaunch',
        },
    },
    CONSTRAINTS = {
        CODE_MIN_LENGTH = 2,
        CODE_MAX_LENGTH = 64,
        DISCOUNT_MIN = 0.01,
        DISCOUNT_MAX = 100,
        URL_MAX_LENGTH = 2048,
        VIP_COLLECTION = {
            TITLE_MIN_LENGTH = 2,
            TITLE_MAX_LENGTH = 120,
            DESCRIPTION_MIN_LENGTH = 2,
            DESCRIPTION_MAX_LENGTH = 1000,
            URL_MAX_LENGTH = 2048,
        },
    },
    CALLBACKS = {
        OPEN_ADMIN = 'hud:coupons:open-admin',
        LIST = 'hud:coupons:list',
        GET_OFFERS = 'hud:coupons:get-offers',
        CREATE = 'hud:coupons:create',
        UPDATE = 'hud:coupons:update',
        UPDATE_STATUS = 'hud:coupons:update-status',
        REMOVE = 'hud:coupons:remove',
        GET_VIP_COLLECTION = 'hud:coupons:get-vip-collection',
        SAVE_VIP_COLLECTION = 'hud:coupons:save-vip-collection',
        REMOVE_VIP_COLLECTION = 'hud:coupons:remove-vip-collection',
        RECORD_INTERACTION = 'hud:coupons:record-interaction',
    },
    EVENTS = {
        SHOW = 'hud:coupons:show',
        CLOSE = 'hud:coupons:close',
        SHOW_NOTIFY = 'hud:coupons:show-notify',
        HIDE_NOTIFY = 'hud:coupons:hide-notify',
    },
    GLOBAL_STATE = {
        OFFERS = 'hud:coupons:offers',
    },
    REOPEN_POPUP = {
        REOPEN_KEY = 'F7',
        DEFAULT_SECONDS = 300,
        COMMAND = 'hudCouponsReopen',
        KEY_MAPPING = 'coupons.keyMapping.reopen',
    },
    POST_BEGINNER = {
        OPEN_DELAY_SECONDS = 30 * 60,
        DEFAULT_WORLD_BUCKET = 1,
    },
    NUI = {
        ACTIONS = {
            OPEN = 'openAdCupons',
            UPDATE = 'updateAdCupons',
            CLOSE = 'closeAdCupons',
            HIDE_FLOATING = 'hideAdCuponsFloating',
            SHOW_NOTIFY = 'showAdCupomNotify',
            HIDE_NOTIFY = 'hideAdCupomNotify',
        },
        CALLBACKS = {
            CLOSE = 'closeAdCupons',
            BANNER_CLICK = 'adCupomBannerClick',
            STORE_OPEN = 'adCupomStoreOpen',
            COPY = 'adCupomCopy',
            USE = 'adCupomUse',
        },
    },
    INTERACTIONS = {
        COPY = 'copy',
        USE_NOW = 'use_now',
        VIEW = 'view',
        BANNER_CLICK = 'banner_click',
        STORE_OPEN = 'store_open',
        CLOSE = 'close',
    },
    CLOSE_REASONS = {
        CLOSE_BUTTON = 'close_button',
        ESC = 'esc',
        OUTSIDE = 'outside',
        -- Fechamento que não partiu do jogador: evento do server ou stop do resource.
        EXTERNAL = 'external',
    },
    WEBHOOK = {
        NAME = 'staffcoupons',
        ACTIONS = {
            CREATE = 'coupons.webhook.actions.create',
            UPDATE = 'coupons.webhook.actions.update',
            UPDATE_STATUS = 'coupons.webhook.actions.updateStatus',
            REMOVE = 'coupons.webhook.actions.remove',
        },
    },
}
