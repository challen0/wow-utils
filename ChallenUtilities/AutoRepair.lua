addonName, addonTable = ...

local AutoRepair = {}

local function HowMuchOwnFundsUsed(repairAllCost)
    local guildBankWithdrawLimit = GetGuildBankWithdrawMoney()
    return repairAllCost - guildBankWithdrawLimit, guildBankWithdrawLimit
end

local function PrintMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage(message, 255, 255, 255)
end

local function HandleRepairMessaging(repairAllCost)
    local ownFundsUsed, guildRepairMoneyLeft = HowMuchOwnFundsUsed(repairAllCost)
    if (ownFundsUsed > 0) then
        message = string.format("Repaired gear for %s, but used %s of your own money (out of guild money for the day)", GetCoinText(repairAllCost, ", "), GetCoinText(ownFundsUsed, ", "))
    else
        message = string.format("Repaired gear for %s, and you have %s left from the guild for the day", GetCoinText(repairAllCost, ", "), GetCoinText(guildRepairMoneyLeft, ", "))
    end
    PrintMessage(message)
end

function AutoRepair:OnMerchantShow(event)
    if (event == "MERCHANT_SHOW") then
        local canMerchantRepair = CanMerchantRepair()
        if (canMerchantRepair) then
            local repairAllCost, needRepairs = GetRepairAllCost()
            local canUseGuildBankForRepairing = CanGuildBankRepair()
            if (needRepairs and canUseGuildBankForRepairing) then
                RepairAllItems(true)
                HandleRepairMessaging(repairAllCost)
            end
        end
    end
end

addonTable.AutoRepair = AutoRepair
