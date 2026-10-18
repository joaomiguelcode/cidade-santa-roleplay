---@alias HudCouponInteractionType "copy" | "use_now" | "view" | "banner_click" | "store_open" | "close"
---@alias HudCouponCloseReason "close_button" | "esc" | "outside" | "external"

---Enviado pela NUI/client junto de cada interação.
---@class HudCouponInteractionDetails
---@field displayId? string Exibição do modal que originou o evento
---@field closeReason? HudCouponCloseReason
---@field closeMs? number Milissegundos entre a exibição e o fechamento

---Dimensões resolvidas no server e gravadas na linha da interação.
---@class HudCouponInteractionContext
---@field displayId? string
---@field closeReason? HudCouponCloseReason
---@field closeMs? number
---@field sessionId? number
---@field city? string
---@field offerId? number
---@field bannerId? string
---@field productId? string

---@class HudCouponPayload
---@field code string
---@field category string
---@field discount number
---@field tebexUrl string
---@field minimumPurchase? number
---@field startsAt? number
---@field expiresAt? number
---@field isActive boolean

---@class HudCouponWebhookFields
---@field code string
---@field category string
---@field discount string
---@field tebexUrl string
---@field minimumPurchase string
---@field startsAt string
---@field expiresAt string
---@field status string

---@class HudVipCollectionPayload
---@field title string
---@field description string
---@field tebexUrl string
---@field bannerUrl string

---@class HudCouponRepositoryRow
---@field id number
---@field code string
---@field category string
---@field discount number|string
---@field tebex_url string
---@field minimum_purchase? number|string
---@field starts_at? number
---@field expires_at? number
---@field nui_expires_at? number
---@field is_active boolean
---@field created_by_character_id number
---@field updated_by_character_id number
---@field deleted_by_character_id? number
---@field created_at number
---@field updated_at number
---@field deleted_at? number
---@field created_by_name? string
---@field updated_by_name? string

---@class HudVipCollectionRepositoryRow
---@field id number
---@field title string
---@field description string
---@field tebex_url string
---@field banner_url string
---@field created_by_character_id number
---@field updated_by_character_id number
---@field created_at number
---@field updated_at number
---@field created_by_name? string
---@field updated_by_name? string

---@class HudCouponPublicDto
---@field id number
---@field code string
---@field category string
---@field discount integer
---@field tebexUrl string
---@field minimumPurchase? number
---@field startsAt? number
---@field expiresAt? number
---@field isActive boolean
---@field isAvailable boolean

---@class HudCouponAdminDto: HudCouponPublicDto
---@field startsAtFormatted? string
---@field expiresAtFormatted? string
---@field createdByCharacterId number
---@field createdByName string
---@field updatedByCharacterId number
---@field updatedByName string
---@field createdAt number
---@field updatedAt number
---@field createdAtFormatted string
---@field updatedAtFormatted string

---@class HudAdCouponDto
---@field id number
---@field target string
---@field discount string
---@field condition? string
---@field code string
---@field link string
---@field expiresAt? number

---@class HudAdCouponBannerDto
---@field title string
---@field subtitle? string
---@field image string
---@field link string

---@class HudAdCouponNotifyDto
---@field cupom HudAdCouponDto
---@field key string
---@field duration? number

---@class HudVipCollectionPublicDto
---@field title string
---@field description string
---@field tebexUrl string
---@field bannerUrl string

---@class HudVipCollectionAdminDto: HudVipCollectionPublicDto
---@field createdByCharacterId number
---@field createdByName string
---@field updatedByCharacterId number
---@field updatedByName string
---@field createdAt number
---@field updatedAt number

---@class HudCouponOffersDto
---@field cupons HudAdCouponDto[]
---@field banner? HudAdCouponBannerDto
---@field reopenKey? string
---@field floatingSeconds? number

---@class HudCouponResult
---@field ok boolean
---@field message string
---@field data? any
