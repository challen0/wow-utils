addonName, addonTable = ...

local ClassInfo = {}

function ClassInfo:GetPlayerClass()
    local class, _ = UnitClassBase('player')
    return class
end

function ClassInfo:CanEquipShield(class)
    return class == 'WARRIOR' or class == 'PALADIN' or class == 'SHAMAN'
end

function ClassInfo:CanWearPlate(class)
    return class == 'DEATHKNIGHT' or class == 'PALADIN' or class == 'WARRIOR'
end

function ClassInfo:CanWearMail(class)
    return ClassInfo:CanWearPlate(class) or class == 'HUNTER' or class == 'SHAMAN'
end

function ClassInfo:CanWearLeather(class)
    return ClassInfo:CanWearMail(class) or class == 'DEMONHUNTER' or class == 'DRUID' or class == 'MONK' or class == 'ROGUE'
end

function ClassInfo:CanWearCloth(class)
    return ClassInfo:CanWearLeather(class) or class == 'MAGE' or class == 'PRIEST' or class == 'WARLOCK'
end

addonTable.ClassInfo = ClassInfo
