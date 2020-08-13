addonName, addonTable = ...

local AutoRepair = {}

local function FormatMoney(money)
    return GetCoinText(money, ", ")
end

local function FormatGuildRepairMessage(repairAllCost, guildBankWithdrawLimit)
    local GuildRepairMessage = "Repairing your items for %s. You have %s left in the guild bank for today."
    return string.format(GuildRepairMessage, FormatMoney(repairAllCost), FormatMoney(guildBankWithdrawLimit))
end

local function FormatOwnRepairMessage(repairAllCost, guildBankUsed, ownMoneyUsed)
    local OwnRepairMessage = "Repairing your items for %s with %s from the guild bank and %s of your own money."
    return string.format(OwnRepairMessage, FormatMoney(repairAllCost), FormatMoney(guildBankUsed), FormatMoney(ownMoneyUsed))
end

local function DetermineRepairMessage(repairAllCost)
    local guildBankWithdrawLimit = GetGuildBankWithdrawMoney()
    if (repairAllCost < guildBankWithdrawLimit) then
        return FormatGuildRepairMessage(repairAllCost, guildBankWithdrawLimit - repairAllCost)
    else
        return FormatOwnRepairMessage(repairAllCost, guildBankWithdrawLimit, repairAllCost - guildBankWithdrawLimit)
    end
end

local function PrintMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage(message, 255, 255, 0)
end

function AutoRepair:OnMerchantShow(event)
    if (event == "MERCHANT_SHOW") then
        local canMerchantRepair = CanMerchantRepair()
        if (canMerchantRepair) then
            local repairAllCost, needRepairs = GetRepairAllCost()
            local canUseGuildBankForRepairing = CanGuildBankRepair()
            if (needRepairs and canUseGuildBankForRepairing) then
                local guildBankWithdrawLimit = GetGuildBankWithdrawMoney()
                local message = DetermineRepairMessage(repairAllCost)
                PrintMessage(message)
                RepairAllItems(true)
            end
        end
    end
end

addonTable.AutoRepair = AutoRepair
