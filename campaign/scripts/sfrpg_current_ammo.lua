--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

--	luacheck: globals onDoubleClick
function onDoubleClick()
	if not window.isAmmoAutolinkable() then
		Interface.openWindow('char_weapon_reload', window.getDatabaseNode())
		return true
	end
	return false
end
