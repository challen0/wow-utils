addonName, addonTable = ...

local AutoSellPoorQuality = {}

local function SellItem(bag, slot)
    PickupContainerItem(bag, slot)
    PickupMerchantItem()
end

local function IsItemPoorQuality(quality)
    return quality == 0
end

function AutoSellPoorQuality:OnMerchantShow(event)
    if (event == "MERCHANT_SHOW") then
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local _, _, _, quality, _, _, _, _, noValue, itemID = GetContainerItemInfo(bag, slot)
                if (itemID and IsItemPoorQuality(quality) and not noValue) then
                    SellItem(bag, slot)
                end
            end
        end
    end
end

addonTable.AutoSellPoorQuality = AutoSellPoorQuality
