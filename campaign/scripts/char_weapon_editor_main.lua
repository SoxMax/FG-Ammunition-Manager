--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
-- luacheck: globals onDataChanged
function onDataChanged()
	if super and super.onDataChanged then super.onDataChanged() end
	local nodeWeapon = getDatabaseNode()
	local bRanged = DB.getValue(nodeWeapon, 'type', 0) == 1

	header_ammo.setVisible(bRanged)
	ammopicker.setComboBoxVisible(bRanged)
	label_ammopicker.setVisible(bRanged)
	recoverypercentage.setVisible(bRanged)
	label_recoverypercentage.setVisible(bRanged)
	label_ammopercentof.setVisible(bRanged)
	missedshots.setVisible(bRanged)
	label_missedshots.setVisible(bRanged)
	recoverammo.setVisible(bRanged)

	local nodeAmmoLink = AmmunitionManager.getAmmoNode(nodeWeapon)
	if nodeAmmoLink then
		local nodeAmmoMisses = DB.getChild(nodeAmmoLink, 'missedshots')
		if not nodeAmmoMisses then
			DB.setValue(nodeAmmoLink, 'missedshots', 'number', 0)
			nodeAmmoMisses = DB.getChild(nodeAmmoLink, 'missedshots')
		end
		missedshots.setLink(nodeAmmoMisses, true)
	else
		missedshots.setLink()
	end
end

function onInit()
	if super and super.onInit then super.onInit() end

	local sNode = DB.getPath(getDatabaseNode())
	DB.addHandler(sNode, 'onChildUpdate', onDataChanged)

	onDataChanged()
end

function onClose()
	if super and super.onClose then super.onClose() end

	local sNode = DB.getPath(getDatabaseNode())
	DB.removeHandler(sNode, 'onChildUpdate', onDataChanged)
end
