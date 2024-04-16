--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

--	luacheck: globals getShortcutNode
function getShortcutNode(node, shortcutName)
	shortcutName = shortcutName or 'shortcut'
	local _, sRecord = DB.getValue(node, shortcutName, '')
	if sRecord and sRecord ~= '' then return DB.findNode(sRecord) end
end

-- luacheck: globals parseWeaponCapacity
function parseWeaponCapacity(capacity)
	capacity = capacity:lower()
	if capacity == 'drawn' then
		return 0, capacity
	end
	local splitCapacity = StringManager.splitWords(capacity)
	return tonumber(splitCapacity[1]) or 20, splitCapacity[2] or 'charges'
end

---	This function finds the correct node for a weapon's ammunition.
--	It first checks for a path saved in ammoshortcut. If found, databasenode record is returned.
--	If no path is found, it checks to see if the ammo name is known.
--	If ammo name is available, it searches through the inventory for a match.
--	If found, databasenode record is returned.
--	If no match is found, nothing is returned.
--	luacheck: globals getAmmoNode
function getAmmoNode(nodeWeapon)
	-- check for saved ammoshortcut windowreference and return if found
	local ammoNode = getShortcutNode(nodeWeapon, 'ammoshortcut')
	if ammoNode then return ammoNode end

	-- if ammoshortcut does not provide a good node and weapon is ranged, try searching the inventory.
	local bRanged = DB.getValue(nodeWeapon, 'type', 0) == 1
	if not bRanged then return end

	local sAmmo = DB.getValue(nodeWeapon, 'ammopicker', '')
	if sAmmo == '' then return end

	Debug.console(Interface.getString('debug_ammo_noammoshortcutfound'))

	local nodeInventory = DB.getChild(nodeWeapon, '...inventorylist')
	if DB.getName(nodeInventory) ~= 'inventorylist' then
		Debug.console(Interface.getString('debug_ammo_noinventoryfound'))
		return
	end
	for _, nodeItem in ipairs(DB.getChildList(nodeInventory)) do
		local sItemName
		if ItemManager.getIDState(nodeItem) then
			sItemName = DB.getValue(nodeItem, 'name', '')
		else
			sItemName = DB.getValue(nodeItem, 'nonid_name', '')
		end
		if sItemName == sAmmo then return nodeItem end
	end
	Debug.console(Interface.getString('debug_ammo_itemnotfound'))
end

--	luacheck: globals getWeaponName
function getWeaponName(s)
	local sWeaponName = s:gsub('%[ATTACK%s#?%d*%s?%(%u%)%]', '')
	sWeaponName = sWeaponName:gsub('%[%u+%]', '')
	if sWeaponName:match('%[USING ') then sWeaponName = sWeaponName:match('%[USING (.-)%]') end
	sWeaponName = sWeaponName:gsub('%[.+%]', '')
	sWeaponName = sWeaponName:gsub(' %(vs%. .+%)', '')
	sWeaponName = StringManager.trim(sWeaponName)

	return sWeaponName or ''
end

--	luacheck: globals getAmmoRemaining
function getAmmoRemaining(rSource, nodeWeapon, nodeAmmoLink)
	local function isInfiniteAmmo()
		local bInfiniteAmmo = DB.getValue(nodeWeapon, 'type', 0) ~= 1
		return bInfiniteAmmo or EffectManager.hasCondition(rSource, 'INFAMMO')
	end

	local bInfiniteAmmo = isInfiniteAmmo()

	local nAmmo = 0
	if not bInfiniteAmmo then
		if nodeAmmoLink then
			nAmmo = DB.getValue(nodeAmmoLink, 'count', 0)
		else
			local nMaxAmmo = DB.getValue(nodeWeapon, 'maxammo', 0)
			local nAmmoUsed = DB.getValue(nodeWeapon, 'ammo', 0)
			nAmmo = nMaxAmmo - nAmmoUsed
			if nMaxAmmo == 0 then bInfiniteAmmo = true end
		end
	end
	return nAmmo, bInfiniteAmmo
end

-- luacheck: globals getWeaponUsage
function getWeaponUsage(attackNode)
	local nodeLinkedWeapon = AmmunitionManager.getShortcutNode(attackNode, 'shortcut')
	if nodeLinkedWeapon then return tonumber(DB.getValue(nodeLinkedWeapon, 'usage', 1)) or 1 end
	return 1
end

-- luacheck: globals useAmmoStarfinder
function useAmmoStarfinder(rSource, rRoll)
	local attackNode
	if rRoll.sAttackNode then attackNode = DB.findNode(rRoll.sAttackNode) end
	if attackNode and DB.getValue(attackNode, 'type', 0) == 1 then -- ranged attack
		local ammoNode = AmmunitionManager.getAmmoNode(attackNode)
		local nAmmoCount, bInfiniteAmmo = AmmunitionManager.getAmmoRemaining(rSource, attackNode, ammoNode)
		if bInfiniteAmmo then return end
		local weaponUsage = AmmunitionManager.getWeaponUsage(attackNode)
		local remainingAmmo = nAmmoCount - weaponUsage
		DB.setValue(ammoNode, 'count', 'number', remainingAmmo)
		if remainingAmmo <= 0 then
			local attackName = DB.getValue(attackNode, 'name', '')
			local messageText = string.format(Interface.getString('char_actions_usedallammo'), attackName)
			local messagedata = { text = messageText, sender = ActorManager.resolveActor(DB.getChild(attackNode, '...')).sName, font = 'emotefont' }
			Comm.deliverChatMessage(messagedata)
		end
	end
end

-- Function Overrides

local onPostAttackResolve_old
local function onPostAttackResolve_new(rSource, rTarget, rRoll, rMessage, ...)
	onPostAttackResolve_old(rSource, rTarget, rRoll, rMessage, ...)
	AmmunitionManager.useAmmoStarfinder(rSource, rRoll)
end

function onInit()
	onPostAttackResolve_old = ActionAttack.onPostAttackResolve
	ActionAttack.onPostAttackResolve = onPostAttackResolve_new
end
