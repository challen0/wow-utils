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
