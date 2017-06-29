----------------------------------------------------
--===================Aurelien=====================--
----------------------------------------------------
------------------------Lua-------------------------

local DrawMarkerShow = false
local DrawBlipTradeShow = true
local camionSortie = false
local vehicle
local ArgentJoueur = 0
local money = 0


-- -900.0, -3002.0, 13.0
-- -800.0, -3002.0, 13.0
-- -1078.0, -3002.0, 13.0

local Price = 35

local Position = {
    -- VOS POINTS ICI
	Compagnie={x=2907.5,y=4380.72,z=49.8561,distance=5},
    Recolet={x=2859.38,y=4603.92,z=47.4724, distance=5},
  traitement={x=2308.96,y=4886.74,z=41.8082, distance=5}, 
    vente={x=1702.53,y=4915.77,z=42.0781, distance=5},
	garage={x=2907.5,y=4380.72,z=49.8561,distance=5},

}

local BlipMine
local BlipTraitement
local BlipVenteMine


function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

local ShowMsgtime = {msg="",time=0}
local weedcount = 0

AddEventHandler("tradeill:cbgetQuantity", function(itemQty)
  weedcount = itemQty
end)

local myjob = 0

RegisterNetEvent("mine:getJobs")
AddEventHandler("mine:getJobs", function(job)
  myjob = job
end)

function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

AddEventHandler("tradeill:cbgetQuantity", function(itemQty)
  qte = 0
  qte = itemQty
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if ShowMsgtime.time ~= 0 then
        drawTxt(ShowMsgtime.msg, 0,1,0.5,0.8,0.6,255,255,255,255)
        ShowMsgtime.time = ShowMsgtime.time - 1
      end
    end
end)

RegisterNetEvent("agri:f_getCash")
AddEventHandler("agri:f_getCash", function(argent)
  ArgentJoueur = argent
end)

Citizen.CreateThread(function()
  while true do
    if(IsInVehicle()) then
      if(IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey("pounder", _r))) then
        carJob = true
        Wait(300000)
      else
        carJob = false
      end
    else
      carJob = false
    end
    Wait(5000)
  end
end)

