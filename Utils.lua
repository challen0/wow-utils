GUILD_REPAIR_MESSAGE = "Repairing your items for %s from guild funds. You have %s left for today."
OWN_REPAIR_MESSAGE = "Repairing your items for %s (%s from guild funds and %s from your funds)."

function MerchantShow_AutoRepair(self, event)
	if (CanMerchantRepair()) then
		local repairAllCost, needRepairs = GetRepairAllCost()
		if (needRepairs and CanGuildBankRepair()) then
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
			-- RepairAllItems(true)
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", MerchantShow_AutoRepair)
