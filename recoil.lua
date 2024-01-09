Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DisplayAmmoThisFrame(false)
		local ped = PlayerPedId()
		local status, weapon = GetCurrentPedWeapon(ped, true)
		if status == 1 then
			if IsPedShooting(ped) then
				local myShootingStat = exports['vms_gym']:getSkill('shooting')
				local inVehicle = IsPedInAnyVehicle(ped, false)
				local WeaponCombination = WeaponOptions[weapon]
				if WeaponCombination then
					if WeaponCombination.shake then
						ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 
							myShootingStat < 20.0 and WeaponCombination.shake or
							myShootingStat >= 20.0 and myShootingStat < 50.0 and WeaponCombination.shake/1.2 or
							myShootingStat >= 50.0 and myShootingStat < 70.0 and WeaponCombination.shake/1.5 or
							myShootingStat >= 70.0 and myShootingStat < 90.0 and WeaponCombination.shake/1.7 or
							WeaponCombination.shake/2.0
						)
					end
					if WeaponCombination.recoil and #WeaponCombination.recoil > 0 then
						local i, tv = (inVehicle and 2 or 1), 0
						if GetFollowPedCamViewMode() ~= 4 then
							repeat
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 0.1, 0.2)
								tv = tv + 0.1
								Citizen.Wait(0)
							until tv >= WeaponCombination.recoil[i]
						else
							repeat
								local t = GetRandomFloatInRange(
									myShootingStat < 20.0 and WeaponCombination.recoil[1] or
									myShootingStat >= 20.0 and myShootingStat < 50.0 and WeaponCombination.recoil[1]/1.2 or
									myShootingStat >= 50.0 and myShootingStat < 70.0 and WeaponCombination.recoil[1]/1.5 or
									myShootingStat >= 70.0 and myShootingStat < 90.0 and WeaponCombination.recoil[1]/1.7 or
									WeaponCombination.recoil[1]/2.0, 
									myShootingStat < 20.0 and WeaponCombination.recoil[2] or
									myShootingStat >= 20.0 and myShootingStat < 50.0 and WeaponCombination.recoil[2]/1.2 or
									myShootingStat >= 50.0 and myShootingStat < 70.0 and WeaponCombination.recoil[2]/1.5 or
									myShootingStat >= 70.0 and myShootingStat < 90.0 and WeaponCombination.recoil[2]/1.7 or
									WeaponCombination.recoil[2]/2.0
								)
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + t, (WeaponCombination.recoil[i] > 0.1 and 1.2 or 0.333))
								tv = tv + t
								Citizen.Wait(0)
							until tv >= WeaponCombination.recoil[i]
						end
					end
				end
			end
		end
	end
end)