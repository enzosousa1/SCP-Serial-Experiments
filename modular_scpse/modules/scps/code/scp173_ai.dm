/datum/targeting_strategy/basic/scp173
	parent_type = /datum/targeting_strategy/basic
	ignore_sight = TRUE

/datum/targeting_strategy/basic/scp173/can_attack(mob/living/living_mob, atom/the_target, vision_range)
	var/datum/ai_controller/basic_controller/controller = living_mob.ai_controller

	if(isnull(controller))
		return FALSE

	if(!isliving(the_target))
		return FALSE

	var/mob/living/target = the_target

	if(target.stat == DEAD)
		return FALSE

	// ignora facção
	if(faction_check(controller, living_mob, target))
		return FALSE

	// IGNORA visão completamente
	if(get_dist(living_mob, target) > controller.blackboard[BB_VISION_RANGE])
		return FALSE

	return TRUE

/datum/ai_controller/basic_controller/scp173
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/scp173,
		BB_FIND_TARGET_RANGE = 20,
		BB_TARGET_MINIMUM_STAT = CONSCIOUS,
		BB_VISION_RANGE = 20,
		BB_AGGRO_VISION_RANGE = 20,
	)

	ai_movement = /datum/ai_movement/jps
	idle_behavior = /datum/idle_behavior/idle_random_walk

	planning_subtrees = list(
	/datum/ai_planning_subtree/escape_captivity,
	/datum/ai_planning_subtree/simple_find_target,
	/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/targeting_strategy/basic/scp173/
