local CAM_KNOWN_MECHANICS_SOURCES = {
["Players.<local>.PlayerScripts.CU.Combat"]="oneclick_sources/017_Combat.lua",
["Players.<local>.PlayerScripts.CU.Combat.Main_Combat_Script_Client"]="oneclick_sources/060_Main_Combat_Script_Client.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent"]="core_sources/015_DialogueComponent.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Amount"]="core_sources/058_Amount.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Blacksmith"]="core_sources/066_Blacksmith.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Blacksmith.ListRecipe"]="core_sources/078_ListRecipe.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Blacksmith.MaterialCard"]="core_sources/080_MaterialCard.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Blacksmith.MaterialTile"]="core_sources/081_MaterialTile.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Blacksmith.Recipe"]="core_sources/079_Recipe.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Blacksmith.RefineBadge"]="core_sources/082_RefineBadge.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Blacksmith.TierBadge"]="core_sources/083_TierBadge.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.EvilArtSpinning"]="core_sources/062_EvilArtSpinning.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.EvilArtSpinning.Slots"]="core_sources/073_Slots.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.EvilArtSpinning.Slots.Slot"]="core_sources/086_Slot.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.EvilArtSpinning.SpinBuyComponent"]="core_sources/072_SpinBuyComponent.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.EvilArtSpinning.Spinner"]="core_sources/071_Spinner.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Exchange"]="core_sources/067_Exchange.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Exchange.Row"]="core_sources/085_Row.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Exchange.Tile"]="core_sources/084_Tile.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.PointsCounter"]="core_sources/064_PointsCounter.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Quests"]="core_sources/065_Quests.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Quests.HuntCard"]="core_sources/075_HuntCard.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Quests.Timer"]="core_sources/076_Timer.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Quests.Transition"]="core_sources/077_Transition.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Quests.Types"]="core_sources/074_Types.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Refinement"]="core_sources/061_Refinement.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Sell"]="core_sources/060_Sell.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Shop"]="core_sources/059_Shop.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.SpinsCounter"]="core_sources/063_SpinsCounter.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.DialogueUtility"]="core_sources/038_DialogueUtility.lua",
["ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Option"]="core_sources/039_Option.lua",
["ReplicatedStorage.CAM.Client.Components.Client.InputHandler"]="oneclick_sources/008_InputHandler.lua",
["ReplicatedStorage.CAM.Client.Components.Client.StaminaComponent"]="core_sources/014_StaminaComponent.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.NoneResetting.Menu.Pages.Inventory.ItemEquipepdFrame.EquippedOptions.Toolbar"]="oneclick_sources/011_Toolbar.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.NoneResetting.Menu.Pages.Inventory.ItemEquipepdFrame.EquippedOptions.Toolbar.Slot"]="oneclick_sources/056_Slot.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.CenterBottomContent.Skills"]="oneclick_sources/012_Skills.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.CenterBottomContent.Skills.Skill"]="oneclick_sources/057_Skill.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.CenterBottomContent.Toolbar"]="oneclick_sources/013_Toolbar.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.CenterBottomContent.Toolbar.MasteryItem"]="oneclick_sources/058_MasteryItem.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.CenterBottomContent.Toolbar.Tool"]="oneclick_sources/059_Tool.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.Mobile.Combat"]="oneclick_sources/016_Combat.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.Mobile.Skills"]="oneclick_sources/015_Skills.lua",
["ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.Mobile.Toolbar"]="oneclick_sources/014_Toolbar.lua",
["ReplicatedStorage.CAM.Client.Components.ProximityPrompt.ProximityPromptChooser"]="core_sources/016_ProximityPromptChooser.lua",
["ReplicatedStorage.CAM.Client.Controllers.ChestController"]="core_sources/020_ChestController.lua",
["ReplicatedStorage.CAM.Client.Controllers.ChestController.ChestAnimations"]="core_sources/041_ChestAnimations.lua",
["ReplicatedStorage.CAM.Client.Controllers.ChestController.ChestAssets"]="core_sources/042_ChestAssets.lua",
["ReplicatedStorage.CAM.Client.Controllers.ChestController.ChestSeal"]="core_sources/043_ChestSeal.lua",
["ReplicatedStorage.CAM.Client.Controllers.LootDropController"]="core_sources/021_LootDropController.lua",
["ReplicatedStorage.CAM.Client.Controllers.LootDropController.VisualBinder"]="core_sources/044_VisualBinder.lua",
["ReplicatedStorage.CAM.Client.Controllers.Platform_Handler"]="core_sources/019_Platform_Handler.lua",
["ReplicatedStorage.CAM.Client.Controllers.Skill_Controller"]="oneclick_sources/010_Skill_Controller.lua",
["ReplicatedStorage.CAM.Client.Controllers.Skill_Controller.Settings"]="oneclick_sources/055_Settings.lua",
["ReplicatedStorage.CAM.Client.Controllers.Skills_Provider"]="oneclick_sources/009_Skills_Provider.lua",
["ReplicatedStorage.CAM.Client.Modules.GamePlay.Dash_Handler"]="oneclick_sources/006_Dash_Handler.lua",
["ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue"]="oneclick_sources/000_Dialogue.lua",
["ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue.CrowTasks"]="oneclick_sources/021_CrowTasks.lua",
["ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue.FianlSelection"]="oneclick_sources/019_FianlSelection.lua",
["ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue.MuzanLair"]="oneclick_sources/020_MuzanLair.lua",
["ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue.TextPlusIDs"]="oneclick_sources/018_TextPlusIDs.lua",
["ReplicatedStorage.CAM.Client.Modules.GamePlay.Run_Handler"]="core_sources/012_Run_Handler.lua",
["ReplicatedStorage.CAM.Client.Modules.GamePlay.Run_Handler.RunHandlerSettings"]="core_sources/037_RunHandlerSettings.lua",
["ReplicatedStorage.CAM.Client.Modules.RecommendedQuest"]="oneclick_sources/003_RecommendedQuest.lua",
["ReplicatedStorage.CAM.Global.Character_info_provider"]="core_sources/005_Character_info_provider.lua",
["ReplicatedStorage.CAM.Global.Checker"]="core_sources/002_Checker.lua",
["ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements"]="oneclick_sources/005_ItemRequirements.lua",
["ReplicatedStorage.CAM.Global.Collectibles.Items"]="core_sources/006_Items.lua",
["ReplicatedStorage.CAM.Global.Combat_presets"]="core_sources/003_Combat_presets.lua",
["ReplicatedStorage.CAM.Global.Combat_presets.MorePresets"]="core_sources/025_MorePresets.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver"]="core_sources/008_PlayerStatResolver.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.Accessory"]="core_sources/046_Accessory.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.ActiveTool"]="core_sources/047_ActiveTool.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.Clan"]="core_sources/054_Clan.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.Mastery"]="core_sources/048_Mastery.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.NpcStats"]="core_sources/055_NpcStats.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.PerformanceStats"]="core_sources/049_PerformanceStats.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.Power"]="core_sources/056_Power.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.Progression"]="core_sources/057_Progression.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.SkillTree"]="core_sources/050_SkillTree.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.Titles"]="core_sources/053_Titles.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.ToolbarEquipped"]="core_sources/051_ToolbarEquipped.lua",
["ReplicatedStorage.CAM.Global.PlayerStatResolver.Solvers.ValueFolder"]="core_sources/052_ValueFolder.lua",
["ReplicatedStorage.CAM.Global.Shop"]="oneclick_sources/007_Shop.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Demon Horns"]="oneclick_sources/064_Demon_Horns.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Gamepass"]="oneclick_sources/063_Gamepass.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Golden Fish"]="oneclick_sources/065_Golden_Fish.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Metal Scraps"]="oneclick_sources/067_Metal_Scraps.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Mythic Refinement Ore"]="oneclick_sources/066_Mythic_Refinement_Ore.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Product"]="oneclick_sources/062_Product.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Refinement Ore"]="oneclick_sources/069_Refinement_Ore.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.RunPoints"]="oneclick_sources/071_RunPoints.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Silk Thread"]="oneclick_sources/068_Silk_Thread.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Spins"]="oneclick_sources/070_Spins.lua",
["ReplicatedStorage.CAM.Global.Shop.Cashiers.Wen"]="oneclick_sources/061_Wen.lua",
["ReplicatedStorage.CAM.Global.Shop.Content.Clans.Clans"]="oneclick_sources/080_Clans.lua",
["ReplicatedStorage.CAM.Global.Shop.Content.Evil Art Orbs.Evil Art Orbs"]="oneclick_sources/078_Evil_Art_Orbs.lua",
["ReplicatedStorage.CAM.Global.Shop.Content.Gamepasses.Gamepasses"]="oneclick_sources/081_Gamepasses.lua",
["ReplicatedStorage.CAM.Global.Shop.Content.ShopSettings.ShopSettings"]="oneclick_sources/079_ShopSettings.lua",
["ReplicatedStorage.CAM.Global.Shop.Content.Spins.Spins"]="oneclick_sources/077_Spins.lua",
["ReplicatedStorage.CAM.Global.Shop.OrderProcessers.Clan"]="oneclick_sources/075_Clan.lua",
["ReplicatedStorage.CAM.Global.Shop.OrderProcessers.Grant"]="oneclick_sources/076_Grant.lua",
["ReplicatedStorage.CAM.Global.Shop.OrderProcessers.Item"]="oneclick_sources/072_Item.lua",
["ReplicatedStorage.CAM.Global.Shop.OrderProcessers.Product"]="oneclick_sources/074_Product.lua",
["ReplicatedStorage.CAM.Global.Shop.OrderProcessers.Spins"]="oneclick_sources/073_Spins.lua",
["ReplicatedStorage.CAM.Global.SkillService.GetMasteryStatus"]="core_sources/023_GetMasteryStatus.lua",
["ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder"]="core_sources/024_SkillTreeholder.lua",
["ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder.Requirements.Boss"]="core_sources/068_Boss.lua",
["ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder.Requirements.Mastery"]="core_sources/069_Mastery.lua",
["ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder.Requirements.SkillPoints"]="core_sources/070_SkillPoints.lua",
["ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder.SkillTreeConfig"]="core_sources/045_SkillTreeConfig.lua",
["ReplicatedStorage.CAM.Global.SkillService.Stats"]="core_sources/022_Stats.lua",
["ReplicatedStorage.CAM.Global.Skills_Module"]="core_sources/007_Skills_Module.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel"]="core_sources/010_ManuelCancel.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests"]="oneclick_sources/002_Quests.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.AcceptCost"]="oneclick_sources/028_AcceptCost.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.BossHunts"]="oneclick_sources/031_BossHunts.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.CollectState"]="oneclick_sources/024_CollectState.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.DeliverAction"]="oneclick_sources/025_DeliverAction.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.DepositState"]="oneclick_sources/026_DepositState.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.EscortState"]="oneclick_sources/027_EscortState.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.EvilArtCores"]="oneclick_sources/030_EvilArtCores.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.PickupState"]="oneclick_sources/023_PickupState.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.RewardsStyling"]="oneclick_sources/022_RewardsStyling.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.UnderwaterRocksState"]="oneclick_sources/029_UnderwaterRocksState.lua",
["ReplicatedStorage.CAM.Global.Subsets.Gameplay.ToolbarItemRestrictions"]="oneclick_sources/004_ToolbarItemRestrictions.lua",
["ReplicatedStorage.CAM.Global.Utility"]="core_sources/004_Utility.lua",
["ReplicatedStorage.CAM.Global.Utility.find_character_from_descendant"]="core_sources/026_find_character_from_descendant.lua",
["ReplicatedStorage.CAM.Global.gameSettings"]="world_sources/000_gameSettings.lua",
["ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent"]="core_sources/000_SignalEvent.lua",
["ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction"]="core_sources/001_SignalFunction.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove"]="world_sources/002_Bamboo_Grove.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Bear Cub"]="world_sources/033_Bear_Cub.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Hoyuzo"]="world_sources/035_Hoyuzo.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Hoyuzo Subordinate"]="world_sources/034_Hoyuzo_Subordinate.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Kaiden"]="world_sources/037_Kaiden.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Kaiden Subordinate"]="world_sources/036_Kaiden_Subordinate.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Mother Bear"]="world_sources/038_Mother_Bear.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Functions.LivActions"]="world_sources/176_LivActions.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Functions.QuestActions"]="world_sources/177_QuestActions.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Betty"]="world_sources/173_Betty.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Chaka"]="world_sources/172_Chaka.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Liv"]="world_sources/175_Liv.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Tom"]="world_sources/171_Tom.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Wagwan"]="world_sources/174_Wagwan.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Yap.Betty"]="world_sources/167_Betty.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Yap.Chaka"]="world_sources/166_Chaka.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Yap.Kuro"]="world_sources/169_Kuro.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Yap.Liv"]="world_sources/170_Liv.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Yap.Tom"]="world_sources/165_Tom.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Yap.Wagwan"]="world_sources/168_Wagwan.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcShared.BearSettings"]="world_sources/032_BearSettings.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.Npcs.Bamboo Grove Sanctuary.Liv"]="world_sources/135_Liv.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.Npcs.Betty"]="world_sources/029_Betty.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.Npcs.Chaka"]="world_sources/028_Chaka.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.Npcs.Kuro"]="world_sources/031_Kuro.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.Npcs.Tom"]="world_sources/027_Tom.lua",
["ReplicatedStorage.Ouwland.Content.Bamboo Grove.Npcs.Wagwan"]="world_sources/030_Wagwan.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate"]="world_sources/006_Butterfly_Estate.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.ActiveNpcs.Veilfall Cavern.Greater Demon"]="world_sources/141_Greater_Demon.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.ActiveNpcs.Veilfall Cavern.Lesser Demon"]="world_sources/142_Lesser_Demon.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Functions.InfirmaryActions"]="world_sources/244_InfirmaryActions.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Functions.RenActions"]="world_sources/245_RenActions.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Functions.WarFansActions"]="world_sources/246_WarFansActions.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Quests.Ren"]="world_sources/241_Ren.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Quests.Shiori"]="world_sources/240_Shiori.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Quests.Veilfall Cavern.Demon Slayer Goro"]="world_sources/261_Demon_Slayer_Goro.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Yap.Ren"]="world_sources/243_Ren.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Yap.Shiori"]="world_sources/242_Shiori.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Yap.Veilfall Cavern.Demon Slayer Goro"]="world_sources/262_Demon_Slayer_Goro.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcShared.GreaterDemonSettings"]="world_sources/116_GreaterDemonSettings.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcShared.LesserDemonSettings"]="world_sources/115_LesserDemonSettings.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.Npcs.Ren"]="world_sources/114_Ren.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.Npcs.Shiori"]="world_sources/113_Shiori.lua",
["ReplicatedStorage.Ouwland.Content.Butterfly Estate.Npcs.Veilfall Cavern.Demon Slayer Goro"]="world_sources/140_Demon_Slayer_Goro.lua",
["ReplicatedStorage.Ouwland.Content.Final Selection Plains"]="world_sources/008_Final_Selection_Plains.lua",
["ReplicatedStorage.Ouwland.Content.Final Selection Plains.ActiveNpcs.Fujiko"]="world_sources/134_Fujiko.lua",
["ReplicatedStorage.Ouwland.Content.Final Selection Plains.ActiveNpcs.The White Terror Lair.Mizunoe Demon Slayer"]="world_sources/147_Mizunoe_Demon_Slayer.lua",
["ReplicatedStorage.Ouwland.Content.Final Selection Plains.NpcContents.Dialogues.Quests.The White Terror Lair.Demon Mokuro"]="world_sources/269_Demon_Mokuro.lua",
["ReplicatedStorage.Ouwland.Content.Final Selection Plains.NpcContents.Dialogues.Yap.The White Terror Lair.Demon Mokuro"]="world_sources/270_Demon_Mokuro.lua",
["ReplicatedStorage.Ouwland.Content.Final Selection Plains.NpcShared.MizunoeDemonSlayerSettings"]="world_sources/133_MizunoeDemonSlayerSettings.lua",
["ReplicatedStorage.Ouwland.Content.Final Selection Plains.Npcs.The White Terror Lair.Demon Mokuro"]="world_sources/146_Demon_Mokuro.lua",
["ReplicatedStorage.Ouwland.Content.Final Selection Plains.Npcs.UbuSister1"]="world_sources/131_UbuSister1.lua",
["ReplicatedStorage.Ouwland.Content.Final Selection Plains.Npcs.UbuSister2"]="world_sources/132_UbuSister2.lua",
["ReplicatedStorage.Ouwland.Content.Forgotten Ruins"]="world_sources/011_Forgotten_Ruins.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village"]="world_sources/004_Hidden_Mist_Village.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.NpcContents.Dialogues.Functions.MaterialExchangeActions"]="world_sources/202_MaterialExchangeActions.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.NpcContents.Dialogues.Functions.SeriesCapstoneActions"]="world_sources/201_SeriesCapstoneActions.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.NpcContents.Dialogues.Functions.StatueActions"]="world_sources/200_StatueActions.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.NpcContents.Dialogues.Quests.Blacksmith Togane"]="world_sources/203_Blacksmith_Togane.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.NpcContents.Dialogues.Yap.Baitmonger Nori"]="world_sources/195_Baitmonger_Nori.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.NpcContents.Dialogues.Yap.Blacksmith Togane"]="world_sources/197_Blacksmith_Togane.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.NpcContents.Dialogues.Yap.Refiner Hagane"]="world_sources/196_Refiner_Hagane.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.NpcContents.Dialogues.Yap.Stonemason Tobei"]="world_sources/199_Stonemason_Tobei.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.NpcContents.Dialogues.Yap.Yagane"]="world_sources/198_Yagane.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.Npcs.Baitmonger Nori"]="world_sources/055_Baitmonger_Nori.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.Npcs.Blacksmith Togane"]="world_sources/057_Blacksmith_Togane.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.Npcs.Refiner Hagane"]="world_sources/056_Refiner_Hagane.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.Npcs.Stonemason Tobei"]="world_sources/059_Stonemason_Tobei.lua",
["ReplicatedStorage.Ouwland.Content.Hidden Mist Village.Npcs.Yagane"]="world_sources/058_Yagane.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley"]="world_sources/007_Iceveil_Valley.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.ActiveNpcs.Fire Profound Demon"]="world_sources/127_Fire_Profound_Demon.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.ActiveNpcs.High Demon"]="world_sources/128_High_Demon.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.ActiveNpcs.Ice Profound Demon"]="world_sources/129_Ice_Profound_Demon.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.ActiveNpcs.Kanoe Demon Slayer"]="world_sources/130_Kanoe_Demon_Slayer.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Functions.FoxfireActions"]="world_sources/254_FoxfireActions.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Functions.Iceveil Settlement.GateActions"]="world_sources/268_GateActions.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Functions.WarFansActions"]="world_sources/255_WarFansActions.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Quests.Demon Delroy"]="world_sources/253_Demon_Delroy.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Quests.Demon Slayer Mitsu"]="world_sources/252_Demon_Slayer_Mitsu.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Quests.Iceveil Settlement.Iceveil Guard Shiro"]="world_sources/266_Iceveil_Guard_Shiro.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Quests.Iceveil Settlement.Shrine Messenger Akio"]="world_sources/267_Shrine_Messenger_Akio.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Quests.Wounded Slayer Tomoi"]="world_sources/251_Wounded_Slayer_Tomoi.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Yap.Demon Delroy"]="world_sources/250_Demon_Delroy.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Yap.Demon Slayer Mitsu"]="world_sources/249_Demon_Slayer_Mitsu.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Yap.Iceveil Settlement.Iceveil Guard Shiro"]="world_sources/263_Iceveil_Guard_Shiro.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Yap.Iceveil Settlement.Shrine Messenger Akio"]="world_sources/264_Shrine_Messenger_Akio.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Yap.Iceveil Settlement.Winter Store Rep Lynx"]="world_sources/265_Winter_Store_Rep_Lynx.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Yap.Old Trapper Retsu"]="world_sources/247_Old_Trapper_Retsu.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Yap.Wounded Slayer Tomoi"]="world_sources/248_Wounded_Slayer_Tomoi.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcShared.FireProfoundDemonSettings"]="world_sources/125_FireProfoundDemonSettings.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcShared.HighDemonSettings"]="world_sources/123_HighDemonSettings.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcShared.IceProfoundDemonSettings"]="world_sources/124_IceProfoundDemonSettings.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcShared.KanoeDemonSlayerSettings"]="world_sources/126_KanoeDemonSlayerSettings.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.Npcs.Chest Mounds"]="world_sources/122_Chest_Mounds.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.Npcs.Demon Delroy"]="world_sources/120_Demon_Delroy.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.Npcs.Demon Slayer Mitsu"]="world_sources/119_Demon_Slayer_Mitsu.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.Npcs.Foxfire"]="world_sources/121_Foxfire.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.Npcs.Iceveil Settlement.Iceveil Guard Shiro"]="world_sources/143_Iceveil_Guard_Shiro.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.Npcs.Iceveil Settlement.Shrine Messenger Akio"]="world_sources/144_Shrine_Messenger_Akio.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.Npcs.Iceveil Settlement.Winter Store Rep Lynx"]="world_sources/145_Winter_Store_Rep_Lynx.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.Npcs.Old Trapper Retsu"]="world_sources/117_Old_Trapper_Retsu.lua",
["ReplicatedStorage.Ouwland.Content.Iceveil Valley.Npcs.Wounded Slayer Tomoi"]="world_sources/118_Wounded_Slayer_Tomoi.lua",
["ReplicatedStorage.Ouwland.Content.Misc"]="world_sources/005_Misc.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Akazo"]="world_sources/085_Akazo.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Datai"]="world_sources/086_Datai.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Domae"]="world_sources/087_Domae.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Enru"]="world_sources/088_Enru.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Flame Trainee"]="world_sources/089_Flame_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Giyen"]="world_sources/090_Giyen.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Gyorei"]="world_sources/091_Gyorei.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Gyutai"]="world_sources/092_Gyutai.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Insect Trainee"]="world_sources/093_Insect_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Nezura"]="world_sources/094_Nezura.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Obari"]="world_sources/095_Obari.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Reaper"]="world_sources/097_Reaper.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Reaper Trainee"]="world_sources/096_Reaper_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Rengu"]="world_sources/098_Rengu.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Saneri"]="world_sources/099_Saneri.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Serpent Trainee"]="world_sources/100_Serpent_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Shinora"]="world_sources/101_Shinora.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Soryu Trainee"]="world_sources/102_Soryu_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Sound Trainee"]="world_sources/103_Sound_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Stone Trainee"]="world_sources/104_Stone_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Sumari"]="world_sources/105_Sumari.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Tai Chi Trainee"]="world_sources/106_Tai_Chi_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Tengai"]="world_sources/107_Tengai.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Thunder Trainee"]="world_sources/108_Thunder_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Water Trainee"]="world_sources/109_Water_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Wind Trainee"]="world_sources/110_Wind_Trainee.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Yahari"]="world_sources/111_Yahari.lua",
["ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Zentaro"]="world_sources/112_Zentaro.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Functions.CleaverDuelActions"]="world_sources/207_CleaverDuelActions.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Functions.MuzanActions"]="world_sources/204_MuzanActions.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Functions.SeriesTradeActions"]="world_sources/206_SeriesTradeActions.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Functions.StyleTrialActions"]="world_sources/205_StyleTrialActions.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Boss Hunts"]="world_sources/221_Boss_Hunts.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Evil Art Cores"]="world_sources/217_Evil_Art_Cores.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Flame Trainer"]="world_sources/209_Flame_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Harvester of Souls Zurinyz"]="world_sources/220_Harvester_of_Souls_Zurinyz.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Insect Trainer"]="world_sources/215_Insect_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Lamplighter Isamu"]="world_sources/222_Lamplighter_Isamu.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Muzan"]="world_sources/208_Muzan.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Serpent Trainer"]="world_sources/214_Serpent_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Soryu Expert Kazuma"]="world_sources/218_Soryu_Expert_Kazuma.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Sound Trainer"]="world_sources/216_Sound_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Stone Trainer"]="world_sources/213_Stone_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Tai Chi Expert Renjiro"]="world_sources/219_Tai_Chi_Expert_Renjiro.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Thunder Trainer"]="world_sources/210_Thunder_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Water Trainer"]="world_sources/211_Water_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Quests.Wind Trainer"]="world_sources/212_Wind_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Black Marketer"]="world_sources/224_Black_Marketer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Duelist Hibiki"]="world_sources/239_Duelist_Hibiki.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Flame Trainer"]="world_sources/225_Flame_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Harvester of Souls Zurinyz"]="world_sources/235_Harvester_of_Souls_Zurinyz.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Insect Trainer"]="world_sources/231_Insect_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Lamplighter Isamu"]="world_sources/236_Lamplighter_Isamu.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Muzan"]="world_sources/223_Muzan.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Serpent Trainer"]="world_sources/230_Serpent_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Soryu Expert Kazuma"]="world_sources/233_Soryu_Expert_Kazuma.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Sound Trainer"]="world_sources/232_Sound_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Stone Trainer"]="world_sources/229_Stone_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Tai Chi Expert Renjiro"]="world_sources/234_Tai_Chi_Expert_Renjiro.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Tailor Omi"]="world_sources/238_Tailor_Omi.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Thunder Trainer"]="world_sources/226_Thunder_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Water Trainer"]="world_sources/227_Water_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Weaver Hatsu"]="world_sources/237_Weaver_Hatsu.lua",
["ReplicatedStorage.Ouwland.Content.Misc.NpcContents.Dialogues.Yap.Wind Trainer"]="world_sources/228_Wind_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Black Marketer"]="world_sources/060_Black_Marketer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Boss Hunts"]="world_sources/077_Boss_Hunts.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Duelist Hibiki"]="world_sources/084_Duelist_Hibiki.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Flame Trainer"]="world_sources/064_Flame_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Harvester of Souls Zurinyz"]="world_sources/066_Harvester_of_Souls_Zurinyz.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Horse"]="world_sources/061_Horse.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Insect Trainer"]="world_sources/071_Insect_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Lamplighter Isamu"]="world_sources/079_Lamplighter_Isamu.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Muzan"]="world_sources/078_Muzan.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Sealed Chest T1"]="world_sources/063_Sealed_Chest_T1.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Sealed Chest T2"]="world_sources/062_Sealed_Chest_T2.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Sealed Chest T3"]="world_sources/068_Sealed_Chest_T3.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Serpent Box"]="world_sources/083_Serpent_Box.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Serpent Trainer"]="world_sources/075_Serpent_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Soryu Expert Kazuma"]="world_sources/072_Soryu_Expert_Kazuma.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Sound Trainer"]="world_sources/074_Sound_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Stone Trainer"]="world_sources/076_Stone_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Study Props"]="world_sources/082_Study_Props.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Tai Chi Expert Renjiro"]="world_sources/069_Tai_Chi_Expert_Renjiro.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Tailor Omi"]="world_sources/081_Tailor_Omi.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Thunder Trainer"]="world_sources/065_Thunder_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Water Trainer"]="world_sources/070_Water_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Weaver Hatsu"]="world_sources/080_Weaver_Hatsu.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Wind Trainer"]="world_sources/073_Wind_Trainer.lua",
["ReplicatedStorage.Ouwland.Content.Misc.Npcs.Yeti Summon"]="world_sources/067_Yeti_Summon.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor"]="world_sources/003_Mistfall_Harbor.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.ActiveNpcs.Beast Born Demon"]="world_sources/053_Beast_Born_Demon.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.ActiveNpcs.Civilian"]="world_sources/054_Civilian.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.ActiveNpcs.Dreamfall Hollow.Blood Hounded Demon"]="world_sources/138_Blood_Hounded_Demon.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.ActiveNpcs.Seasons Crossing.Mizunoto"]="world_sources/139_Mizunoto.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Functions.DockActions"]="world_sources/179_DockActions.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Functions.MerchantActions"]="world_sources/178_MerchantActions.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Functions.Seasons Crossing.QuestActions"]="world_sources/256_QuestActions.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Functions.WarFansActions"]="world_sources/180_WarFansActions.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Quests.Angler Runo"]="world_sources/184_Angler_Runo.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Quests.Dreamfall Hollow.Jugg"]="world_sources/258_Jugg.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Quests.Ginzo"]="world_sources/181_Ginzo.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Quests.Niko"]="world_sources/185_Niko.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Quests.Rin"]="world_sources/182_Rin.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Quests.Seasons Crossing.Shady Individual"]="world_sources/257_Shady_Individual.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Quests.Sofen"]="world_sources/183_Sofen.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Angler Runo"]="world_sources/192_Angler_Runo.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Dreamfall Hollow.Jugg"]="world_sources/260_Jugg.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Elara"]="world_sources/186_Elara.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Fisherman Jeso"]="world_sources/191_Fisherman_Jeso.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Ginzo"]="world_sources/187_Ginzo.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Isao"]="world_sources/193_Isao.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Meku"]="world_sources/189_Meku.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Niko"]="world_sources/194_Niko.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Rin"]="world_sources/188_Rin.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Seasons Crossing.Shady Individual"]="world_sources/259_Shady_Individual.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Yap.Sofen"]="world_sources/190_Sofen.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcShared.BeastBornSettings"]="world_sources/041_BeastBornSettings.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcShared.BloodHoundedDemonSettings"]="world_sources/040_BloodHoundedDemonSettings.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcShared.CivilianSettings"]="world_sources/042_CivilianSettings.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcShared.MizunotoSettings"]="world_sources/039_MizunotoSettings.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Angler Runo"]="world_sources/049_Angler_Runo.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Dreamfall Hollow.Jugg"]="world_sources/137_Jugg.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Drowned Line"]="world_sources/050_Drowned_Line.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Elara"]="world_sources/043_Elara.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Fisherman Jeso"]="world_sources/048_Fisherman_Jeso.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Ginzo"]="world_sources/044_Ginzo.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Isao"]="world_sources/051_Isao.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Meku"]="world_sources/046_Meku.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Niko"]="world_sources/052_Niko.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Rin"]="world_sources/045_Rin.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Seasons Crossing.Rooyi"]="world_sources/136_Rooyi.lua",
["ReplicatedStorage.Ouwland.Content.Mistfall Harbor.Npcs.Sofen"]="world_sources/047_Sofen.lua",
["ReplicatedStorage.Ouwland.Content.Stone Sanctuary"]="world_sources/010_Stone_Sanctuary.lua",
["ReplicatedStorage.Ouwland.Content.Verdant Cliffs"]="world_sources/009_Verdant_Cliffs.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak"]="world_sources/001_Windy_Peak.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.ActiveNpcs.Bandit"]="world_sources/023_Bandit.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.ActiveNpcs.Civilian"]="world_sources/024_Civilian.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.ActiveNpcs.Spy"]="world_sources/025_Spy.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.ActiveNpcs.Zuko"]="world_sources/026_Zuko.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Functions.QuestActions"]="world_sources/163_QuestActions.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Functions.WagasaActions"]="world_sources/164_WagasaActions.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Quests.Kazu"]="world_sources/158_Kazu.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Quests.Kona"]="world_sources/162_Kona.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Quests.Krue"]="world_sources/157_Krue.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Quests.Lucy"]="world_sources/161_Lucy.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Quests.MoldySugar"]="world_sources/160_MoldySugar.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Quests.Noote"]="world_sources/159_Noote.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Yap.Firstlight Wagasa NPC"]="world_sources/156_Firstlight_Wagasa_NPC.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Yap.Kazu"]="world_sources/151_Kazu.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Yap.Kona"]="world_sources/155_Kona.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Yap.Krue"]="world_sources/148_Krue.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Yap.Lucy"]="world_sources/154_Lucy.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Yap.MoldySugar"]="world_sources/153_MoldySugar.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Yap.Noote"]="world_sources/152_Noote.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Yap.Raze"]="world_sources/149_Raze.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Yap.Rika"]="world_sources/150_Rika.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcShared.BanditSettings"]="world_sources/012_BanditSettings.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.NpcShared.CivilianSettings"]="world_sources/013_CivilianSettings.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.Kazu"]="world_sources/017_Kazu.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.Kona"]="world_sources/021_Kona.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.Krue"]="world_sources/014_Krue.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.Lucy"]="world_sources/020_Lucy.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.MoldySugar"]="world_sources/019_MoldySugar.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.Noote"]="world_sources/018_Noote.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.Raze"]="world_sources/015_Raze.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.Rika"]="world_sources/016_Rika.lua",
["ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.Wagasa Maker Genzo"]="world_sources/022_Wagasa_Maker_Genzo.lua",
["ReplicatedStorage.QuestStates.Cryokinesis Core Training"]="oneclick_sources/051_Cryokinesis_Core_Training.lua",
["ReplicatedStorage.QuestStates.Earn a Fishing Permit"]="oneclick_sources/040_Earn_a_Fishing_Permit.lua",
["ReplicatedStorage.QuestStates.Escort Akio to Windy Peak"]="oneclick_sources/045_Escort_Akio_to_Windy_Peak.lua",
["ReplicatedStorage.QuestStates.Find Betty's Gemstone"]="oneclick_sources/033_Find_Betty_s_Gemstone.lua",
["ReplicatedStorage.QuestStates.Find the Lucky Penny"]="oneclick_sources/034_Find_the_Lucky_Penny.lua",
["ReplicatedStorage.QuestStates.Five Broken Blades"]="oneclick_sources/036_Five_Broken_Blades.lua",
["ReplicatedStorage.QuestStates.Five Hundred Pennies"]="oneclick_sources/035_Five_Hundred_Pennies.lua",
["ReplicatedStorage.QuestStates.Locate Ren's Lost Nichirin"]="oneclick_sources/046_Locate_Ren_s_Lost_Nichirin.lua",
["ReplicatedStorage.QuestStates.Muzan Quest"]="oneclick_sources/038_Muzan_Quest.lua",
["ReplicatedStorage.QuestStates.Recover the Lost Pages"]="oneclick_sources/032_Recover_the_Lost_Pages.lua",
["ReplicatedStorage.QuestStates.Restock the Infirmary"]="oneclick_sources/039_Restock_the_Infirmary.lua",
["ReplicatedStorage.QuestStates.Retrieve Ginzo's Jewelry Box"]="oneclick_sources/037_Retrieve_Ginzo_s_Jewelry_Box.lua",
["ReplicatedStorage.QuestStates.Sound Breathing Training"]="oneclick_sources/049_Sound_Breathing_Training.lua",
["ReplicatedStorage.QuestStates.Supply the Settlement"]="oneclick_sources/044_Supply_the_Settlement.lua",
["ReplicatedStorage.QuestStates.The Deep Catch"]="oneclick_sources/048_The_Deep_Catch.lua",
["ReplicatedStorage.QuestStates.The Full Pantry"]="oneclick_sources/043_The_Full_Pantry.lua",
["ReplicatedStorage.QuestStates.The Good Catch"]="oneclick_sources/042_The_Good_Catch.lua",
["ReplicatedStorage.QuestStates.The Morning Haul"]="oneclick_sources/041_The_Morning_Haul.lua",
["ReplicatedStorage.QuestStates.The Reaper's Trial"]="oneclick_sources/054_The_Reaper_s_Trial.lua",
["ReplicatedStorage.QuestStates.The Soryu Trial"]="oneclick_sources/052_The_Soryu_Trial.lua",
["ReplicatedStorage.QuestStates.The Tai Chi Trial"]="oneclick_sources/053_The_Tai_Chi_Trial.lua",
["ReplicatedStorage.QuestStates.The Winter Catch"]="oneclick_sources/047_The_Winter_Catch.lua",
["ReplicatedStorage.QuestStates.Water Breathing Training"]="oneclick_sources/050_Water_Breathing_Training.lua",
["ReplicatedStorage.Regions"]="oneclick_sources/001_Regions.lua",
}
-- CAM Mechanics Recorder OneClick 1.7. Read-only inspection; no remote calls or require().
local function RunCollector(Lumen)
    local env = (getgenv and getgenv()) or _G
    if env.NZLGameDebug and env.NZLGameDebug.Stop then
        pcall(env.NZLGameDebug.Stop)
    end
    local Players = game:GetService("Players")
    local Http = game:GetService("HttpService")
    local Logs = game:GetService("LogService")
    local Tags = game:GetService("CollectionService")
    local LP = Players.LocalPlayer
    assert(LP, "Run on the client (LocalScript / client executor)")

    local cfg = { maxNodes = 20000, sources = false, decompile = false, sourceFilter = "", maxSources = 250 }
    local state = { alive = true, busy = false, exporting = false, cancelExport = false, cancel = false, logs = {}, report = nil, connections = {}, sourceTask = nil }
    local clipboard = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    local decompiler = decompile
    local fileWriter = writefile
    local MAX_TEXT = 12000000
    local MAX_SOURCE_BYTES = 4000000
    local statusLabel, countLabel, lastExport, exportSelector, exportFilterBox, savedSelector, reportLabel
    local sourceToggle, decompileToggle, sourceFilterBox, sourceCountSlider
    local exportKind, exportFilter = "Full report", ""
    local lastProfile = "game"
    local savedReports = {}
    local function prefix(s, n)
        if #s <= n then return s end
        -- Avoid splitting a UTF-8 codepoint at byte-limited boundaries.
        while n > 0 do
            local b = s:byte(n + 1)
            if not b or b < 128 or b >= 192 then break end
            n = n - 1
        end
        return s:sub(1, n)
    end
    local function str(x, limit)
        local s = tostring(x)
        local n = limit or 1500
        if #s > n then return prefix(s, n) .. " ... [truncated]" end
        return s
    end
    local function path(obj)
        local ok, result = pcall(function() return obj:GetFullName() end)
        return ok and result or "<unavailable>"
    end
    local function value(x)
        local t = typeof(x)
        if t == "Instance" then return { type = t, path = path(x) } end
        if t == "number" then
            if x ~= x or x == math.huge or x == -math.huge then return tostring(x) end
            return x
        end
        if t == "boolean" then return x end
        if t == "string" then return str(x, 2000) end
        return str(x)
    end
    local function notify(text)
        if state.alive then
            pcall(function() Lumen:Notification({ Name = "Game Debug", Description = text, Duration = 5 }) end)
        end
    end
    local function status(text)
        if state.alive and statusLabel then pcall(function() statusLabel:SetText(text) end) end
    end
    local function pushLog(message, kind, origin)
        if not state.alive then return end
        state.logs[#state.logs + 1] = { time = os.date("!%Y-%m-%dT%H:%M:%SZ"), kind = str(kind), origin = origin, message = str(message, 3000) }
        if #state.logs > 200 then table.remove(state.logs, 1) end
    end
    pcall(function()
        local history = Logs:GetLogHistory()
        for i = math.max(1, #history - 99), #history do
            local item = history[i]
            state.logs[#state.logs + 1] = { time = tostring(item.timestamp), kind = tostring(item.messageType), origin = "history", message = str(item.message, 3000) }
        end
    end)
    state.connections[#state.connections + 1] = Logs.MessageOut:Connect(function(message, kind)
        pushLog(message, kind, "MessageOut")
    end)
    pcall(function()
        state.connections[#state.connections + 1] = game:GetService("ScriptContext").Error:Connect(function(message, stack, scriptObject)
            pushLog(str(message, 2000) .. "\n" .. str(stack, 4000) .. "\nScript: " .. (scriptObject and path(scriptObject) or "unknown"), "Error", "ScriptContext")
        end)
    end)

    local function stop()
        state.alive, state.cancel = false, true
        for _, connection in ipairs(state.connections) do pcall(function() connection:Disconnect() end) end
        if state.sourceTask then pcall(task.cancel, state.sourceTask) end
        if state.recorder and state.recorder.stop then state.recorder.stop() end
    end
    env.NZLGameDebug = { Stop = stop }
    local originalUnload = Lumen.Unload
    function Lumen:Unload()
        stop()
        return originalUnload(self)
    end

    local function properties(obj, keys)
        local out = {}
        for _, key in ipairs(keys) do
            local ok, result = pcall(function() return obj[key] end)
            if ok and result ~= nil then out[key] = value(result) end
        end
        return out
    end
    local function boundedSource(obj, useDecompile)
        if state.sourceDeadline and os.clock()>=state.sourceDeadline then return nil,"source time budget exhausted" end
        local finished, result, failure = false, nil, nil
        local active = true
        local thread = task.spawn(function()
            local ok, source = pcall(function()
                if useDecompile then return decompiler(obj) end
                return obj.Source
            end)
            if not active then return end
            if ok and type(source) == "string" and source ~= "" then result = source
            else failure = ok and "empty source" or str(source, 500) end
            finished = true
        end)
        state.sourceTask = thread
        local deadline = math.min(os.clock() + 5, state.sourceDeadline or math.huge)
        while not finished and state.alive and not state.cancel and os.clock() < deadline do task.wait(0.05) end
        active = false
        if not finished then
            pcall(task.cancel, thread)
            failure = state.cancel and "cancelled" or "timeout (5s; cancellation is best-effort)"
        end
        state.sourceTask = nil
        return result, failure
    end
    local function inspectDecompiled(text)
        -- Heuristic only: an error-only comment stub is not a recovered script.
        -- An error marker alongside code is retained as a warning, not discarded.
        local hasCode, diagnostic, blockEnd = false, nil, nil
        for line in (text .. "\n"):gmatch("([^\n]*)\n") do
            local t = line:match("^%s*(.-)%s*$") or ""
            local comment = false
            if blockEnd then
                comment = true
                local pos = t:find(blockEnd, 1, true)
                if pos then
                    local tail = t:sub(pos + #blockEnd)
                    blockEnd = nil
                    if tail:match("%S") and not tail:match("^%s*%-%-") then hasCode = true end
                end
            elseif t:sub(1,2) == "--" then
                comment = true
                local eq = t:match("^%-%-%[(=*)%[")
                if eq ~= nil then
                    local close = "]" .. eq .. "]"
                    local pos = t:find(close, 5 + #eq, true)
                    if not pos then blockEnd = close
                    else
                        local tail = t:sub(pos + #close)
                        if tail:match("%S") and not tail:match("^%s*%-%-") then hasCode = true end
                    end
                end
            elseif t ~= "" then hasCode = true end
            if comment then
                local body = t:gsub("^%-%-%s*", ""):lower()
                if body:match("^error%s*:") or body:find("decompilation failed",1,true)
                    or body:find("failed to decompile",1,true) then diagnostic = diagnostic or str(t,1000) end
            end
        end
        if diagnostic then return not hasCode, diagnostic end
        return false, nil
    end
    local function captureSettings()
        return { maxNodes = cfg.maxNodes, sources = cfg.sources, decompile = cfg.decompile,
            sourceFilter = cfg.sourceFilter, maxSources = cfg.maxSources }
    end
    local focusPaths = {}
    local function collectRoots(profile)
        local roots, used, missing = {}, {}, {}
        local function add(obj)
            if obj and not used[obj] then used[obj] = true roots[#roots + 1] = obj end
        end
        local function service(name)
            -- Only allowlisted public game services; tolerate a renamed service instance.
            local found = game:FindFirstChild(name)
            if found then return found end
            local ok, serviceObject = pcall(function() return game:GetService(name) end)
            return ok and serviceObject or nil
        end
        if profile == "core" then
            for _, fullPath in ipairs(focusPaths) do
                local obj = game
                local first = true
                for name in fullPath:gmatch("[^%.]+") do
                    if first then obj = service(name); first = false
                    else obj = obj and obj:FindFirstChild(name) end
                    if not obj then break end
                end
                if obj then add(obj) else missing[#missing + 1] = fullPath end
            end
            for _,object in ipairs(state.extraFocusRoots or {}) do add(object) end
        elseif profile == "replicated" then
            add(service("ReplicatedStorage"))
        elseif profile == "clients" then
            -- Prefer actual local-player scripts over a second copy in StarterPlayer.
            local ps = LP:FindFirstChild("PlayerScripts")
            if ps then add(ps)
            else
                local sp = service("StarterPlayer")
                add(sp and sp:FindFirstChild("StarterPlayerScripts"))
            end
            add(LP:FindFirstChild("PlayerGui"))
            add(LP.Character)
            add(LP:FindFirstChild("Backpack"))
            add(service("ReplicatedFirst"))
        else
            -- Allowlist excludes CorePackages, CoreGui, Script Context and internal services.
            for _, name in ipairs({ "ReplicatedStorage", "ReplicatedFirst", "StarterPlayer", "StarterGui",
                "StarterPack", "Workspace", "Players", "Lighting", "SoundService", "Teams" }) do
                add(service(name))
            end
        end
        return roots, missing
    end
    local function scan(profile)
        if state.busy or state.exporting then notify("Wait for the current scan/export") return end
        profile = (profile == "replicated" or profile == "clients" or profile == "overview" or profile == "core") and profile or "game"
        local roots, missingRoots = collectRoots(profile)
        if #roots == 0 then notify("No client-visible roots for this profile") return end
        if profile == "replicated" or profile == "clients" or profile == "core" then
            -- Source count is preset per mechanics pass, never user-configured.
            -- Explicit source buttons opt in; no saved config silently enables extraction.
            cfg.sources, cfg.decompile, cfg.sourceFilter = true, true, ""
            if sourceToggle then sourceToggle:Set(true, true) end
            if decompileToggle then decompileToggle:Set(true, true) end
            if sourceFilterBox then sourceFilterBox:Set("", true) end
            if sourceCountSlider then sourceCountSlider:Set(cfg.maxSources, true) end
            exportKind, exportFilter = "Scripts", ""
            if exportSelector then exportSelector:Set(exportKind, true) end
            if exportFilterBox then exportFilterBox:Set("", true) end
            notify("Source preset: " .. profile .. ". Up to " .. cfg.maxSources .. " scripts; no modules are executed.")
        elseif profile == "overview" then
            exportKind, exportFilter = "Full report", ""
            if exportSelector then exportSelector:Set(exportKind, true) end
            if exportFilterBox then exportFilterBox:Set("", true) end
        end
        lastProfile = profile
        if savedSelector then savedSelector:Set("Latest", true) end
        state.busy, state.cancel = true, false
        task.spawn(function()
            local started = os.clock()
            local settings = captureSettings()
            settings.profile = profile
            if profile == "core" then
                settings.requestedRootPaths = table.clone(focusPaths)
                settings.missingRequestedRoots = table.clone(missingRoots)
            end
            if profile == "overview" then settings.sources, settings.decompile, settings.sourceFilter = false, false, "" end
            settings.excluded = { "CorePackages", "CoreGui", "RobloxReplicatedStorage", "engine-internal services", "collector UI" }
            settings.maxSourceBytes = MAX_SOURCE_BYTES
            settings.maxBytesPerSource = 160000
            settings.attemptTimeoutSeconds = 5
            local report = {
                format = "NZL Game Debug 1.4", createdUTC = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                scope = "Client-visible instances only. No require(), remote calls, HTTP upload or interception.",
                limitations = {
                    "Server-only scripts, ServerStorage and ServerScriptService contents are not replicated.",
                    "StreamingEnabled, permissions and scan limits can make this report incomplete.",
                    "Remote metadata does not reveal arguments, server handlers or protocol semantics.",
                    "Decompiler output is not original source or guaranteed deobfuscation; output may be invalid.",
                    "Paths are descriptive; names containing dots or duplicate names can be ambiguous. Use node IDs.",
                    "Logs and source may contain private data. Review before sharing."
                },
                game = { placeId = game.PlaceId, universeId = game.GameId, placeVersion = game.PlaceVersion,
                    loaded = game:IsLoaded(), workspace = properties(workspace, { "StreamingEnabled", "Gravity", "DistributedGameTime" }) },
                capabilities = { clipboard = type(clipboard) == "function", writefile = type(fileWriter) == "function", decompile = type(decompiler) == "function" },
                settings = settings, roots = {}, nodes = {}, remotes = {}, scripts = {}, interactives = {},
                models = {}, classCounts = {}, errors = {},
                stats = { sourceAttempts = 0, sourceCountLimitSkipped = 0, sourceBytesLimitSkipped = 0,
                    sourceFailures = 0, sourceTimeouts = 0, sourceDiagnosticErrors = 0, sourceWarnings = 0,
                    sourcesCancelled = 0, sourceTruncatedCount = 0,
                    sourceEligible = 0, sourceUniqueTexts = 0, sourceDeadlineSkipped = 0 }, logs = {},
            }
            state.report = report
            local targets, metadataBytes, sourceTexts = {}, 0, {}
            local ok, err = xpcall(function()
                local queue, head, seen = {}, 1, {}
                for _, root in ipairs(roots) do
                    queue[#queue + 1] = { object = root, parent = 0, depth = 0 }
                    report.roots[#report.roots + 1] = { name = root.Name, class = root.ClassName, path = path(root) }
                end
                while head <= #queue and #report.nodes < settings.maxNodes and metadataBytes < MAX_TEXT and not state.cancel and state.alive do
                    local entry = queue[head]
                    queue[head] = false
                    head = head + 1
                    local obj = entry.object
                    local isOwn = obj == Lumen.State.Screen
                    if not seen[obj] and not isOwn then
                        seen[obj] = true
                        local nodeId = #report.nodes + 1
                        local node = { id = nodeId, parent = entry.parent, depth = entry.depth, name = str(obj.Name, 300), class = obj.ClassName, path = str(path(obj), 1800) }
                        local attrOk, attrs = pcall(function() return obj:GetAttributes() end)
                        if attrOk and next(attrs) then
                            node.attributes = {}
                            local count = 0
                            for key, v in pairs(attrs) do
                                count = count + 1
                                if count > 40 then node.attributesTruncated = true break end
                                node.attributes[str(key, 150)] = value(v)
                            end
                        end
                        local tagOk, tags = pcall(function() return Tags:GetTags(obj) end)
                        if tagOk and #tags > 0 then node.tags = {} for i = 1, math.min(#tags, 40) do node.tags[i] = str(tags[i], 150) end end
                        if obj:IsA("ValueBase") then node.properties = properties(obj, { "Value" }) end
                        if obj:IsA("BasePart") then
                            node.properties = properties(obj, { "Position", "Size", "Anchored", "CanCollide", "Transparency" })
                        elseif obj:IsA("Humanoid") then
                            node.properties = properties(obj, { "Health", "MaxHealth", "WalkSpeed", "RigType" })
                        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                            node.properties = properties(obj, { "Text", "Visible" })
                        elseif obj:IsA("Animation") then node.properties = properties(obj, { "AnimationId" })
                        elseif obj:IsA("Sound") then node.properties = properties(obj, { "SoundId", "Volume", "IsPlaying" }) end
                        report.nodes[#report.nodes + 1] = node
                        report.classCounts[node.class] = (report.classCounts[node.class] or 0) + 1
                        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
                            report.remotes[#report.remotes + 1] = { id = nodeId, class = node.class, path = node.path }
                        end
                        if obj:IsA("LuaSourceContainer") then
                            local record = { id = nodeId, class = node.class, path = node.path,
                                properties = properties(obj, { "Disabled", "Enabled", "RunContext" }), sourceStatus = "not requested" }
                            report.scripts[#report.scripts + 1] = record
                            local matches = settings.sourceFilter == "" or node.path:lower():find(settings.sourceFilter:lower(), 1, true)
                            if settings.sources and matches and (obj:IsA("ModuleScript") or obj:IsA("LocalScript") or tostring(record.properties.RunContext) == "Enum.RunContext.Client") then
                                report.stats.sourceEligible = report.stats.sourceEligible + 1
                                if #targets < settings.maxSources then
                                    record.sourceStatus = "pending"
                                    targets[#targets + 1] = { object = obj, record = record }
                                else
                                    record.sourceStatus = "source count limit"
                                    report.stats.sourceCountLimitSkipped = report.stats.sourceCountLimitSkipped + 1
                                end
                            elseif settings.sources then record.sourceStatus = "outside filter or not a client/module script" end
                        end
                        if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") or obj:IsA("Tool") or obj:IsA("TouchTransmitter") then
                            report.interactives[#report.interactives + 1] = { id = nodeId, class = node.class, path = node.path,
                                properties = properties(obj, { "Enabled", "ActionText", "ObjectText", "MaxActivationDistance", "HoldDuration", "RequiresHandle", "ToolTip" }) }
                        end
                        if obj:IsA("Model") then
                            report.models[#report.models + 1] = { id = nodeId, path = node.path,
                                humanoid = obj:FindFirstChildOfClass("Humanoid") ~= nil,
                                properties = properties(obj, { "PrimaryPart", "WorldPivot" }) }
                        end
                        local encodedOk, encoded = pcall(function() return Http:JSONEncode(node) end)
                        metadataBytes = metadataBytes + (encodedOk and #encoded or 2000)
                        local childrenOk, children = true, {}
                        -- Roots are individually selected scripts. Never descend into their asset/UI trees here.
                        if childrenOk then
                            for _, child in ipairs(children) do
                                -- Queue is bounded as well as the output.
                                if #queue >= settings.maxNodes then report.stats.queueLimitReached = true break end
                                queue[#queue + 1] = { object = child, parent = nodeId, depth = entry.depth + 1 }
                            end
                        elseif #report.errors < 100 then report.errors[#report.errors + 1] = node.path .. ": " .. str(children, 400) end
                    end
                    if head % 100 == 0 then
                        status("Scanning: " .. #report.nodes .. " objects | " .. #report.remotes .. " remotes")
                        task.wait()
                    end
                end
                report.stats.metadataLimitReached = metadataBytes >= MAX_TEXT
                report.stats.cancelled = state.cancel or not state.alive
                report.stats.nodes = #report.nodes
                report.stats.remotes = #report.remotes
                report.stats.scripts = #report.scripts
                report.stats.sourceBytes = 0
                report.stats.sourcesCollected = 0
                for i, target in ipairs(targets) do
                    if state.cancel or not state.alive then
                        target.record.sourceStatus = "cancelled"
                        report.stats.sourcesCancelled = report.stats.sourcesCancelled + 1
                    elseif state.sourceDeadline and os.clock()>=state.sourceDeadline then
                        target.record.sourceStatus="source time budget exhausted"
                        report.stats.sourceDeadlineSkipped=report.stats.sourceDeadlineSkipped+1
                    elseif report.stats.sourceBytes >= MAX_SOURCE_BYTES then
                        target.record.sourceStatus = "total source size limit"
                        report.stats.sourceBytesLimitSkipped = report.stats.sourceBytesLimitSkipped + 1
                    else
                        report.stats.sourceAttempts = report.stats.sourceAttempts + 1
                        status("Source " .. i .. "/" .. #targets .. ": " .. str(target.object.Name, 40))
                        local source, failure = boundedSource(target.object, false)
                        local method = "Source property"
                        if not source and settings.decompile and type(decompiler) == "function" and not state.cancel and state.alive then
                            method = "decompile (unverified output)"
                            source, failure = boundedSource(target.object, true)
                        end
                        if source and method == "decompile (unverified output)" then
                            local errorOnly, diagnostic = inspectDecompiled(source)
                            if errorOnly then
                                target.record.decompilerDiagnostic = prefix(source,4000)
                                target.record.decompilerDiagnosticTruncated = #source > 4000
                                target.record.sourceErrorKind = "decompiler_diagnostic_only"
                                report.stats.sourceDiagnosticErrors = report.stats.sourceDiagnosticErrors + 1
                                failure = "decompiler returned error text instead of source"
                                source = nil
                            elseif diagnostic then
                                target.record.sourceWarning = diagnostic
                                report.stats.sourceWarnings = report.stats.sourceWarnings + 1
                            end
                        end
                        if source then
                            if not sourceTexts[source] then
                                sourceTexts[source] = true
                                report.stats.sourceUniqueTexts = report.stats.sourceUniqueTexts + 1
                            end
                            local maxBytes = math.min(160000, MAX_SOURCE_BYTES - report.stats.sourceBytes)
                            target.record.source = prefix(source, maxBytes)
                            target.record.sourceTruncated = #source > maxBytes
                            if target.record.sourceTruncated then report.stats.sourceTruncatedCount = report.stats.sourceTruncatedCount + 1 end
                            target.record.sourceStatus = method
                            report.stats.sourceBytes = report.stats.sourceBytes + #target.record.source
                            report.stats.sourcesCollected = report.stats.sourcesCollected + 1
                        else
                            target.record.sourceStatus = failure or "unavailable"
                            if state.cancel or not state.alive then
                                report.stats.sourcesCancelled = report.stats.sourcesCancelled + 1
                            else
                                report.stats.sourceFailures = report.stats.sourceFailures + 1
                                if tostring(failure):find("timeout", 1, true) then report.stats.sourceTimeouts = report.stats.sourceTimeouts + 1 end
                            end
                            if settings.decompile and type(decompiler) ~= "function" then
                                target.record.sourceStatus = target.record.sourceStatus .. "; decompile API unavailable"
                            end
                        end
                    end
                    task.wait()
                end
            end, function(e) return debug.traceback(tostring(e), 2) end)
            if not ok then report.errors[#report.errors + 1] = str(err, 4000) end
            report.stats.cancelled = state.cancel or not state.alive
            report.stats.durationSeconds = math.floor((os.clock() - started) * 100) / 100
            report.stats.completed = ok and not report.stats.cancelled
            report.stats.nodes, report.stats.remotes, report.stats.scripts = #report.nodes, #report.remotes, #report.scripts
            report.stats.treeIncomplete = not report.stats.completed or report.stats.queueLimitReached == true or report.stats.metadataLimitReached == true
            report.stats.sourcesPending = 0
            for _, record in ipairs(report.scripts) do
                if record.sourceStatus == "pending" then report.stats.sourcesPending = report.stats.sourcesPending + 1 end
            end
            report.stats.missingRequestedRoots = #missingRoots
            report.stats.sourceIncomplete = settings.sources and (#missingRoots > 0 or report.stats.sourceCountLimitSkipped > 0
                or report.stats.sourceBytesLimitSkipped > 0 or report.stats.sourceDeadlineSkipped > 0 or report.stats.sourceFailures > 0
                or report.stats.sourcesCancelled > 0 or report.stats.sourceTruncatedCount > 0 or report.stats.sourcesPending > 0) or false
            report.stats.incomplete = report.stats.treeIncomplete or report.stats.sourceIncomplete
            report.logs = table.clone(state.logs)
            savedReports[profile] = report
            state.busy = false
            if state.alive then
                if reportLabel then reportLabel:SetText("Active report: " .. profile) end
                status((report.stats.cancelled and "Cancelled: " or (ok and "Done: " or "Partial report: ")) .. #report.nodes .. " objects")
                countLabel:SetText(#report.remotes .. " remotes | " .. #report.scripts .. " scripts | " .. (report.stats.sourcesCollected or 0) .. " sources")
                notify((report.stats.incomplete and "Partial scan" or "Scan ready") .. "; preparing automatic export...")
            end
        end)
    end

    local function selectReport()
        if not state.report then notify("Run Scan first") return end
        if state.busy or state.exporting then notify("Wait for scan/export completion, or press Cancel") return end
        local r = state.report
        r.logs = table.clone(state.logs)
        if exportKind == "Full report" then return r end
        if exportKind == "Logs" then return { format = r.format, createdUTC = r.createdUTC, game = r.game, settings = r.settings, stats = r.stats, logs = r.logs } end
        local key = ({ Remotes = "remotes", Scripts = "scripts", Interactives = "interactives", Models = "models", Tree = "nodes" })[exportKind]
        local records = {}
        for _, item in ipairs(r[key] or {}) do
            if exportFilter == "" or (item.path or ""):lower():find(exportFilter:lower(), 1, true) then records[#records + 1] = item end
        end
        return { format = r.format, createdUTC = r.createdUTC, game = r.game, stats = r.stats, settings = r.settings,
            capabilities = r.capabilities, roots = r.roots, errors = r.errors, limitations = r.limitations,
            section = exportKind, filter = exportFilter, records = records }
    end
    local function encodeSafe(report)
        if state.exporting then notify("Export already running") return end
        state.exporting, state.cancelExport = true, false
        status("Encoding report...")
        local ok, text, info = pcall(function()
            local success, result = pcall(function() return Http:JSONEncode(report) end)
            if success and type(result)=="string" and result~="" then return result end
            local details = { error = str(result or "Native encoder returned no text",1000), fields = {} }
            -- First identify failing top-level fields; never discard them silently.
            for key, v in pairs(report) do
                if not state.alive or state.cancelExport then error("Export cancelled; cached scan retained",0) end
                local fieldOK, fieldError = pcall(function() return Http:JSONEncode(v) end)
                if not fieldOK then details.fields[#details.fields+1] = { field = tostring(key), error = str(fieldError,500) } end
                task.wait()
            end
            status("Native JSON failed; using portable export...")
            return PortableJSON(report, details, function(count, bytes)
                if not state.alive or state.cancelExport then error("Export cancelled; cached scan retained",0) end
                status("Exporting: " .. count .. " values / " .. math.floor(bytes/1024) .. " KB")
                task.wait()
            end)
        end)
        state.exporting = false
        if not ok then
            status("Export stopped; report remains in memory")
            notify("Export error: " .. str(text,180))
            return
        end
        state.lastSerialization = info
        lastExport = text
        status("Export ready: " .. #text .. " bytes")
        if info then
            notify("Portable JSON ready. Normalized values: " .. info.normalizationCount .. ". Details: _jsonExport.")
        end
        return text
    end
    local function encodeReport()
        local report = selectReport()
        if not report then return end
        return encodeSafe(report)
    end
    local manualFrame
    local function manualCopy(text)
        if manualFrame then manualFrame:Destroy() end
        local frame = Instance.new("Frame")
        manualFrame = frame
        frame.Size = UDim2.fromScale(0.82, 0.76)
        frame.Position = UDim2.fromScale(0.09, 0.12)
        frame.BackgroundColor3 = Color3.fromRGB(24, 26, 33)
        frame.ZIndex = 300
        frame.Parent = Lumen.State.Screen
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, -10, 0, 38)
        header.Position = UDim2.fromOffset(5, 0)
        header.BackgroundTransparency = 1
        header.TextColor3 = Color3.new(1, 1, 1)
        header.TextSize = 14
        header.ZIndex = 301
        header.Parent = frame
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -20, 1, -90)
        box.Position = UDim2.fromOffset(10, 40)
        box.MultiLine = true
        box.ClearTextOnFocus = false
        box.TextEditable = true
        box.TextWrapped = false
        box.Font = Enum.Font.Code
        box.TextSize = 12
        box.TextColor3 = Color3.fromRGB(215, 225, 235)
        box.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextYAlignment = Enum.TextYAlignment.Top
        box.ZIndex = 301
        box.Parent = frame
        local page, pageSize = 1, 30000
        local chunks, first = {}, 1
        while first <= #text do
            local last = math.min(#text, first + pageSize - 1)
            while last < #text do
                local b = text:byte(last + 1)
                if b < 128 or b >= 192 then break end
                last = last - 1
            end
            chunks[#chunks + 1] = text:sub(first, last)
            first = last + 1
        end
        if #chunks == 0 then chunks[1] = "" end
        local pages = #chunks
        local function render()
            -- UTF-8-safe, byte-exact chunks; concatenate in order.
            box.Text = chunks[page]
            header.Text = "Manual copy: page " .. page .. "/" .. pages .. " | Ctrl+A, Ctrl+C (join pages in order)"
        end
        local function button(title, x, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(100, 30)
            b.Position = UDim2.new(0, x, 1, -38)
            b.Text = title
            b.ZIndex = 302
            b.Parent = frame
            b.MouseButton1Click:Connect(callback)
        end
        button("Previous", 10, function() page = math.max(1, page - 1) render() end)
        button("Next", 120, function() page = math.min(pages, page + 1) render() end)
        button("Select all", 230, function() box:CaptureFocus() box.CursorPosition = #box.Text + 1 box.SelectionStart = 1 end)
        button("Close", 340, function() frame:Destroy() manualFrame = nil end)
        render()
    end
    local function encodeBundle()
        if state.busy or state.exporting then notify("Wait for scan/export completion or cancel first") return end
        local reports = {}
        for _, key in ipairs({ "core", "overview", "replicated", "clients", "game" }) do
            if savedReports[key] then reports[#reports + 1] = savedReports[key] end
        end
        if #reports == 0 then notify("Run at least one scan first") return end
        return encodeSafe({ format = "NZL Game Debug Bundle 1.4", exportType = "bundle",
            createdUTC = os.date("!%Y-%m-%dT%H:%M:%SZ"), reportCount = #reports,
            reports = reports, logsAtExport = table.clone(state.logs),
            note = "Full cached scans, ignoring export filters. Client-visible data only; review before sharing." })
    end
    local function copy(bundle)
        local text
        if bundle then text = encodeBundle() else text = encodeReport() end
        if not text then return end
        if type(clipboard) == "function" then
            local ok, err = pcall(clipboard, text)
            if ok then notify("Sent to clipboard: " .. #text .. " bytes") return end
            notify("Clipboard failed: " .. str(err, 120))
        else notify("No clipboard API. Use manual copy / save file.") end
        manualCopy(text)
    end
    local function save(bundle)
        local text
        if bundle then text = encodeBundle() else text = encodeReport() end
        if not text then return end
        if type(fileWriter) ~= "function" then notify("writefile unavailable. Use Copy / manual copy.") return end
        local label = bundle and "ALL_SCANS" or ((state.report.settings.profile or "game") .. "_" .. exportKind:gsub("%W", "_"))
        local filename = "GameDebug_" .. game.PlaceId .. "_" .. label .. "_" .. os.date("!%Y%m%d_%H%M%S") .. ".json"
        local ok, err = pcall(fileWriter, filename, text)
        notify(ok and ("Saved: " .. filename) or ("Save failed: " .. str(err, 180)))
    end

    -- Passive runtime snapshot; never require or invoke a gameplay module here.
    local function resolveNames(root,names)
        for _,name in ipairs(names) do root=root and root:FindFirstChild(name);if not root then break end end
        return root
    end
    local function runtimeSnapshot()
        local r={collectedUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),errors={},
            note="Passive observation only. Module presence does not establish active listeners; no M1, skills, equip, quest or remote requests were performed."}
        local function attempt(key,fn)
            local ok,result=pcall(fn)
            if ok then r[key]=result else r.errors[#r.errors+1]={section=key,error=str(result,1200)} end
        end
        attempt("executor",function()
            local fn=identifyexecutor or getexecutorname
            if type(fn)~="function" then return {name="unknown",reason="Identification API unavailable"} end
            local name,version=fn();return {name=str(name,200),version=version and str(version,100) or nil}
        end)
        attempt("device",function()
            local input=game:GetService("UserInputService")
            local d=properties(input,{"KeyboardEnabled","TouchEnabled","GamepadEnabled","MouseEnabled"})
            local ok,p=pcall(function() return input:GetPlatform() end);d.platform=ok and tostring(p) or "unavailable"
            return d
        end)
        attempt("mainHub",function()
            local hub=env.CAMMainHub
            if type(hub)~="table" then return {present=false,note="CAM Main was not found in this executor environment"} end
            if type(hub.Snapshot)=="function" then
                -- This is our own hub's bounded, read-only snapshot, not a discovered game module.
                return {present=true,version=hub.Version,report=hub.Snapshot()}
            end
            return {present=true,version=hub.Version,note="Snapshot API unavailable"}
        end)
        local function compactTree(root,limit,depthLimit)
            if not root then return {missing=true} end
            local result={path=path(root),nodes={},incomplete=false}
            local queue={{o=root,depth=0,parent=0}};local head=1
            while head<=#queue and #result.nodes<limit do
                if not state.alive then error("Collector unloaded") end
                local entry=queue[head];head=head+1;local o=entry.o
                local node={name=str(o.Name,200),class=o.ClassName,parent=entry.parent,depth=entry.depth}
                local ok,a=pcall(function() return o:GetAttributes() end)
                if ok then node.attributes={};for k,v in pairs(a) do node.attributes[str(k,200)]=value(v) end end
                node.properties=properties(o,{"Value","Health","MaxHealth","WalkSpeed","JumpPower","JumpHeight","Position","Enabled","Disabled"})
                result.nodes[#result.nodes+1]=node;local id=#result.nodes
                local success,children=pcall(function() return o:GetChildren() end)
                if success then
                    if entry.depth<depthLimit then
                        for _,child in ipairs(children) do
                            if #queue<limit then queue[#queue+1]={o=child,depth=entry.depth+1,parent=id} else result.incomplete=true end
                        end
                    elseif #children>0 then result.incomplete=true end
                end
            end
            if head<=#queue then result.incomplete=true end
            return result
        end
        local RS=game:GetService("ReplicatedStorage")
        attempt("localState",function()
            local dataRoot=resolveNames(RS,{"Player_Service","Data",LP.Name})
            local slot=dataRoot and dataRoot:FindFirstChild("slotEquipped")
            local d=slot and resolveNames(dataRoot,{"slots","Slot"..tostring(slot.Value)})
            local c=LP.Character;local h=c and c:FindFirstChildOfClass("Humanoid")
            return {
                character=c and path(c) or "missing",humanoid=h and properties(h,{"Health","MaxHealth","WalkSpeed","PlatformStand","Sit","MoveDirection"}) or {},
                characterAttributes=c and c:GetAttributes() or {},
                menuDestination=compactTree(LP:FindFirstChild("MenuDestination"),3,0),
                equipped=compactTree(LP:FindFirstChild("Items_Config"),20,2),
                values=compactTree(resolveNames(RS,{"Player_Service","Values",LP.Name}),300,3),
                toolbar=compactTree(d and resolveNames(d,{"Inventory","Toolbar"}),40,2),
                inventory=compactTree(d and resolveNames(d,{"Inventory","Inventory"}),800,3),
                quests=compactTree(d and d:FindFirstChild("Quests"),350,5),
                experience=compactTree(d and d:FindFirstChild("Exp"),30,3),
                race=compactTree(d and d:FindFirstChild("Race"),3,0),
                wen=compactTree(d and d:FindFirstChild("Wen"),3,0),
                powers=compactTree(d and d:FindFirstChild("Powers"),60,3),
                skillTree=compactTree(d and d:FindFirstChild("SkillTreeUnlockedList"),150,3),
                playerAttributes=LP:GetAttributes(),
                worldAttributes=workspace:GetAttributes(),
                skillState=compactTree(c and c:FindFirstChild("SHC"),10,1),
                serverSkillState=compactTree(c and c:FindFirstChild("SHCS"),10,1),
                pendingDialogue=LP:GetAttribute("PendingDialogue"),
                dialogueVisibility=compactTree(resolveNames(RS,{"CAM","Client","Components","Layout","Visibility","Dialogue"}),3,0),
                skillVisibility=compactTree(resolveNames(RS,{"CAM","Client","Components","Layout","Visibility","HUD","Skills"}),3,0),
            }
        end)
        attempt("loadedModules",function()
            if type(getloadedmodules)~="function" then return {available=false} end
            local list=getloadedmodules();local out={available=true,paths={},incomplete=false}
            for _,m in ipairs(list) do
                local p=path(m)
                if p:find("ReplicatedStorage.CAM",1,true) or p:find("ReplicatedStorage.Regions",1,true) or p:find("PlayerScripts",1,true) then
                    if #out.paths<1200 then out.paths[#out.paths+1]=str(p,1200) else out.incomplete=true end
                end
            end
            table.sort(out.paths);return out
        end)
        return r
    end
    -- Read-only discovery of gameplay scripts. Assets/packages/other players are not traversed.
    local mechanicTerms={
        stamina={"stamina","exhaust","sustain","climb","swim","run_handler","dash","horse"},
        combat={"combat","parry","blocking","hitbox","damage","ragdoll","death","despawn","npcservice","aimimic"},
        fishing={"fishing","fish","bait","barkeepup"},
        training={"training","skilltree","mastery","breathing","meditation","pushup","boulder","cup game","target shooting"},
        quests={"quest","dialogue","deliver","escort"},
        modes={"queue","minigame","ouwi","ranked","dungeon","wave","gauntlet","card","matchmaking","joinworld"},
        items={"potion","shop","inventory","equipment","toolscript","schematic","craft","crystal","loot","chest","cache","soul","reward","redeem","restock"},
        race={"race","muzan","sunlight","sundamage"},
    }
    local importantNames={checker=true,utility=true,skills_module=true,skill_controller=true,skills_provider=true,
        character_info_provider=true,serverclientportal=true,signalevent=true,signalfunction=true,queuesignal=true,
        itemrequirements=true,toolbaritemrestrictions=true,statsfetch=true,gamesettings=true,playerstatresolver=true,stats=true,skill_info=true,manage_cd=true,effectsevent=true}
    local function canonical(p)
        local names=string.split and string.split(p,".") or nil
        if names and names[1]=="Players" and names[2]==LP.Name then names[2]="<local>";return table.concat(names,".") end
        local start="Players."..LP.Name.."."
        if p:sub(1,#start)==start then return "Players.<local>."..p:sub(#start+1) end
        return p
    end
    local function mechanismGroups(p)
        local result={};local lower=p:lower()
        for category,words in pairs(mechanicTerms) do
            for _,word in ipairs(words) do if lower:find(word,1,true) then result[#result+1]=category;break end end
        end
        table.sort(result);return result
    end
    local function discoverFocusedRoots()
        local RS=game:GetService("ReplicatedStorage")
        local diagnostics={paths={},errors={},groups={},knownReferences={},remotes={},excluded={},deferred={},visited=0,eligible=0,
            scope="Gameplay scripts, local client scripts and current-place Content; no asset models, packages or other player data"}
        local candidates,queue,seen={}, {},{}
        local function add(root) if root then queue[#queue+1]=root end end
        add(RS);add(LP:FindFirstChild("PlayerScripts"));add(LP:FindFirstChild("PlayerGui"));add(LP.Character);add(LP:FindFirstChild("Backpack"))
        local ok,first=pcall(function() return game:GetService("ReplicatedFirst") end);if ok then add(first) end
        local head=1
        local excludedNames={CorePackages=true,CoreGui=true,RobloxReplicatedStorage=true,Packages=true,NodeModules=true,
            Assets=true,Effects=true,Animations=true,Player_Service=true,OCIFolder=true,DefaultChatSystemChatEvents=true,
            TextChatService=true,Chat=true,ExperienceChat=true,ChatScript=true,PlayerList=true}
        while head<=#queue and diagnostics.visited<25000 and state.alive and not state.cancel do
            local o=queue[head];queue[head]=false;head=head+1
            if o and not seen[o] then
                seen[o]=true;diagnostics.visited=diagnostics.visited+1
                local p=path(o);local name=tostring(o.Name);local lower=name:lower()
                local skip=excludedNames[name] or o==Lumen.State.Screen or lower:find("cam_main",1,true) or lower:find("cam_debug",1,true)
                if name=="Effects" and p:find(".Communication.",1,true) then skip=false end
                if o:IsA("Model") and o~=LP.Character then skip=true end
                if skip then
                    if #diagnostics.excluded<100 then diagnostics.excluded[#diagnostics.excluded+1]=p end
                else
                    if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") or o:IsA("UnreliableRemoteEvent") or o:IsA("BindableEvent") or o:IsA("BindableFunction") then
                        if #diagnostics.remotes<600 then diagnostics.remotes[#diagnostics.remotes+1]={path=p,class=o.ClassName,groups=mechanismGroups(p)} else diagnostics.remoteLimitReached=true end
                    end
                    if o:IsA("ModuleScript") or o:IsA("LocalScript") or (o:IsA("Script") and tostring(o.RunContext)=="Enum.RunContext.Client") then
                        local key=canonical(p);local groups=mechanismGroups(p)
                        local known=CAM_KNOWN_MECHANICS_SOURCES[key]
                        local sameBuild=game.PlaceId==136406881576517 and game.PlaceVersion==5354
                        -- Re-read mechanic-specific sources, reuse unrelated known content only on the same build.
                        local content=p:find(".Content.",1,true)~=nil
                        local critical=importantNames[lower] or (#groups>0 and not content)
                        if not (state.scannedPaths and state.scannedPaths[p]) then
                            if known and sameBuild and not critical then
                                if #diagnostics.knownReferences<2000 then diagnostics.knownReferences[#diagnostics.knownReferences+1]={path=p,reference=known} else diagnostics.referenceLimitReached=true end
                            else
                                local score=(critical and 100 or #groups>0 and 60 or 20)+(known and 0 or 10)+(content and not sameBuild and 30 or 0)
                                if lower:find("stamina",1,true) or importantNames[lower] then score=score+50 end
                                candidates[#candidates+1]={o=o,path=p,score=score,groups=groups}
                            end
                        end
                    end
                    local success,children=pcall(function() return o:GetChildren() end)
                    if success then
                        for _,child in ipairs(children) do
                            if #queue<25000 then queue[#queue+1]=child else diagnostics.limitReached=true;break end
                        end
                    elseif #diagnostics.errors<50 then diagnostics.errors[#diagnostics.errors+1]=p..": "..str(children,400) end
                end
            end
            if head%200==0 then task.wait() end
        end
        if head<=#queue then diagnostics.limitReached=true end
        diagnostics.eligible=#candidates
        table.sort(candidates,function(a,b) if a.score==b.score then return a.path<b.path end;return a.score>b.score end)
        local roots={};local limit=state.latePass and 80 or 350
        for i,c in ipairs(candidates) do
            if i<=limit then
                roots[#roots+1]=c.o;diagnostics.paths[#diagnostics.paths+1]=c.path
                for _,group in ipairs(c.groups) do diagnostics.groups[group]=(diagnostics.groups[group] or 0)+1 end
            else
                diagnostics.selectionLimitReached=true
                if #diagnostics.deferred<500 then diagnostics.deferred[#diagnostics.deferred+1]={path=c.path,groups=c.groups,priority=c.score} else diagnostics.deferredListLimitReached=true end
            end
        end
        diagnostics.selected=#roots
        return roots,diagnostics
    end
    local function deliverText(text)
        local filename="CAM_Debug_Mechanics_"..tostring(game.PlaceId).."_"..os.date("!%Y%m%d_%H%M%S")..".json"
        local saved,copied=false,false
        if type(fileWriter)=="function" then
            local ok,err=pcall(fileWriter,filename,text);saved=ok
            if not ok then pushLog("Save failed: "..str(err,500),"Warning","export") end
        end
        if type(clipboard)=="function" then
            local ok,err=pcall(clipboard,text);copied=ok
            if not ok then pushLog("Clipboard failed: "..str(err,500),"Warning","export") end
        end
        if saved then status("SAVED: "..filename);notify("Saved JSON in executor workspace. "..(copied and "Also sent to clipboard." or "Clipboard unavailable."))
        elseif copied then status("COPIED: paste into a text file and send it");notify("JSON sent to clipboard; file saving unavailable.")
        else status("Export APIs unavailable - manual copy");manualCopy(text);notify("Copy all pages in order, not just the first page.") end
        state.oneClickDelivery={filename=saved and filename or nil,saved=saved,copied=copied,bytes=#text}
        if saved then countLabel:SetText("Send file: "..filename) end
    end
    -- Passive recorder. No outgoing remote hooks, synthetic input, stat writes or game require().
    local function recordMechanics()
        local RS=game:GetService("ReplicatedStorage")
        local rec={durationRequested=90,intervalSeconds=0.5,startedUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),events={},samples={},uiSnapshots={},mainTransitions={},mainLogs={},errors={},limits={},
            note="Client observations only: HP change/removal is not proof of server kill, loot, EXP, attribution or infinite stamina."}
        local start=os.clock();local lastMap,lastMain,seenLogs={},{},{};local watched={};local connections={};local running=true
        local npcIds,nextNpcId={},0
        local lastSlow=-100;local lastSample=-100;local lastUI=-100;local ticks=0;local lastTick=start
        local function time() return math.floor((os.clock()-start)*1000)/1000 end
        local function errorRow(where,err) if #rec.errors<50 then rec.errors[#rec.errors+1]={time=time(),where=where,error=str(err,700)} else rec.limits.errors=true end end
        local function emit(kind,record)
            if #rec.events>=6000 then rec.limits.events=true;return end
            record.kind=kind;record.time=time();rec.events[#rec.events+1]=record
        end
        local function attrs(o)
            local result={};if not o then return result end
            local ok,a=pcall(function() return o:GetAttributes() end)
            if ok then local n=0;for k,v in pairs(a) do n=n+1;if n>40 then rec.limits.attributes=true;break end;result[str(k,100)]=value(v) end end
            return result
        end
        local function xyz(p)
            if not p then return nil end
            local ok,v=pcall(function() return p.Position end)
            if ok and v then return {x=v.X,y=v.Y,z=v.Z} end
        end
        local function watchSignal(signal,fn)
            if not signal then return end
            local ok,c=pcall(function() return signal:Connect(function(...)
                if not running or not state.alive then return end
                local success,err=pcall(fn,...);if not success then errorRow("event",err) end
            end) end)
            if ok then connections[#connections+1]=c end
        end
        local function localData()
            local root=resolveNames(RS,{"Player_Service","Data",LP.Name});local slot=root and root:FindFirstChild("slotEquipped")
            return slot and resolveNames(root,{"slots","Slot"..tostring(slot.Value)})
        end
        local function addValues(map,root,label,limit,depthLimit)
            if not root then map[label.."/@missing"]=true;return end
            local q={{o=root,depth=0,key=label}};local head=1;local count=0
            while head<=#q and count<limit do
                local entry=q[head];head=head+1;count=count+1;local o=entry.o
                if o:IsA("ValueBase") then
                    local ok,v=pcall(function() return o.Value end)
                    if ok then map[entry.key]=value(v) end
                    for _,key in ipairs({"MinValue","MaxValue"}) do local ok,v=pcall(function() return o[key] end);if ok and v~=nil then map[entry.key.."/"..key]=value(v) end end
                end
                if entry.depth<depthLimit then
                    for _,child in ipairs(o:GetChildren()) do
                        local lower=child.Name:lower()
                        local roster=label:sub(1,5)=="Mode/" and (lower=="players" or lower=="playerdata" or lower=="members" or lower=="roster")
                        if not roster then
                            if #q<limit then q[#q+1]={o=child,depth=entry.depth+1,key=entry.key.."/"..child.Name} else rec.limits[label]=true end
                        end
                    end
                elseif #o:GetChildren()>0 then rec.limits[label.."Depth"]=true end
            end
            if head<=#q then rec.limits[label]=true end
        end
        local function mainSample()
            local hub=env.CAMMainHub
            if type(hub)~="table" then return {present=false} end
            local report=type(hub.Snapshot)=="function" and hub.Snapshot() or {}
            local s=report.state or hub.State or {};local f=report.farm or {}
            local m={present=true,version=hub.Version,status=s.status,autoLevel=s.autoLevel,farm=s.farm,attack=s.attack,
                questStage=s.questStage,questName=s.questName,questProgress=s.questProgress,equipment=s.equipment,
                hpStop=s.healthStop,noDamageTimeout=s.noDamageTimeout,backend=f.backend,level=f.level,
                requests=f.requests,comboAcks=f.comboAcks,damageObservations=f.damageObservations,target=report.target}
            for _,entry in ipairs(report.log or {}) do
                local key=tostring(entry.time).."|"..tostring(entry.kind).."|"..tostring(entry.text)
                if not seenLogs[key] then
                    seenLogs[key]=true
                    if #rec.mainLogs<500 then rec.mainLogs[#rec.mainLogs+1]={observedAt=time(),time=entry.time,kind=entry.kind,text=entry.text} else rec.limits.mainLogs=true end
                end
            end
            if m.status~=lastMain.status or m.autoLevel~=lastMain.autoLevel or m.questStage~=lastMain.questStage or m.present~=lastMain.present then
                if #rec.mainTransitions<350 then
                    local why=lastMain.autoLevel==true and m.autoLevel==false and "AutoLevel transitioned ON -> OFF" or "Main state changed"
                    rec.mainTransitions[#rec.mainTransitions+1]={time=time(),reason=why,before=lastMain,after=m}
                else rec.limits.mainTransitions=true end
            end
            lastMain=m;return m
        end
        local function guiSnapshot()
            local root=LP:FindFirstChild("PlayerGui");local rows={};if not root then return rows end
            local queue={{o=root,visible=true}};local head=1;local walked=0
            while head<=#queue and walked<6000 do
                local e=queue[head];head=head+1;walked=walked+1;local o=e.o;local p=path(o);local lower=p:lower()
                local own=lower:find("cam_main",1,true) or lower:find("cam_debug",1,true) or o==Lumen.State.Screen
                local private=lower:find("chat",1,true) or lower:find("playerlist",1,true) or o:IsA("TextBox")
                if not own and not private then
                    local visible=e.visible
                    if o:IsA("GuiObject") then visible=visible and o.Visible elseif o:IsA("ScreenGui") then visible=visible and o.Enabled end
                    local groups=mechanismGroups(p)
                    if visible and #groups>0 and (o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("Frame") or o:IsA("ImageButton")) then
                        if #rows<180 then rows[#rows+1]={path=p,class=o.ClassName,groups=groups,properties=properties(o,{"Text","Visible","Position","Size","AbsolutePosition","AbsoluteSize"})}
                        else rec.limits.uiRows=true end
                    end
                    for _,child in ipairs(o:GetChildren()) do if #queue<6000 then queue[#queue+1]={o=child,visible=visible} else rec.limits.uiWalk=true end end
                end
            end
            if head<=#queue then rec.limits.uiWalk=true end
            return rows
        end
        local function npcSample()
            local root=workspace:FindFirstChild("Humanoids")
            if not root then return {missingRoot=true,note="Workspace.Humanoids is unavailable; no full map scan performed"} end
            local c=LP.Character;local myRoot=c and c:FindFirstChild("HumanoidRootPart")
            local q={root};local head=1;local candidates={}
            while head<=#q and head<=4000 do
                local o=q[head];head=head+1
                if o:IsA("Humanoid") then
                    local model=o.Parent
                    if model and model~=c and not Players:GetPlayerFromCharacter(model) then
                        local p=model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
                        local distance=myRoot and p and (myRoot.Position-p.Position).Magnitude or math.huge
                        if distance<200 then candidates[#candidates+1]={model=model,h=o,p=p,distance=distance} end
                    end
                elseif o:IsA("Folder") or o:IsA("Model") or o==root then
                    for _,child in ipairs(o:GetChildren()) do if #q<4000 then q[#q+1]=child else rec.limits.npcWalk=true end end
                end
            end
            if head<=#q then rec.limits.npcWalk=true end
            table.sort(candidates,function(a,b) return a.distance<b.distance end)
            local rows={}
            for i=1,math.min(12,#candidates) do
                local n=candidates[i];local model,h,p=n.model,n.h,n.p
                local owner="unavailable";local fn=isnetworkowner or env.isnetworkowner
                if type(fn)=="function" and p then local ok,v=pcall(fn,p);if ok then owner=v and "local client" or "not local client" end end
                if not npcIds[model] then nextNpcId=nextNpcId+1;npcIds[model]=nextNpcId end
                local row={id=npcIds[model],path=path(model),name=model.Name,distance=n.distance,position=xyz(p),health=h.Health,maxHealth=h.MaxHealth,attributes=attrs(model),ownership=owner,
                    root=properties(p or model,{"Anchored","AssemblyLinearVelocity"}),humanoid=properties(h,{"PlatformStand","Sit","BreakJointsOnDeath"})}
                rows[#rows+1]=row
                if watched[model] then watched[model].health=row.health end
                if not watched[model] and rec.npcWatchCount~=nil and rec.npcWatchCount>=50 then rec.limits.npcWatches=true
                elseif not watched[model] then
                    watched[model]={health=row.health};rec.npcWatchCount=(rec.npcWatchCount or 0)+1
                    watchSignal(h.HealthChanged,function(hp) watched[model].health=hp;emit("npcHealth",{id=row.id,path=path(model),health=hp,position=xyz(p)}) end)
                    watchSignal(h.Died,function() emit("npcDiedEvent",{id=row.id,path=path(model),note="Client event, not confirmation of server reward"}) end)
                    watchSignal(model.AncestryChanged,function()
                        if not model:IsDescendantOf(workspace) then emit("npcNoLongerInWorkspace",{id=row.id,path=row.path,lastObservedHealth=watched[model].health,note="Not proof of death or reward"}) end
                    end)
                    local animator=h:FindFirstChildOfClass("Animator")
                    if animator then watchSignal(animator.AnimationPlayed,function(track)
                        local anim=track.Animation
                        emit("npcAnimation",{id=row.id,path=path(model),name=track.Name,animationId=anim and anim.AnimationId or nil,length=track.Length,speed=track.Speed})
                    end) end
                end
            end
            return rows
        end
        local function tick()
            local now=os.clock();ticks=ticks+1
            if now-lastTick>2 then emit("samplingGap",{seconds=now-lastTick}) end;lastTick=now
            local d=localData();local c=LP.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local root=c and c:FindFirstChild("HumanoidRootPart")
            local map={}
            addValues(map,resolveNames(RS,{"Player_Service","Values",LP.Name}),"Values",350,4)
            addValues(map,LP:FindFirstChild("Items_Config"),"Equipped",30,2)
            addValues(map,LP:FindFirstChild("MenuDestination"),"Menu",3,0)
            for _,name in ipairs({"Exp","Wen","Race","Quests","Powers","SkillTreeUnlockedList"}) do addValues(map,d and d:FindFirstChild(name),name,name=="Quests" and 220 or 100,6) end
            addValues(map,c and c:FindFirstChild("SHC"),"SHC",20,2);addValues(map,c and c:FindFirstChild("SHCS"),"SHCS",20,2)
            addValues(map,resolveNames(RS,{"CAM","Client","Controllers","Skills_Provider","CurPower"}),"CurPower",3,0)
            local modeRoots=0
            for _,container in ipairs({RS,LP}) do
                for _,child in ipairs(container:GetChildren()) do
                    local n=child.Name:lower()
                    if (child:IsA("Folder") or child:IsA("Configuration") or child:IsA("ValueBase")) and
                        (n:find("minigame",1,true) or n:find("gamestate",1,true) or n:find("round",1,true) or n:find("queue",1,true) or n:find("wave",1,true)) then
                        modeRoots=modeRoots+1
                        if modeRoots<=6 then addValues(map,child,"Mode/"..container.Name.."/"..child.Name,80,3) else rec.limits.modeRoots=true end
                    end
                end
            end
            if h then map["Character/Health"]=h.Health;map["Character/MaxHealth"]=h.MaxHealth;map["Character/WalkSpeed"]=h.WalkSpeed end
            for label,obj in pairs({Player=LP,Character=c,World=workspace,Replicated=RS}) do for k,v in pairs(attrs(obj)) do map[label.."/@"..k]=v end end
            for k,v in pairs(map) do if type(v)=="table" then local ok,s=pcall(function() return Http:JSONEncode(v) end);map[k]=ok and s or tostring(v) end end
            for k,v in pairs(map) do if lastMap[k]~=v then emit(lastMap[k]==nil and "initialOrAddedValue" or "valueChanged",{path=k,value=v,previous=lastMap[k]}) end end
            for k,v in pairs(lastMap) do if map[k]==nil then emit("valueRemoved",{path=k,previous=v}) end end
            lastMap=map
            if now-lastSample>=1 then
                lastSample=now
                local ok,main=pcall(mainSample);if not ok then errorRow("mainSnapshot",main);main={error=str(main,300)} end
                local row={time=time(),main=main,position=xyz(root),humanoid=h and properties(h,{"Health","MaxHealth","WalkSpeed","PlatformStand","Sit"}) or {},
                    stamina=map["Values/Stamina"],staminaMax=map["Values/Stamina/MaxValue"],exp=map["Exp/Current"],expGoal=map["Exp/Goal"],wen=map.Wen}
                if now-lastSlow>=2 then lastSlow=now;local ok,result=pcall(npcSample);if ok then row.npcs=result else errorRow("NPC sample",result) end end
                if #rec.samples<100 then rec.samples[#rec.samples+1]=row else rec.limits.samples=true end
            end
            if now-lastUI>=15 then lastUI=now;local ok,rows=pcall(guiSnapshot);if ok then rec.uiSnapshots[#rec.uiSnapshots+1]={time=time(),rows=rows} else errorRow("UI snapshot",rows) end end
            state.recordRemaining=math.max(0,math.ceil(90-(now-start)))
            if countLabel then pcall(function() countLabel:SetText("Recording: "..state.recordRemaining.."s left | "..#rec.events.." changes | keep using the game") end) end
        end
        local portal=resolveNames(RS,{"Communication","CnC","NotEnoughStamina"})
        if portal and portal:IsA("BindableEvent") then watchSignal(portal.Event,function(amount) emit("NotEnoughStamina",{amount=value(amount)}) end) end
        local handle={report=rec,done=false}
        local function close()
            if not running then return end
            running=false
            for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
            rec.durationActual=time();rec.ticks=ticks;rec.finishedEarly=state.requestFinish==true or not state.alive
            rec.incomplete=rec.finishedEarly or next(rec.limits)~=nil or #rec.errors>0
            handle.done=true
        end
        handle.stop=close
        handle.thread=task.spawn(function()
            local ok,err=pcall(function()
                while running and state.alive and not state.requestFinish and os.clock()-start<90 do
                    local good,e=pcall(tick);if not good then errorRow("tick",e) end
                    task.wait(0.5)
                end
            end)
            if not ok then errorRow("recorder",err) end
            close()
        end)
        return handle
    end
    local function enrichDiscovery(report,discovery)
        report.discovery=discovery
        if discovery.limitReached or discovery.selectionLimitReached or discovery.remoteLimitReached or discovery.referenceLimitReached or #discovery.errors>0 then
            report.stats.incomplete=true;report.stats.discoveryIncomplete=true
        end
        state.scannedPaths=state.scannedPaths or {}
        for _,scriptRecord in ipairs(report.scripts or {}) do state.scannedPaths[scriptRecord.path]=true end
    end
    local function collectOneClick()
        if state.oneClickRunning or state.busy or state.exporting then notify("Collection/export already running") return end
        state.oneClickRunning=true;state.requestFinish=false;state.cancel=false;state.scannedPaths={};state.latePass=false
        task.spawn(function()
            local ok,err=pcall(function()
                local started=os.clock();state.sourceDeadline=started+85
                state.beforeDiagnostic=runtimeSnapshot()
                state.recorder=recordMechanics()
                cfg.maxNodes=500;cfg.maxSources=350
                local passes={}
                local function sourcePass(label)
                    state.extraFocusRoots,state.focusDiscovery=discoverFocusedRoots()
                    if #state.extraFocusRoots==0 then
                        local empty={pass=label,scripts={},stats={sourcesCollected=0,sourceBytes=0,incomplete=false},note="No additional selected source in this pass"}
                        enrichDiscovery(empty,state.focusDiscovery);passes[#passes+1]=empty;return
                    end
                    state.report=nil;scan("core")
                    while state.busy and state.alive do task.wait(0.1) end
                    if not state.report then error("Source scan returned no report") end
                    local r=state.report;r.format="CAM Mechanics Sources 1.7";r.pass=label;enrichDiscovery(r,state.focusDiscovery);passes[#passes+1]=r
                end
                sourcePass("initial")
                while state.alive and not state.recorder.done do task.wait(0.1) end
                if not state.alive then return end
                if not state.requestFinish then
                    state.latePass=true;state.sourceDeadline=os.clock()+25;cfg.maxSources=80
                    sourcePass("late: newly appeared or previously uncollected scripts")
                end
                local report={format="CAM Mechanics Recorder OneClick 1.7",createdUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),
                    game={placeId=game.PlaceId,universeId=game.GameId,placeVersion=game.PlaceVersion},
                    purpose="Remaining mechanic implementations and intermittent main STOP diagnosis; passive evidence, not bypass testing",
                    runtimeBefore=state.beforeDiagnostic,runtimeAfter=runtimeSnapshot(),recording=state.recorder.report,sourcePasses=passes,
                    stats={durationSeconds=os.clock()-started,sourcesCollected=0,sourceBytes=0,incomplete=state.recorder.report.incomplete},
                    logs=table.clone(state.logs),
                    capabilities={writefile=type(fileWriter)=="function",clipboard=type(clipboard)=="function",decompile=type(decompiler)=="function",
                        getsenv=type(getsenv or env.getsenv)=="function",isnetworkowner=type(isnetworkowner or env.isnetworkowner)=="function"},
                    limitations={"Only client-visible state and replicated source; inaccessible server handlers are not recovered.",
                        "No require, attacks, purchases, remote calls, outgoing interception, stat modification or NPC deletion.",
                        "Recording observes user/main actions; it does not perform the demonstrated actions for you.",
                        "Record separately after entering another mode/place. The collector does not persist across teleport.",
                        "Sources/models/packages and trace fields have documented bounds; incomplete flags describe limits, not full game coverage.",
                        "Known unrelated sources on the same place/version may be referenced rather than copied. Decompilation is unverified.",
                        "Logs and game source can contain private data; review before sharing. No HTTP upload is performed."}}
                for _,pass in ipairs(passes) do
                    report.stats.sourcesCollected=report.stats.sourcesCollected+(pass.stats.sourcesCollected or 0)
                    report.stats.sourceBytes=report.stats.sourceBytes+(pass.stats.sourceBytes or 0)
                    if pass.stats.incomplete then report.stats.incomplete=true end
                end
                state.report=report
                local text=encodeSafe(report);if text and state.alive then deliverText(text) end
            end)
            if state.recorder and not state.recorder.done then state.recorder.stop() end
            state.oneClickRunning=false
            if not ok and state.alive then
                pushLog("Mechanics collection failed: "..str(err,2000),"Error","collector")
                -- Preserve observations even if discovery or source collection failed.
                local partial={format="CAM Mechanics Recorder OneClick 1.7",error=str(err,3000),stats={incomplete=true},
                    runtimeBefore=state.beforeDiagnostic,recording=state.recorder and state.recorder.report,partialSourcePass=state.report,logs=table.clone(state.logs)}
                state.report=partial;local text=encodeSafe(partial);if text then deliverText(text) end
                notify("Partial report saved where possible; collector error is included")
            end
        end)
    end
    Lumen.Folder="cam_mechanics_debug"
    Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="CAM Debug | MECHANICS + STOP TRACE",Version="1.7",Footer="Passive recording | RightShift menu | no gameplay changes",Keybind=Enum.KeyCode.RightShift,Size=UDim2.fromOffset(860,560),SettingsPage=false})
    local p=window:Page({Name="one click",Columns=1,Group="debug"})
    local sec=p:Section({Name="mechanics / auto-level stop reasons",Side=1})
    statusLabel=sec:Label("Ready. Keep CAM Main loaded. It may continue farming during recording.")
    countLabel=sec:Label("Press once -> act normally for 90 seconds -> automatic JSON save + copy")
    sec:Button({Name="START 90s + COLLECT + SAVE + COPY",Callback=collectOneClick})
    sec:Label("Use the game: farm, run/dash, block, fish or open the relevant menu.")
    sec:Label("Main OFF transitions, HP/stamina/EXP, quests, nearby NPCs and animations.")
    sec:Label("Fishing, training, skills, shops, queues, waves/cards and current-mode scripts.")
    sec:Label("Records available sources initially and checks for newly appeared scripts at the end.")
    sec:Label("No purchases, attacks, require(), hooks, remote requests, stat edits or HTTP upload.")
    sec:Label("Finish can take ~25 more seconds for late sources. Limits/errors are reported.")
    sec:Label("Send CAM_Debug_Mechanics_*.json from your executor workspace.")
    sec:Button({Name="FINISH NOW - save partial recording",Callback=function()
        state.requestFinish=true;state.cancel=true
        if state.sourceTask then pcall(task.cancel,state.sourceTask) end
    end})
    sec:Button({Name="Save + copy last report again",Callback=function()
        if state.busy or state.exporting or state.oneClickRunning then notify("Wait for collection") return end
        if not state.report then notify("Record first") return end
        local text=encodeSafe(state.report);if text then deliverText(text) end
    end})
    sec:Button({Name="Unload debug",Callback=function() Lumen:Unload() end})
    notify("Mechanics recorder ready. Press START once; keep main loaded to capture its STOP reason.")
end
RunCollector(Lumen)
