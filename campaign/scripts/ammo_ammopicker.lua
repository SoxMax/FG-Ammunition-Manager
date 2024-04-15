--
-- Please see the LICENSE.md file included with this distribution for
-- attribution and copyright information.
--

-- luacheck: globals itemsheetaltname itemsheetname

local function isAmmo(nodeItem, sTypeField)
	if sTypeField and DB.getChild(nodeItem, sTypeField) then
		local sItemType = DB.getValue(nodeItem, sTypeField, ''):lower()
		return (sItemType:match('ammunition') ~= nil) or (sItemType:match('ammo') ~= nil)
	end
end

-- luacheck: globals itemsheetname setValue setTooltipText
function onInit()

	if super then
		if super.onInit then super.onInit() end

		local function setListValue_new(sValue)
			setValue(sValue)

			-- save node to weapon node when choosing ammo
			local nodeWeapon = DB.getParent(getDatabaseNode())
			local nodeInventory = DB.getChild(nodeWeapon, '...inventorylist')
			if nodeInventory then
				for _, nodeItem in ipairs(DB.getChildList(nodeInventory)) do
					local sName = ItemManager.getDisplayName(nodeItem, true)
					if sValue == '' then
						DB.setValue(nodeWeapon, 'ammoshortcut', 'windowreference', 'item', '')
					elseif sValue == sName then
						DB.setValue(nodeWeapon, 'ammoshortcut', 'windowreference', 'item', '....inventorylist.' .. DB.getName(nodeItem))
					end
				end
			end

			local nodeOldNode = DB.getChild(nodeWeapon, 'ammopickernode')
			if nodeOldNode then DB.deleteNode(nodeOldNode) end

			setTooltipText(sValue)
			super.refreshSelectionDisplay()
		end

		super.setListValue = setListValue_new
	end

	local aAutoFill = {}
	table.insert(aAutoFill, Interface.getString('none'))

	local nodeInventory = DB.getChild(getDatabaseNode(), '....inventorylist')
	if nodeInventory then
		for _, nodeItem in ipairs(DB.getChildList(nodeInventory)) do
			if DB.getValue(nodeItem, 'carried', 0) ~= 0 then
				local sName = ItemManager.getDisplayName(nodeItem, true)
				if sName ~= '' then
					if isAmmo(nodeItem, itemsheetname[1]) or isAmmo(nodeItem, itemsheetaltname[1]) then table.insert(aAutoFill, sName) end
				end
			end
		end
	end
	super.addItems(aAutoFill)
end
