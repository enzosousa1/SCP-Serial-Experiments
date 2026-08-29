/*
 * SCP-939 AI - With Many Voices
 *
 * Priority order:
 * 1. generic_resist
 * 2. scp939_retreat
 * 3. scp939_pry_blocking_door
 * 4. scp939_vent_hunt
 * 5. scp939_combat
 * 6. scp939_mimicry
 */

#define SCP939_VENT_HUNT_SEARCH_RANGE 34
#define SCP939_VENT_HUNT_PATHING_FAILURES 3

// ============================================================
//  AI Controller
// ============================================================
/datum/ai_controller/basic_controller/scp939
	ai_movement = /datum/ai_movement/basic_avoidance
	movement_delay = 0.4 SECONDS

	planning_subtrees = list(
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/scp939_retreat,
		/datum/ai_planning_subtree/scp939_pry_blocking_door,
		/datum/ai_planning_subtree/scp939_vent_hunt,
		/datum/ai_planning_subtree/scp939_combat,
		/datum/ai_planning_subtree/scp939_mimicry,
	)

	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_SCP939_FLEE_HEALTH = 80,
		BB_SCP939_SAFE_VENT = null,
		BB_SCP939_VICTIMS_LIST = list(),
		BB_SCP939_BLOCKING_DOOR = null,
		BB_ENTRY_VENT_TARGET = null,
		BB_CURRENTLY_TARGETING_VENT = FALSE,
		BB_VENTCRAWL_COOLDOWN = 15 SECONDS,
		BB_LOWER_VENT_TIME_LIMIT = 8 SECONDS,
		BB_UPPER_VENT_TIME_LIMIT = 12 SECONDS,
		BB_TIME_TO_GIVE_UP_ON_VENT_PATHING = 30 SECONDS,
		BB_BASIC_MOB_FLEE_DISTANCE = 8,
	)

// ============================================================
//  Planning subtree - Retreat
// ============================================================
/datum/ai_planning_subtree/scp939_retreat

