
�
ability_roulette.proto"J
struct_ability_roulette
pos (Rpos

ability_id (R	abilityId"P
struct_ability_roulette_partner
id (Rid

partner_id (R	partnerId"�
resp_ability_roulette_infoL
ability_roulette_list (2.struct_ability_rouletteRabilityRouletteListC
partner_list (2 .struct_ability_roulette_partnerRpartnerList
use_id (RuseId&
ability_id_list (RabilityIdList"1
req_ability_roulette_use
use_id (RuseId"Z
req_ability_roulette_change;
ability_list (2.struct_ability_rouletteRabilityList"a
#req_ability_roulette_partner_change:
partner (2 .struct_ability_roulette_partnerRpartnerbproto3
�
activity.proto"L
struct_activity_task
task_id (RtaskId
	is_finish (RisFinish"
req_activity_info"�
resp_activity_info
value (Rvalue

control_id (R	controlId2
	task_list (2.struct_activity_taskRtaskList
can_get (RcanGet
has_get (RhasGet"5
req_activity_award
award_value (R
awardValue"U
resp_activity_award

error_code (R	errorCode
award_value (R
awardValuebproto3
`
adventure.proto"
req_adventure"4
resp_adventure
lev (Rlev
exp (Rexpbproto3
�
struct_common.proto"3
	struct_kv
key (Rkey
value (Rvalue";
struct_progress
id (Rid
current (Rcurrent"P
struct_position
pos_x (RposX
pos_y (RposY
pos_z (RposZ"S
struct_client_cache
	cache_key (	RcacheKey
cache_value (	R
cacheValuebproto3
�
alchemy.protostruct_common.proto"S
struct_solution
left (2
.struct_kvRleft 
right (2
.struct_kvRright"�
struct_alchemy_formula

formula_id (R	formulaId1
history_yin (2.struct_solutionR
historyYin3
history_yang (2.struct_solutionRhistoryYang9
history_balance (2.struct_solutionRhistoryBalance"
req_alchemy_info"O
resp_alchemy_info:
formula_list (2.struct_alchemy_formulaRformulaList"p
req_alchemy

formula_id (R	formulaId,
solution (2.struct_solutionRsolution
count (Rcount"L
resp_alchemy

error_code (R	errorCode

formula_id (R	formulaIdbproto3
�
struct_asset_center.protostruct_common.proto"�
struct_asset_center_build_info
asset_id (RassetId
level (RlevelM
decoration_list (2$.struct_asset_center_decoration_infoRdecorationList>
decoration_count_list (2
.struct_kvRdecorationCountList
pos_info (	RposInfo!
partner_list (RpartnerList"�
(struct_asset_center_decoration_work_info!
partner_list (RpartnerList*
last_refresh_time (RlastRefreshTime
work_id (RworkId
work_amount (R
workAmount

work_value (R	workValue#
finish_amount (RfinishAmount

product_id (R	productId'
	food_list (2
.struct_kvRfoodList"�
#struct_asset_center_decoration_info
id (Rid
template_id (R
templateId
pos_info (	RposInfoF
	work_info (2).struct_asset_center_decoration_work_infoRworkInfo"�
struct_asset_center_work_update
asset_id (RassetIdM
decoration_list (2$.struct_asset_center_decoration_infoRdecorationListbproto3
�
asset_center.protostruct_asset_center.protostruct_common.proto"p
req_asset_center_buy_asset0
purchase_template_id (RpurchaseTemplateId 
show_id_list (R
showIdList"�
req_asset_center_buy_decoration
asset_id (RassetId4
decoration_template_id (RdecorationTemplateId
amount (Ramount"n
&req_asset_center_change_decoration_pos
asset_id (RassetId
id (Rid
pos_info (	RposInfo"<
req_asset_center_asset_level_up
asset_id (RassetId"�
req_asset_partner_skill_unlock

partner_id (R	partnerId
skill_id (RskillId*
assist_partner_id (RassistPartnerId"o
"resp_asset_center_asset_build_listI
asset_build_list (2.struct_asset_center_build_infoRassetBuildList"�
!resp_asset_center_decoration_list
asset_id (RassetIdM
decoration_list (2$.struct_asset_center_decoration_infoRdecorationList"�
'resp_asset_center_decoration_count_list
asset_id (RassetId>
decoration_count_list (2
.struct_kvRdecorationCountList"v
%resp_asset_center_decoration_bag_listM
decoration_list (2$.struct_asset_center_decoration_infoRdecorationList"G
,resp_asset_center_decoration_bag_list_del_id
only_id (RonlyId"m
+resp_asset_center_decoration_bag_count_list>
decoration_count_list (2
.struct_kvRdecorationCountList"P
resp_asset_center_build_level
asset_id (RassetId
level (Rlevel"�
req_asset_center_work_set
asset_id (RassetId#
decoration_id (RdecorationId!
partner_list (RpartnerList
work_id (RworkId
work_amount (R
workAmount

product_id (R	productId"\
req_asset_center_partner_set
asset_id (RassetId!
partner_list (RpartnerList"�
!req_asset_center_work_partner_set
asset_id (RassetId#
decoration_id (RdecorationId!
partner_list (RpartnerList"�
%req_asset_center_work_partner_replace
asset_id (RassetId#
decoration_id (RdecorationId$
old_partner_id (RoldPartnerId$
new_partner_id (RnewPartnerId"^
req_asset_center_work_cancel
asset_id (RassetId#
decoration_id (RdecorationId"]
req_asset_center_work_fetch
asset_id (RassetId#
decoration_id (RdecorationId"�
req_asset_center_food_set
asset_id (RassetId#
decoration_id (RdecorationId'
	food_list (2
.struct_kvRfoodList"b
resp_asset_center_work_updateA
update_list (2 .struct_asset_center_work_updateR
updateListbproto3
�
asset.proto"Q
resp_energy_info
energy (Renergy%
next_timestamp (RnextTimestamp"�
resp_role_asset_info
gold (Rgold!
bind_diamond (RbindDiamond
diamond (Rdiamond
power (Rpower'
mercenary_medal (RmercenaryMedal#
gundam_copper (RgundamCopper
city_copper (R
cityCopper*
skill_book_copper (RskillBookCopper
paota_hexin	 (R
paotaHexin"�
resp_role_virtual_itemK
virtual_item (2(.resp_role_virtual_item.VirtualItemEntryRvirtualItem>
VirtualItemEntry
key (Rkey
value (Rvalue:8bproto3
�
bargain.proto"{
struct_bargain!
negotiate_id (RnegotiateId#
bargain_count (RbargainCount!
latest_point (RlatestPoint"G
resp_bargain_list2
bargain_list (2.struct_bargainRbargainList"�
req_bargain_check_seq
type (Rtype
	relate_id (RrelateId!
negotiate_id (RnegotiateId
npc_seq (RnpcSeq

client_seq (R	clientSeq%
original_point (RoriginalPoint"�
resp_bargain_point_info#
bargain_count (RbargainCount%
original_point (RoriginalPoint!
negotiate_id (RnegotiateId"L
req_bargain_remove_effect
type (Rtype
	relate_id (RrelateIdbproto3
�
battle.proto"Y
req_battle_frame
frame_id (RframeId*

battle_opt (2.battle_optR	battleOpt"s
req_battle_verify
key_session (	R
keySession=
battle_frame_list (2.req_battle_frameRbattleFrameList*+

battle_opt
Move 	
Fight
Exitbproto3
�
bullet_chat.proto"a
struct_bullet_chat
	send_time (RsendTime
content (	Rcontent
color (Rcolor":
req_bullet_chat_history
timeline_id (R
timelineId"j
resp_bullet_chat_history
timeline_id (R
timelineId-
history (2.struct_bullet_chatRhistory"m
req_bullet_chat_send
timeline_id (R
timelineId4
bullet_chat (2.struct_bullet_chatR
bulletChatbproto3
�
city_operate.proto"u
"struct_city_operate_entrust_urgent

entrust_id (R	entrustId0
entrust_reward_grade (RentrustRewardGrade"�
struct_city_operate_store
store_id (RstoreId#
entrust_level (RentrustLevelS
entrust_urgent_list (2#.struct_city_operate_entrust_urgentRentrustUrgentList*
max_entrust_level (RmaxEntrustLevel"S
resp_city_operate_info9

store_list (2.struct_city_operate_storeR	storeList"�
&req_city_operate_entrust_level_setting
store_id (RstoreId#
entrust_level (RentrustLevel*
max_entrust_level (RmaxEntrustLevel"�
req_city_operate_entrust_enter
store_id (RstoreId

entrust_id (R	entrustId'
use_hero_id_list (RuseHeroIdList"h
req_city_operate_entrust_finish.
system_duplicate_id (RsystemDuplicateId
is_win (RisWinbproto3
�

client.protostruct_common.proto"0
req_heartbeat
client_time (R
clientTime"R
resp_heartbeat
client_time (R
clientTime
server_time (R
serverTime"�
req_client_login
account (	Raccount
type (Rtype
platform (	Rplatform
zone_id (RzoneId
channel_reg (R
channelReg
dispense_id (	R
dispenseId
	device_id (	RdeviceId
device_type (R
deviceType
user_id	 (	RuserId
ts
 (Rts
ticket (	Rticket
os_type (RosType
age (Rage
sdk_account (	R
sdkAccount
version (Rversion"�
resp_client_login
flag (Rflag
msg (	Rmsg)
server_timestamp (RserverTimestamp
timezone (Rtimezone
uid (Ruid"
req_client_quit"1
resp_client_quit

error_code (R	errorCode"3
req_client_file_record
rec_list (	RrecList"�
resp_client_cmd
order_id (RorderId
cmd (Rcmd
notice_code (R
noticeCode
module (	Rmodule
line (Rline
args (	Rargs"
resp_client_replace"L
req_client_cache_list3

cache_list (2.struct_client_cacheR	cacheList"M
resp_client_cache_list3

cache_list (2.struct_client_cacheR	cacheList"6
req_client_inner_time

inner_time (R	innerTime"7
resp_client_inner_time

inner_time (R	innerTimebproto3
�
condition.proto"%
req_condition_state
id (Rid"[
resp_condition_state

error_code (R	errorCode
id (Rid
state (Rstatebproto3
�
crime.proto"5
req_crime_add_bounty

crime_type (R	crimeType"�
resp_crime_bountyC
bounty_info (2".resp_crime_bounty.BountyInfoEntryR
bountyInfo=
BountyInfoEntry
key (Rkey
value (Rvalue:8"7
req_crime_prison_game_finish
game_id (RgameId"J
req_crime_prison_info
state (Rstate
	prison_id (RprisonId"�
resp_crime_prison_info
state (Rstate
	prison_id (RprisonId!
bounty_value (RbountyValue
finish_game (R
finishGamebproto3
�
daily_sign_in.proto"A
struct_sign_in
nth_day (RnthDay
status (Rstatus"X
struct_daily_sign_in
id (Rid0
status_list (2.struct_sign_inR
statusList"
req_daily_sign_in_info"]
resp_daily_sign_in_infoB
daily_sign_in_list (2.struct_daily_sign_inRdailySignInList"B
req_daily_sign_in_award
id (Rid
nth_day (RnthDaybproto3
�
dialog_reward.proto"�
resp_dialog_reward_infoM
group_id_maps (2).resp_dialog_reward_info.GroupIdMapsEntryRgroupIdMaps>
GroupIdMapsEntry
key (Rkey
value (Rvalue:8",
req_dialog_select
talk_id (RtalkId">
resp_dialog_reward_remove!
refresh_type (RrefreshType"4
resp_dialog_reward_unlock
talk_id (RtalkIdbproto3
�

draw.proto";
req_draw
draw_id (RdrawId
button (Rbutton"A
	resp_draw
draw_id (RdrawId
	item_list (RitemList"s
resp_draw_count
draw_id (RdrawId

draw_count (R	drawCount(
daily_draw_count (RdailyDrawCount"{
resp_draw_guarantee"
draw_group_id (RdrawGroupId#
current_count (RcurrentCount
	max_count (RmaxCount"6
req_draw_history"
draw_group_id (RdrawGroupId"L
struct_draw_history
item_id (RitemId
	timestamp (R	timestamp"p
resp_draw_history"
draw_group_id (RdrawGroupId7
history_list (2.struct_draw_historyRhistoryListbproto3
�
struct_duplicate.protostruct_common.proto"�
struct_duplicate_key!
duplicate_id (RduplicateId.
system_duplicate_id (RsystemDuplicateId*
task_duplicate_id (RtaskDuplicateId"�
struct_duplicate'
key (2.struct_duplicate_keyRkey

best_score (R	bestScore%
finished_times (RfinishedTimes
id (Rid"�
struct_duplicate_info.
system_duplicate_id (RsystemDuplicateId%
finished_times (RfinishedTimes

best_score (R	bestScore#
current_score (RcurrentScore'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList
	win_times (RwinTimes"�
struct_duplicate_best5
duplicate_best_key_type (RduplicateBestKeyType=
duplicate_best_key_sysdupid (RduplicateBestKeySysdupidT
duplicate_best_info_list (2.struct_duplicate_best_infoRduplicateBestInfoList"�
struct_duplicate_best_info.
system_duplicate_id (RsystemDuplicateId

best_score (R	bestScore
use_time (RuseTime

hp_percent (R	hpPercent'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList"�
 struct_duplicate_nightmare_final
round (Rround
layer (Rlayer
	old_layer (RoldLayer
	last_time (RlastTime
order (Rorder%
duplicate_rule (RduplicateRule
level (Rlevel"�
struct_nightmare_rank_info
user_id (RuserId
	user_name (	RuserName
score (Rscore
	hero_list (RheroList
frame (Rframebproto3
�
struct_item.proto"~
struct_item
	unique_id (RuniqueId
template_id (R
templateId
count (Rcount
	is_locked (RisLocked"h
struct_reward_show
	unique_id (RuniqueId
template_id (R
templateId
count (Rcountbproto3
�
duplicate.protostruct_common.protostruct_duplicate.protostruct_item.proto"Z
resp_duplicate_state_list=
duplicate_list (2.struct_duplicate_infoRduplicateList"�
resp_duplicate_enter_base.
system_duplicate_id (RsystemDuplicateId/
progress_list (2
.struct_kvRprogressList"
pos (2.struct_positionRpos(
rotate (2.struct_positionRrotate'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList"
req_duplicate_reset_base"
req_duplicate_quit_base"t
resp_duplicate_quit_base.
system_duplicate_id (RsystemDuplicateId(
rotate (2.struct_positionRrotate"N
req_duplicate_progress_base/
progress_list (2
.struct_kvRprogressList"m
req_duplicate_relive_pos_base"
pos (2.struct_positionRpos(
rotate (2.struct_positionRrotate"
req_duplicate_again_base"K
resp_duplicate_again_base.
system_duplicate_id (RsystemDuplicateId"�
req_duplicate_task_enter.
system_duplicate_id (RsystemDuplicateId(
rotate (2.struct_positionRrotate'
use_hero_id_list (RuseHeroIdList"�
req_duplicate_task_finish.
system_duplicate_id (RsystemDuplicateId.
kill_mon_list (2
.struct_kvRkillMonList
is_win (RisWin"�
resp_duplicate_task_finish.
system_duplicate_id (RsystemDuplicateId4
reward_list (2.struct_reward_showR
rewardList"�
req_duplicate_resource_enter.
system_duplicate_id (RsystemDuplicateId(
rotate (2.struct_positionRrotate'
use_hero_id_list (RuseHeroIdList"�
req_duplicate_resource_finish.
system_duplicate_id (RsystemDuplicateId.
kill_mon_list (2
.struct_kvRkillMonList
is_win (RisWin"�
resp_duplicate_resource_finish.
system_duplicate_id (RsystemDuplicateId4
reward_list (2.struct_reward_showR
rewardList"�
req_duplicate_nightmare_enter.
system_duplicate_id (RsystemDuplicateId(
rotate (2.struct_positionRrotate'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList"�
req_duplicate_nightmare_finish.
system_duplicate_id (RsystemDuplicateId.
kill_mon_list (2
.struct_kvRkillMonList
is_win (RisWin,
duplicate_use_time (RduplicateUseTime

hp_percent (R	hpPercent'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList"�
resp_duplicate_nightmare_finish.
system_duplicate_id (RsystemDuplicateId4
reward_list (2.struct_reward_showR
rewardList"j
req_duplicate_nightmare_reset
key_type (RkeyType.
system_duplicate_id (RsystemDuplicateId"k
resp_duplicate_nightmare_reset
key_type (RkeyType.
system_duplicate_id (RsystemDuplicateId"_
'req_duplicate_nightmare_get_score_award4
layer_score_list (2
.struct_kvRlayerScoreList"`
(resp_duplicate_nightmare_get_score_award4
layer_score_list (2
.struct_kvRlayerScoreList"a
)resp_duplicate_nightmare_layer_score_list4
layer_score_list (2
.struct_kvRlayerScoreList"�
"resp_duplicate_nightmare_best_list
type (RtypeF
duplicate_best_list (2.struct_duplicate_bestRduplicateBestList"z
#resp_duplicate_nightmare_final_infoS
nightmare_final_info (2!.struct_duplicate_nightmare_finalRnightmareFinalInfo";
req_duplicate_nightmare_rank
	rank_type (RrankType"�
resp_duplicate_nightmare_rank
	rank_type (RrankType8
	show_list (2.struct_nightmare_rank_infoRshowList2
rank_score_list (2
.struct_kvRrankScoreList"�
"resp_duplicate_city_operate_finish.
system_duplicate_id (RsystemDuplicateId4
reward_list (2.struct_reward_showR
rewardList
cost_energy (R
costEnergybproto3
�
ecosystem.protostruct_common.proto"L
struct_conclude_info 
probability (Rprobability
time (Rtime"�
struct_entity_born
id (Rid
reborn_time (R
rebornTime:
conclude_info (2.struct_conclude_infoRconcludeInfo"�
struct_ecosystem_drop
id (Rid(
item_template_id (RitemTemplateId

item_count (R	itemCount$
form_entity_id (RformEntityId
	dead_time (RdeadTime,
position (2.struct_positionRposition",
req_ecosystem_state
map_id (RmapId"�
resp_ecosystem_state
map_id (RmapId=
entity_born_list (2.struct_entity_bornRentityBornList9
unable_reborn_entity_list (RunableRebornEntityList3
	drop_list (2.struct_ecosystem_dropRdropList"Q
req_ecosystem_hit
id (Rid,
position (2.struct_positionRposition"}
*struct_ecosystem_hit_partner_conclude_info

partner_id (R	partnerId0
golden_conclude_time (RgoldenConcludeTime"�
resp_ecosystem_hit
id (Rid3
	drop_list (2.struct_ecosystem_dropRdropList_
partner_conclude_info (2+.struct_ecosystem_hit_partner_conclude_infoRpartnerConcludeInfo

error_code (R	errorCode"m
resp_ecosystem_update
map_id (RmapId=
entity_born_list (2.struct_entity_bornRentityBornList"F
resp_ecosystem_transport_point$
entity_born_id (RentityBornId"Q
struct_entity_state$
entity_born_id (RentityBornId
state (Rstate"u
req_ecosystem_entity_state
map_id (RmapId@
entity_state_list (2.struct_entity_stateRentityStateList"v
resp_ecosystem_entity_state
map_id (RmapId@
entity_state_list (2.struct_entity_stateRentityStateList"A
req_npc_state0
npc_state_list (2
.struct_kvRnpcStateList"B
resp_npc_state0
npc_state_list (2
.struct_kvRnpcStateList";
 req_ecosystem_monster_level_bias
id_list (RidList"�
!resp_ecosystem_monster_level_bias]
level_bias_maps (25.resp_ecosystem_monster_level_bias.LevelBiasMapsEntryRlevelBiasMaps@
LevelBiasMapsEntry
key (Rkey
value (Rvalue:8bproto3
�
erlsn.proto">
struct_battle
frame_id (RframeId
opts (Ropts"^
e2s_verify_battle
session (	Rsession/
battle_list (2.struct_battleR
battleList"
s2e_verify_battle"#
e2s_hello_world
msg (	Rmsg"#
s2e_hello_world
msg (	Rmsg""
s2e_hello_test
msg (	Rmsgbproto3
�
example.proto"Y
req_example
	req_field (RreqField-
example_opt (2.example_optR
exampleOpt"1
req_example_spec

resp_field (	R	respField"-
resp_example

resp_field (	R	respField*+
example_opt
Opt1 
Opt2
Opt3bproto3
Y
frame.proto"
req_frame_list"0
resp_frame_list

frame_list (R	frameListbproto3
�
information.proto"
req_information"�
resp_information
	nick_name (	RnickName
	signature (	R	signature
photo_id (RphotoId
uid (Ruid
	avatar_id (RavatarId
frame_id (RframeId 
hero_id_list (R
heroIdList"
badge_id_list (RbadgeIdList%
birthday_month	 (RbirthdayMonth!
birthday_day
 (RbirthdayDay#
register_date (RregisterDate
sex (Rsex"8
req_information_nick_name
	nick_name (	RnickName"9
resp_information_nick_name
	nick_name (	RnickName"9
req_information_signature
	signature (	R	signature":
resp_information_signature
	signature (	R	signature"5
req_information_photo_id
photo_id (RphotoId"6
resp_information_photo_id
photo_id (RphotoId"8
req_information_avatar_id
	avatar_id (RavatarId"9
resp_information_avatar_id
	avatar_id (RavatarId"5
req_information_frame_id
frame_id (RframeId"6
resp_information_frame_id
frame_id (RframeId"d
req_information_birthday%
birthday_month (RbirthdayMonth!
birthday_day (RbirthdayDay"e
resp_information_birthday%
birthday_month (RbirthdayMonth!
birthday_day (RbirthdayDay"=
req_information_hero_list 
hero_id_list (R
heroIdList">
resp_information_hero_list 
hero_id_list (R
heroIdList"@
req_information_badge_list"
badge_id_list (RbadgeIdList"A
resp_information_badge_list"
badge_id_list (RbadgeIdList"'
req_information_sex
sex (Rsex"(
resp_information_sex
sex (Rsexbproto3
�
struct_hero.protostruct_common.proto"W
struct_hero_skill
order_id (RorderId
lev (Rlev
ex_lev (RexLev"�
struct_hero
id (Rid
lev (Rlev
exp (Rexp
stage (Rstage
star (Rstar
is_new (RisNew
	weapon_id (RweaponId

partner_id (R	partnerId/
property_list	 (2
.struct_kvRpropertyList1

skill_list
 (2.struct_hero_skillR	skillList"X
struct_formation
id (Rid
name (	Rname 
hero_id_list (R
heroIdListbproto3
�
struct_weapon.proto"�
struct_weapon
	unique_id (RuniqueId
template_id (R
templateId
lev (Rlev
exp (Rexp
stage (Rstage
refine (Rrefine
hero_id (RheroId
	is_locked (RisLockedbproto3
�
struct_partner.protostruct_common.proto"j
struct_panel_skill
skill_id (RskillId
pos (2
.struct_kvRpos
	is_active (RisActive"�
struct_panel
panel_id (RpanelId
template_id (R
templateId2

skill_list (2.struct_panel_skillR	skillList
pos (2
.struct_kvRpos
rotate (Rrotate"4
struct_affix
id (Rid
level (Rlevel"�
struct_partner_work
satiety (Rsatiety
san (Rsan
asset_id (RassetId
status (Rstatus

work_speed (R	workSpeed,
work_decoration_id (RworkDecorationId0
status_decoration_id (RstatusDecorationId"�
struct_partner
	unique_id (RuniqueId
template_id (R
templateId
hero_id (RheroId
lev (Rlev
exp (Rexp/
property_list (2
.struct_kvRpropertyList)

skill_list (2
.struct_kvR	skillList8
passive_skill_list (2
.struct_kvRpassiveSkillList,

panel_list	 (2.struct_panelR	panelList
	is_locked
 (RisLocked,

affix_list (2.struct_affixR	affixList1
	work_info (2.struct_partner_workRworkInfo(
asset_skill_list (RassetSkillListbproto3
�
friend.protoinformation.protostruct_hero.protostruct_weapon.protostruct_partner.protostruct_common.proto"�
struct_player_information3
information (2.resp_informationRinformation#
adventure_lev (RadventureLev
	world_lev (RworldLev)
	hero_list (2.struct_heroRheroList/
weapon_list (2.struct_weaponR
weaponList2
partner_list (2.struct_partnerRpartnerList+
offline_timestamp (RofflineTimestamp
hero_num (RheroNum&
identity	 (2
.struct_kvRidentity"z
struct_relation_obj
	target_id (RtargetId
remark (	Rremark.
info (2.struct_player_informationRinfo"
req_friend_fetch"J
resp_friend_fetch5
friend_list (2.struct_relation_objR
friendList"P
resp_friend_offline
	target_id (RtargetId
	timestamp (R	timestamp"0
req_friend_search
	target_id (RtargetId"1
req_friend_request
	target_id (RtargetId"N
resp_friend_request7
request_list (2.struct_relation_objRrequestList"T
req_friend_request_reply
	is_accept (RisAccept
	target_id (RtargetId"0
req_friend_remove
	target_id (RtargetId"1
resp_friend_remove
	target_id (RtargetId"
req_friend_black_fetch"N
resp_friend_black_fetch3

black_list (2.struct_relation_objR	blackList"3
req_friend_black_add
	target_id (RtargetId"6
req_friend_black_remove
	target_id (RtargetId"4
req_friend_info_fetch
	target_id (RtargetId"e
resp_friend_info_fetch
	target_id (RtargetId.
info (2.struct_player_informationRinfo"H
req_friend_remark
	target_id (RtargetId
remark (	Rremark"
req_friend_recommend"T
resp_friend_recommend;
recommend_list (2.struct_relation_objRrecommendList"H
req_friend_chat
	target_id (RtargetId
content (	Rcontent"f
struct_chat_content
from_id (RfromId
content (	Rcontent
	timestamp (R	timestamp"�
resp_friend_chat
	target_id (RtargetId7
content_list (2.struct_chat_contentRcontentList
	is_unread (RisUnread"3
req_friend_chat_read
	target_id (RtargetIdbproto3
�
gm.proto"U
struct_gm_args_desc
	args_desc (	RargsDesc!
args_default (	RargsDefault"y
	struct_gm
gm_name (	RgmName
gm_desc (	RgmDesc:
args_desc_list (2.struct_gm_args_descRargsDescList"%

req_gm_cmd
cmd_str (	RcmdStr"&
resp_gm_cmd
res_str (	RresStr"
req_gm_list"3
resp_gm_list#
gm_list (2
.struct_gmRgmList":
req_gm_exec
gm_name (	RgmName
args (	Rargs""
resp_gm_exec
tips (	Rtipsbproto3
�
guide.proto"
req_guide_add
id (Rid"?
resp_guide_add

error_code (R	errorCode
id (Rid"
req_guide_init"*
resp_guide_init
id_list (RidListbproto3
�
hacking.protostruct_common.proto".
req_hacking_build
build_id (RbuildId"5
req_hacking_build_unlock
build_id (RbuildId"6
resp_hacking_build_unlock
build_id (RbuildId"k
struct_build_unlock
build_id (RbuildId9
progresses_list (2.struct_progressRprogressesList"l
"resp_hacking_build_unlock_progressF
unlock_progress_list (2.struct_build_unlockRunlockProgressList"9
req_blueprint_unlock!
blueprint_id (RblueprintId"�
struct_blueprint_connect_point(
parent_bone_name (	RparentBoneName&
child_bone_name (	RchildBoneName

point_type (	R	pointType"�
struct_blueprint_node
index (Rindex
build_id (RbuildId(
offset (2.struct_positionRoffset(
rotate (2.struct_positionRrotate!
parent_index (RparentIndexD
connect_point (2.struct_blueprint_connect_pointRconnectPoint
	node_namee (	RnodeName!
connect_nodef (	RconnectNode5

child_listg (2.struct_blueprint_nodeR	childList2
parent_transform_nameh (	RparentTransformName"�
struct_blueprint!
blueprint_id (RblueprintId
name (	Rname

image_path (	R	imagePath,
nodes (2.struct_blueprint_nodeRnodes
build_ide (RbuildId5

child_listf (2.struct_blueprint_nodeR	childList"L
req_blueprint_custom_save/
	blueprint (2.struct_blueprintR	blueprint"@
req_blueprint_custom_delete!
blueprint_id (RblueprintId"�
resp_blueprint_info
unlock_list (R
unlockList2
custom_list (2.struct_blueprintR
customList<
use_time (2!.resp_blueprint_info.UseTimeEntryRuseTime;
history (2!.resp_blueprint_info.HistoryEntryRhistory:
UseTimeEntry
key (Rkey
value (Rvalue:8:
HistoryEntry
key (Rkey
value (Rvalue:8"J
req_blueprint_set
type (Rtype!
blueprint_id (RblueprintIdbproto3
�

hero.protostruct_hero.protostruct_common.proto"
req_hero_list";
resp_hero_list)
	hero_list (2.struct_heroRheroList"S
req_hero_lev_up
hero_id (RheroId'
	item_list (2
.struct_kvRitemList"1
resp_hero_lev_up

error_code (R	errorCode",
req_hero_stage_up
hero_id (RheroId"3
resp_hero_stage_up

error_code (R	errorCode"+
req_hero_star_up
hero_id (RheroId"2
resp_hero_star_up

error_code (R	errorCode"V
req_hero_skill_lev_up
hero_id (RheroId$
skill_order_id (RskillOrderId"7
resp_hero_skill_lev_up

error_code (R	errorCode"
req_formation_list"O
resp_formation_list8
formation_list (2.struct_formationRformationList"H
req_formation_update
id (Rid 
hero_id_list (R
heroIdList"I
resp_formation_update
id (Rid 
hero_id_list (R
heroIdList"8
req_formation_name
id (Rid
name (	Rname"9
resp_formation_name
id (Rid
name (	Rname"#
req_formation_use
id (Rid"$
resp_formation_use
id (Rid"b
req_hero_sync_property
hero_id (RheroId/
property_list (2
.struct_kvRpropertyList"8
resp_hero_sync_property

error_code (R	errorCode"
req_hero_use
id (Rid"
resp_hero_use
id (Rid"E
req_hero_change_weapon
id (Rid
	weapon_id (RweaponId"G
req_hero_equip_partner
id (Rid

partner_id (R	partnerId"*
req_hero_unequip_partner
id (Rid"(
req_hero_del_red_point
id (Ridbproto3
�
identity.protostruct_common.proto"�
resp_identity_info_attr&
identity (2
.struct_kvRidentity\
identity_attr_maps (2..resp_identity_info_attr.IdentityAttrMapsEntryRidentityAttrMaps_
identity_level_maps (2/.resp_identity_info_attr.IdentityLevelMapsEntryRidentityLevelMapsC
IdentityAttrMapsEntry
key (Rkey
value (Rvalue:8D
IdentityLevelMapsEntry
key (Rkey
value (Rvalue:8"H
resp_identity_info_reward+
reward_list (2
.struct_kvR
rewardList"B
req_identity_reward+
reward_list (2
.struct_kvR
rewardList"=
req_identity_swtich&
identity (2
.struct_kvRidentity">
resp_identity_swtich&
identity (2
.struct_kvRidentitybproto3
�

item.protostruct_common.protostruct_item.proto"
req_item_list";
resp_item_list)
	item_list (2.struct_itemRitemList":
req_item_drop)
	item_list (2.struct_itemRitemList":
req_item_sell)
	item_list (2.struct_itemRitemList"A
req_item_use
	unique_id (RuniqueId
count (Rcount"a
resp_item_use
	unique_id (RuniqueId
count (Rcount

error_code (R	errorCode"E
req_item_lock
	unique_id (RuniqueId
is_lock (RisLock"�
resp_item_reward

reward_src (R	rewardSrc4
reward_list (2.struct_reward_showR
rewardList
ex_arg_list (R	exArgList"S
resp_item_init
volume (Rvolume)
	item_list (2.struct_itemRitemList"
resp_item_update'
add_list (2.struct_itemRaddList
del_list (RdelList'
mod_list (2.struct_itemRmodList"�
req_item_exchange
exchange_id (R
exchangeId
count (Rcount/
exchange_list (2
.struct_kvRexchangeList
is_show (RisShow"E
resp_item_exchange/
exchange_list (2
.struct_kvRexchangeList">
req_item_use_energy'
	item_list (2
.struct_kvRitemListbproto3
�
struct_level_event.protostruct_common.proto"[
struct_level_event
event_id (ReventId*
first_finish_time (RfirstFinishTimebproto3
�
level_event.protostruct_common.protostruct_level_event.proto"6
req_level_event_get_award
event_id (ReventId"4
req_level_event_trigger
event_id (ReventId"[
resp_level_event_info_list=
level_event_list (2.struct_level_eventRlevelEventList"B
resp_level_event_trigger_list!
trigger_list (RtriggerListbproto3
�
mailing.protostruct_common.proto"B
resp_mailing_info-
mailing_list (2
.struct_kvRmailingList"3
req_mailing_active

mailing_id (R	mailingId"m
req_mailing_exchange

mailing_id (R	mailingId
item_id (RitemId

item_count (R	itemCount"N
resp_mailing_exchange

mailing_id (R	mailingId
result (Rresultbproto3
�

mail.protostruct_common.proto"�
struct_mail
id (Rid
type (Rtype
template_id (R
templateId
from (	Rfrom
title (	Rtitle
content (	Rcontent'
	item_list (2
.struct_kvRitemList
	read_flag (RreadFlag
reward_flag	 (R
rewardFlag
send_ts
 (RsendTs
	expire_ts (RexpireTs"
req_mail_list";
resp_mail_list)
	mail_list (2.struct_mailRmailList"
req_mail_read
id (Rid" 
resp_mail_read
id (Rid"%
req_mail_get_reward
id (Rid"&
resp_mail_get_reward
id (Rid"
req_mail_get_reward_all"3
resp_mail_get_reward_all
id_list (RidList"*
req_mail_delete
id_list (RidList"+
resp_mail_delete
id_list (RidList"
req_mail_delete_read"0
resp_mail_delete_read
id_list (RidListbproto3
�
	map.protostruct_common.proto"�
struct_map_mark
mark_id (RmarkId
type (Rtype
name (	Rname
map_id (RmapId,
position (2.struct_positionRposition"
req_map_info"~
resp_map_info
map_id (RmapId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate"�
req_map_sync_position
map_id (RmapId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate"|
resp_map_sync_position

error_code (R	errorCode
map_id (RmapId,
position (2.struct_positionRposition"~
req_map_enter
map_id (RmapId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate"�
resp_map_enter
map_id (RmapId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate

error_codee (R	errorCode"�
req_map_to_transport_point$
entity_born_id (RentityBornId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate"�
resp_map_to_transport_point
map_id (RmapId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate";
req_map_mark+
map_mark (2.struct_map_markRmapMark"<
resp_map_mark+
map_mark (2.struct_map_markRmapMark".
req_map_mark_remove
mark_id (RmarkId"/
resp_map_mark_remove
mark_id (RmarkId"2
req_map_system_jump
	show_list (RshowList"3
resp_map_system_jump
	show_list (RshowList"W
struct_role_scene_msg 
scene_msg_id (R
sceneMsgId
	operation (R	operation"L
req_scene_msg_operate3
	scene_msg (2.struct_role_scene_msgRsceneMsg"R
resp_scene_msg_operate_list3
	scene_msg (2.struct_role_scene_msgRsceneMsg";
req_scene_msg_statistic 
scene_msg_id (R
sceneMsgId"j
resp_scene_msg_statistic 
scene_msg_id (R
sceneMsgId
like (Rlike
dislike (Rdislikebproto3
T

meme.proto"
req_meme_list"-
resp_meme_list
	meme_list (RmemeListbproto3
�
mercenary_hunt.proto"3
resp_mercenary_main_info
main_id (RmainId"2
resp_mercenary_alert_value
value (Rvalue"!
req_mercenary_clean_alert_value"1
req_mercenary_fight_state
state (Rstate"�
struct_mercenary!
ecosystem_id (RecosystemId
level (Rlevel
	name_list (RnameList%
discover_state (RdiscoverState
chase_state (R
chaseState
reborn_time (R
rebornTime
rank_id (RrankId
rank_lv (RrankLv"O
resp_mercenary_list8
mercenary_list (2.struct_mercenaryRmercenaryList"A
req_mercenary_discover_state!
ecosystem_id (RecosystemId"
req_mercenary_kill_player"G
resp_mercenary_rank
rank_id (RrankId
rank_lv (RrankLv"4
req_mercenary_reward_list
rank_id (RrankId">
resp_mercenary_reward_list 
rank_id_list (R
rankIdList"s
resp_mercenary_promote_info!
promote_time (RpromoteTime1
last_add_promote_time (RlastAddPromoteTime"
req_mercenary_daily_reward"}
resp_mercenary_daily_reward-
is_get_daily_reward (RisGetDailyReward/
daily_reward_rank_id (RdailyRewardRankIdbproto3
�
message.proto"i
struct_message

message_id (R	messageId
talk_id (RtalkId
option_list (R
optionList"u
req_message_read)
message (2.struct_messageRmessage

message_ide (R	messageId
talk_idf (RtalkId"y
resp_message_read2
reading_list (2.struct_messageRreadingList0
finish_list (2.struct_messageR
finishListbproto3
�
noticeboard.proto"�
struct_notice
id (Rid
tab (Rtab
title (	Rtitle
content (	Rcontent

start_time (R	startTime
end_time (RendTime
banner (	Rbanner
priority (Rpriority"
req_noticeboard_list"H
resp_noticeboard_list/
notice_list (2.struct_noticeR
noticeList"7
req_noticeboard_redpoint
	notice_id (RnoticeId"A
resp_noticeboard_redpoint$
notice_id_list (RnoticeIdListbproto3
�
novice.proto"~
struct_novice
id (Rid
	acc_times (RaccTimes
value (Rvalue*
reward_value_list (RrewardValueList"
req_novice_info"C
resp_novice_info/
novice_list (2.struct_noviceR
noviceList"E
req_novice_award
id (Rid!
reward_value (RrewardValuebproto3
�
partner.protostruct_common.protostruct_partner.proto"�
resp_partner_update*
add_list (2.struct_partnerRaddList
del_list (RdelList*
mod_list (2.struct_partnerRmodList"Y
resp_partner_init
volume (Rvolume,
	item_list (2.struct_partnerRitemList"J
req_partner_lock

partner_id (R	partnerId
is_lock (RisLock"�
req_partner_lev_up

partner_id (R	partnerId&
partner_id_list (RpartnerIdList'
	item_list (2
.struct_kvRitemList"T
req_partner_skill_lev_up

partner_id (R	partnerId
skill_id (RskillId"o
req_partner_use_skill_book

partner_id (R	partnerId
pos (Rpos 
book_item_id (R
bookItemId"e
req_partner_eat

partner_id (R	partnerId
pos (2
.struct_kvRpos
eat_id (ReatId"G
req_partner_show_get_window(
partner_group_id (RpartnerGroupId"`
req_partner_panel

partner_id (R	partnerId,

panel_list (2.struct_panelR	panelList"8
req_partner_panel_reset

partner_id (R	partnerId"N
resp_partner_conclude_info0
golden_conclude_time (RgoldenConcludeTime"�
req_partner_conclude
item_id (RitemId!
ecosystem_id (RecosystemId

hp_percent (R	hpPercent
is_break (RisBreak"�
resp_partner_conclude!
ecosystem_id (RecosystemId 
probability (Rprobability)
rand_probability (RrandProbability
result (Rresult"?
req_partner_conclude_heart!
ecosystem_id (RecosystemId"?
req_partner_conclude_reset!
ecosystem_id (RecosystemId"�
req_partner_fusion*
master_partner_id (RmasterPartnerId9
master_affix_list (2.struct_affixRmasterAffixList(
slave_partner_id (RslavePartnerId7
slave_affix_list (2.struct_affixRslaveAffixListbproto3
�
purchase.protostruct_common.proto"?
resp_purchase_total_purchase
month_total (R
monthTotal"�
struct_purchase_cfg
id (Rid
price (Rprice
item_id (RitemId
item_num (RitemNum"
first_item_id (RfirstItemId$
first_item_num (RfirstItemNum"
extra_item_id (RextraItemId$
extra_item_num (RextraItemNum
name	 (	Rname
icon
 (	Ricon
icon_bg (	RiconBg
priority (Rpriority"D
resp_purchase_cfg/
cfg_list (2.struct_purchase_cfgRcfgList"F
resp_purchase_info0
buy_count_list (2
.struct_kvRbuyCountList""
req_purchase_buy
id (Rid"�
struct_purchase_package_cfg
id (Rid
price (Rprice
name (	Rname
icon (	Ricon
page (Rpage
	cost_item (RcostItem"
cost_item_num (RcostItemNum
	reward_id (RrewardId
	buy_limit	 (RbuyLimit
refresh
 (Rrefresh
show_tag (RshowTag#
show_discount (	RshowDiscount!
soldout_show (RsoldoutShow
priority (Rpriority"T
resp_purchase_package_cfg7
cfg_list (2.struct_purchase_package_cfgRcfgList"N
resp_purchase_package_info0
buy_count_list (2
.struct_kvRbuyCountList"*
req_purchase_package_buy
id (Rid"Z
struct_monthcard
id (Rid
rest_day (RrestDay
	is_reward (RisReward"E
resp_monthcard_info.
	card_list (2.struct_monthcardRcardList"#
req_monthcard_buy
id (Rid"&
req_monthcard_reward
id (Ridbproto3
�
rogue.proto"�
struct_rogue_area_logic"
area_logic_id (RareaLogicId\
current_event_maps (2..struct_rogue_area_logic.CurrentEventMapsEntryRcurrentEventMapsC
CurrentEventMapsEntry
key (Rkey
value (Rvalue:8"r
struct_season_event
event_id (ReventId#
is_discovered (RisDiscovered
	finish_ts (RfinishTs"
req_rogue_info"�
resp_rogue_info*
season_version_id (RseasonVersionId&
area_version_id (RareaVersionId

game_round (R	gameRound[
rogue_area_logic_maps (2(.resp_rogue_info.RogueAreaLogicMapsEntryRrogueAreaLogicMapsT
event_first_reward (2&.resp_rogue_info.EventFirstRewardEntryReventFirstReward'
season_schedule (RseasonSchedule=
season_schedule_reward_list (RseasonScheduleRewardList,
game_refresh_times (RgameRefreshTimes/
game_last_refresh_ts	 (RgameLastRefreshTs2
discovered_event_list
 (RdiscoveredEventList;
game_discovered_event_list (RgameDiscoveredEventList@
season_event_list (2.struct_season_eventRseasonEventList_
RogueAreaLogicMapsEntry
key (Rkey.
value (2.struct_rogue_area_logicRvalue:8C
EventFirstRewardEntry
key (Rkey
value (Rvalue:8"W
req_rogue_event_finish"
area_logic_id (RareaLogicId
event_id (ReventId"�
resp_rogue_event_finish"
area_logic_id (RareaLogicId
event_id (ReventId'
season_schedule (RseasonSchedule
ts (Rts"x
resp_rogue_info_refresh,
game_refresh_times (RgameRefreshTimes/
game_last_refresh_ts (RgameLastRefreshTs"q
 req_rogue_season_schedule_reward!
reward_level (RrewardLevel*
reward_level_list (RrewardLevelList"B
req_rogue_restart-
remove_card_id_list (RremoveCardIdList"�
resp_rogue_card_info=
card_bag (2".resp_rogue_card_info.CardBagEntryRcardBagC

card_equip (2$.resp_rogue_card_info.CardEquipEntryR	cardEquipc
current_round_card_bag (2..resp_rogue_card_info.CurrentRoundCardBagEntryRcurrentRoundCardBag:
CardBagEntry
key (Rkey
value (Rvalue:8<
CardEquipEntry
key (Rkey
value (Rvalue:8F
CurrentRoundCardBagEntry
key (Rkey
value (Rvalue:8"0
req_rogue_card_choose
card_id (RcardId"Y
resp_rogue_card_choice_list
	card_list (RcardList

area_logic (R	areaLogic"�
req_rogue_card_equipC

card_equip (2$.req_rogue_card_equip.CardEquipEntryR	cardEquip<
CardEquipEntry
key (Rkey
value (Rvalue:8"Y
req_rogue_event_discover"
area_logic_id (RareaLogicId
event_id (ReventIdbproto3
�

role.proto"

req_quit"
req_role_init"
resp_role_init"�
resp_role_propertyJ
property_maps (2%.resp_role_property.PropertyMapsEntryRpropertyMaps?
PropertyMapsEntry
key (Rkey
value (Rvalue:8"�
req_role_property_syncN
property_maps (2).req_role_property_sync.PropertyMapsEntryRpropertyMaps?
PropertyMapsEntry
key (Rkey
value (Rvalue:8"r
resp_role_kick_offline
	kick_type (RkickType!
kick_context (	RkickContext
version (Rversionbproto3
�

shop.protostruct_common.proto"�
struct_goods
goods_id (RgoodsId
item_id (RitemId

item_count (R	itemCount$
consume (2
.struct_kvRconsume
	condition (R	condition
	buy_limit (RbuyLimit

refresh_id (R	refreshId
	buy_count (RbuyCount
priority	 (Rpriority

is_bargain
 (R	isBargain")
req_shop_goods
shop_id (RshopId"�
resp_shop_goods
shop_id (RshopId!
refresh_type (RrefreshType,

goods_list (2.struct_goodsR	goodsList
discount (Rdiscount"L
req_shop_goods_buy
goods_id (RgoodsId
	buy_count (RbuyCountbproto3
�
statistic.proto"J
resp_statistic_info3
statistic_info (2.struct_treeRstatisticInfo"S
 req_statistic_client_control_add
type (Rtype
	add_value (RaddValue"W
struct_tree
key (Rkey
value (Rvalue 
next (2.struct_treeRnextbproto3
�
struct_task.protostruct_common.proto"�
struct_task
id (Rid
step (Rstep
finish (Rfinish,
progress (2.struct_progressRprogress
in_progress (R
inProgress"V
struct_task_node
node_id (RnodeId)
	task_list (2.struct_taskRtaskList"�
struct_task_group
group_id (RgroupId
dream_id (RdreamId

start_node (R	startNode!
current_node (RcurrentNode=
	task_node (2 .struct_task_group.TaskNodeEntryRtaskNode
typee (Rtype
sec_typef (RsecTypeN
TaskNodeEntry
key (Rkey'
value (2.struct_task_nodeRvalue:8"6
struct_finish_task_node
	task_list (RtaskListbproto3
a
sys_open.proto""
req_sys_open_add
id (Rid"#
resp_sys_open_add
id (Ridbproto3
�
system_task.protostruct_common.proto"s
struct_system_task
id (Rid5
progress_list (2.struct_progressRprogressList
finish (Rfinish"I
resp_system_task_list0
	task_list (2.struct_system_taskRtaskList"E
resp_system_task_finished_list#
finished_list (RfinishedList"(
req_system_task_commit
id (Rid"?
resp_system_task_cancel_list
cancel_list (R
cancelList"X
req_system_task_client_event

event_type (R	eventType
arg_list (RargListbproto3
�
talent.protostruct_common.proto"?
resp_talent_info+
talent_list (2
.struct_kvR
talentList"0
req_talent_lev_up
	talent_id (RtalentIdbproto3
�


task.protostruct_task.proto"�
resp_task_info1

task_group (2.struct_task_groupR	taskGroup"
task_dream_id (RtaskDreamId1

task_dream (2.struct_task_groupR	taskDreamS
task_node_finished (2%.resp_task_info.TaskNodeFinishedEntryRtaskNodeFinished

task_trace (R	taskTrace]
TaskNodeFinishedEntry
key (Rkey.
value (2.struct_finish_task_nodeRvalue:8"G
resp_task_node_update.
	task_node (2.struct_task_nodeRtaskNode"=
resp_task_update)
	task_list (2.struct_taskRtaskList")
req_task_trace
task_id (RtaskId"*
resp_task_trace
task_id (RtaskId"}
req_task_client_add_progress
task_id (RtaskId
step_id (RstepId
add_num (RaddNum
type (Rtype"2
req_task_reset_progress
task_id (RtaskId"*
req_task_reward
task_id (RtaskId"+
resp_task_reward
task_id (RtaskId"�
struct_task_choice
id (Rida
task_choice_count_maps (2,.struct_task_choice.TaskChoiceCountMapsEntryRtaskChoiceCountMapsF
TaskChoiceCountMapsEntry
key (Rkey
value (Rvalue:8"J
req_task_finish_statistic
type (Rtype
sec_type (RsecType"�
resp_task_finish_statistic
type (Rtype
sec_type (RsecType4
choice_list (2.struct_task_choiceR
choiceListbproto3
�
teach.proto"
req_teach_add
id (Rid""
req_teach_reward
id (Rid"#
resp_teach_reward
id (Rid"-
resp_teach_last_id
id_list (RidListbproto3
�
trade.proto"a
struct_order
id (Rid%
bargain_result (RbargainResult
discount (Rdiscount"t
struct_store
id (Rid,

order_list (2.struct_orderR	orderList&
next_refresh_ts (RnextRefreshTs"
req_trade_info"?
resp_trade_info,

store_list (2.struct_storeR	storeList"5
req_trade_store_activate
store_id (RstoreId"`
req_trade_order
store_id (RstoreId
order_id (RorderId
item_id (RitemIdbproto3
�
unlock.proto""
req_unlock_begin
id (Rid"$
req_unlock_success
id (Rid"3
resp_unlock_list
unlock_list (R
unlockListbproto3
T
vehicle.proto";
resp_vehicle_unlock_list
unlock_list (R
unlockListbproto3
�
weapon.protostruct_common.protostruct_weapon.proto"
req_weapon_lev_up
	weapon_id (RweaponId$
weapon_id_list (RweaponIdList'
	item_list (2
.struct_kvRitemList"3
resp_weapon_lev_up

error_code (R	errorCode"2
req_weapon_stage_up
	weapon_id (RweaponId"5
resp_weapon_stage_up

error_code (R	errorCode"V
req_weapon_refine
	weapon_id (RweaponId$
weapon_id_list (RweaponIdList"3
resp_weapon_refine

error_code (R	errorCode"W
resp_weapon_init
volume (Rvolume+
	item_list (2.struct_weaponRitemList"�
resp_weapon_update)
add_list (2.struct_weaponRaddList
del_list (RdelList)
mod_list (2.struct_weaponRmodList"G
req_weapon_lock
	weapon_id (RweaponId
is_lock (RisLock"1
resp_weapon_lock

error_code (R	errorCodebproto3
�
world_level.proto"E
resp_world_level
level (Rlevel
	max_level (RmaxLevel"
req_world_level_upgrade"
req_world_level_degradebproto3