---@alias MembershipName string
---@alias MembershipLevel integer

---@class Membership
---@field name MembershipName
---@field level MembershipLevel
---@field expiresAt string?

---@alias MembershipSnapshot Membership[]

---@class MembershipSnapshotEventPayload
---@field memberships MembershipSnapshot

---@class StoredMembership
---@field name MembershipName
---@field level MembershipLevel
---@field expires_epoch integer?

---@class MembershipGroupDefinition
---@field Parent table<MembershipName, unknown>

---@alias MembershipGroups table<MembershipName, MembershipGroupDefinition>
---@alias MembershipInheritance table<MembershipName, MembershipName[]>
