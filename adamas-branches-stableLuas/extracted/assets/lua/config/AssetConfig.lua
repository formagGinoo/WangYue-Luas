AssetConfig = AssetConfig or {}

-- init
-- AssetConfig.font = "Font/wqy.ttf"
AssetConfig.font_syht_medium = "Font/syht_medium.ttf"
AssetConfig.syht_heavy = "Font/syht_heavy.ttf"
AssetConfig.font_android = "Font/wqy_android.ttf"
AssetConfig.carp = "Font/carp.OTF"
AssetConfig.unlit_texture_shader = "Shaders/UnlitTexture.shader"
AssetConfig.UnlitTransparentCutout = "Shaders/UnlitTransparentCutout.shader"

AssetConfig.wwiseEventBank = "Sound/_WwiseEventBank.asset"

AssetConfig.graphic = "Scene/Scene10020001/GraphicAssets/Block/GraphicManager_10020001.prefab" 

AssetConfig.runtimeSVC = "Shaders/RuntimeSVC/RuntimeShaderVariant.shadervariants" 


-- Demo
AssetConfig.demo_window_prefab = "Prefabs/UI/Demo/DemoWindow.prefab"
AssetConfig.demo_map_path = "Textures/Maps/10001/map%s_%s.jpg"
AssetConfig.demo_scence_element_path = "Prefabs/Single/SceneElement/SceneElements.prefab"
AssetConfig.uicyclescroll_panel_prefab = "Prefabs/UI/Demo/TestCycleScrollPanel.prefab"
AssetConfig.uigrid_panel_prefab = "Prefabs/UI/Demo/TestGridPanel.prefab"
AssetConfig.uihv_panel_prefab = "Prefabs/UI/Demo/TestHVPanel.prefab"
AssetConfig.uitab_panel_prefab = "Prefabs/UI/Demo/TestTabPanel.prefab"
AssetConfig.uitween_panel_prefab = "Prefabs/UI/Demo/TestTweenPanel.prefab"
AssetConfig.uipreview_panel_prefab = "Prefabs/UI/Demo/TestPreviewPanel.prefab"
AssetConfig.uitest_window_prefab = "Prefabs/UI/Demo/UITestMailWindow.prefab"
AssetConfig.demo_multiple_icon_task = "Textures/Icon/Mutliple/Task.png"
AssetConfig.sound_effct_214_path = "Sound/Effect/214.ogg"

-- Login
AssetConfig.login_window_prefab = "Prefabs/UI/Login/LoginWindow.prefab"
AssetConfig.loading_page_bg = "Textures/BigBgPref/LoadingPageBg.prefab"
AssetConfig.loading_logo = "Textures/BigBgPref/I18NLogo_fswy.prefab"
AssetConfig.login_bg = "Textures/BigBgOrigin/MainBg%s.png"
AssetConfig.login_spine = "Prefabs/UI/Login/LoginSceneNode.prefab"

-- FightDebug
AssetConfig.main_debug = "Prefabs/UI/FightDebug/MainDebug.prefab"
AssetConfig.debug_map_list = "Prefabs/UI/FightDebug/DebugMapList.prefab"
AssetConfig.debug_game_speed = "Prefabs/UI/FightDebug/DebugGameSpeed.prefab"
AssetConfig.debug_show_terrain = "Prefabs/UI/FightDebug/DebugShowTerrain.prefab"
AssetConfig.debug_map_window = "Prefabs/UI/FightDebug/DebugFightMap.prefab"

AssetConfig.gate_map_ui = "Prefabs/UI/FightDebug/GateMap.prefab"
AssetConfig.gate_detail_ui = "Prefabs/UI/FightDebug/GateDetail.prefab"


-- FightMainUI
AssetConfig.fight_main_ui = "Prefabs/UI/Fight/FightMainUI.prefab"
AssetConfig.fight_tips = "Prefabs/UI/Fight/FightTips/FightTips.prefab"

-- Scene
AssetConfig.sceneelements = "Prefabs/Single/SceneElement/SceneElements.prefab"

-- Effect
AssetConfig.effect_path = "Effect/Prefab/%s.prefab"

