CreateThread(function()

	exports.qtarget:AddBoxZone("MissionRowDutyClipboard", vector3(441.7989, -982.0529, 30.67834), 0.45, 0.35, {
		name="MissionRowDutyClipboard",
		heading=11.0,
		debugPoly=true,
		minZ=30.77834,
		maxZ=30.87834,
		}, {
			options = {
				{
					event = "qrp_duty:goOnDuty",
					icon = "fas fa-sign-in-alt",
					label = "Sign In",
					job = "police",
				},
				{
					event = "qrp_duty:goOffDuty",
					icon = "fas fa-sign-out-alt",
					label = "Sign Out",
					job = "police",
				},
			},
			distance = 3.5
	})

end)

RegisterNetEvent('qrp_duty:goOnDuty', function()
    print('pedal')
end)

RegisterNetEvent('qrp_duty:goOffDuty', function()
    print('pedaloff')
end)