/datum/ai_planning_subtree/scp939_retreat/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	if(pawn.health > controller.blackboard[BB_SCP939_FLEE_HEALTH])
		return

	if(HAS_TRAIT(pawn, TRAIT_MOVE_VENTCRAWLING))
		return SUBTREE_RETURN_FINISH_PLANNING

	if(pawn.current_posture != SCP939_POSTURE_QUADRUPED)
		pawn.set_posture(SCP939_POSTURE_QUADRUPED)

	var/obj/machinery/atmospherics/components/unary/vent_pump/target = controller.blackboard[BB_ENTRY_VENT_TARGET]
	if(QDELETED(target))
		controller.clear_blackboard_key(BB_ENTRY_VENT_TARGET)
		target = null

	if(isnull(target))
		controller.queue_behavior(
			/datum/ai_behavior/find_and_set/scp939_vent,
			BB_ENTRY_VENT_TARGET,
			/obj/machinery/atmospherics/components/unary/vent_pump,
			10,
		)
		if(controller.blackboard_key_exists(BB_BASIC_MOB_CURRENT_TARGET))
			controller.queue_behavior(/datum/ai_behavior/run_away_from_target, BB_BASIC_MOB_CURRENT_TARGET, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(get_turf(pawn) != get_turf(target))
		controller.queue_behavior(/datum/ai_behavior/travel_towards, BB_ENTRY_VENT_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	controller.set_blackboard_key(BB_CURRENTLY_TARGETING_VENT, TRUE)
	controller.queue_behavior(/datum/ai_behavior/crawl_through_vents/scp939_escape, BB_ENTRY_VENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

// ============================================================
//  AI Behavior - Find a usable vent
// ============================================================
/datum/ai_behavior/find_and_set/scp939_vent

/datum/ai_behavior/find_and_set/scp939_vent/search_tactic(datum/ai_controller/controller, locate_path, search_range = SEARCH_TACTIC_DEFAULT_RANGE)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	var/list/found_vents = list()

	for(var/obj/machinery/atmospherics/components/unary/vent_pump/vent in range(search_range, pawn))
		if(!is_usable_entry_vent(vent))
			continue

		found_vents += vent

	if(length(found_vents))
		return get_closest_atom(/obj/machinery/atmospherics/components/unary/vent_pump, found_vents, pawn)

	return null

/datum/ai_behavior/find_and_set/scp939_vent/proc/is_usable_entry_vent(obj/machinery/atmospherics/components/unary/vent_pump/vent)
	if(QDELETED(vent) || vent.welded)
		return FALSE
	if(!(vent.vent_movement & VENTCRAWL_ENTRANCE_ALLOWED))
		return FALSE
	if(!length(vent.parents))
		return FALSE

	var/datum/pipeline/vent_parent = vent.parents[1]
	if(isnull(vent_parent))
		return FALSE

	return length(get_exit_vents(vent)) > 0

/datum/ai_behavior/find_and_set/scp939_vent/proc/get_exit_vents(obj/machinery/atmospherics/components/unary/vent_pump/entry_vent)
	var/list/found_exits = list()
	if(QDELETED(entry_vent) || !length(entry_vent.parents))
		return found_exits

	var/datum/pipeline/vent_parent = entry_vent.parents[1]
	if(isnull(vent_parent))
		return found_exits

	for(var/obj/machinery/atmospherics/components/unary/vent_pump/exit_vent in vent_parent.other_atmos_machines)
		if(exit_vent == entry_vent || QDELETED(exit_vent) || exit_vent.welded)
			continue
		if(!(exit_vent.vent_movement & VENTCRAWL_ENTRANCE_ALLOWED))
			continue
		found_exits += exit_vent

	return found_exits

/datum/ai_behavior/find_and_set/scp939_vent/hunt

/datum/ai_behavior/find_and_set/scp939_vent/hunt/search_tactic(datum/ai_controller/controller, locate_path, search_range = SEARCH_TACTIC_DEFAULT_RANGE)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	var/atom/prey = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION] || controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(prey))
		return null

	var/obj/machinery/atmospherics/components/unary/vent_pump/best_entry
	var/best_score = INFINITY

	for(var/obj/machinery/atmospherics/components/unary/vent_pump/vent in range(search_range, pawn))
		if(!is_usable_entry_vent(vent))
			continue

		var/obj/machinery/atmospherics/components/unary/vent_pump/best_exit = get_closest_atom(/obj/machinery/atmospherics/components/unary/vent_pump, get_exit_vents(vent), prey)
		if(isnull(best_exit))
			continue

		var/score = get_dist(pawn, vent) + get_dist(best_exit, prey)
		if(score >= best_score)
			continue

		best_entry = vent
		best_score = score

	return best_entry

// ============================================================
//  Planning subtree - Pry blocked doors
// ============================================================
/datum/ai_planning_subtree/scp939_pry_blocking_door

/datum/ai_planning_subtree/scp939_pry_blocking_door/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION] || controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return

	var/obj/machinery/door/blocking_door = find_blocking_door(controller, target)
	if(isnull(blocking_door))
		return

	if(pawn.current_posture != SCP939_POSTURE_BIPED)
		pawn.set_posture(SCP939_POSTURE_BIPED)

	controller.set_blackboard_key(BB_SCP939_BLOCKING_DOOR, blocking_door)
	controller.queue_behavior(/datum/ai_behavior/scp939_pry_door, BB_SCP939_BLOCKING_DOOR)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/scp939_pry_blocking_door/proc/find_blocking_door(datum/ai_controller/controller, atom/target)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	var/dir_to_target = get_dir(pawn, target)
	if(!dir_to_target)
		return null

	var/list/dirs_to_check = list()
	if(ISDIAGONALDIR(dir_to_target))
		for(var/direction in GLOB.cardinals)
			if(direction & dir_to_target)
				dirs_to_check += direction
	else
		dirs_to_check += dir_to_target

	for(var/direction in dirs_to_check)
		var/turf/next_step = get_step(pawn, direction)
		if(isnull(next_step))
			continue

		var/obj/machinery/door/blocking_door = locate(/obj/machinery/door) in next_step
		if(can_pry_door(blocking_door))
			return blocking_door

	return null

