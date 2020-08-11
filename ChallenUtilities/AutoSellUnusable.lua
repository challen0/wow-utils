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
                -- determine if item is unusable and sell it
            end
        end
        if (totalSellPrice > 0) then
            local message = FormatSoldMessage(totalSellPrice)
            PrintMessage(message)
        end
    end
end

addonTable.AutoSellUnusable = AutoSellUnusable
