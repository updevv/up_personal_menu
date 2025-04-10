local UpDev = {}
local openmenu = false

local billsList = {}
local billsInfos = {}

local InteractMenu = {
    helmet = false,
    Visual1 = false,
    Visual2 = false,
    Visual3 = false,
    Visual4 = false,
    Visual5 = false,

    engineActionList = {
        "Allumer",
        "Éteindre",
    },

    maxSpeedList = {
        "50",
        "80",
        "120",
        "130",
        "Désactiver",
    },

    doorsList = {
        "Toutes les portes",
        "Porte avant-gauche",
        "Porte avant-droite",
        "Porte arrière-gauche",
        "Porte arrière-droite",
        "Capot",
        "Coffre"
    },

    maxSpeedListIndex = 1,
    engineActionIndex = 1,
    doorActionIndex = 1,
    doorIndex = 1,
    checkedRadar = true,
    checkedCinematic = false,

    dstLoadIndex = 1,
    dstShadowIndex = 1,

    dstLoad = GetResourceKvpFloat("view_lod"),
    dstShadow = GetResourceKvpFloat("dist_shadow"),
    showBanner = GetResourceKvpInt("banner_active"),


}

local function doorAction(door)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then return end

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local open = (InteractMenu.doorActionIndex == 1)

    if door == -1 then
        for i = 0, 7 do
            if open then
                SetVehicleDoorOpen(veh, i, false, false)
            else
                SetVehicleDoorShut(veh, i, false)
            end
        end
    else
        if open then
            SetVehicleDoorOpen(veh, door, false, false)
        else
            SetVehicleDoorShut(veh, door, false)
        end
    end

    doorCoolDown = true
    SetTimeout(500, function()
        doorCoolDown = false
    end)
end


local function doorState()
	local playerPed = PlayerPedId()
	local GetVehicle = GetVehiclePedIsIn(playerPed, false)
	local GetVehicleDoorLockStatus = GetVehicleDoorLockStatus(GetVehicle)
	if GetVehicleDoorLockStatus == 1 then
		return "~HUD_COLOUR_PM_WEAPONS_PURCHASABLE~Désactiver"
	elseif GetVehicleDoorLockStatus == 2 then
		return "~g~Actif"
	end
end

