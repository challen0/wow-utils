addonName, addonTable = ...

local AutoSellPoorQuality = {}

local function SellItem(bag, slot)
    PickupContainerItem(bag, slot)
    PickupMerchantItem()
end

local function IsItemPoorQuality(quality)
    return quality == 0
end

local function FormatProfitMessage(ownFundsUsed)
    local profitMessage = "Sold junk for %s"
    return string.format(profitMessage, GetCoinText(ownFundsUsed, ", "))
end

local function PrintMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage(message, 255, 255, 255)
end

local function HandleProfitMessaging(profit)
    if profit > 0 then
        local message = FormatProfitMessage(profit)
        PrintMessage(message)
    end
end

local function CalculateStackPrice(itemCount, itemID)
    local _, _, _, _, _, _, _, _, _, _, sellPrice, _, _, _, _, _, _ = GetItemInfo(itemID)
    local stackPrice = itemCount * sellPrice
    return stackPrice
end

function AutoSellPoorQuality:OnMerchantShow(event)
    if (event == "MERCHANT_SHOW") then
        local profit = 0
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local _, itemCount, _, quality, _, _, _, _, noValue, itemID = GetContainerItemInfo(bag, slot)
                if (itemID and IsItemPoorQuality(quality) and not noValue) then
                    local stackPrice = CalculateStackPrice(itemCount, itemID)
                    profit = profit + stackPrice
                    SellItem(bag, slot)
                end
            end
        end
        HandleProfitMessaging(profit)
    end
end

addonTable.AutoSellPoorQuality = AutoSellPoorQuality
