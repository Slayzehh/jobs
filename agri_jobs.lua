----------------------------------------------------
--===================Aurelien=====================--
----------------------------------------------------
------------------------Lua-------------------------

local DrawMarkerShow = false
local DrawBlipTradeShow = true

-- -900.0, -3002.0, 13.0
-- -800.0, -3002.0, 13.0
-- -1078.0, -3002.0, 13.0

local PrixRoche = 50
local chance = 10
local qte = 0
local camionSortie = false
local vehicle
local money = 0
local carJob = false
local ArgentJoueur = 0
local Position = {
  Compagnie={x=2907.5,y=4380.72,z=49.8561,distance=5},
  SpawnCamion={x=2907.5,y=4380.72,z=49.8561,distance=5},
  Recolet={x=2859.38,y=4603.92,z=47.4724, distance=5},
  traitement={x=2308.96,y=4886.74,z=41.8082, distance=5},
  venteDiams={x=-1041.2098388671875,y=-769.1842651367188,z=18.114465713500977, distance=5},
  vente={x=1702.53,y=4915.77,z=42.0781, distance=5},
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
  DrawText(x, y)
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

local ShowMsgtime = { msg = "", time = 0 }
local roche = 0
local cuivre = 0
local fer = 0
local diams = 0

AddEventHandler("tradeill:cbgetQuantity", function(itemQty)
  qte = 0
  qte = itemQty
end)

local myjob = 0


RegisterNetEvent("mine:f_getCash")
AddEventHandler("mine:f_getCash", function(argent)
  ArgentJoueur = argent
end)

RegisterNetEvent("mine:getJobs")
AddEventHandler("mine:getJobs", function(job)
  myjob = job
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if ShowMsgtime.time ~= 0 then
      drawTxt(ShowMsgtime.msg, 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
      ShowMsgtime.time = ShowMsgtime.time - 1
    end
  end
end)


Citizen.CreateThread(function()
  --Création des blips pour les faire aparaitre et disparaitre --
  if DrawBlipTradeShow then
    SetBlipTrade(426, "Entreprise d'Agriculture", 2, Position.Compagnie.x, Position.Compagnie.y, Position.Compagnie.z)
  end

  while true do
    Citizen.Wait(0)
    if DrawMarkerShow then
      DrawMarker(1, Position.Recolet.x, Position.Recolet.y, Position.Recolet.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
      DrawMarker(1, Position.traitement.x, Position.traitement.y, Position.traitement.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
      DrawMarker(1, Position.vente.x, Position.vente.y, Position.vente.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
      DrawMarker(1, Position.venteDiams.x, Position.venteDiams.y, Position.venteDiams.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
      DrawMarker(1, Position.Compagnie.x, Position.Compagnie.y, Position.Compagnie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    if(IsInVehicle()) then
      if(IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey("Mule3", _r))) then
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
  while true do
    Citizen.Wait(0)
    local playerPos = GetEntityCoords(GetPlayerPed(-1))

    local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.Compagnie.x, Position.Compagnie.y, Position.Compagnie.z, true)
    if not IsInVehicle() then
      if distance < Position.Compagnie.distance then
        if camionSortie == false then
          ShowInfo('~b~Appuyer sur ~g~E~b~ pour obtenir votre camion', 0)
          if IsControlJustPressed(1,38) then
            TriggerServerEvent("poleemploi:getjobs")
            TriggerServerEvent("mine:getCash_s")
            Wait(100)
            if myjob == 14 then
              if ArgentJoueur >= 3000 then
              local car = GetHashKey("Mule3")
              RequestModel(car)
              while not HasModelLoaded(car) do
                Wait(1)
              end
              TriggerEvent("vmenu:JobOutfit", 11, 124)
              vehicle =  CreateVehicle(car, Position.SpawnCamion.x,  Position.SpawnCamion.y,  Position.SpawnCamion.z, 0.0, true, false)
              SetVehicleOnGroundProperly(vehicle)
              SetVehicleNumberPlateText(vehicle, "M15510")
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
			  TriggerServerEvent("mine:addmoney",(-3000))
			        ShowMsgtime.msg = "Allez à la mine et n'oubliez pas de ramener le camion pour être rembourser"
              ShowMsgtime.time = 300
            else
              ShowMsgtime.msg = "Vous n'avez pas assez d'argent, il vous faut 3000$ pour récupérer le camion"
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
              removeBlip()
			  Wait(100)
			  TriggerServerEvent("mine:addmoney",3000)
			  ShowMsgtime.msg = "~r~ Vous avez été remboursé"
              ShowMsgtime.time = 300
			  money = 0

              TriggerServerEvent("vmenu:lastChar")
            end
          end
        end
      end
    end

    local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.Recolet.x, Position.Recolet.y, Position.Recolet.z, true)
    if not IsInVehicle() then
      if distance < Position.Recolet.distance then
        ShowInfo('~b~Appuyez sur ~g~E~b~ pour ramasser le blé', 0)
        if IsControlJustPressed(1, 38) then
          TriggerServerEvent("poleemploi:getjobs")
          Wait(100)
          if myjob == 14 then
            if carJob == true then
              TriggerEvent("player:getQuantity", 28)
              roche = qte
              TriggerEvent("player:getQuantity", 17)
              cuivre = qte
              TriggerEvent("player:getQuantity", 18)
              fer = qte
              TriggerEvent("player:getQuantity", 19)
              diams = qte
              -- TriggerEvent("player:getQuantity", 4, function(data)
              --     weedcount = data.count
              -- end)
              local chance_mat = math.random(chance,1000)
              Wait(100)
              Citizen.Wait(1)
              if (roche+cuivre+fer+diams) < 30 and chance_mat <=1000  then
                ShowMsgtime.msg = 'Ramassage du ~b~blé ~g~en cours...'
                ShowMsgtime.time = 250
                TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                Wait(2500)
                ShowMsgtime.msg = '~g~ + 1 ~b~Blé'
                ShowMsgtime.time = 150
                TriggerEvent("player:receiveItem", 28, 1)
                chance = chance + 1

              else
                ShowMsgtime.msg = '~r~ Inventaire plein, allez au traitement !'
                ShowMsgtime.time = 150
              end
            else
              ShowMsgtime.msg = '~r~ Vous devez avoir été dans le bon véhicule dans les 5 dernières minutes !'
              ShowMsgtime.time = 150
            end
          else
            ShowMsgtime.msg = '~r~ Vous devez être Agriculteur !'
            ShowMsgtime.time = 150
          end
        end
      end
    end
    -------------------------Bloc Pour rajouter un traitement-------------------------------------------
    local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.traitement.x, Position.traitement.y, Position.traitement.z, true)
    if not IsInVehicle() then
      if distance < Position.traitement.distance then
        ShowInfo('~b~Appuyez sur ~g~E~b~ pour traiter le ~b~', 0)
        if IsControlJustPressed(1, 38) then
          TriggerServerEvent("poleemploi:getjobs")
          Wait(100)
          if myjob == 14 then
            if carJob == true then
              TriggerEvent("player:getQuantity", 28)
              roche = qte
              TriggerEvent("player:getQuantity", 17)
              cuivre = qte
              TriggerEvent("player:getQuantity", 18)
              fer = qte
              TriggerEvent("player:getQuantity", 19)
              diams = qte

			  local roche_trait = 0


			  TriggerEvent("player:getQuantity", 29)
              roche_trait = qte
              TriggerEvent("player:getQuantity", 20)
              cuivre_trait = qte
              TriggerEvent("player:getQuantity", 21)
              fer_trait = qte
              TriggerEvent("player:getQuantity", 22)
              diams_trait = qte
              -- TriggerEvent("player:getQuantity", 6, function(data)
              --      weedcount = data.count
              -- end)
              Wait(100)
              if roche ~= 0 and (roche_trait+cuivre_trait+fer_trait+diams_trait) < 30 then
                ShowMsgtime.msg = '~g~ Traitement du ~b~blé'
                ShowMsgtime.time = 250
                TriggerEvent("vmenu:anim" ,"pickup_object", "pickup_low")
                Wait(2500)
                ShowMsgtime.msg = '~g~ + 1 ~b~Pain'
                ShowMsgtime.time = 150

                TriggerEvent("player:looseItem", 28, 1)
                TriggerEvent("player:receiveItem", 29, 1)
              else
                ShowMsgtime.msg = "~r~ Vous n'avez plus aucun blé, allez à l'acheteur !"
                ShowMsgtime.time = 300
              end
            else
              ShowMsgtime.msg = '~r~ Vous devez avoir été dans le bon véhicule dans les 5 dernières minutes !'
              ShowMsgtime.time = 150
            end
          else
            ShowMsgtime.msg = '~r~ Vous devez être Agriculeur !'
            ShowMsgtime.time = 150
          end
        end
      end
    end
    -------------------------Fin Du Bloc Pour rajouter un traitement-------------------------------------------
    local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.vente.x, Position.vente.y, Position.vente.z, true)
    if not IsInVehicle() then
      if distance < Position.vente.distance then
        ShowInfo('~b~ Appuyez sur ~g~E~b~ pour vendre', 0)
        if IsControlJustPressed(1, 38) then
          TriggerServerEvent("poleemploi:getjobs")
          Wait(100)
          if myjob == 14 then
            if carJob == true then
              TriggerEvent("player:getQuantity", 29)
              roche = qte
              TriggerEvent("player:getQuantity", 20)
              cuivre = qte
              TriggerEvent("player:getQuantity", 21)
              fer = qte
              TriggerEvent("player:getQuantity", 22)
              diams = qte
              -- TriggerEvent("player:getQuantity", 7, function(data)
              --         weedcount = data.count
              -- end)
              Wait(100)
              if roche ~= 0 then
                ShowMsgtime.msg = '~g~Vendre le ~b~pain'
                ShowMsgtime.time = 250
                Wait(2500)
                ShowMsgtime.msg = '~g~ 1 Pain vendu'
				        TriggerEvent("inventory:sell",0, 1, 29, PrixRoche, "")
                ShowMsgtime.time = 150
              else
                ShowMsgtime.msg = "~r~ Vous n'avez plus aucun or, allez rendre votre camion pour recevoir votre argent !"
                ShowMsgtime.time = 300
              end
            else
              ShowMsgtime.msg = '~r~ Vous devez avoir été dans le bon véhicule dans les 5 dernières minutes !'
              ShowMsgtime.time = 150
            end
          else
            ShowMsgtime.msg = '~r~ Vous devez être Agriculteur !'
            ShowMsgtime.time = 150
          end
        end
      end
    end


    local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.venteDiams.x, Position.venteDiams.y, Position.venteDiams.z, true)
    if not IsInVehicle() then
      if distance < Position.vente.distance then
        ShowInfo('~b~ Appuyez sur ~g~E~b~ pour vendre', 0)
        if IsControlJustPressed(1, 38) then
          TriggerServerEvent("poleemploi:getjobs")
          Wait(100)
          if myjob == 14 then
            if carJob == true then
              TriggerEvent("player:getQuantity", 22)
              diams = qte
              -- TriggerEvent("player:getQuantity", 7, function(data)
              --         weedcount = data.count
              -- end)
              Wait(100)
              if diams ~= 0 then
                ShowMsgtime.msg = '~g~ Vendre ~b~ du diamant'
                ShowMsgtime.time = 250
                Wait(2500)
                ShowMsgtime.msg = '~g~ 1 diamant vendu + ' .. ' ' .. PrixDiams .. '$'
                ShowMsgtime.time = 150
								        TriggerEvent("inventory:sell",0, 1, 22, PrixDiams, "")
                money = money + PrixDiams
              else
                ShowMsgtime.msg = "~r~ Vous n'avez plus aucun minerai !"
                ShowMsgtime.time = 150
              end
            else
              ShowMsgtime.msg = '~r~ Vous devez avoir été dans le bon véhicule dans les 5 dernières minutes !'
              ShowMsgtime.time = 150
            end
          else
            ShowMsgtime.msg = '~r~ Vous devez être mineur !'
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
  SetBlipColour(BlipMine, 1)
  SetBlipAsShortRange(BlipMine, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Ramassage du blé')
  EndTextCommandSetBlipName(BlipMine)

  BlipTraitement = AddBlipForCoord(Position.traitement.x, Position.traitement.y, Position.traitement.z)

  SetBlipSprite(BlipTraitement, 18)
  SetBlipColour(BlipTraitement, 1)
  SetBlipAsShortRange(BlipTraitement, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Traitement du blé')
  EndTextCommandSetBlipName(BlipTraitement)

  BlipVenteMine = AddBlipForCoord(Position.vente.x, Position.vente.y, Position.vente.z)

  SetBlipSprite(BlipVenteMine, 19)
  SetBlipColour(BlipVenteMine, 1)
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
