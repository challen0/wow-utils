GUILD_REPAIR_MESSAGE = "Repairing your items for %s. You have %s left in the guild bank for today."
OWN_REPAIR_MESSAGE = "Repairing your items for %s with %s from the guild bank and %s of your own money."

function MerchantShow_AutoRepair(self, event)
	if (CanMerchantRepair()) then
		local repairAllCost, needRepairs = GetRepairAllCost()
		if (needRepairs and CanGuildBankRepair()) then
			PrintRepairMessage(repairAllCost)
			-- RepairAllItems(true)
		end
	end
end

function DetermineRepairMessage(repairAllCost, guildBankWithdrawLimit)
	if (repairAllCost < guildBankWithdrawLimit) then
		return GUILD_REPAIR_MESSAGE
	else
		return OWN_REPAIR_MESSAGE
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

function PrintRepairMessage(repairAllCost)
	local guildBankWithdrawLimit = GetGuildBankWithdrawMoney()
	local repairAllCoinText = GetCoinText(repairAllCost, ", ")
	if (repairAllCost < guildBankWithdrawLimit) then
		local guildBankWithdrawLimitCoinText = GetCoinText(guildBankWithdrawLimit - repairAllCost, ", ")
		DEFAULT_CHAT_FRAME:AddMessage(string.format(GUILD_REPAIR_MESSAGE, repairAllCoinText, guildBankWithdrawLimitCoinText), 255, 255, 0)
	else
		local guildFundsCoinText = GetCoinText(guildBankWithdrawLimit, ", ")
		local ownFundsCoinText = GetCoinText(abs(repairAllCost - guildBankWithdrawLimit), ", ")
		DEFAULT_CHAT_FRAME:AddMessage(string.format(OWN_REPAIR_MESSAGE, repairAllCoinText, guildFundsCoinText, ownFundsCoinText), 255, 255, 0)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", MerchantShow_AutoRepair)
