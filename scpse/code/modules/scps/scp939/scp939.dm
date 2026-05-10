/*
 * SCP-939 - With Many Voices
 *
 * A predatory organism that mimics the voices of those it has consumed to
 * lure new prey. Operates in two distinct postures:
 *
 * QUADRUPED (hunting mode):
 *   - Faster movement, higher melee damage
 *   - Can crawl through ventilation shafts
 *   - Can pass over tables
 *
 * BIPED (social mode):
 *   - Slower movement, lower melee damage
 *   - Can open doors and operate radios
 *   - Cannot enter ventilation shafts
 */

// ============================================================
//  Blackboard keys (defined here so scp939.dm is self-contained;
//  scp939_ai.dm includes this file or they share a common #include)
// ============================================================
#define BB_SCP939_FLEE_HEALTH   "scp939_flee_health"
#define BB_SCP939_SAFE_VENT     "scp939_safe_vent"
#define BB_SCP939_VICTIMS_LIST  "scp939_victims_list"
#define BB_SCP939_BLOCKING_DOOR "scp939_blocking_door"

// ============================================================
//  Posture defines
// ============================================================
#define SCP939_POSTURE_QUADRUPED "quadruped"
#define SCP939_POSTURE_BIPED     "biped"
#define SCP939_BIPED_TRAIT_SOURCE "scp939_biped"
#define SCP939_BIPED_INTERACTION  "scp939_biped_airlock_pry"

// ============================================================
//  Mob type
// ============================================================
/mob/living/basic/scp/scp939
	name = "\improper SCP-939"
	desc = "A predatory organism capable of mimicking human speech to lure prey. Its crimson hide is slick with ammonia-like secretions."
	icon = 'scpse/icons/scps/scp-939.dmi'
	icon_state = "crawling"
	icon_dead = "dead_dramatic"
	mob_biotypes = MOB_ORGANIC | MOB_BEAST
	health = 250
	maxHealth = 250

	// Quadruped defaults
	melee_damage_lower = 20
	melee_damage_upper = 33
	speed = 0.2

	// ---- Attack configuration ----
	attack_verb_continuous = "mauls"
	attack_verb_simple = "maul"
	attack_sound = 'sound/items/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	see_in_dark = 6
	mob_size = MOB_SIZE_LARGE
	light_range = 0
	var/current_posture = SCP939_POSTURE_QUADRUPED
	var/list/consumed_victims = list()
	var/current_voice_name = null
	var/consume_cooldown = FALSE

/mob/living/basic/scp/scp939/Initialize(mapload)
	. = ..()
	ai_controller = new /datum/ai_controller/basic_controller/scp939(src)

	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
	pass_flags |= PASSTABLE
	AddElement(/datum/element/footstep, footstep_type = FOOTSTEP_MOB_CLAW)
	AddComponent(/datum/component/basic_inhands)

/mob/living/basic/scp/scp939/Destroy()
	QDEL_NULL(ai_controller)
	consumed_victims.Cut()
	return ..()

/mob/living/basic/scp/scp939/update_icon_state()
	. = ..()
	if(stat == DEAD)
		icon_state = icon_dead
		return
	icon_state = (current_posture == SCP939_POSTURE_QUADRUPED) ? "crawling" : "standing"

/mob/living/basic/scp/scp939/proc/set_posture(new_posture)
	if(!(new_posture in list(SCP939_POSTURE_QUADRUPED, SCP939_POSTURE_BIPED)))
		return
	if(current_posture == new_posture)
		return
	current_posture = new_posture

	switch(current_posture)
		if(SCP939_POSTURE_QUADRUPED)
			// Fast, lethal, can vent-crawl and pass tables
			set_varspeed(0.2)
			melee_damage_lower = 20
			melee_damage_upper = 33
			remove_traits(list(TRAIT_ADVANCEDTOOLUSER, TRAIT_CAN_STRIP), SCP939_BIPED_TRAIT_SOURCE)
			RemoveElement(/datum/element/door_pryer, pry_time = 4 SECONDS, interaction_key = SCP939_BIPED_INTERACTION)
			RemoveElement(/datum/element/dextrous)
			ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
			pass_flags |= PASSTABLE
			visible_message(span_warning("[src] drops to all fours, moving with predatory efficiency!"))

		if(SCP939_POSTURE_BIPED)
			// Slower, weaker — but can open doors and use a radio
			set_varspeed(1)
			melee_damage_lower = 15
			melee_damage_upper = 25
			REMOVE_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
			pass_flags &= ~PASSTABLE
			add_traits(list(TRAIT_ADVANCEDTOOLUSER, TRAIT_CAN_STRIP), SCP939_BIPED_TRAIT_SOURCE)
			AddElement(/datum/element/dextrous)
			AddElement(/datum/element/door_pryer, pry_time = 4 SECONDS, interaction_key = SCP939_BIPED_INTERACTION)
			visible_message(span_notice("[src] rises onto two legs, eerily imitating human posture."))

	update_appearance()

