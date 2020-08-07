addonName, addonTable = ...

local AutoRepair = {}

function OnMerchantShow(self, event)
    if event == "MERCHANT_SHOW" then
        local canMerchantRepair = CanMerchantRepair()
        if (canMerchantRepair) then
            local repairAllCost, needRepairs = GetRepairAllCost()
            local canUseGuildBankForRepairing = CanGuildBankRepair()
            if (needRepairs and canUseGuildBankForRepairing) then
                local message = DetermineRepairMessage(repairAllCost)
                PrintRepairMessage(message)
                RepairAllItems(true)
            end
        end
    end
end

function DetermineRepairMessage(repairAllCost)
    local guildBankWithdrawLimit = GetGuildBankWithdrawMoney()
    if (repairAllCost < guildBankWithdrawLimit) then
        return FormatGuildRepairMessage(repairAllCost, guildBankWithdrawLimit - repairAllCost)
    else
        return FormatOwnRepairMessage(repairAllCost, guildBankWithdrawLimit, repairAllCost - guildBankWithdrawLimit)
    end
end

function FormatGuildRepairMessage(repairAllCost, guildBankWithdrawLimit)
    local GuildRepairMessage = "Repairing your items for %s. You have %s left in the guild bank for today."
    return string.format(GuildRepairMessage, FormatMoney(repairAllCost), FormatMoney(guildBankWithdrawLimit))
end

function FormatOwnRepairMessage(repairAllCost, guildBankUsed, ownMoneyUsed)
    local OwnRepairMessage = "Repairing your items for %s with %s from the guild bank and %s of your own money."
    return string.format(OwnRepairMessage, FormatMoney(repairAllCost), FormatMoney(guildBankUsed), FormatMoney(ownMoneyUsed))
end

function FormatMoney(money)
    return GetCoinText(money, ", ")
end

function PrintRepairMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage(message, 255, 255, 0)
end

addonTable.AutoRepair = AutoRepair
