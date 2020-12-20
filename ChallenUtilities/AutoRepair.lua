addonName, addonTable = ...

local AutoRepair = {}

local function PrintMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage(message, 255, 255, 255)
end

local function HandleRepairMessaging(repairAllCost, costDiff)
    if (costDiff > 0) then
        message = string.format("Repaired gear for %s, but used %s of your own money (out of guild money for the day)", GetCoinText(repairAllCost, ", "), GetCoinText(costDiff, ", "))
    else
        message = string.format("Repaired gear for %s, and you have %s left from the guild for the day", GetCoinText(repairAllCost, ", "), GetCoinText(abs(costDiff), ", "))
    end
    PrintMessage(message)
end

local function CalculateCostDirection(repairAllCost)
    local guildBankWithdrawLimit = GetGuildBankWithdrawMoney()
    return repairAllCost - guildBankWithdrawLimit
end

function AutoRepair:OnMerchantShow(event)
    if (event == "MERCHANT_SHOW") then
        local canMerchantRepair = CanMerchantRepair()
        if (canMerchantRepair) then
            local repairAllCost, needRepairs = GetRepairAllCost()
            local canUseGuildBankForRepairing = CanGuildBankRepair()
            if (needRepairs and canUseGuildBankForRepairing) then
                RepairAllItems(true)
                local costDiff = CalculateCostDirection(repairAllCost)
                HandleRepairMessaging(repairAllCost, costDiff)
            end
        end
    end
end

addonTable.AutoRepair = AutoRepair