/datum/ai_planning_subtree/scp939_pry_blocking_door/proc/can_pry_door(obj/machinery/door/blocking_door)
	if(QDELETED(blocking_door) || !blocking_door.density || blocking_door.operating)
		return FALSE

	if(istype(blocking_door, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlock = blocking_door
		if(airlock.locked || airlock.welded || airlock.seal)
			return FALSE

	return TRUE

// ============================================================
//  Planning subtree - Vent hunt inaccessible prey
// ============================================================
/datum/ai_planning_subtree/scp939_vent_hunt

/datum/ai_planning_subtree/scp939_vent_hunt/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	if(HAS_TRAIT(pawn, TRAIT_MOVE_VENTCRAWLING))
		return SUBTREE_RETURN_FINISH_PLANNING

	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION] || controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target) || get_dist(pawn, target) <= 1)
		return

	if(!should_take_vent_route(controller, target))
		return

	if(pawn.current_posture != SCP939_POSTURE_QUADRUPED)
		pawn.set_posture(SCP939_POSTURE_QUADRUPED)

	var/obj/machinery/atmospherics/components/unary/vent_pump/entry_vent = controller.blackboard[BB_ENTRY_VENT_TARGET]
	if(QDELETED(entry_vent) || get_dist(pawn, entry_vent) > SCP939_VENT_HUNT_SEARCH_RANGE)
		controller.clear_blackboard_key(BB_ENTRY_VENT_TARGET)
		entry_vent = null

	if(isnull(entry_vent))
		controller.queue_behavior(
			/datum/ai_behavior/find_and_set/scp939_vent/hunt,
			BB_ENTRY_VENT_TARGET,
			/obj/machinery/atmospherics/components/unary/vent_pump,
			SCP939_VENT_HUNT_SEARCH_RANGE,
		)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(get_turf(pawn) != get_turf(entry_vent))
		controller.queue_behavior(/datum/ai_behavior/travel_towards, BB_ENTRY_VENT_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	controller.set_blackboard_key(BB_CURRENTLY_TARGETING_VENT, TRUE)
	controller.queue_behavior(/datum/ai_behavior/crawl_through_vents/scp939_hunt, BB_ENTRY_VENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/scp939_vent_hunt/proc/should_take_vent_route(datum/ai_controller/controller, atom/target)
	if(controller.consecutive_pathing_attempts >= SCP939_VENT_HUNT_PATHING_FAILURES)
		return TRUE

	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	var/turf/next_step = get_step_towards(pawn, target)
	if(!isnull(next_step) && next_step.is_blocked_turf(exclude_mobs = TRUE, source_atom = pawn))
		return TRUE

	if(get_dist(pawn, target) >= 6 && !can_see(pawn, target, 7))
		return TRUE

	return FALSE

// ============================================================
//  Planning subtree - Combat
// ============================================================
/datum/ai_planning_subtree/scp939_combat

/datum/ai_planning_subtree/scp939_combat/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn

	if(!controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		controller.queue_behavior(
			/datum/ai_behavior/find_and_set,
			BB_BASIC_MOB_CURRENT_TARGET,
			/mob/living/carbon/human,
			7,
		)
		return

	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(QDELETED(target) || target.stat == DEAD)
		if(istype(target, /mob/living/carbon/human))
			pawn.consume_victim(target)
		controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		return

	var/atom/final_target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION] || target
	var/dist = get_dist(pawn, final_target)
	if(dist > 1 && pawn.current_posture != SCP939_POSTURE_QUADRUPED)
		pawn.set_posture(SCP939_POSTURE_QUADRUPED)

	controller.queue_behavior(/datum/ai_behavior/scp939_attack, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

// ============================================================
//  Planning subtree - Mimicry
// ============================================================
/datum/ai_planning_subtree/scp939_mimicry

/datum/ai_planning_subtree/scp939_mimicry/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	if(!length(pawn.consumed_victims))
		return
	if(!SPT_PROB(5, seconds_per_tick))
		return

	controller.queue_behavior(/datum/ai_behavior/scp939_mimic_speech)

// ============================================================
//  AI Behavior - Attack
// ============================================================
/datum/ai_behavior/scp939_attack
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/scp939_attack/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION] || controller.blackboard[target_key]
	if(!QDELETED(target))
		set_movement_target(controller, target)

/datum/ai_behavior/scp939_attack/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]

	if(QDELETED(target) || target.stat == DEAD)
		if(istype(target, /mob/living/carbon/human))
			pawn.consume_victim(target)
		controller.clear_blackboard_key(target_key)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

	var/datum/targeting_strategy/targeting_strategy = GET_TARGETING_STRATEGY(controller.blackboard[BB_TARGETING_STRATEGY])
	var/atom/hiding_target = targeting_strategy?.find_hidden_mobs(pawn, target)
	if(!QDELETED(hiding_target))
		controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION, hiding_target)
	else if(controller.blackboard_key_exists(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION))
		controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

	var/atom/final_target = hiding_target || target
	if(controller.current_movement_target != final_target)
		set_movement_target(controller, final_target)

	if(pawn.Adjacent(final_target))
		pawn.melee_attack(final_target)

	return AI_BEHAVIOR_DELAY

