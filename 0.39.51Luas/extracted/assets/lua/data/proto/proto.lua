
¡
ability_roulette.proto"J
struct_ability_roulette
pos (Rpos

ability_id (R	abilityId"P
struct_ability_roulette_partner
id (Rid

partner_id (R	partnerId"î
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
»
activity.proto"L
struct_activity_task
task_id (RtaskId
	is_finish (RisFinish"
req_activity_info"¯
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
¶
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
ƒ
alchemy.protostruct_common.proto"S
struct_solution
left (2
.struct_kvRleft 
right (2
.struct_kvRright"Ú
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
é
struct_partner.protostruct_common.proto"j
struct_panel_skill
skill_id (RskillId
pos (2
.struct_kvRpos
	is_active (RisActive"´
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
level (Rlevel"­
struct_partner_work
satiety (Rsatiety
san (Rsan
asset_id (RassetId
status (Rstatus

work_speed (R	workSpeed,
work_decoration_id (RworkDecorationId0
status_decoration_id (RstatusDecorationId
status_time (R
statusTime
food_id	 (RfoodId"î
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
asset_skill_list (RassetSkillList7
car_skill_list (2.struct_car_skillRcarSkillList<
car_slot_info (2.struct_partner_car_slotRcarSlotInfo"æ
struct_partner_fusion_info*
master_partner_id (RmasterPartnerId9
master_affix_list (2.struct_affixRmasterAffixList(
slave_partner_id (RslavePartnerId7
slave_affix_list (2.struct_affixRslaveAffixList"
struct_car_skill
skill_id (RskillId
lev (Rlev
exp (Rexp
car_id (RcarId
slot_id (RslotId"M
struct_partner_car_slot
car_id (RcarId
	slot_list (RslotListbproto3
¶
struct_asset_center.protostruct_common.protostruct_partner.proto"è
struct_asset_center_build_info
asset_id (RassetId
level (RlevelM
decoration_list (2$.struct_asset_center_decoration_infoRdecorationList>
decoration_count_list (2
.struct_kvRdecorationCountList
pos_info (	RposInfo!
partner_list (RpartnerList
buy_time (RbuyTime\
partner_decoration_list (2$.struct_asset_center_decoration_infoRpartnerDecorationList 
is_get_award	 (R
isGetAward-
parking_info
 (2
.struct_kvRparkingInfo"ý
(struct_asset_center_decoration_work_info!
partner_list (RpartnerList*
last_refresh_time (RlastRefreshTime
work_id (RworkId
work_amount (R
workAmount

work_value (R	workValue#
finish_amount (RfinishAmount

product_id (R	productId'
	food_list (2
.struct_kvRfoodList<
fusion_info	 (2.struct_partner_fusion_infoR
fusionInfo"¹
#struct_asset_center_decoration_info
id (Rid
template_id (R
templateId
pos_info (	RposInfoF
	work_info (2).struct_asset_center_decoration_work_infoRworkInfo"‹
struct_asset_center_work_update
asset_id (RassetIdM
decoration_list (2$.struct_asset_center_decoration_infoRdecorationList"°
,struct_asset_center_decoration_product_times4
decoration_template_id (RdecorationTemplateId"
can_use_times (RcanUseTimes&
today_use_times (RtodayUseTimesbproto3
…
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
ë
asset_center.protostruct_asset_center.protostruct_partner.protostruct_common.protostruct_item.proto"
req_asset_center_buy_asset0
purchase_template_id (RpurchaseTemplateId 
show_id_list (R
showIdList
is_down_pay (R	isDownPay"¿
req_asset_center_buy_decoration
asset_id (RassetId4
decoration_template_id (RdecorationTemplateId
amount (Ramount3
decoration_list (2
.struct_kvRdecorationList"n
&req_asset_center_change_decoration_pos
asset_id (RassetId
id (Rid
pos_info (	RposInfo"
#req_asset_center_change_partner_pos
asset_id (RassetId#
decoration_id (RdecorationId
	move_type (RmoveType
pos_info (	RposInfo"<
req_asset_center_asset_level_up
asset_id (RassetId"†
req_asset_partner_skill_unlock

partner_id (R	partnerId
skill_id (RskillId*
assist_partner_id (RassistPartnerId"o
"resp_asset_center_asset_build_listI
asset_build_list (2.struct_asset_center_build_infoRassetBuildList"
!resp_asset_center_decoration_list
asset_id (RassetIdM
decoration_list (2$.struct_asset_center_decoration_infoRdecorationList"•
)resp_asset_center_partner_decoration_list
asset_id (RassetIdM
decoration_list (2$.struct_asset_center_decoration_infoRdecorationList"„
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
.struct_kvRdecorationCountList"r
resp_asset_center_build_level
asset_id (RassetId
level (Rlevel 
is_get_award (R
isGetAward"×
req_asset_center_work_set
asset_id (RassetId#
decoration_id (RdecorationId!
partner_list (RpartnerList
work_id (RworkId
work_amount (R
workAmount

product_id (R	productId"—
 req_asset_center_work_set_fusion5
work_set (2.req_asset_center_work_setRworkSet<
fusion_info (2.struct_partner_fusion_infoR
fusionInfo"\
req_asset_center_partner_set
asset_id (RassetId!
partner_list (RpartnerList"†
!req_asset_center_work_partner_set
asset_id (RassetId#
decoration_id (RdecorationId!
partner_list (RpartnerList"³
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
decoration_id (RdecorationId"„
req_asset_center_food_set
asset_id (RassetId#
decoration_id (RdecorationId'
	food_list (2
.struct_kvRfoodList"b
resp_asset_center_work_updateA
update_list (2 .struct_asset_center_work_updateR
updateList"[
resp_asset_center_product_count8
product_count_list (2
.struct_kvRproductCountList"q
req_asset_center_buy_garage0
purchase_template_id (RpurchaseTemplateId 
show_id_list (R
showIdList"¸
req_asset_center_cook

produce_id (R	produceId
asset_id (RassetId#
decoration_id (RdecorationId*
assist_partner_id (RassistPartnerId
times (Rtimes"Š
resp_asset_center_cook7
reward_list_1 (2.struct_reward_showRrewardList17
reward_list_2 (2.struct_reward_showRrewardList2"¢
req_asset_center_tree

produce_id (R	produceId
asset_id (RassetId#
decoration_id (RdecorationId*
assist_partner_id (RassistPartnerId"Š
resp_asset_center_tree7
reward_list_1 (2.struct_reward_showRrewardList17
reward_list_2 (2.struct_reward_showRrewardList2"
/resp_asset_center_decoration_product_times_listL

times_list (2-.struct_asset_center_decoration_product_timesR	timesListbproto3
Ì
asset.proto"Q
resp_energy_info
energy (Renergy%
next_timestamp (RnextTimestamp"¹
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
paotaHexin"¥
resp_role_virtual_itemK
virtual_item (2(.resp_role_virtual_item.VirtualItemEntryRvirtualItem>
VirtualItemEntry
key (Rkey
value (Rvalue:8bproto3
ƒ
bargain.proto"{
struct_bargain!
negotiate_id (RnegotiateId#
bargain_count (RbargainCount!
latest_point (RlatestPoint"G
resp_bargain_list2
bargain_list (2.struct_bargainRbargainList"Ê
req_bargain_check_seq
type (Rtype
	relate_id (RrelateId!
negotiate_id (RnegotiateId
npc_seq (RnpcSeq

client_seq (R	clientSeq%
original_point (RoriginalPoint"ˆ
resp_bargain_point_info#
bargain_count (RbargainCount%
original_point (RoriginalPoint!
negotiate_id (RnegotiateId"L
req_bargain_remove_effect
type (Rtype
	relate_id (RrelateIdbproto3
“
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
•
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
ƒ
struct_car.proto"Q
struct_component_info
pos_id (RposId!
component_id (RcomponentId"i
struct_car_slot_info
slot_id (RslotId

partner_id (R	partnerId
skill_id (RskillId"¨

struct_car
id (Rid
	garage_id (RgarageId
lock (Rlock=
component_info (2.struct_component_infoRcomponentInfo
template_id (R
templateId
parking_num (R
parkingNum
	from_shop (RfromShop;
slot_info_list (2.struct_car_slot_infoRslotInfoListbproto3
„
	car.protostruct_car.protostruct_common.proto"¾
req_car_buy
id (Rid5
components_info_id_list (RcomponentsInfoIdList
	garage_id (RgarageId%
parking_number (RparkingNumber$
system_jump_id (RsystemJumpId"q
resp_car_get&
car_list (2.struct_carRcarList9
unlock_components_id_list (RunlockComponentsIdList"A
resp_car_partner_update&
car_list (2.struct_carRcarList"
req_car_sell
id (Rid"o
req_car_move
id (Rid(
target_garage_id (RtargetGarageId%
parking_number (RparkingNumber"7
req_car_lock
id (Rid
is_lock (RisLock"N
req_components_buy!
component_id (RcomponentId
car_id (RcarId"R
req_components_install
car_id (RcarId!
component_id (RcomponentId"'
req_car_notice
car_id (RcarId"[
struct_car_buy_num
shop_id (RshopId,
buy_num_list (2
.struct_kvR
buyNumList"Í
resp_car_info&
car_list (2.struct_carRcarList,
components_id_list (RcomponentsIdList(
notice_card_list (RnoticeCardList<
car_buy_num_list (2.struct_car_buy_numRcarBuyNumList"§
req_car_assemble_partner
car_id (RcarId
car_slot_id (R	carSlotId*
partner_unique_id (RpartnerUniqueId(
partner_skill_id (RpartnerSkillId"˜
req_car_remove_partner
car_id (RcarId
slot_id (RslotId

partner_id (R	partnerId/
partner_car_skill_id (RpartnerCarSkillId"H
req_car_remove_component
car_id (RcarId
pos_id (RposIdbproto3
Î
city_operate.proto"u
"struct_city_operate_entrust_urgent

entrust_id (R	entrustId0
entrust_reward_grade (RentrustRewardGrade"Ü
struct_city_operate_store
store_id (RstoreId#
entrust_level (RentrustLevelS
entrust_urgent_list (2#.struct_city_operate_entrust_urgentRentrustUrgentList*
max_entrust_level (RmaxEntrustLevel"S
resp_city_operate_info9

store_list (2.struct_city_operate_storeR	storeList"”
&req_city_operate_entrust_level_setting
store_id (RstoreId#
entrust_level (RentrustLevel*
max_entrust_level (RmaxEntrustLevel"ƒ
req_city_operate_entrust_enter
store_id (RstoreId

entrust_id (R	entrustId'
use_hero_id_list (RuseHeroIdList"h
req_city_operate_entrust_finish.
system_duplicate_id (RsystemDuplicateId
is_win (RisWinbproto3
à
client.protostruct_common.proto"0
req_heartbeat
client_time (R
clientTime"R
resp_heartbeat
client_time (R
clientTime
server_time (R
serverTime"ð
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
version (Rversion
cfg_version (	R
cfgVersion!
svn_revision (	RsvnRevision
ip (	Rip"Ï
resp_client_login
flag (Rflag
msg (	Rmsg)
server_timestamp (RserverTimestamp
timezone (Rtimezone
uid (Ruid
aes_key (	RaesKey"
aes_key_bytes (	RaesKeyBytes"
req_client_quit"1
resp_client_quit

error_code (R	errorCode"3
req_client_file_record
rec_list (	RrecList"Ÿ
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

inner_time (R	innerTime"&
resp_client_tips
tips (	Rtipsbproto3

condition.proto"%
req_condition_state
id (Rid"[
resp_condition_state

error_code (R	errorCode
id (Rid
state (Rstatebproto3
¦	
crime.proto"5
req_crime_add_bounty

crime_type (R	crimeType"º
resp_crime_bounty!
bounty_value (RbountyValueC
bounty_infoe (2".resp_crime_bounty.BountyInfoEntryR
bountyInfo=
BountyInfoEntry
key (Rkey
value (Rvalue:8"-
req_crime_fight_state
state (Rstate"7
req_crime_prison_game_finish
game_id (RgameId"J
req_crime_prison_info
state (Rstate
	prison_id (RprisonId"
resp_crime_prison_info
state (Rstate
	prison_id (RprisonId!
bounty_value (RbountyValue
finish_game (R
finishGame"
req_crime_be_in_prison"2
req_crime_hero_edu_exam
hero_id (RheroId"h
resp_crime_exam_question,
exam_question_list (RexamQuestionList
is_edu_exam (R	isEduExam"˜
req_crime_hero_question_answer
hero_id (RheroId
answer_list (R
answerList
question_ide (R
questionId
	answer_idf (RanswerId"7
req_crime_hero_out_of_prison
hero_id (RheroId"<
!req_crime_hero_clear_notification
hero_id (RheroId"F
resp_crime_hero_prison_until&
in_prison_until (RinPrisonUntil"C
resp_crime_hero_current_answer!
right_answer (RrightAnswerbproto3
÷
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

deliver_cargo.proto"R
struct_current_cargo
cargo_id (RcargoId
accept_time (R
acceptTime"f
struct_panel_info
cargo_id (RcargoId
pos_id (RposId
finish_time (R
finishTime"E
req_deliver_cargo
pos_id (RposId
cargo_id (RcargoId"5
req_deliver_cargo_finish
cargo_id (RcargoId"3
req_deliver_cargo_fail
cargo_id (RcargoId"6
req_deliver_cargo_give_up
cargo_id (RcargoId"È
resp_deliver_cargo_info:
panel_info_list (2.struct_panel_infoRpanelInfoListC
current_cargo_info (2.struct_current_cargoRcurrentCargoInfo,
history_cargo_list (RhistoryCargoListbproto3
_
dialog.proto"G
req_dialog_loss
talk_id (RtalkId
	option_id (RoptionIdbproto3
ì
dialog_reward.proto"¨
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
þ

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
æ
struct_duplicate.protostruct_common.proto"•
struct_duplicate_key!
duplicate_id (RduplicateId.
system_duplicate_id (RsystemDuplicateId*
task_duplicate_id (RtaskDuplicateId"‘
struct_duplicate'
key (2.struct_duplicate_keyRkey

best_score (R	bestScore%
finished_times (RfinishedTimes
id (Rid"¨
struct_duplicate_info.
system_duplicate_id (RsystemDuplicateId%
finished_times (RfinishedTimes

best_score (R	bestScore#
current_score (RcurrentScore'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList
	win_times (RwinTimes"ã
struct_duplicate_best5
duplicate_best_key_type (RduplicateBestKeyType=
duplicate_best_key_sysdupid (RduplicateBestKeySysdupidT
duplicate_best_info_list (2.struct_duplicate_best_infoRduplicateBestInfoList"þ
struct_duplicate_best_info.
system_duplicate_id (RsystemDuplicateId

best_score (R	bestScore
use_time (RuseTime

hp_percent (R	hpPercent'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList"Û
 struct_duplicate_nightmare_final
round (Rround
layer (Rlayer
	old_layer (RoldLayer
	last_time (RlastTime
order (Rorder%
duplicate_rule (RduplicateRule
level (Rlevel"›
struct_nightmare_rank_info
user_id (RuserId
	user_name (	RuserName
score (Rscore
	hero_list (RheroList
frame (Rframe"u
"struct_duplicate_energy_boss_award.
system_duplicate_id (RsystemDuplicateId
finish_time (R
finishTimebproto3
å$
duplicate.protostruct_common.protostruct_duplicate.protostruct_item.proto"Z
resp_duplicate_state_list=
duplicate_list (2.struct_duplicate_infoRduplicateList"£
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
system_duplicate_id (RsystemDuplicateId"
req_duplicate_task_enter.
system_duplicate_id (RsystemDuplicateId(
rotate (2.struct_positionRrotate'
use_hero_id_list (RuseHeroIdList"’
req_duplicate_task_finish.
system_duplicate_id (RsystemDuplicateId.
kill_mon_list (2
.struct_kvRkillMonList
is_win (RisWin"‚
resp_duplicate_task_finish.
system_duplicate_id (RsystemDuplicateId4
reward_list (2.struct_reward_showR
rewardList"¡
req_duplicate_resource_enter.
system_duplicate_id (RsystemDuplicateId(
rotate (2.struct_positionRrotate'
use_hero_id_list (RuseHeroIdList"–
req_duplicate_resource_finish.
system_duplicate_id (RsystemDuplicateId.
kill_mon_list (2
.struct_kvRkillMonList
is_win (RisWin"†
resp_duplicate_resource_finish.
system_duplicate_id (RsystemDuplicateId4
reward_list (2.struct_reward_showR
rewardList"Ò
req_duplicate_nightmare_enter.
system_duplicate_id (RsystemDuplicateId(
rotate (2.struct_positionRrotate'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList"×
"req_duplicate_nightmare_enter_next.
system_duplicate_id (RsystemDuplicateId(
rotate (2.struct_positionRrotate'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList"½
req_duplicate_nightmare_finish.
system_duplicate_id (RsystemDuplicateId.
kill_mon_list (2
.struct_kvRkillMonList
is_win (RisWin,
duplicate_use_time (RduplicateUseTime

hp_percent (R	hpPercent'
use_hero_id_list (RuseHeroIdList.
use_buff_list (2
.struct_kvRuseBuffList"‡
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
.struct_kvRlayerScoreList"€
"resp_duplicate_nightmare_best_list
type (RtypeF
duplicate_best_list (2.struct_duplicate_bestRduplicateBestList"z
#resp_duplicate_nightmare_final_infoS
nightmare_final_info (2!.struct_duplicate_nightmare_finalRnightmareFinalInfo";
req_duplicate_nightmare_rank
	rank_type (RrankType"ª
resp_duplicate_nightmare_rank
	rank_type (RrankType8
	show_list (2.struct_nightmare_rank_infoRshowList2
rank_score_list (2
.struct_kvRrankScoreList"«
"resp_duplicate_city_operate_finish.
system_duplicate_id (RsystemDuplicateId4
reward_list (2.struct_reward_showR
rewardList
cost_energy (R
costEnergy"¤
req_duplicate_energy_boss_enter.
system_duplicate_id (RsystemDuplicateId(
rotate (2.struct_positionRrotate'
use_hero_id_list (RuseHeroIdList"™
 req_duplicate_energy_boss_finish.
system_duplicate_id (RsystemDuplicateId.
kill_mon_list (2
.struct_kvRkillMonList
is_win (RisWin"‰
!resp_duplicate_energy_boss_finish.
system_duplicate_id (RsystemDuplicateId4
reward_list (2.struct_reward_showR
rewardList"U
#req_duplicate_energy_boss_get_award.
system_duplicate_id (RsystemDuplicateId"Œ
$resp_duplicate_energy_boss_get_award.
system_duplicate_id (RsystemDuplicateId4
reward_list (2.struct_reward_showR
rewardList"o
)resp_duplicate_energy_boss_can_award_listB

award_list (2#.struct_duplicate_energy_boss_awardR	awardListbproto3
Ò
ecosystem.protostruct_common.proto"L
struct_conclude_info 
probability (Rprobability
time (Rtime"
struct_entity_born
id (Rid
reborn_time (R
rebornTime:
conclude_info (2.struct_conclude_infoRconcludeInfo"á
struct_ecosystem_drop
id (Rid(
item_template_id (RitemTemplateId

item_count (R	itemCount$
form_entity_id (RformEntityId
	dead_time (RdeadTime,
position (2.struct_positionRposition",
req_ecosystem_state
map_id (RmapId"Ü
resp_ecosystem_state
map_id (RmapId=
entity_born_list (2.struct_entity_bornRentityBornList9
unable_reborn_entity_list (RunableRebornEntityList3
	drop_list (2.struct_ecosystem_dropRdropList"t
req_ecosystem_hit
id (Rid,
position (2.struct_positionRposition!
is_transform (RisTransform"}
*struct_ecosystem_hit_partner_conclude_info

partner_id (R	partnerId0
golden_conclude_time (RgoldenConcludeTime"Ù
resp_ecosystem_hit
id (Rid3
	drop_list (2.struct_ecosystem_dropRdropList_
partner_conclude_info (2+.struct_ecosystem_hit_partner_conclude_infoRpartnerConcludeInfo

error_code (R	errorCode"M
req_ecosystem_obstruction_hit,
position (2.struct_positionRposition"º
resp_ecosystem_obstruction_hitW
drop_count_map (21.resp_ecosystem_obstruction_hit.DropCountMapEntryRdropCountMap?
DropCountMapEntry
key (Rkey
value (Rvalue:8"m
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
id_list (RidList"Ä
!resp_ecosystem_monster_level_bias]
level_bias_maps (25.resp_ecosystem_monster_level_bias.LevelBiasMapsEntryRlevelBiasMaps@
LevelBiasMapsEntry
key (Rkey
value (Rvalue:8bproto3
Ü
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
msg (	Rmsg""
e2s_hello_test
msg (	Rmsgbproto3

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

information.proto"
req_information"ù
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
ç
struct_hero.protostruct_common.proto"W
struct_hero_skill
order_id (RorderId
lev (Rlev
ex_lev (RexLev"Ê
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
 (2.struct_hero_skillR	skillListF
favorability_info (2.struct_hero_favorabilityRfavorabilityInfo&
first_gain_time (RfirstGainTime@
invitation_info (2.struct_hero_invitationRinvitationInfo&
in_prison_until (RinPrisonUntil 
is_in_prison (R
isInPrison;
out_of_prison_notification (RoutOfPrisonNotification
is_edu_exam (R	isEduExam!
bounty_level (RbountyLevel*
current_right_nume (RcurrentRightNum"X
struct_formation
id (Rid
name (	Rname 
hero_id_list (R
heroIdList"‰
struct_hero_favorability
level (Rlevel
cur_lev_exp (R	curLevExp7
already_treasure_id_list (RalreadyTreasureIdList"Š
struct_hero_robot
id (Rid/
property_list (2
.struct_kvRpropertyList
task_id (RtaskId
	task_step (RtaskStep"©
struct_hero_invitation.
is_accompany_unlock (RisAccompanyUnlock_
last_invitation_options_list (2.struct_hero_invitation_optionRlastInvitationOptionsList"p
struct_hero_invitation_option#
invitation_id (RinvitationId*
last_options_list (RlastOptionsListbproto3
õ
struct_weapon.proto"Õ
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
Ê
friend.protoinformation.protostruct_hero.protostruct_weapon.protostruct_partner.protostruct_common.proto"’
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
	timestamp (R	timestamp"…
resp_friend_chat
	target_id (RtargetId7
content_list (2.struct_chat_contentRcontentList
	is_unread (RisUnread"3
req_friend_chat_read
	target_id (RtargetIdbproto3
×
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
µ
guide.proto"
req_guide_add
id (Rid"?
resp_guide_add

error_code (R	errorCode
id (Rid"
req_guide_init"*
resp_guide_init
id_list (RidListbproto3
½
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
blueprint_id (RblueprintId"È
struct_blueprint_connect_point(
parent_bone_name (	RparentBoneName&
child_bone_name (	RchildBoneName

point_type (	R	pointType5
effect_offset (2.struct_positionReffectOffset"ç
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
parent_transform_nameh (	RparentTransformName5
effect_offseti (2.struct_positionReffectOffset"è
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
blueprint_id (RblueprintId"Ý
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
é

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
id (Rid"›
req_hero_robot_list
type (Rtype
task_id (RtaskId
	task_step (RtaskStep:
hero_robot_list (2.struct_hero_robotRheroRobotList"R
resp_hero_robot_list:
hero_robot_list (2.struct_hero_robotRheroRobotList"`
req_hero_favorability_give
hero_id (RheroId)

gifts_list (2
.struct_kvR	giftsList"M
!req_hero_favorability_gain_reward(
hero_treasure_id (RheroTreasureId"h
req_hero_invitation_get_reward#
invitation_id (RinvitationId!
options_list (RoptionsList"g
 resp_hero_invitation_show_reward
order (Rorder-
is_get_other_reward (RisGetOtherReward"?
$req_hero_invitation_accompany_unlock
hero_id (RheroId"H
resp_hero_city_ability_trigger&
city_ability_id (RcityAbilityIdbproto3
È
identity.protostruct_common.proto"‹
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
»
item_formula.proto"
req_item_formula_info";
resp_item_formula_info!
formula_list (RformulaList"G
req_item_formula

formula_id (R	formulaId
count (Rcountbproto3
Þ

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
is_lock (RisLock"‡
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
mod_list (2.struct_itemRmodList"”
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
.struct_kvRitemList"b
req_item_consume
template_id (R
templateId
count (Rcount
hero_id (RheroId"‰
struct_item_consume_record
item_id (RitemId,
record_remain_time (RrecordRemainTime$
cd_remain_time (RcdRemainTime"V
req_item_consume_staff<
record_list (2.struct_item_consume_recordR
recordList"W
resp_item_consume_staff<
record_list (2.struct_item_consume_recordR
recordList"¼
struct_item_consume_hero
hero_id (RheroId

full_value (R	fullValue*
avail_remain_time (RavailRemainTime<
record_list (2.struct_item_consume_recordR
recordList"F
req_item_consume_hero-
list (2.struct_item_consume_heroRlist"G
resp_item_consume_hero-
list (2.struct_item_consume_heroRlistbproto3
ƒ
struct_level_event.proto"[
struct_level_event
event_id (ReventId*
first_finish_time (RfirstFinishTime"
struct_level_event_finish_again
event_id (ReventId
finish_time (R
finishTime"
is_get_lilian (RisGetLilianbproto3
œ
level_event.protostruct_level_event.proto"6
req_level_event_get_award
event_id (ReventId"4
req_level_event_trigger
event_id (ReventId"[
resp_level_event_info_list=
level_event_list (2.struct_level_eventRlevelEventList"B
resp_level_event_trigger_list!
trigger_list (RtriggerList"9
req_level_event_finish_again
event_id (ReventId"=
 req_level_event_get_lilian_point
event_id (ReventId"B
req_lilian_point_get_award
id (Rid
level (Rlevel"—
resp_level_event_finish_again
type (Rtypeb
level_event_finish_again_list (2 .struct_level_event_finish_againRlevelEventFinishAgainListbproto3
ä
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
²

mail.protostruct_common.proto"³
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
Õ
	map.protostruct_common.proto"—
struct_map_mark
mark_id (RmarkId
type (Rtype
name (	Rname
map_id (RmapId,
position (2.struct_positionRposition"y
struct_fog_info)
big_bell_tower_id (RbigBellTowerId
	is_unlock (RisUnlock
fog_id_list (R	fogIdList"
req_map_info"~
resp_map_info
map_id (RmapId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate"†
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
rotate (2.struct_positionRrotate"ž
resp_map_enter
map_id (RmapId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate

error_codee (R	errorCode"š
req_map_to_transport_point$
entity_born_id (RentityBornId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate"Œ
resp_map_to_transport_point
map_id (RmapId,
position (2.struct_positionRposition(
rotate (2.struct_positionRrotate"H
req_map_transport_inside,
position (2.struct_positionRposition";
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
dislike (Rdislike"
req_map_fog"—
resp_map_fog8
	fog_infos (2.resp_map_fog.FogInfosEntryRfogInfosM
FogInfosEntry
key (Rkey&
value (2.struct_fog_infoRvalue:8"V
req_map_fog_unlock)
big_bell_tower_id (RbigBellTowerId
fog_id (RfogIdbproto3
T

meme.proto"
req_meme_list"-
resp_meme_list
	meme_list (RmemeListbproto3
å
mercenary_hunt.proto"3
resp_mercenary_main_info
main_id (RmainId"2
resp_mercenary_alert_value
value (Rvalue"!
req_mercenary_clean_alert_value"1
req_mercenary_fight_state
state (Rstate"ƒ
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
ô
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
t
monster_pursue.proto".
resp_monster_pursue
id_list (RidList"$
req_monster_pursue
id (Ridbproto3
ï
music.proto"f
struct_music
id (Rid
like (Rlike
	choise_id (RchoiseId
is_new (RisNew"
req_music_info"4
resp_music_info!
list (2.struct_musicRlist"+
req_music_like
music_id (RmusicId"-
req_music_unlike
music_id (RmusicId"K
req_music_comment
music_id (RmusicId
	choise_id (RchoiseId"P
req_music_activate
music_id (RmusicId
template_id (R
templateId"-
req_music_readed
music_id (RmusicIdbproto3
Ü
new_bargain.protostruct_common.proto"M
resp_bargain_info8
bargain_count_list (2
.struct_kvRbargainCountList"6
req_bargain_begin!
negotiate_id (RnegotiateId",
resp_bargain_begin
ticket (Rticket"®
req_bargain_result!
negotiate_id (RnegotiateId
rule (Rrule*
npc_operation_seq (RnpcOperationSeq0
player_operation_seq (RplayerOperationSeq:
skill_info_list (2.struct_skill_infoRskillInfoList
result (Rresult
ticket (Rticket
shop_id (RshopId"D
struct_skill_info
skill_id (RskillId
round (Rroundbproto3
Ë
noticeboard.proto"Ï
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
µ
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
¾
partner.protostruct_common.protostruct_partner.proto"ˆ
resp_partner_update*
add_list (2.struct_partnerRaddList
del_list (RdelList*
mod_list (2.struct_partnerRmodList"Y
resp_partner_init
volume (Rvolume,
	item_list (2.struct_partnerRitemList"J
req_partner_lock

partner_id (R	partnerId
is_lock (RisLock"„
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
golden_conclude_time (RgoldenConcludeTime"Œ
req_partner_conclude
item_id (RitemId!
ecosystem_id (RecosystemId

hp_percent (R	hpPercent
is_break (RisBreak"Ÿ
resp_partner_conclude!
ecosystem_id (RecosystemId 
probability (Rprobability)
rand_probability (RrandProbability
result (Rresult"?
req_partner_conclude_heart!
ecosystem_id (RecosystemId"?
req_partner_conclude_reset!
ecosystem_id (RecosystemId"Þ
req_partner_fusion*
master_partner_id (RmasterPartnerId9
master_affix_list (2.struct_affixRmasterAffixList(
slave_partner_id (RslavePartnerId7
slave_affix_list (2.struct_affixRslaveAffixList"A
resp_partner_fusion*
master_partner_id (RmasterPartnerId"¼
resp_partner_recruit_infoN
partner_info (2+.resp_partner_recruit_info.PartnerInfoEntryRpartnerInfoO
PartnerInfoEntry
key (Rkey%
value (2.struct_partnerRvalue:8"g
req_partner_recruit"
npc_entity_id (RnpcEntityId,
partner_recruit_id (RpartnerRecruitId"†
req_partner_car_skill_lev_up

partner_id (R	partnerId/
partner_car_skill_id (RpartnerCarSkillId6
raw_cost_partner_id_list (RrawCostPartnerIdList.
raw_item_list (2
.struct_kvRrawItemList
car_id (RcarId
slot_id (RslotId"C
resp_partner_interact_info%
interact_count (RinteractCount"<
req_partner_interact_fondle

partner_id (R	partnerId"S
req_partner_interact_feed

partner_id (R	partnerId
food_id (RfoodIdbproto3
í
struct_partner_recruit.protostruct_common.protostruct_partner.proto"m
struct_partner_recruit_id
type (Rtype
id (Rid,
position (2.struct_positionRposition"ª
struct_partner_recruit_info9

recruit_id (2.struct_partner_recruit_idR	recruitId6
recruit_type_list (2
.struct_kvRrecruitTypeList8
passive_skill_list (2
.struct_kvRpassiveSkillList,

affix_list (2.struct_affixR	affixList0
cold_down_list (2
.struct_kvRcoldDownListbproto3

partner_recruit.protostruct_partner_recruit.protonew_bargain.proto"ÿ
resp_partner_recruit_task_infov
partner_recruit_task_list (2;.resp_partner_recruit_task_info.PartnerRecruitTaskListEntryRpartnerRecruitTaskListe
PartnerRecruitTaskListEntry
key (Rkey0
value (2.struct_partner_recruit_idRvalue:8"T
req_partner_recruit_info_init3
id_list (2.struct_partner_recruit_idRidList"x
resp_partner_recruit_info_newW
partner_recruit_info_list (2.struct_partner_recruit_infoRpartnerRecruitInfoList"Ä
#resp_partner_recruit_npc_refresh_cd\
refresh_cd_map (26.resp_partner_recruit_npc_refresh_cd.RefreshCdMapEntryRrefreshCdMap?
RefreshCdMapEntry
key (Rkey
value (Rvalue:8"W
req_partner_recruit_submit9

recruit_id (2.struct_partner_recruit_idR	recruitId"^
!req_partner_recruit_bargain_start9

recruit_id (2.struct_partner_recruit_idR	recruitId"
req_partner_recruit_bargain_end9

recruit_id (2.struct_partner_recruit_idR	recruitId2
bargain_client_result (RbargainClientResult"]
 req_partner_recruit_stroke_start9

recruit_id (2.struct_partner_recruit_idR	recruitId"
req_partner_recruit_stroke_end9

recruit_id (2.struct_partner_recruit_idR	recruitId0
stroke_client_result (RstrokeClientResult"u
req_partner_recruit_task_accept9

recruit_id (2.struct_partner_recruit_idR	recruitId
task_id (RtaskId"\
req_partner_recruit_task_submit9

recruit_id (2.struct_partner_recruit_idR	recruitId"]
 req_partner_recruit_task_give_up9

recruit_id (2.struct_partner_recruit_idR	recruitId"Ù
req_partner_recruit_bargain9

recruit_id (2.struct_partner_recruit_idR	recruitId!
negotiate_id (RnegotiateId
rule (Rrule*
npc_operation_seq (RnpcOperationSeq0
player_operation_seq (RplayerOperationSeq:
skill_info_list (2.struct_skill_infoRskillInfoList
result (Rresult
ticket (Rticket"W
req_partner_recruit_stroke9

recruit_id (2.struct_partner_recruit_idR	recruitIdbproto3
Û
purchase.protostruct_common.proto"?
resp_purchase_total_purchase
month_total (R
monthTotal"à
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
id (Rid"“
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
¾
rogue.proto"à
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
req_rogue_info"×
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
event_id (ReventId"‘
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
remove_card_id_list (RremoveCardIdList"Á
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

area_logic (R	areaLogic"™
req_rogue_card_equipC

card_equip (2$.req_rogue_card_equip.CardEquipEntryR	cardEquip<
CardEquipEntry
key (Rkey
value (Rvalue:8"Y
req_rogue_event_discover"
area_logic_id (RareaLogicId
event_id (ReventIdbproto3
ø

role.proto"

req_quit"
req_role_init"
resp_role_init"¡
resp_role_propertyJ
property_maps (2%.resp_role_property.PropertyMapsEntryRpropertyMaps?
PropertyMapsEntry
key (Rkey
value (Rvalue:8"©
req_role_property_syncN
property_maps (2).req_role_property_sync.PropertyMapsEntryRpropertyMaps?
PropertyMapsEntry
key (Rkey
value (Rvalue:8"â
resp_role_kick_offline
	kick_type (RkickType
version (Rversion5
args (2!.resp_role_kick_offline.ArgsEntryRargs!
kick_context (	RkickContext7
	ArgsEntry
key (	Rkey
value (	Rvalue:8bproto3
ø

shop.protostruct_common.proto"¹
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
shop_id (RshopId"—
resp_shop_goods
shop_id (RshopId!
refresh_type (RrefreshType,

goods_list (2.struct_goodsR	goodsList
discount (Rdiscount"L
req_shop_goods_buy
goods_id (RgoodsId
	buy_count (RbuyCountbproto3
V
sleep.proto"2
resp_sleep_info
sleep_count (R
sleepCount"
	req_sleepbproto3
°
statistic.proto"J
resp_statistic_info3
statistic_info (2.struct_treeRstatisticInfo"p
 req_statistic_client_control_add
type (Rtype
	add_value (RaddValue
	args_list (RargsList"W
struct_tree
key (Rkey
value (Rvalue 
next (2.struct_treeRnextbproto3
÷
struct_task.protostruct_common.protostruct_partner_recruit.proto"{
struct_task_assist_id;

recruit_id (2.struct_partner_recruit_idH R	recruitId
system_typee (R
systemTypeB
id"Í
struct_task
id (Rid
step (Rstep
finish (Rfinish,
progress (2.struct_progressRprogress
in_progress (R
inProgress3
	assist_id (2.struct_task_assist_idRassistId"V
struct_task_node
node_id (RnodeId)
	task_list (2.struct_taskRtaskList"É
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
ü
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
ƒ
talent.protostruct_common.proto"ª
resp_talent_info=
talent_info_list (2.struct_talent_infoRtalentInfoList+
talent_liste (2
.struct_kvR
talentList*
already_open_listf (RalreadyOpenList"G
struct_talent_info
	talent_id (RtalentId
level (Rlevel".
req_talent_open
	talent_ide (RtalentId"0
req_talent_lev_up
	talent_id (RtalentIdbproto3
‹

task.protostruct_task.proto"í
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
task_id (RtaskId"_
req_task_accept
task_id (RtaskId3
	assist_id (2.struct_task_assist_idRassistId"*
req_task_submit
task_id (RtaskId"+
req_task_give_up
task_id (RtaskId"+
resp_task_remove
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
task_id (RtaskId"Ï
struct_task_choice
id (Rida
task_choice_count_maps (2,.struct_task_choice.TaskChoiceCountMapsEntryRtaskChoiceCountMapsF
TaskChoiceCountMapsEntry
key (Rkey
value (Rvalue:8"J
req_task_finish_statistic
type (Rtype
sec_type (RsecType"
resp_task_finish_statistic
type (Rtype
sec_type (RsecType4
choice_list (2.struct_task_choiceR
choiceListbproto3
®
teach.proto"
req_teach_add
id (Rid""
req_teach_reward
id (Rid"#
resp_teach_reward
id (Rid"-
resp_teach_last_id
id_list (RidListbproto3
•
	tip.proto"_
	struct_id
type (Rtype%
composition_id (RcompositionId
jump_id (RjumpId"J
resp_tip_info9
already_tip_id_list (2
.struct_idRalreadyTipIdList"S
req_tip_new_discovery:
combination_id_list (2
.struct_idRcombinationIdListbproto3
Ú
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
•
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
Ë
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
	item_list (2.struct_weaponRitemList"…
resp_weapon_update)
add_list (2.struct_weaponRaddList
del_list (RdelList)
mod_list (2.struct_weaponRmodList"G
req_weapon_lock
	weapon_id (RweaponId
is_lock (RisLock"1
resp_weapon_lock

error_code (R	errorCodebproto3
˜
world_level.proto"E
resp_world_level
level (Rlevel
	max_level (RmaxLevel"
req_world_level_upgrade"
req_world_level_degradebproto3