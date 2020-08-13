addonName, addonTable = ...

local ItemInfo = {}

function ItemInfo:IsItemPoorQuality(quality)
    return quality == 0
end

function ItemInfo:IsItemBindOnPickup(bindType)
    return bindType == 1
end

function ItemInfo:IsItemArmor(itemClassID)
    return itemClassID == LE_ITEM_CLASS_ARMOR
end

addonTable.ItemInfo = ItemInfo
