#define SCPSE_CLEARANCE_NONE 0
#define SCPSE_CLEARANCE_ONE 1
#define SCPSE_CLEARANCE_TWO 2
#define SCPSE_CLEARANCE_THREE 3
#define SCPSE_CLEARANCE_FOUR 4
#define SCPSE_CLEARANCE_FIVE 5

/proc/scpse_get_facility_clearance(mob/user)
	if(!isliving(user))
		return SCPSE_CLEARANCE_NONE

	var/mob/living/living_user = user
	var/obj/item/card/id/id_card = living_user.get_idcard(hand_first = TRUE)
	if(!id_card)
		return SCPSE_CLEARANCE_NONE

	var/scpse_clearance = id_card.scpse_get_clearance_level()
	if(isnum(scpse_clearance))
		return scpse_clearance

	var/list/access = id_card.GetAccess()
	if(!length(access))
		return SCPSE_CLEARANCE_NONE

	if((ACCESS_CAPTAIN in access) || (ACCESS_CENT_CAPTAIN in access) || (ACCESS_CENT_GENERAL in access) || (ACCESS_CENT_SPECOPS in access))
		return SCPSE_CLEARANCE_FIVE

	if((ACCESS_COMMAND in access) || (ACCESS_HOP in access) || (ACCESS_HOS in access) || (ACCESS_CE in access) || (ACCESS_CMO in access) || (ACCESS_RD in access) || (ACCESS_QM in access))
		return SCPSE_CLEARANCE_FOUR

	if((ACCESS_SECURITY in access) || (ACCESS_ARMORY in access) || (ACCESS_SCIENCE in access) || (ACCESS_RESEARCH in access) || (ACCESS_MEDICAL in access) || (ACCESS_ENGINEERING in access))
		return SCPSE_CLEARANCE_THREE

	if((ACCESS_CARGO in access) || (ACCESS_SERVICE in access) || (ACCESS_MAINT_TUNNELS in access) || (ACCESS_ATMOSPHERICS in access) || (ACCESS_ROBOTICS in access))
		return SCPSE_CLEARANCE_TWO

	return SCPSE_CLEARANCE_ONE

/proc/scpse_get_user_dna_hash(mob/user)
	var/datum/dna/user_dna = user?.has_dna()
	return user_dna?.unique_enzymes

/obj/structure/scpse_facility_doorframe
	name = "facility door frame"
	desc = "A reinforced frame for a heavy facility door."
	icon = 'modular_scpse/modules/facility/icons/facility_doors.dmi'
	icon_state = "doorframe"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = CLOSED_DOOR_LAYER - 0.01

/obj/machinery/door/airlock/scpse_facility
	name = "facility door"
	desc = "A heavy facility access door."
	icon = 'modular_scpse/modules/facility/icons/facility_doors.dmi'
	icon_state = "lcz_door"
	base_icon_state = "lcz_door"
	can_open_with_hands = FALSE
	autoclose = TRUE
	overlays_file = null
	anchored = TRUE
	density = TRUE
	opacity = TRUE
	flags_1 = IGNORE_TURF_PIXEL_OFFSET_1
	pass_flags_self = PASSDOORS
	note_overlay_file = null
	smoothing_flags = NONE
	assemblytype = null
	/// Optional mapper-facing note for the intended matching /obj/machinery/button/door/scpse_facility id.
	var/facility_link_note
	/// Mapper-friendly alias for id_tag. Buttons match either this or id_tag.
	var/id
	/// The frame spawned with this door. It intentionally survives door destruction.
	var/obj/structure/scpse_facility_doorframe/door_frame

/obj/machinery/door/airlock/scpse_facility/Initialize(mapload)
	. = ..()
	if(id && !id_tag)
		id_tag = id
	door_frame = locate(/obj/structure/scpse_facility_doorframe) in loc
	if(!door_frame)
		door_frame = new(loc)
	door_frame.dir = dir

/obj/machinery/door/airlock/scpse_facility/update_icon_state()
	if(!airlock_state)
		airlock_state = density ? AIRLOCK_CLOSED : AIRLOCK_OPEN
	switch(airlock_state)
		if(AIRLOCK_OPEN)
			icon_state = null
		if(AIRLOCK_OPENING, AIRLOCK_CLOSING)
			icon_state = "lcz_door-open"
		else
			icon_state = "lcz_door"

/obj/machinery/door/airlock/scpse_facility/update_overlays()
	return list()

/obj/machinery/door/airlock/scpse_facility/bumpopen(mob/living/user)
	return FALSE

/obj/machinery/door/airlock/scpse_facility/proc/scpse_matches_button_id(button_id)
	return button_id && (id_tag == button_id || id == button_id)

/obj/machinery/door/airlock/scpse_facility/on_deconstruction(disassembled)
	if(!door_frame || QDELETED(door_frame))
		door_frame = new(loc)
		door_frame.dir = dir
	else
		door_frame.forceMove(loc)
		door_frame.dir = dir

/obj/machinery/door/airlock/scpse_facility/examine(mob/user)
	. = ..()
	if(id)
		. += span_notice("Its facility door ID is '[id]'.")
	if(id_tag)
		. += span_notice("Its facility control ID is '[id_tag]'.")
	if(facility_link_note)
		. += span_notice("[facility_link_note]")

/obj/machinery/button/door/scpse_facility
	name = "facility door button"
	desc = "A facility door control switch."
	icon = 'modular_scpse/modules/facility/icons/buttons.dmi'
	icon_state = "button"
	base_icon_state = "button"
	normaldoorcontrol = TRUE
	can_alter_skin = FALSE
	/// Local cooldown used because SCPSE buttons directly pulse SCPSE doors.
	var/next_scpse_press = 0

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/button/door/scpse_facility, 24)

