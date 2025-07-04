
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
�
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
pos_z (RposZbproto3
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
�
asset.proto"Q
resp_energy_info
energy (Renergy%
next_timestamp (RnextTimestamp"Z
resp_role_asset_info
gold (Rgold
diamond (Rdiamond
power (Rpowerbproto3
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
�
client.proto"0
req_heartbeat
client_time (R
clientTime"R
resp_heartbeat
client_time (R
clientTime
server_time (R
serverTime"�
req_client_login
account (	Raccount
type (Rtype
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
ticket (	Rticket"�
resp_client_login
flag (Rflag
msg (	Rmsg)
server_timestamp (RserverTimestamp
timezone (Rtimezone"
req_client_quit"1
resp_client_quit

error_code (R	errorCode"3
req_client_file_record
rec_list (	RrecList"_
resp_client_cmd
order_id (RorderId
cmd (Rcmd
notice_code (R
noticeCodebproto3
�
condition.proto"%
req_condition_state
id (Rid"[
resp_condition_state

error_code (R	errorCode
id (Rid
state (Rstatebproto3
�
struct_duplicate.proto"h
struct_duplicate
id (Rid

best_score (R	bestScore%
finished_times (RfinishedTimesbproto3
�
duplicate.protostruct_common.protostruct_duplicate.proto"
req_duplicate_state"P
resp_duplicate_state8
duplicate_list (2.struct_duplicateRduplicateList"8
req_duplicate_enter!
duplicate_id (RduplicateId"X
resp_duplicate_enter!
duplicate_id (RduplicateId

error_code (R	errorCode"
req_duplicate_quit"W
resp_duplicate_quit!
duplicate_id (RduplicateId

error_code (R	errorCode"i
req_duplicate_finish!
duplicate_id (RduplicateId.
kill_mon_list (2
.struct_kvRkillMonList"g
resp_duplicate_finish!
duplicate_id (RduplicateId+
reward_list (2
.struct_kvR
rewardListbproto3
�

ecosystem.protostruct_common.proto"E
struct_entity_born
id (Rid
reborn_time (R
rebornTime"�
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
position (2.struct_positionRposition"x
resp_ecosystem_hit
id (Rid3
	drop_list (2.struct_ecosystem_dropRdropList

error_code (R	errorCode"m
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
entity_state_list (2.struct_entity_stateRentityStateListbproto3
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
G
hacking.proto".
req_hacking_build
build_id (RbuildIdbproto3
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
id (Ridbproto3
�
information.proto"
req_information"z
resp_information
	nick_name (	RnickName
	signature (	R	signature
photo_id (RphotoId
uid (Ruid"8
req_information_nick_name
	nick_name (	RnickName"X
resp_information_nick_name

error_code (R	errorCode
	nick_name (	RnickName"9
req_information_signature
	signature (	R	signature"Y
resp_information_signature

error_code (R	errorCode
	signature (	R	signature"5
req_information_photo_id
photo_id (RphotoId"U
resp_information_photo_id

error_code (R	errorCode
photo_id (RphotoIdbproto3
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
�

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
ex_arg_list (R	exArgList"S
resp_item_init
volume (Rvolume)
	item_list (2.struct_itemRitemList"
resp_item_update'
add_list (2.struct_itemRaddList
del_list (RdelList'
mod_list (2.struct_itemRmodListbproto3
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
�
	map.protostruct_common.proto"�
struct_map_mark
mark_id (RmarkId
type (Rtype
name (	Rname
map_id (RmapId,
position (2.struct_positionRposition"
req_map_info"T
resp_map_info
map_id (RmapId,
position (2.struct_positionRposition"\
req_map_sync_position
map_id (RmapId,
position (2.struct_positionRposition"|
resp_map_sync_position

error_code (R	errorCode
map_id (RmapId,
position (2.struct_positionRposition"T
req_map_enter
map_id (RmapId,
position (2.struct_positionRposition"t
resp_map_enter

error_code (R	errorCode
map_id (RmapId,
position (2.struct_positionRposition"p
req_map_to_transport_point$
entity_born_id (RentityBornId,
position (2.struct_positionRposition"b
resp_map_to_transport_point
map_id (RmapId,
position (2.struct_positionRposition";
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
scene_msg_id (R
sceneMsgId
	operation (R	operation"L
req_scene_msg_operate3
	scene_msg (2.struct_role_scene_msgRsceneMsg"R
resp_scene_msg_operate_list3
	scene_msg (2.struct_role_scene_msgRsceneMsg";
req_scene_msg_statistic 
scene_msg_id (R
sceneMsgId"j
resp_scene_msg_statistic 
scene_msg_id (R
sceneMsgId
like (Rlike
dislike (Rdislikebproto3
�
mercenary_hunt.proto"T
resp_mercenary_main_info
main_id (RmainId
reward_time (R
rewardTime"2
resp_mercenary_alert_value
value (Rvalue"!
req_mercenary_clean_alert_value"1
req_mercenary_fight_state
state (Rstate"�
struct_mercenary!
ecosystem_id (RecosystemId
stage_id (RstageId
level (Rlevel
	name_list (RnameList%
discover_state (RdiscoverState
chase_state (R
chaseState
reborn_time (R
rebornTime"n
resp_mercenary_list8
mercenary_list (2.struct_mercenaryRmercenaryList

is_refresh (R	isRefresh"A
req_mercenary_discover_state!
ecosystem_id (RecosystemId"'
resp_mercenary_rank
exp (Rexp":
req_mercenary_reward_list

rank_level (R	rankLevel"D
resp_mercenary_reward_list&
rank_level_list (RrankLevelListbproto3
�
partner.protostruct_common.proto"�
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
.struct_kvR	skillList"�
resp_partner_update*
add_list (2.struct_partnerRaddList
del_list (RdelList*
mod_list (2.struct_partnerRmodList"Y
resp_partner_init
volume (Rvolume,
	item_list (2.struct_partnerRitemList"[
req_partner_lev_up

partner_id (R	partnerId&
partner_id_list (RpartnerIdList"T
req_partner_skill_lev_up

partner_id (R	partnerId
skill_id (RskillId"G
req_partner_show_get_window(
partner_group_id (RpartnerGroupIdbproto3
C

role.proto"

req_quit"
req_role_init"
resp_role_initbproto3
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
priority	 (Rpriority")
req_shop_goods
shop_id (RshopId"{
resp_shop_goods
shop_id (RshopId!
refresh_type (RrefreshType,

goods_list (2.struct_goodsR	goodsList"L
req_shop_goods_buy
goods_id (RgoodsId
	buy_count (RbuyCountbproto3
�
statistic.proto"J
resp_statistic_info3
statistic_info (2.struct_treeRstatisticInfo"s
struct_tree
key (H Rkey�
value (HRvalue� 
next (2.struct_treeRnextB
_keyB
_valuebproto3
�
struct_task.protostruct_common.proto"�
struct_task
id (Rid
finish (Rfinish5
progress_list (2.struct_progressRprogressList
in_progress (R
inProgressbproto3
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
�

task.protostruct_task.proto"
req_task_state"<
resp_task_state)
	task_list (2.struct_taskRtaskList"*
req_task_accept
task_id (RtaskId"1
resp_task_accept

error_code (R	errorCode"*
req_task_commit
task_id (RtaskId"J
resp_task_commit
task_id (RtaskId

error_code (R	errorCode"
req_task_finished"6
resp_task_finished 
task_id_list (R
taskIdList"
req_task_visible"5
resp_task_visible 
task_id_list (R
taskIdList"�
req_task_client_add_progress
task_id (RtaskId
progress_id (R
progressId
add_num (RaddNum
type (Rtype">
resp_task_client_add_progress

error_code (R	errorCode"2
req_task_reset_progress
task_id (RtaskId"9
resp_task_reset_progress

error_code (R	errorCode")
req_task_trace
task_id (RtaskId"*
resp_task_trace
task_id (RtaskIdbproto3
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
�
unlock.proto""
req_unlock_begin
id (Rid"$
req_unlock_success
id (Rid"3
resp_unlock_list
unlock_list (R
unlockListbproto3
�
weapon.protostruct_common.proto"�
struct_weapon
	unique_id (RuniqueId
template_id (R
templateId
lev (Rlev
exp (Rexp
stage (Rstage
refine (Rrefine
hero_id (RheroId
	is_locked (RisLocked"
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