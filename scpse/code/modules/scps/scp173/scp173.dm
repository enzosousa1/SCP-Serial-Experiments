#define SNAP_COUNTER_MAX 3
#define SNAP_COOLDOWN_MAX 60 SECONDS

/mob/living/basic/scp173
    name = "SCP-173"
    desc = "A creepy concrete statue. It moves when unobserved."
    icon = 'scpse/icons/scps/scp-173.dmi'
    icon_state = "173"
    faction = list(FACTION_SCP)
    health = 5000
    maxHealth = 5000
    animate_movement = NO_STEPS
    hud_possible = list(ANTAG_HUD)
    speed = -1
    status_flags = CANPUSH
    unsuitable_atmos_damage = 0
    unsuitable_cold_damage = 0
    unsuitable_heat_damage = 0
    sight = SEE_SELF|SEE_MOBS|SEE_OBJS|SEE_TURFS

    move_force = MOVE_FORCE_EXTREMELY_STRONG
    move_resist = MOVE_FORCE_EXTREMELY_STRONG
    pull_force = MOVE_FORCE_EXTREMELY_STRONG
    ai_controller = /datum/ai_controller/basic_controller/scp173

    var/snap_counter = SNAP_COUNTER_MAX
    COOLDOWN_DECLARE(exhaustion_cooldown)



/mob/living/basic/scp173/Initialize(mapload)
    . = ..()
    add_traits(list(TRAIT_MUTE, TRAIT_STRONG_GRABBER), INNATE_TRAIT)

/mob/living/basic/scp173/Move(atom/newloc, direct, glide_size_override)
	if(can_be_seen())
		return FALSE
	return ..()

/mob/living/basic/scp173/proc/is_observed_by(mob/living/observer)
	if(QDELETED(observer) || observer == src || !observer.client)
		return FALSE
	if(observer.stat != CONSCIOUS)
		return FALSE
	if(observer.is_scp173_blinking())
		return FALSE

	var/observer_to_scp = get_dir(observer, src)
	if(!observer_to_scp || !(observer.dir & observer_to_scp))
		return FALSE

	return can_see(observer, src, get_dist(observer, src))

/mob/living/basic/scp173/proc/can_be_seen()
	for(var/mob/living/observer in GLOB.player_list)
		if(is_observed_by(observer))
			return TRUE
	return FALSE

/mob/living/basic/scp173/med_hud_set_health()
    return //we're a statue we're invincible

/mob/living/basic/scp173/med_hud_set_status()
    return //we're a statue we're invincible

/mob/living/basic/scp173/melee_attack(atom/target, list/modifiers, ignore_cooldown)
    if (!iscarbon(target))
        return ..()

    var/mob/living/carbon/carbon_target = target

    if (!COOLDOWN_FINISHED(src, exhaustion_cooldown))
        to_chat(src, span_warning("Your concrete joints are locked! Please wait."))
        return FALSE

    carbon_target.visible_message(span_userdanger("[src] breaks [carbon_target]'s neck!"))
    playsound(carbon_target, 'sound/effects/snap.ogg', 50, TRUE)
    carbon_target.apply_damage(9999, BRUTE, BODY_ZONE_HEAD)
    carbon_target.investigate_log("[src] got killed by SCP-173.", INVESTIGATE_DEATHS)
    snap_counter--

    if (snap_counter <= 0)
        COOLDOWN_START(src, exhaustion_cooldown, SNAP_COOLDOWN_MAX)
        snap_counter = SNAP_COUNTER_MAX
        to_chat(src, span_danger("You've twisted necks too quickly! Wait a minute to recover your mobility."))

    return TRUE

/mob/living/basic/scp173/gib()
    dust()