/obj/machinery/button/door/scpse_facility/setup_device(mapload)
	initialized_button = TRUE

/obj/machinery/button/door/scpse_facility/update_icon_state()
	icon_state = base_icon_state
	return

/obj/machinery/button/door/scpse_facility/update_overlays()
	return list()

/obj/machinery/button/door/scpse_facility/proc/scpse_can_press(mob/user)
	return TRUE

/obj/machinery/button/door/scpse_facility/proc/scpse_get_linked_doors()
	var/list/obj/machinery/door/airlock/scpse_facility/linked_doors = list()
	if(id)
		for(var/obj/machinery/door/airlock/scpse_facility/facility_door as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door/airlock/scpse_facility))
			if(facility_door.scpse_matches_button_id(id))
				linked_doors += facility_door
		return linked_doors

	for(var/obj/machinery/door/airlock/scpse_facility/nearby_door in orange(1, src))
		linked_doors += nearby_door
	return linked_doors

/obj/machinery/button/door/scpse_facility/proc/scpse_pulse_linked_doors(mob/user)
	var/list/obj/machinery/door/airlock/scpse_facility/linked_doors = scpse_get_linked_doors()
	if(!length(linked_doors))
		balloon_alert(user, "no linked door")
		return FALSE

	var/doors_need_closing = FALSE
	for(var/obj/machinery/door/airlock/scpse_facility/facility_door as anything in linked_doors)
		if(!facility_door.density)
			doors_need_closing = TRUE
			break

	for(var/obj/machinery/door/airlock/scpse_facility/facility_door as anything in linked_doors)
		INVOKE_ASYNC(facility_door, doors_need_closing ? TYPE_PROC_REF(/obj/machinery/door/airlock/scpse_facility, close) : TYPE_PROC_REF(/obj/machinery/door/airlock/scpse_facility, open))

	return TRUE

/obj/machinery/button/door/scpse_facility/attempt_press(mob/user)
	if((machine_stat & (NOPOWER|BROKEN)))
		return FALSE

	if(next_scpse_press > world.time)
		return FALSE

	if(!allowed(user) || !scpse_can_press(user))
		balloon_alert(user, "access denied")
		flick(base_icon_state, src)
		return FALSE

	use_energy(5 JOULES)
	flick(base_icon_state, src)
	if(!scpse_pulse_linked_doors(user))
		return FALSE

	next_scpse_press = world.time + 1 SECONDS
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_BUTTON_PRESSED, src)
	return TRUE

/obj/machinery/button/door/scpse_facility/cardlock
	name = "facility cardlock"
	desc = "A facility card reader."
	icon_state = "cardlock"
	base_icon_state = "cardlock"
	/// Minimum SCPSE clearance level accepted by this reader.
	var/required_clearance = SCPSE_CLEARANCE_ONE

/obj/machinery/button/door/scpse_facility/card_lock
	parent_type = /obj/machinery/button/door/scpse_facility/cardlock

/obj/machinery/button/door/scpse_facility/cardlock/examine(mob/user)
	. = ..()
	. += span_notice("It requires facility clearance level [required_clearance] or higher.")

/obj/machinery/button/door/scpse_facility/cardlock/scpse_can_press(mob/user)
	if(!..())
		return FALSE
	return scpse_get_facility_clearance(user) >= required_clearance

/obj/machinery/button/door/scpse_facility/cardlock/level_1
	required_clearance = SCPSE_CLEARANCE_ONE

/obj/machinery/button/door/scpse_facility/cardlock/level_2
	required_clearance = SCPSE_CLEARANCE_TWO

/obj/machinery/button/door/scpse_facility/cardlock/level_3
	required_clearance = SCPSE_CLEARANCE_THREE

/obj/machinery/button/door/scpse_facility/cardlock/level_4
	required_clearance = SCPSE_CLEARANCE_FOUR

/obj/machinery/button/door/scpse_facility/cardlock/level_5
	required_clearance = SCPSE_CLEARANCE_FIVE

/obj/machinery/button/door/scpse_facility/dnalock
	name = "facility DNA lock"
	desc = "A facility biometric scanner."
	icon_state = "dnalock"
	base_icon_state = "dnalock"
	/// Set this to a target mob's dna.unique_enzymes value for exact biometric matching.
	var/required_dna
	/// Optional mapper-friendly fallback when a stable DNA hash is not known.
	var/required_real_name

/obj/machinery/button/door/scpse_facility/dna_lock
	parent_type = /obj/machinery/button/door/scpse_facility/dnalock

/obj/machinery/button/door/scpse_facility/dnalock/examine(mob/user)
	. = ..()
	if(required_real_name)
		. += span_notice("It is keyed to [required_real_name].")

/obj/machinery/button/door/scpse_facility/dnalock/scpse_can_press(mob/user)
	if(!..())
		return FALSE

	var/datum/dna/user_dna = user?.has_dna()
	if(required_dna && user_dna?.unique_enzymes == required_dna)
		return TRUE

	if(required_real_name && (user?.real_name == required_real_name || user_dna?.real_name == required_real_name))
		return TRUE

	return FALSE

#undef SCPSE_CLEARANCE_NONE
#undef SCPSE_CLEARANCE_ONE
#undef SCPSE_CLEARANCE_TWO
#undef SCPSE_CLEARANCE_THREE
#undef SCPSE_CLEARANCE_FOUR
#undef SCPSE_CLEARANCE_FIVE
