addonName, addonTable = ...

function addonTable.FormatMoney(money)
    return GetCoinText(money, ", ")
end

function addonTable.PrintMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage(message, 255, 255, 0)
end
