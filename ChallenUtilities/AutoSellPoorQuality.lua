addonName, addonTable = ...

local FormatMoney = addonTable.FormatMoney
local PrintMessage = addonTable.PrintMessage
local AutoSellPoorQuality = {}

local function FormatSoldMessage(total)
    local SoldMessage = "Sold all poor quality items for %s"
    return string.format(SoldMessage, FormatMoney(total))
end

local function SellItem(bag, slot)
    PickupContainerItem(bag, slot)
    PickupMerchantItem()
end

function AutoSellPoorQuality:OnMerchantShow(event)
    if (event == "MERCHANT_SHOW") then
        local totalSellPrice = 0
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local _, itemCount, _, quality, _, _, _, _, noValue, itemID = GetContainerItemInfo(bag, slot)
                if (itemID and quality == 0 and not noValue) then
                    local stackPrice = itemCount * select(11, GetItemInfo(itemID))
                    totalSellPrice = totalSellPrice + stackPrice
                    SellItem(bag, slot)
                end
            end
        end
        if (totalSellPrice > 0) then
            local message = FormatSoldMessage(totalSellPrice)
            PrintMessage(message)
        end
    end
end

addonTable.AutoSellPoorQuality = AutoSellPoorQuality