local function isAllowedToManageVehicle()
    if IsPedInAnyVehicle(PlayerPedId(),false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if doorState() == "~g~Actif" then
			return ESX.ShowNotification("Le véhicule est verrouillé")
		end
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            return true
        end
        return false
    end
    return false
end

local function setCinemaMode(bool)
    local alpha = 0;
    CreateThread(function()
        while InteractMenu.checkedCinematic do
            Wait(0);

            if alpha <= 255 then
                alpha = alpha + 15;
            end

            DrawRect(0.471, 0.0485, 1.065, 0.13, 0, 0, 0, alpha)
            DrawRect(0.503, 0.935, 1.042, 0.13, 0, 0, 0, alpha)
        end

        while alpha > 0 do 
            Wait(0); 
            alpha = alpha - 15;
            DrawRect(0.471, 0.0485, 1.065, 0.13, 0, 0, 0, alpha)
            DrawRect(0.503, 0.935, 1.042, 0.13, 0, 0, 0, alpha)
        end
    end)
end

Keys.Register("F5", "F5", "Menu Interaction", function()
    UpDev.OpenPersonalMenu()
end)

function UpDev.OpenPersonalMenu()
    local menuPrincipal = RageUI.CreateMenu(nil, "Personal Menu", nil, nil, "updev", "header_updev")
    local wallet = RageUI.CreateSubMenu(menuPrincipal, nil, "Portefeuille")
    local infoJob = RageUI.CreateSubMenu(wallet, nil, "Metier")
    local infoCrew = RageUI.CreateSubMenu(wallet, nil, "Crew")
    local bills = RageUI.CreateSubMenu(wallet, nil, "Portefeuille")
    local billsInfo = RageUI.CreateSubMenu(bills, nil, "Factures")
    local VehicleOption = RageUI.CreateSubMenu(menuPrincipal, nil, "Véhicule")
    local visualOption = RageUI.CreateSubMenu(menuPrincipal, nil, "Visuels")
    local visualconfig = RageUI.CreateSubMenu(visualOption, nil, "Visuels")
    local optiMenu = RageUI.CreateSubMenu(visualconfig, nil, "Visuels")
    local carOption = RageUI.CreateSubMenu(visualOption, nil, "Véhicule Option")
    local walksList = RageUI.CreateSubMenu(visualOption, nil, "Marche")

    local keyPadInfo = RageUI.CreateSubMenu(menuPrincipal, nil, "Clavier")

    menuPrincipal.Closed = function()
        openmenu = false
    end

    if openmenu then
        openmenu = false
        RageUI.Visible(menuPrincipal, false)
    else
        openmenu = true
        RageUI.Visible(menuPrincipal, true)

        CreateThread(function()
            while openmenu do
                RageUI.IsVisible(menuPrincipal, function()
                local isInCar = IsPedSittingInAnyVehicle(PlayerPedId())
                local playerData = ESX.GetPlayerData()
                RageUI.Separator(string.format("ID Unique: %s", playerData.unique_id--[[GetPlayerServerId(PlayerId())]]))
                
                RageUI.Line()

                RageUI.Button("Portefeuille", "Votre Portefeuille", {RightLabel = "→"}, true, {}, wallet)
                RageUI.Button("Gestion véhicule", "Actions sur le véhicule", {RightLabel = "→"}, isInCar, {}, VehicleOption)
                RageUI.Button("Préférences", "Définissez vos préférences", {RightLabel = "→"}, true, {}, visualOption)
                RageUI.Button("Guide", nil, {RightLabel = "→"}, true, {}, keyPadInfo)
                          
                end)

                RageUI.IsVisible(wallet, function()

                    RageUI.Separator("Information Compte")

                    local playerData = ESX.GetPlayerData()
                    local bankMoney = playerData.accounts[1] and playerData.accounts[1].money or 0
                    local blackMoney = playerData.accounts[2] and playerData.accounts[3].money or 0
                    local cashMoney = playerData.accounts[3] and playerData.accounts[2].money or 0

                    RageUI.Button(string.format("Argent Propre: ~g~%s~s~ $", cashMoney), nil, { RightLabel = "" }, true, {})
                    RageUI.Button(string.format("Argent en Banque: ~b~%s~s~ $", bankMoney), nil, { RightLabel = "" }, true, {})
                    RageUI.Button(string.format("Argent Sale: ~r~%s~s~ $", blackMoney), nil, { RightLabel = "" }, true, {})

                    RageUI.Separator("Information Personnelles")

                    RageUI.Button("Factures", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback("esx_billing:getBills", function(cb)
                                billsList = cb
                            end)
                        end
                    }, bills)
                                             
                    RageUI.Button("Information Métier", "Accéder aux information de votre métier", {RightLabel = "→"}, true, {onSelected = function() end}, infoJob)
        
                    RageUI.Button("Information Crew", "Accéder aux information de votre crew", {RightLabel = "→"}, true, {onSelected = function() end}, infoCrew)

                end)

                RageUI.IsVisible(infoJob, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    RageUI.Separator(string.format("Votre Métier : ~b~%s~s~", (ESX.PlayerData.job and ESX.PlayerData.job.label) or "undefined"))
                    RageUI.Separator(string.format("Votre Grade : ~b~%s~s~", (ESX.PlayerData.job and ESX.PlayerData.job.grade_label) or "undefined"))
                    RageUI.Line()
                    local isUnemployed = ESX.PlayerData.job.name ~= "unemployed"
                    RageUI.Button("Quitter son Emploie", nil, {RightLabel = "→"}, isUnemployed, {
                        onSelected = function()
                            if lib.inputDialog("Voulez-vous vraiment quittez votre emploi ?", {}) then

                                TriggerServerEvent("UpDev:personnal:quitJob")

                            end
                        end
                    })

                end)
        
                RageUI.IsVisible(infoCrew, function()
                    RageUI.Separator(string.format("Votre Crew : ~b~%s~s~", (ESX.PlayerData.crew and ESX.PlayerData.crew.label) or "undefined"))
                    RageUI.Separator(string.format("Votre Rang : ~b~%s~s~", (ESX.PlayerData.crew and ESX.PlayerData.crew.grade_label) or "undefined"))
                    RageUI.Line()
                    local isNoCrew = ESX.PlayerData.crew.name ~= "nocrew"
                    RageUI.Button("Quitter son Crew", nil, {RightLabel = "→"}, isNoCrew, {
                        onSelected = function()
                            if lib.inputDialog("Voulez-vous vraiment quittez votre crew", {}) then
                                TriggerServerEvent("UpDev:personnal:quitCrew")
                            end 
                        end
                    })

                end)

                RageUI.IsVisible(bills, function()
                    if #billsList == 0 then
                        RageUI.Separator()
                        RageUI.Separator("~r~Vous n'avez aucune Facture")
                        RageUI.Separator()
                    else
                        for i = 1, #billsList do
                            local v = billsList[i]
                            RageUI.Button(v.label, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    billsInfos = v
                                end
                            }, billsInfo)
                        end
                        
                        
                    end
                end)

                RageUI.IsVisible(billsInfo, function()

                    RageUI.Separator("Information Facture")
                    if billsInfos then
                        RageUI.Button(string.format("Facture ID : %s", tostring(billsInfos.id)), nil, {RightLabel = ""}, true, {})
                        RageUI.Button(string.format("Nom de la Facture : %s", tostring(billsInfos.label)), nil, {RightLabel = ""}, true, {})
                        RageUI.Button(string.format("Montant de la Facture : %s$", tostring(billsInfos.amount)), nil, {RightLabel = ""}, true, {})
                        RageUI.Button(string.format("Date de la Facture : %s", tostring(billsInfos.date)), nil, {RightLabel = ""}, true, {})
                        RageUI.Button(string.format("Raison de la Facture : %s", tostring(billsInfos.reason)), nil, {RightLabel = ""}, true, {})

                        RageUI.Line()

                        RageUI.Button("Payer la Facture", nil, {RightLabel = "→"}, true, {
                            onSelected = function()


                                ESX.TriggerServerCallback("esx_billing:payBill", function(success)
                                    if success then
                                        ESX.TriggerServerCallback("esx_billing:getBills", function(cb)
                                            billsList = cb
                                        end)
                                        RageUI.GoBack()
                                    end
                                end, billsInfos.id)
                            end
                        })
                    end
                    
                end)
                
                RageUI.IsVisible(VehicleOption, function()
                    local playerPed = PlayerPedId()
                        
                    if IsPedSittingInAnyVehicle(playerPed) then
                        local GetVehicle = GetVehiclePedIsIn(playerPed, false)

                        local VehicleFuel = (GetVehicleFuelLevel(GetVehicle))
                        local GetVehicleHealth = (GetVehicleEngineHealth(GetVehicle)) / 10
                
                        RageUI.Separator(string.format("Verrouillage centralisé : %s", doorState()))
                        RageUI.Separator(string.format("Carburant : %.2f L", VehicleFuel))
                        RageUI.Separator(string.format("État du moteur : %s %%", GetVehicleHealth))

                
                        RageUI.Line()
                
                        RageUI.List("Action Moteur", InteractMenu.engineActionList, InteractMenu.engineActionIndex, nil, {}, true, {
                            onListChange = function(index)
                                InteractMenu.engineActionIndex = index
                            end,
                
                            onSelected = function(index)
                                if index == 1 then
                                    SetVehicleEngineOn(GetVehicle, true, true, false)
                                else
                                    SetVehicleEngineOn(GetVehicle, false, true, true)
                                end
                            end
                        })
                
                        RageUI.List("Limiteur de vitesse", InteractMenu.maxSpeedList, InteractMenu.maxSpeedListIndex, nil, {}, true, {
                            onListChange = function(index)
                                InteractMenu.maxSpeedListIndex = index
                            end,
                            onSelected = function(index)
                                if index == 1 then
                                    SetVehicleMaxSpeed(GetVehicle, 13.7)
                                elseif index == 2 then
                                    SetVehicleMaxSpeed(GetVehicle, 22.0)
                                elseif index == 3 then
                                    SetVehicleMaxSpeed(GetVehicle, 33.0)
                                elseif index == 4 then
                                    SetVehicleMaxSpeed(GetVehicle, 36.0)
                                elseif index == 5 then
                                    SetVehicleMaxSpeed(GetVehicle, 0.0)
                                end
                            end
                        })
                
                        RageUI.List("Action portes", {"Ouvrir","Fermer"}, InteractMenu.doorActionIndex, nil, {}, true, {
                            onListChange = function(index)
                                InteractMenu.doorActionIndex = index
                            end,
                        })
                
                        RageUI.List("Ouverture", InteractMenu.doorsList, InteractMenu.doorIndex, nil, {}, true, {
                            onListChange = function(index)
                                InteractMenu.doorIndex = index
                            end,
                            onSelected = function(index)
                                if isAllowedToManageVehicle() then
                                    if index == 1 then
                                        doorAction(-1) 
                                    elseif index == 2 then
                                        doorAction(0) 
                                    elseif index == 3 then
                                        doorAction(1) 
                                    elseif index == 4 then
                                        doorAction(2) 
                                    elseif index == 5 then
                                        doorAction(3) 
                                    elseif index == 6 then
                                        doorAction(4) 
                                    elseif index == 7 then
                                        doorAction(5) 
                                    end
                                end
                            end
                        })
                
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Vous devez être dans un véhicule")
                        RageUI.Separator("")
                    end

                end)

                RageUI.IsVisible(visualOption, function()
                    RageUI.Button("Affichage", nil, {RightLabel = "→"}, true, {}, visualconfig)
                    RageUI.Button("Véhicules", nil, {RightLabel = "→"}, true, {}, carOption)
                    RageUI.Button("Démarche", nil, {RightLabel = UpDev.getWalkStyle()}, true, {}, walksList)
                end)

                RageUI.IsVisible(visualconfig, function()
                    RageUI.Button("Visual", nil, {RightLabel = ""}, true, {}, optiMenu)
                    RageUI.Checkbox("Afficher le Radar", nil, InteractMenu.checkedRadar, {}, {
                        onChecked = function()
                            DisplayRadar(true)
                        end,
                        onUnChecked = function()
                            DisplayRadar(false)
                        end,
                        onSelected = function(Index)
                            InteractMenu.checkedRadar = Index;
                        end
                    })
                    RageUI.Checkbox("Mode Cinéma", nil, InteractMenu.checkedCinematic, {}, {
                        onChecked = function()
                            setCinemaMode(InteractMenu.checkedCinematic)
                            DisplayRadar(false)
                            --toggleHud()
                        end,
                        onUnChecked = function()
                            setCinemaMode(InteractMenu.checkedCinematic)
                            DisplayRadar(true)
                            --toggleHud()
                        end,
                        onSelected = function(Index)
                            InteractMenu.checkedCinematic = Index;
                        end
                    })
                end)

                RageUI.IsVisible(optiMenu, function()

                    RageUI.Checkbox("Vue & lumières améliorées", false, InteractMenu.Visual1, {}, {
                        onSelected = function(Index)
                            InteractMenu.Visual1 = Index
                            if Index == true then
                                SetTimecycleModifier("tunnel")
                            elseif Index == false then
                                SetTimecycleModifier("")
                            end
                        end
                    })
                    RageUI.Checkbox("Visual 1 (Boost FPS)", false, InteractMenu.Visual2, {}, {
                        onSelected = function(Index)
                            InteractMenu.Visual2 = Index
                            if Index == true then
                                SetTimecycleModifier("yell_tunnel_nodirect")
                            elseif Index == false then
                                SetTimecycleModifier("")
                            end
                        end
                    })
                    RageUI.Checkbox("Couleurs amplifiées", false, InteractMenu.Visual3, {}, {
                        onSelected = function(Index)
                            InteractMenu.Visual3 = Index
                            if Index == true then
                                SetTimecycleModifier("rply_saturation")
                            elseif Index == false then
                                SetTimecycleModifier("")
                            end
                        end
                    })
                    RageUI.Checkbox("Noir & blancs", false, InteractMenu.Visual4, {}, {
                        onSelected = function(Index)
                            InteractMenu.Visual4 = Index
                            if Index == true then
                                SetTimecycleModifier("rply_saturation_neg")
                            elseif Index == false then
                                SetTimecycleModifier("")
                            end
                        end
                    })
                    RageUI.Checkbox("Dégats", false, InteractMenu.Visual5, {}, {
                        onSelected = function(Index)
                            InteractMenu.Visual5 = Index
                            if Index == true then
                                SetTimecycleModifier("rply_vignette")
                            elseif Index == false then
                                SetTimecycleModifier("")
                            end
                        end
                    })
                
                    RageUI.List("Ombres", {
                        {Name = "Sans", Value = 0.0},
                        {Name = "Normal", Value = 0.5},
                        {Name = "Détaillés", Value = 1.0},
                    }, InteractMenu.dstShadowIndex, nil, {}, true, {
                        onListChange = function(Index, Item)
                            InteractMenu.dstShadowIndex = Index;
                            InteractMenu.dstShadow = Item["Value"]
                            SetResourceKvpFloat("dist_shadow", InteractMenu.dstShadow);
                            CascadeShadowsSetCascadeBoundsScale(InteractMenu.dstShadow);
                        end
                    })

                    RageUI.List("Distance d'affichage", {
                        {Name = "Près", value = 0.5}, 
                        {Name = "Normal", value = 1.0}, 
                        {Name = "Lointaine", value = 190.0}
                    }, InteractMenu.dstLoadIndex, nil, {}, not CheckedThisDst, {
                        onListChange = function(Index, Item)
                            if InteractMenu.dstLoadIndex ~= Index then
                                InteractMenu.dstLoadIndex = Index;
                                SetResourceKvpFloat("view_lod", Item.value)
                                OverrideLodscaleThisFrame(Item.value)
                            end
                        end
                    })

                end)

                RageUI.IsVisible(carOption, function()
                    RageUI.Checkbox("Casque moto", "Activer le fait d'équiper un casque de moto automatiquement", casque, {RighLabel = ""}, { 
                        onChecked = function()
                            casque = true
                            SetPedConfigFlag(PlayerPedId(), 35, true)
                        end,
                        onUnChecked = function()
                            casque = false
                            SetPedConfigFlag(PlayerPedId(), 35, false)
                        end
                    })

                            RageUI.Checkbox("Conduite décontracté moto", "Activer le style de conduite décontracté en moto", moto, {RighLabel = ""}, { 
                        onChecked = function()
                            moto = true
                            SetPedConfigFlag(PlayerPedId(), 424, true)
                        end,
                        onUnChecked = function()
                            moto = false
                            SetPedConfigFlag(PlayerPedId(), 424, false)
                        end
                    })
                end)

                RageUI.IsVisible(walksList, function()
                    for k,v in pairs(Config.Personalmenu.WalkStyle) do 
                        RageUI.Button(("%s"):format(k), nil, {}, true, {
                            onSelected = function()
                                RageUI.GoBack()
                                UpDev.setNewWalkStyle(k)
                                Wait(150)
                                UpDev.ApplyPlayerWalkStyle()
                            end
                        })
                    end
                end)
        
                RageUI.IsVisible(keyPadInfo, function()
                    if #Config.Personalmenu.guids > 0 then
                        for i = 1, #Config.Personalmenu.guids do
                            local v = Config.Personalmenu.guids[i]
                            RageUI.Button(v[1], nil, {LeftBadge = RageUI.BadgeStyle.Star, RightLabel = v[2]}, true, {})
                        end
                    else
                        RageUI.Separator()
                        RageUI.Separator("~r~Aucune information disponible...")
                        RageUI.Separator("~r~Veuillez verrifier votre configuration")
                        RageUI.Separator("~r~Config.Personalmenu.guids")
                        RageUI.Separator()
                    end
                end)                

                Wait(0)
            end
        end)
    end