// ============================================================
//  AI Behavior - Pry door
// ============================================================
/datum/ai_behavior/scp939_pry_door
	action_cooldown = 0.5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/scp939_pry_door/setup(datum/ai_controller/controller, door_key)
	. = ..()
	var/obj/machinery/door/door = controller.blackboard[door_key]
	if(QDELETED(door) || !door.density)
		controller.clear_blackboard_key(door_key)
		return FALSE
	set_movement_target(controller, door)

/datum/ai_behavior/scp939_pry_door/perform(seconds_per_tick, datum/ai_controller/controller, door_key)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	var/obj/machinery/door/door = controller.blackboard[door_key]
	if(QDELETED(door) || !door.density)
		controller.clear_blackboard_key(door_key)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

	if(door.operating)
		return AI_BEHAVIOR_DELAY

	if(istype(door, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlock = door
		if(airlock.locked || airlock.welded || airlock.seal)
			controller.clear_blackboard_key(door_key)
			return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	if(!pawn.Adjacent(door))
		return AI_BEHAVIOR_DELAY

	if(pawn.current_posture != SCP939_POSTURE_BIPED)
		pawn.set_posture(SCP939_POSTURE_BIPED)

	if(DOING_INTERACTION_WITH_TARGET(pawn, door) || DOING_INTERACTION(pawn, SCP939_BIPED_INTERACTION))
		return AI_BEHAVIOR_DELAY

	var/old_combat_mode = pawn.combat_mode
	pawn.set_combat_mode(FALSE)
	pawn.UnarmedAttack(door, TRUE)
	pawn.set_combat_mode(old_combat_mode)
	return AI_BEHAVIOR_DELAY

/datum/ai_behavior/scp939_pry_door/finish_action(datum/ai_controller/controller, succeeded, door_key)
	. = ..()
	controller.clear_blackboard_key(door_key)

// ============================================================
//  AI Behavior - SCP-939 vent routing
// ============================================================
/datum/ai_behavior/crawl_through_vents/scp939
	var/select_farthest_exit = FALSE

/datum/ai_behavior/crawl_through_vents/scp939/calculate_exit_vent(datum/ai_controller/controller, target_key)
	var/obj/machinery/atmospherics/components/unary/vent_pump/vent_we_entered_through = controller.blackboard[target_key] || controller.blackboard[BB_ENTRY_VENT_TARGET]
	var/atom/prey = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION] || controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(vent_we_entered_through) || QDELETED(prey) || !length(vent_we_entered_through.parents))
		return ..()

	var/datum/pipeline/entry_vent_parent = vent_we_entered_through.parents[1]
	if(isnull(entry_vent_parent))
		return ..()

	var/obj/machinery/atmospherics/components/unary/vent_pump/best_exit
	var/best_score
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/vent in entry_vent_parent.other_atmos_machines)
		if(vent == vent_we_entered_through || !is_vent_valid(vent))
			continue
		if(!(vent.vent_movement & VENTCRAWL_ENTRANCE_ALLOWED))
			continue

		var/score = get_dist(vent, prey)
		if(isnull(best_exit) || (select_farthest_exit ? score > best_score : score < best_score))
			best_exit = vent
			best_score = score

	if(!isnull(best_exit))
		return best_exit

	return ..()

