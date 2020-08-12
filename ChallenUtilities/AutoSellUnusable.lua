addonName, addonTable = ...

local FormatMoney = addonTable.FormatMoney
local PrintMessage = addonTable.PrintMessage
local AutoSellUnusable = {}

local function FormatSoldMessage(total)
    local SoldMessage = "Sold all unusable items for %s"
    return string.format(SoldMessage, FormatMoney(total))
end

local function SellItem(bag, slot)
    PickupContainerItem(bag, slot)
    PickupMerchantItem()
end

local function GetPlayerClass()
    local class, _ = UnitClassBase('player')
    return class
end

local function IsItemBindOnPickup(bindType)
    return bindType == 1 -- 1 is bind on pickup
end

local function IsItemArmor(itemClassID)
    return itemClassID == LE_ITEM_CLASS_ARMOR
end

local function GetUsableItems()
    local _, class, _ = UnitClass('player')
    local usableArmor
    if (class == 'WARRIOR') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH, LE_ITEM_ARMOR_LEATHER, LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD}
    elseif (class == 'PALADIN') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH, LE_ITEM_ARMOR_LEATHER, LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE, LE_ITEM_ARMOR_SHIELD}
    elseif (class == 'DEATHKNIGHT') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH, LE_ITEM_ARMOR_LEATHER, LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_PLATE}
    elseif (class == 'HUNTER') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH, LE_ITEM_ARMOR_LEATHER, LE_ITEM_ARMOR_MAIL}
    elseif (class == 'SHAMAN') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH, LE_ITEM_ARMOR_LEATHER, LE_ITEM_ARMOR_MAIL, LE_ITEM_ARMOR_SHIELD}
    elseif (class == 'ROGUE') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH, LE_ITEM_ARMOR_LEATHER}
    elseif (class == 'MONK') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH, LE_ITEM_ARMOR_LEATHER}
    elseif (class == 'DRUID') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH, LE_ITEM_ARMOR_LEATHER}
    elseif (class == 'DEMONHUNTER') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH, LE_ITEM_ARMOR_LEATHER}
    elseif (class == 'PRIEST') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH}
    elseif (class == 'MAGE') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH}
    elseif (class == 'WARLOCK') then
        usableArmor = {LE_ITEM_ARMOR_CLOTH}
    end

    local usable = {}
    for subclass in usableArmor do
        usable[LE_ITEM_CLASS_ARMOR][subclass] = true
    end

    return usable
end

local function CheckItemUsability(bindType, itemClassID, itemSubclassID)
    local isItemBindOnPickup = IsItemBindOnPickup(bindType)
    if (not isItemBindOnPickup) then
        return true
    end

    local isItemArmor = IsItemArmor(itemClassID)
    if (not isItemArmor) then
        return true
    end

    local class = GetPlayerClass()
    local usableItems = GetUsableItems(class)
    return usableItems[itemClassID][itemSubclassID] == true
end

function AutoSellUnusable:OnMerchantShow(event)
    if (event == "MERCHANT_SHOW") then
        local totalSellPrice = 0
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local _, itemCount, _, _, _, _, _, _, noValue, itemID = GetContainerItemInfo(bag, slot)
                if (itemID and not noValue) then
                    local _, _, _, _, _, _, _, _, _, _, itemSellPrice, itemClassID, itemSubclassID, bindType, _, _, _ = GetItemInfo(itemID)
                    local isItemUsable = CheckItemUsability(bindType, itemClassID, itemSubclassID)
                    if (not isItemUsable) then
                        local stackPrice = itemCount * itemSellPrice
                        totalSellPrice = totalSellPrice + stackPrice
                        SellItem(bag, slot)
                    end
                end
            end
        end
        if (totalSellPrice > 0) then
            local message = FormatSoldMessage(totalSellPrice)
            PrintMessage(message)
        end
    end
end

addonTable.AutoSellUnusable = AutoSellUnusable