Citizen.CreateThread(function()
  --Création des blips pour les faire aparaitre et disparaitre --
  if DrawBlipTradeShow then
    SetBlipTrade(426, "~g~Entreprise Halait", 4, Position.Compagnie.x, Position.Compagnie.y, Position.Compagnie.z)
  end

  while true do
    Citizen.Wait(0)
    if DrawMarkerShow then
      DrawMarker(1, Position.Recolet.x, Position.Recolet.y, Position.Recolet.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
      DrawMarker(1, Position.traitement.x, Position.traitement.y, Position.traitement.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
      DrawMarker(1, Position.vente.x, Position.vente.y, Position.vente.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
      DrawMarker(1, Position.Compagnie.x, Position.Compagnie.y, Position.Compagnie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
    end
  end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPos = GetEntityCoords(GetPlayerPed(-1))

		local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.garage.x, Position.garage.y, Position.garage.z, true)
    if not IsInVehicle() then
      if distance < Position.garage.distance then
        if camionSortie == false then
          ShowInfo('~b~Appuyer sur ~g~E~b~ pour obtenir votre camion', 0)
          if IsControlJustPressed(1,38) then
            TriggerServerEvent("poleemploi:getjobs")
            TriggerServerEvent("agri:getCash_s")
            Wait(100)
            if myjob == 14 then
              if ArgentJoueur >= 2000 then
              local car = GetHashKey("mule3")
              RequestModel(car)
              while not HasModelLoaded(car) do
                Wait(1)
              end
              TriggerEvent("agri:getSkin")
			  local plate = math.random(100, 900)
              vehicle =  CreateVehicle(car, Position.garage.x, Position.garage.y, Position.garage.z, 0.0, true, false)
              SetVehicleOnGroundProperly(vehicle)
              SetVehicleNumberPlateText(vehicle, "VIG"..plate.." ")
              SetVehRadioStation(vehicle, "OFF")
              SetVehicleColours(vehicle, 25, 25)
              SetVehicleLivery(vehicle, 4)
              SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
              SetVehicleEngineOn(vehicle, true, false, false)
              SetEntityAsMissionEntity(vehicle, true, true)
              Wait(100)
              Citizen.Wait(1)
              camionSortie = true
              AfficherBlip()
			  TriggerServerEvent("agri:addmoney",(-2000))
			        ShowMsgtime.msg = "Bon courage, n'oubliez pas de ramener le camion une fois terminé!"
              ShowMsgtime.time = 300
            else
              ShowMsgtime.msg = "Vous n'avez pas assez d'argent, il vous faut 2000$ pour récupérer le camion"
              ShowMsgtime.time = 300
			  end
            else
              ShowMsgtime.msg = '~r~ Vous devez être Agriculteur !'
              ShowMsgtime.time = 150
            end
          end
        else
          ShowInfo('~b~Appuyer sur ~g~E~b~ pour ranger votre camion', 0)
          if IsControlJustPressed(1,38) then
            TriggerServerEvent("poleemploi:getjobs")
            Wait(100)
            if myjob == 14 then
              SetEntityAsMissionEntity(vehicle, true, true)
              Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
              camionSortie = false
              --removeBlip()
			  Wait(100)
			  TriggerServerEvent("agri:addmoney",2000)
			  ShowMsgtime.msg = "~r~ Vous avez été remboursé"
              ShowMsgtime.time = 300
			  money = 0

              TriggerServerEvent("vmenu:lastChar")
            end
          end
        end
      end
    end
		
        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.Recolet.x, Position.Recolet.y, Position.Recolet.z, true)
        if not IsInVehicle() then
          if distanceWeedFarm < Position.Recolet.distance then
		  
             ShowInfo('~b~Appuyer sur ~g~E~b~ pour ramasser le blé', 0)
             if IsControlJustPressed(1,38)  then
				TriggerServerEvent("poleemploi:getjobs")
				 Wait (100)
				if myjob == 14 then	
                  weedcount = 0
                  -- TriggerEvent("player:getQuantity", 4, function(data)
                  --     weedcount = data.count
                  -- end)
                  TriggerEvent("player:getQuantity", 28)
                  Wait(100)
                  Citizen.Wait(1)
                  if weedcount < 30 then
                          ShowMsgtime.msg = 'Ramassage du ~b~blé...'
                          ShowMsgtime.time = 250
                          TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                          Wait(2500)
                          ShowMsgtime.msg = '~g~ + 1 ~b~Blé'
                          ShowMsgtime.time = 150
                          TriggerEvent("player:receiveItem", 28, 1)
                  else
                          ShowMsgtime.msg = '~r~ Inventaire plein !'
                          ShowMsgtime.time = 150
                  end
				else
            ShowMsgtime.msg = '~r~ Vous devez être Agriculteur !'
            ShowMsgtime.time = 150
				end
			end
          end
        end

        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.traitement.x, Position.traitement.y, Position.traitement.z, true)
        if not IsInVehicle() then
          if distanceWeedFarm < Position.traitement.distance then
             ShowInfo('~b~Appuyez sur ~g~E~b~ pour traiter le ~b~blé', 0)
             if IsControlJustPressed(1,38) then
			 TriggerServerEvent("poleemploi:getjobs")
				Wait (100)
				if myjob == 14 then	
                  --weedcount = 0
                   TriggerEvent("player:getQuantity", 28, function(data)
                       weedcount = data.count
                  end)
                 -- TriggerEvent("player:getQuantity", 30)
                  Wait(100)
                  if weedcount > 0 then
                          ShowMsgtime.msg = '~g~ Traitement du ~b~blé...'
                          ShowMsgtime.time = 250
                          TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                          Wait(2500)
                          ShowMsgtime.msg = '~g~ + 1 ~b~Pain'
                          ShowMsgtime.time = 150

                          TriggerEvent("player:looseItem", 28, 1)
                          TriggerEvent("player:receiveItem", 29, 1)
                  else
                          ShowMsgtime.msg = "~r~ Vous n'avez plus de Blé !"
                          ShowMsgtime.time = 150
                  end
				 else
            ShowMsgtime.msg = '~r~ Vous devez être Vigneron !'
            ShowMsgtime.time = 150
				end 
             end
           end
        end

        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.vente.x, Position.vente.y, Position.vente.z, true)
        if not IsInVehicle() then
          if distanceWeedFarm < Position.vente.distance then
             ShowInfo('~b~ Appuyer sur ~g~E~b~ pour vendre le pain', 0)
             if IsControlJustPressed(1,38) then
				TriggerServerEvent("poleemploi:getjobs")
				Wait (100)
				if myjob == 14 then	
                  weedcount = 0
                  -- TriggerEvent("player:getQuantity", 5, function(data)
                  --         weedcount = data.count
                  -- end)
                  TriggerEvent("player:getQuantity", 29)
                  Wait(100)
                  if weedcount ~= 0 then
                          ShowMsgtime.msg = '~g~Vente du ~b~pain...'
                          ShowMsgtime.time = 250
                          TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                          Wait(2500)
                          ShowMsgtime.msg = '~g~ +'.. Price ..'$'
                          ShowMsgtime.time = 150
                          TriggerEvent("inventory:sell",0, 1, 29, Price, "")
                  else
                          ShowMsgtime.msg = "~r~ Vous n'avez plus de Pain !"
                          ShowMsgtime.time = 150
                  end
				 else
            ShowMsgtime.msg = '~r~ Vous devez être Agriculteur !'
            ShowMsgtime.time = 150
				end  
             end
           end
        end

    end
end)