-- Gm
AssetConfig.gm_window = "Prefabs/UI/Gm/GmWindow.prefab"

-- Slot
AssetConfig.item_slot = "Prefabs/UI/Slot/ItemSlot.prefab"

-- Backpack
AssetConfig.backpack_main = "Prefabs/UI/Backpack/BackpackMainWindow.prefab"

--spine prefix
AssetConfig.spine_prefix_path = "Spine/Prefabs/%s.prefab"

AssetConfig.fightTalkOptionIcon = "Textures/Icon/Mutliple/FightTalkOption.png"

AssetConfig.ui_bank = "UI_Common_SBK"
AssetConfig.npc_common_bank = "NPCCommon_SBK"
AssetConfig.action_bank = "Action_SBK"
AssetConfig.terrain_bank = "Terrain_SBK"
AssetConfig.bgm_logic_bank = "Bgm_Logic"

AssetConfig.quality_data = "AssetsData/Default_QualityLevelData.asset"

AssetConfig.terrain_data = "Prefabs/Scene/Scene10020001/HworldAssets/HWorldAssets.prefab"

function AssetConfig.GetWorldBlockData()
	local platform = Application.platform 
	if Application.platform == RuntimePlatform.Android or platform == RuntimePlatform.IPhonePlayer then
    	return "Scene/Scene10020001/Mobile/MapData/BlockData.asset"
    else
    	return "Scene/Scene10020001/PC/MapData/BlockData.asset"
    end
end

function AssetConfig.GetSkillIcon(iconId)
	return string.format("Textures/Icon/Single/SkillIcon/%s.png", iconId)
end

function AssetConfig.GetBehaviorSkillIcon(iconId)
	return string.format("Textures/Icon/Atlas/BehaviorSkillIcon/%s.png", iconId)
end
function AssetConfig.GetSmallHeadIcon(iconId)
	return string.format("Textures/Icon/Single/SmallHeadIcon/%d.png", iconId)
end

function AssetConfig.GetItemIcon(iconId)
	return string.format("Textures/Icon/Single/ItemIcon/%s.png", iconId)
end

function AssetConfig.GetQualityIcon(iconId)
	return string.format("Textures/Icon/Single/QualityIcon/%s.png", iconId)
end

function AssetConfig.GetQualityCardRogueIcon(iconId)
	return string.format("Textures/Icon/Atlas/RogueQualityIcon/card/%s.png", iconId)
end

function AssetConfig.GetQualitySlideRogueIcon(iconId)
	return string.format("Textures/Icon/Atlas/RogueQualityIcon/slide/%s.png", iconId)
end

function AssetConfig.GetNightMareQualityIcon(quality)
	return string.format("Textures/Icon/Atlas/NightmareIcon/buffQuality%s.png", quality)
end

function AssetConfig.GetElementIcon(iconId)
	return string.format("Textures/Icon/Single/ElementIcon/%s_little.png", iconId)
end

function AssetConfig.GetElementWeakIcon(iconId)
	return string.format("Textures/Icon/Single/ElementIcon/%s_weak.png", iconId)
end

function AssetConfig.GetCoopCharacterAndName(character)
	local img = string.format("Textures/Icon/Single/CoopIcon/%s.png", character)
	local name = string.format("Textures/Icon/Single/CoopIcon/name%s.png", character)
	return img, name
end

function AssetConfig.GetDialogIcon(iconId)
	return string.format("Textures/Icon/Single/DialogIcon/%s.png", iconId)
end

function AssetConfig.GetHeroIcon(roleId)
	return string.format("Textures/Icon/Single/HerolistIcon/%s.png", roleId)
end

function AssetConfig.GetTaskTypeIcon(taskType)
	return string.format("Textures/Icon/Single/TaskIcon/newtaskIcon_%s.png", taskType)
end

function AssetConfig.GetInteractionTypeIcon(InteractionType)
	return SystemConfig.GetIconConfig("interaction_"..InteractionType).icon1
end

function AssetConfig.GetPartnerSkillQuality(quality)
    return string.format("Textures/Icon/Atlas/PartnerQualityIcon/%s.png", quality)
end