addonName, addonTable = ...

local AutoRepair = {}

local function HowMuchOwnFundsUsed(repairAllCost)
    local guildBankWithdrawLimit = GetGuildBankWithdrawMoney()
    return repairAllCost - guildBankWithdrawLimit
end

local function FormatRepairMessage(ownFundsUsed)
    local RepairMessage = "Using %s of your own money to repair items"
    return string.format(RepairMessage, GetCoinText(ownFundsUsed, ", "))
end

local function PrintMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage(message, 255, 255, 0)
end

local function HandleRepairMessaging(repairAllCost)
    local ownFundsUsed = HowMuchOwnFundsUsed(repairAllCost)
    if (ownFundsUsed > 0) then
        local message = FormatRepairMessage(ownFundsUsed)
        PrintMessage(message)
    end
end

function AutoRepair:OnMerchantShow(event)
    if (event == "MERCHANT_SHOW") then
        local canMerchantRepair = CanMerchantRepair()
        if (canMerchantRepair) then
            local repairAllCost, needRepairs = GetRepairAllCost()
            local canUseGuildBankForRepairing = CanGuildBankRepair()
            if (needRepairs and canUseGuildBankForRepairing) then
                HandleRepairMessaging(repairAllCost)
                RepairAllItems(true)
            end
        end
    end
end

addonTable.AutoRepair = AutoRepair