function AfficherBlip()

  BlipMine = AddBlipForCoord(Position.Recolet.x, Position.Recolet.y, Position.Recolet.z)

  SetBlipSprite(BlipMine, 17)
  SetBlipColour(BlipMine, 4)
  SetBlipAsShortRange(BlipMine, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Ramassage du blé')
  EndTextCommandSetBlipName(BlipMine)

  BlipTraitement = AddBlipForCoord(Position.traitement.x, Position.traitement.y, Position.traitement.z)

  SetBlipSprite(BlipTraitement, 18)
  SetBlipColour(BlipTraitement, 4)
  SetBlipAsShortRange(BlipTraitement, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Traitement du blé')
  EndTextCommandSetBlipName(BlipTraitement)

  BlipVenteMine = AddBlipForCoord(Position.vente.x, Position.vente.y, Position.vente.z)

  SetBlipSprite(BlipVenteMine, 19)
  SetBlipColour(BlipVenteMine, 4)
  SetBlipAsShortRange(BlipVenteMine, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Vente du pain')
  EndTextCommandSetBlipName(BlipVenteMine)

end

function removeBlip()
  RemoveBlip(BlipVenteMine)
  RemoveBlip(BlipTraitement)
  RemoveBlip(BlipMine)
end

function SetBlipTrade(id, text, color, x, y, z)
  local Blip = AddBlipForCoord(x, y, z)

  SetBlipSprite(Blip, id)
  SetBlipColour(Blip, color)
  SetBlipAsShortRange(Blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(text)
  EndTextCommandSetBlipName(Blip)
end

RegisterNetEvent('agri:getSkin')	
	AddEventHandler('agri:getSkin', function (source)
		local hashSkin = GetHashKey("mp_m_freemode_01")
		Citizen.CreateThread(function()
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
			SetPedComponentVariation(GetPlayerPed(-1), 11, 97, 0, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 62, 1, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 6, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)   -- under skin
			SetPedPropIndex(GetPlayerPed(-1), 0, 20, 0, 2) 
		else	
			SetPedComponentVariation(GetPlayerPed(-1), 11, 37, 4, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 6, 0, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 62, 0, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 38, 1, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)   -- under skin
		end
		end)
		--TriggerServerEvent("skin_customization:SpawnPlayer")
		--RemoveAllPedWeapons(GetPlayerPed(-1), true)
	end)