/mob/living/basic/scp/scp939/get_voice(add_id_name = FALSE)
	if(istext(current_voice_name) && length(current_voice_name))
		return current_voice_name
	return ..(add_id_name)

/mob/living/basic/scp/scp939/proc/consume_victim(mob/living/carbon/human/H)
	if(!istype(H) || consume_cooldown)
		return
	var/victim_name = H.real_name
	if(!length(victim_name))
		victim_name = H.name
	if(!length(victim_name))
		return
	if(consumed_victims[victim_name])
		return // Already have this voice

	consume_cooldown = TRUE
	addtimer(VARSET_CALLBACK(src, consume_cooldown, FALSE), 2 SECONDS, TIMER_UNIQUE)

	// Snapshot the victim's current appearance as a menu icon
	var/image/victim_icon = image(H.icon, icon_state = H.icon_state)
	consumed_victims[victim_name] = victim_icon

	// Passive healing reward for a successful kill
	heal_overall_damage(30)

	visible_message(
		span_danger("[src] tears into [H], absorbing [H.p_their()] voice!"),
		span_userdanger("You absorb [victim_name]'s voice into your memory.")
	)

/mob/living/basic/scp/scp939/proc/resolve_voice_choice(choice)
	if(!istext(choice))
		return null
	for(var/voice_name in consumed_victims)
		if(voice_name == choice)
			return voice_name
	return null

/mob/living/basic/scp/scp939/proc/pick_stored_voice()
	var/list/voice_names = list()
	for(var/voice_name in consumed_victims)
		if(istext(voice_name) && length(voice_name))
			voice_names += voice_name
	if(!length(voice_names))
		return null
	return pick(voice_names)

/mob/living/basic/scp/scp939/proc/open_voice_menu(mob/user)
	if(user != src || stat != CONSCIOUS)
		return
	if(!length(consumed_victims))
		to_chat(src, span_warning("You have no voices stored yet."))
		return

	var/choice = show_radial_menu(
		user,
		src,
		consumed_victims,
		custom_check = CALLBACK(src, PROC_REF(can_use_menu), user),
		radius       = 38,
		require_near = TRUE,
		autopick_single_option = FALSE,
	)
	choice = resolve_voice_choice(choice)
	if(!choice)
		return

	current_voice_name = choice
	to_chat(src, span_notice("You will now speak as [choice]."))

/mob/living/basic/scp/scp939/proc/can_use_menu(mob/user)
	return (user == src && stat == CONSCIOUS)

// --------------------------------------------------------
//  Biped-only: door interaction
// --------------------------------------------------------
/**
 * In biped mode, SCP-939 can physically manipulate doors it bumps into.
 * This is wired via the standard bump proc used by the AI movement layer.
 */
/mob/living/basic/scp/scp939/Bump(atom/A)
	. = ..()
	if(current_posture != SCP939_POSTURE_BIPED)
		return
	if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(!D.density || D.operating)
			return
		var/old_combat_mode = combat_mode
		set_combat_mode(FALSE)
		UnarmedAttack(D, TRUE)
		set_combat_mode(old_combat_mode)

// --------------------------------------------------------
//  Biped-only: radio interaction
// --------------------------------------------------------
/**
 * Lets a biped SCP-939 pick up and operate a radio to broadcast mimicked
 * voices over comms — a uniquely terrifying threat vector.
 * Can only be triggered when in biped mode and conscious.
 */
/mob/living/basic/scp/scp939/proc/try_use_radio(obj/item/radio/R, mob/user)
	if(current_posture != SCP939_POSTURE_BIPED)
		return FALSE
	if(stat != CONSCIOUS || !istype(R))
		return FALSE
	if(!istext(current_voice_name) || !length(current_voice_name))
		to_chat(src, span_warning("You have no voice selected to broadcast."))
		return FALSE
	// Emit the mimicked voice over the radio's channel
	R.talk_into(src, pick(list(
		"Help me!", "Is anyone there?", "I'm bleeding!",
		"Over here!", "I think it's gone...", "Please, somebody..."
	)))
	return TRUE

// --------------------------------------------------------
//  Attack override — quadruped gets a bonus bleed proc
// --------------------------------------------------------
/mob/living/basic/scp/scp939/attack_animal(mob/living/target, list/modifiers)
	. = ..()
	if(!. || current_posture != SCP939_POSTURE_QUADRUPED)
		return
	// Inflict a bleed wound on successful quadruped strikes
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.apply_damage(5, BRUTE, BODY_ZONE_CHEST)
		H.emote("scream")
