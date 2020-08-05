GUILD_REPAIR_MESSAGE = "Repairing your items for %s. You have %s left in the guild bank for today."
OWN_REPAIR_MESSAGE = "Repairing your items for %s with %s from the guild bank and %s of your own money."

function MerchantShow_AutoRepair(self, event)
	if (CanMerchantRepair()) then
		local repairAllCost, needRepairs = GetRepairAllCost()
		if (needRepairs and CanGuildBankRepair()) then
			local message = DetermineRepairMessage(repairAllCost)
			PrintRepairMessage(message)
			-- RepairAllItems(true)
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
	return string.format(GUILD_REPAIR_MESSAGE, FormatMoney(repairAllCost), FormatMoney(guildBankWithdrawLimit))
end

function FormatOwnRepairMessage(repairAllCost, guildBankUsed, ownMoneyUsed)
	return string.format(OWN_REPAIR_MESSAGE, FormatMoney(repairAllCost), FormatMoney(guildBankUsed), FormatMoney(ownMoneyUsed))
end

function FormatMoney(money)
	return GetCoinText(money, ", ")
end

function PrintRepairMessage(message)
	DEFAULT_CHAT_FRAME:AddMessage(message, 255, 255, 0)
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", MerchantShow_AutoRepair)