/datum/ai_behavior/crawl_through_vents/scp939_hunt
	parent_type = /datum/ai_behavior/crawl_through_vents/scp939

/datum/ai_behavior/crawl_through_vents/scp939_escape
	parent_type = /datum/ai_behavior/crawl_through_vents/scp939
	select_farthest_exit = TRUE

// ============================================================
//  AI Behavior - Escape to vent
// ============================================================
/datum/ai_behavior/scp939_escape_to_vent
	required_distance = 0
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/scp939_escape_to_vent/setup(datum/ai_controller/controller, vent_key)
	. = ..()
	var/obj/machinery/atmospherics/components/unary/vent_pump/vent = controller.blackboard[vent_key]
	if(QDELETED(vent))
		controller.clear_blackboard_key(vent_key)
		return AI_BEHAVIOR_FAILED
	set_movement_target(controller, vent)

/datum/ai_behavior/scp939_escape_to_vent/perform(seconds_per_tick, datum/ai_controller/controller, vent_key)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn
	var/obj/machinery/atmospherics/components/unary/vent_pump/vent = controller.blackboard[vent_key]

	if(QDELETED(vent))
		controller.clear_blackboard_key(vent_key)
		return AI_BEHAVIOR_FAILED

	if(get_turf(pawn) != get_turf(vent))
		return AI_BEHAVIOR_DELAY

	if(pawn.current_posture != SCP939_POSTURE_QUADRUPED)
		pawn.set_posture(SCP939_POSTURE_QUADRUPED)

	controller.set_blackboard_key(BB_CURRENTLY_TARGETING_VENT, TRUE)
	controller.queue_behavior(/datum/ai_behavior/crawl_through_vents/scp939_escape, vent_key)
	return AI_BEHAVIOR_SUCCEEDED

// ============================================================
//  AI Behavior - Mimic speech
// ============================================================
/datum/ai_behavior/scp939_mimic_speech

/datum/ai_behavior/scp939_mimic_speech/perform(seconds_per_tick, datum/ai_controller/controller)
	var/mob/living/basic/scp/scp939/pawn = controller.pawn

	var/random_name = pawn.pick_stored_voice()
	if(isnull(random_name))
		return AI_BEHAVIOR_FAILED
	pawn.current_voice_name = random_name

	var/static/list/mimic_phrases = list(
		"Help me!",
		"Is anyone there?",
		"I'm bleeding out - please!",
		"Over here, it's safe!",
		"I think it's gone...",
		"Please, somebody respond!",
		"Don't come this way, run!",
	)

	var/list/phrases = mimic_phrases.Copy()
	phrases += "[random_name] here, I need evac!"

	pawn.say(pick(phrases))
	return AI_BEHAVIOR_SUCCEEDED