end

CreateThread(function()
    while not ESX do Wait(1) end

    local value = GetResourceKvpString("preference_walk")

    if value == "move_m@multiplayer" then
        SetResourceKvp("preference_walk", "Defaultmale")
    elseif value == "move_f@multiplayer" then
        SetResourceKvp("preference_walk", "Defaultfemale")
    end

    if value == nil then
        local default = Config.Personalmenu.BasicDefault["male"]

        if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then
            default = Config.Personalmenu.BasicDefault["girl"]
        end
        UpDev.setNewWalkStyle(default)
    else
        UpDev.setNewWalkStyle(value)
    end
end)

function UpDev.setNewWalkStyle(newWalk)
    SetResourceKvp("preference_walk", newWalk)
    return newWalk
end

function UpDev.getWalkStyle()
    return GetResourceKvpString("preference_walk")
end

function UpDev.RequestWalking(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
        
      Wait(1)
    end
end

function UpDev.ApplyPlayerWalkStyle()
    local walkstyle = UpDev.getWalkStyle()
    for k, v in pairs(Config.Personalmenu.WalkStyle) do
        if k == walkstyle then
            UpDev.RequestWalking(v[1])
            SetPedMovementClipset(PlayerPedId(), v[1], 0.2)
            RemoveAnimSet(v[1])
        end
    end
end


CreateThread(function()
    local playerModel = GetEntityModel(PlayerPedId())
	while playerModel == `player_zero` or playerModel == `player_one` or playerModel == `a_m_y_stbla_02` do
		playerModel = GetEntityModel(PlayerPedId())
		Wait(100)
	end
    UpDev.RestoreWalk()
end)

function UpDev.RestoreWalk()
    local name = GetResourceKvpString("preference_walk")

    if name and name ~= "" then
        UpDev.ApplyPlayerWalkStyle()
    else
        ResetPedMovementClipset(PlayerPedId())
    end
end