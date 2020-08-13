addonName, addonTable = ...

local ItemInfo = addonTable.ItemInfo
local ClassInfo = addonTable.ClassInfo
local AutoSellUnusable = {}

local function SellItem(bag, slot)
    PickupContainerItem(bag, slot)
    PickupMerchantItem()
end

local function GetPlayerClass()
    local class, _ = UnitClassBase('player')
    return class
end

local function CanEquipShield(class)
    return class == 'WARRIOR' or class == 'PALADIN' or class == 'SHAMAN'
end

local function CanWearPlate(class)
    return class == 'DEATHKNIGHT' or class == 'PALADIN' or class == 'WARRIOR'
end

local function CanWearMail(class)
    return CanWearPlate(class) or class == 'HUNTER' or class == 'SHAMAN'
end

local function CanWearLeather(class)
    return CanWearMail(class) or class == 'DEMONHUNTER' or class == 'DRUID' or class == 'MONK' or class == 'ROGUE'
end

local function CanWearCloth(class)
    return CanWearLeather(class) or class == 'MAGE' or class == 'PRIEST' or class == 'WARLOCK'
end

local function GetUsableItems(class)
    local usableItems = {[LE_ITEM_CLASS_ARMOR] = {}}

    if (CanWearCloth(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_CLOTH] = true
    end

    if (CanWearLeather(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_LEATHER] = true
    end

    if (CanWearMail(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_MAIL] = true
    end

    if (CanWearPlate(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_PLATE] = true
    end

    if (CanEquipShield(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_SHIELD] = true
    end

    return usableItems
end

local function CheckItemUsability(bindType, itemClassID, itemSubclassID)
    local isItemBindOnPickup = ItemInfo:IsItemBindOnPickup(bindType)
    if (not isItemBindOnPickup) then
        return true
    end

    local isItemArmor = ItemInfo:IsItemArmor(itemClassID)
    if (not isItemArmor) then
        return true
    end

    local class = GetPlayerClass()
    local usableItems = GetUsableItems(class)
    return usableItems[itemClassID][itemSubclassID] == true
end

function AutoSellUnusable:OnMerchantShow(event)
    if (event == "MERCHANT_SHOW") then
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local _, _, _, quality, _, _, _, _, noValue, itemID = GetContainerItemInfo(bag, slot)
                if (itemID and not ItemInfo:IsItemPoorQuality(quality) and not noValue) then
                    local _, _, _, _, _, _, _, _, _, _, _, itemClassID, itemSubclassID, bindType, _, _, _ = GetItemInfo(itemID)
                    local isItemUsable = CheckItemUsability(bindType, itemClassID, itemSubclassID)
                    if (not isItemUsable) then
                        SellItem(bag, slot)
                    end
                end
            end
        end
    end
end

addonTable.AutoSellUnusable = AutoSellUnusable
