addonName, addonTable = ...

local ItemInfo = addonTable.ItemInfo
local ClassInfo = addonTable.ClassInfo
local AutoSellUnusable = {}

local function SellItem(bag, slot)
    PickupContainerItem(bag, slot)
    PickupMerchantItem()
end

local function GetUsableItems(class)
    local usableItems = {[LE_ITEM_CLASS_ARMOR] = {}}

    -- everyone can use rings, trinkets, and necklaces
    usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_GENERIC] = true
    -- everyone can use cosmetic items
    usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_COSMETIC] = true

    if (ClassInfo:CanWearCloth(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_CLOTH] = true
    end

    if (ClassInfo:CanWearLeather(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_LEATHER] = true
    end

    if (ClassInfo:CanWearMail(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_MAIL] = true
    end

    if (ClassInfo:CanWearPlate(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_PLATE] = true
    end

    if (ClassInfo:CanEquipShield(class)) then
        usableItems[LE_ITEM_CLASS_ARMOR][LE_ITEM_ARMOR_SHIELD] = true
    end

    return usableItems
end

local function CheckItemUsability(bindType, itemClassID, itemSubclassID)
    if (not ItemInfo:IsItemBindOnPickup(bindType)) then
        return true
    end

    if (not ItemInfo:IsItemArmor(itemClassID)) then
        return true
    end

    local class = ClassInfo:GetPlayerClass()
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
                    if (not CheckItemUsability(bindType, itemClassID, itemSubclassID)) then
                        SellItem(bag, slot)
                    end
                end
            end
        end
    end
end

addonTable.AutoSellUnusable = AutoSellUnusable
