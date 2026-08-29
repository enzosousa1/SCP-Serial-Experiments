#define ui_above_resist "EAST-2:26,SOUTH+1:24"
#define SCP173_BLINK_RANGE 24
#define SCP173_BLINK_INTERVAL 7.5 SECONDS
#define SCP173_BLINK_DURATION 0.25 SECONDS
#define SCP173_BLINK_FULLSCREEN "scp173_blink"

/atom/movable/screen/blink
	name = "Blink"
	icon = 'modular_scpse/modules/scp_hud/icons/screen_scp.dmi'
	icon_state = "act_blink"
	base_icon_state = "act_blink"
	mouse_over_pointer = MOUSE_HAND_POINTER
	screen_loc = ui_above_resist
	maptext_x = 2
	maptext_y = 16

/atom/movable/screen/blink/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/living/owner = hud_owner?.mymob
	if(!istype(owner))
		return
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_mob_life))
	update_blink_ui(owner)

/atom/movable/screen/blink/Destroy()
	var/mob/living/owner = hud?.mymob
	if(istype(owner))
		UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	return ..()

/atom/movable/screen/blink/Click()
	var/mob/living/owner = hud?.mymob
	if(usr != owner || !istype(owner))
		return TRUE
	if(owner.scp173_should_blink())
		owner.trigger_scp173_blink()
	update_blink_ui(owner)
	return TRUE

/atom/movable/screen/blink/proc/on_mob_life(mob/living/source, seconds_per_tick)
	SIGNAL_HANDLER
	source.process_scp173_blink(seconds_per_tick)
	update_blink_ui(source)

/atom/movable/screen/blink/proc/update_blink_ui(mob/living/owner)
	if(!istype(owner))
		return
	if(!owner.scp173_should_blink())
		alpha = 90
		maptext = null
		return

	alpha = 255
	var/fill_steps = clamp(round(owner.scp173_blink_progress * 20), 0, 20)
	var/empty_steps = 20 - fill_steps
	var/fill = repeat_string(fill_steps, "|")
	var/empty = repeat_string(empty_steps, ".")
	maptext = MAPTEXT("<div align='center'><font color='white'>[fill][empty]</font></div>")

/mob/living
	/// Current blink meter value for SCP-173 interaction [0..1].
	var/scp173_blink_progress = 1
	/// World time until we're considered to be currently blinking.
	var/scp173_blinking_until = 0

/mob/living/proc/is_scp173_blinking()
	return world.time < scp173_blinking_until

/mob/living/proc/scp173_should_blink()
	if(!client || stat != CONSCIOUS)
		return FALSE
	for(var/mob/living/basic/scp/scp173/scp in GLOB.mob_living_list)
		if(z != scp.z)
			continue
		if(get_dist(src, scp) <= SCP173_BLINK_RANGE)
			return TRUE
	return FALSE

/mob/living/proc/process_scp173_blink(seconds_per_tick)
	if(!scp173_should_blink())
		scp173_blink_progress = 1
		return
	if(is_scp173_blinking())
		return

	scp173_blink_progress = max(0, scp173_blink_progress - (seconds_per_tick / (SCP173_BLINK_INTERVAL / (1 SECONDS))))
	if(scp173_blink_progress <= 0)
		trigger_scp173_blink()

/mob/living/proc/trigger_scp173_blink()
	scp173_blink_progress = 1
	scp173_blinking_until = world.time + SCP173_BLINK_DURATION
	overlay_fullscreen(SCP173_BLINK_FULLSCREEN, /atom/movable/screen/fullscreen/flash/black)
	addtimer(CALLBACK(src, PROC_REF(clear_fullscreen), SCP173_BLINK_FULLSCREEN, 0), SCP173_BLINK_DURATION)

