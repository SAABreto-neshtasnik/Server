local stage = 0
local movingForward = false

Citizen.CreateThread(function()
    while true do
     Citizen.Wait(1)
     if not IsPedSittingInAnyVehicle(PlayerPedId()) then
         if IsControlJustReleased(0, Config.Keys["LEFTCTRL"]) then
             stage = stage + 1
             if stage == 2 then
                 ClearPedTasks(PlayerPedId())
                 RequestAnimSet("move_ped_crouched")
                 while not HasAnimSetLoaded("move_ped_crouched") do
                     Citizen.Wait(0)
                 end
                 SetPedMovementClipset(PlayerPedId(), "move_ped_crouched",1.0)    
                 SetPedWeaponMovementClipset(PlayerPedId(), "move_ped_crouched",1.0)
                 SetPedStrafeClipset(PlayerPedId(), "move_ped_crouched_strafing",1.0)
             elseif stage == 3 then
                 ClearPedTasks(PlayerPedId())
                 RequestAnimSet("move_crawl")
                 while not HasAnimSetLoaded("move_crawl") do
                     Citizen.Wait(0)
                 end
             elseif stage > 3 then
                 stage = 0
                 ClearPedTasks(PlayerPedId())
                 ResetAnimSet()
                 SetPedStealthMovement(PlayerPedId(),0,0)
             end
         end
         if stage == 2 then
             if GetEntitySpeed(PlayerPedId()) > 1.0 then
                 SetPedWeaponMovementClipset(PlayerPedId(), "move_ped_crouched",1.0)
                 SetPedStrafeClipset(PlayerPedId(), "move_ped_crouched_strafing",1.0)
             elseif GetEntitySpeed(PlayerPedId()) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then
                 ResetPedWeaponMovementClipset(PlayerPedId())
                 ResetPedStrafeClipset(PlayerPedId())
             end
         elseif stage == 3 then
             DisableControlAction( 0, 21, true )
             DisableControlAction(1, 140, true)
             DisableControlAction(1, 141, true)
             DisableControlAction(1, 142, true)
             if (IsControlPressed(0, Config.Keys["W"]) and not movingForward) then
                 movingForward = true
                 SetPedMoveAnimsBlendOut(PlayerPedId())
                 local pronepos = GetEntityCoords(PlayerPedId())
                 TaskPlayAnimAdvanced(PlayerPedId(), "move_crawl", "onfront_fwd", pronepos.x, pronepos.y, pronepos.z+0.1, 0.0, 0.0, GetEntityHeading(PlayerPedId()), 100.0, 0.4, 1.0, 7, 2.0, 1, 1) 
                 Citizen.Wait(500)
             elseif (not IsControlPressed(0, Config.Keys["W"]) and movingForward) then
                 local pronepos = GetEntityCoords(PlayerPedId())
                 TaskPlayAnimAdvanced(PlayerPedId(), "move_crawl", "onfront_fwd", pronepos.x, pronepos.y, pronepos.z+0.1, 0.0, 0.0, GetEntityHeading(PlayerPedId()), 100.0, 0.4, 1.0, 6, 2.0, 1, 1)
                 Citizen.Wait(500)
                 movingForward = false
             end
             if IsControlPressed(0, Config.Keys["A"]) then
                 SetEntityHeading(PlayerPedId(),GetEntityHeading(PlayerPedId()) + 1)
             end     
             if IsControlPressed(0, Config.Keys["D"]) then
                 SetEntityHeading(PlayerPedId(),GetEntityHeading(PlayerPedId()) - 1)
             end 
         end
     else
         stage = 0
         Citizen.Wait(1000)
     end
    end
end)

local mp_pointing = false
local keyPressed = false

local function startPointing()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(PlayerPedId(), 0, 1, 1, 1)
    SetPedConfigFlag(PlayerPedId(), 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, PlayerPedId(), "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    Citizen.InvokeNative(0xD01015C7316AE176, PlayerPedId(), "Stop")
    if not IsPedInjured(PlayerPedId()) then
        ClearPedSecondaryTask(PlayerPedId())
    end
    if not IsPedInAnyVehicle(PlayerPedId(), 1) then
        SetPedCurrentWeaponVisible(PlayerPedId(), 1, 1, 1, 1)
    end
    SetPedConfigFlag(PlayerPedId(), 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, Config.Keys["B"]) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, Config.Keys["B"]) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, Config.Keys["B"]) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, Config.Keys["B"]) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, Config.Keys["B"]) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = PlayerPedId()
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end

        Citizen.Wait(0)
    end
end)

RegisterNetEvent('pepe-assets:client:get:tackeled')
AddEventHandler('pepe-assets:client:get:tackeled', function()
 SetPedToRagdoll(PlayerPedId(), math.random(6000, 8000), math.random(6000, 8000), 0, 0, 0, 0) 
end)

function TackleAnim()
 if not Framework.Functions.GetPlayerData().metadata["ishandcuffed"] and not IsPedRagdoll(PlayerPedId()) then
     RequestAnimDict("swimming@first_person@diving")
     while not HasAnimDictLoaded("swimming@first_person@diving") do
         Citizen.Wait(1)
     end
     if IsEntityPlayingAnim(PlayerPedId(), "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
         ClearPedTasks(PlayerPedId())
     else
         TaskPlayAnim(PlayerPedId(), "swimming@first_person@diving", "dive_run_fwd_-45_loop" ,3.0, 3.0, -1, 49, 0, false, false, false)
         Citizen.Wait(250)
         ClearPedTasks(PlayerPedId())
         SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, 0, 0, 0)
     end
 end
end

-- // Functions \\ --
function ResetAnimSet()
  ResetPedMovementClipset(PlayerPedId())
  ResetPedWeaponMovementClipset(PlayerPedId())
  ResetPedStrafeClipset(PlayerPedId())
end

function RequestAnimationDict(AnimDict)
 RequestAnimDict(AnimDict)
 while not HasAnimDictLoaded(AnimDict) do
     Citizen.Wait(1)
 end
end