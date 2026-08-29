#define STAMINA_TICK_SCP714 5

/datum/movespeed_modifier/scp714_tired
	multiplicative_slowdown = 0.5
	id = "scp714_tired"

/datum/status_effect/scp714_exhaustion
	id = "714_exhaustion"
	tick_interval = 2 SECONDS
	duration = STATUS_EFFECT_PERMANENT
	alert_type = null
	var/exhaustion_stacks = 0

/datum/status_effect/scp714_exhaustion/tick(seconds_between_ticks)
	exhaustion_stacks++

	// The ring realistically only affects carbons (humans, monkeys)
	var/mob/living/carbon/wearer = owner
	if(!istype(wearer))
		return

	apply_effects(wearer)

/datum/status_effect/scp714_exhaustion/proc/apply_effects(mob/living/carbon/wearer)
	switch(exhaustion_stacks)
		if(1 to 15) // 0 to 30 seconds
			if(prob(5))
				wearer.emote("yawn")

		if(16 to 30) // 30 seconds to 1 minute
			wearer.add_movespeed_modifier(/datum/movespeed_modifier/scp714_tired)
			wearer.adjust_stamina_loss(STAMINA_TICK_SCP714)

		if(31 to 60) // 1 to 2 minutes
			wearer.adjust_stamina_loss(STAMINA_TICK_SCP714 * 2)
			wearer.adjust_drowsiness(1) // Progressively makes the screen blur and forces rests
			if(prob(10))
				wearer.emote("yawn")
				to_chat(wearer, span_warning("You feel incredibly heavy..."))

		if(61 to INFINITY) // 2+ minutes
			wearer.adjust_stamina_loss(STAMINA_TICK_SCP714 * 3)
			wearer.adjust_drowsiness(2)
			// Thematically force them to sleep rather than hard stunlocking them
			if(prob(15) && wearer.stat == CONSCIOUS)
				to_chat(wearer, span_userdanger("You can't keep your eyes open any longer!"))
				wearer.Sleeping(10 SECONDS)

/datum/status_effect/scp714_exhaustion/on_remove()
	var/mob/living/wearer = owner
	if(istype(wearer))
		wearer.remove_movespeed_modifier(/datum/movespeed_modifier/scp714_tired)
		to_chat(wearer, span_notice("The crushing exhaustion lifts as the ring is removed."))
	return ..()


/obj/item/clothing/gloves/scp
	gender = NEUTER

/obj/item/clothing/gloves/scp/scp714
	name = "\improper SCP-714"
	desc = "A tiny jade ring."
	icon = 'modular_scpse/modules/scps/icons/scp-714.dmi'
	worn_icon = 'modular_scpse/modules/scps/icons/scp-714.dmi'
	icon_state = "714"
	worn_icon_state = "714-worn"
	strip_delay = 4 SECONDS
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)
	resistance_flags = FIRE_PROOF
	body_parts_covered = NONE

/obj/item/clothing/gloves/scp/scp714/equipped(mob/living/user, slot)
	. = ..()

	if(slot & ITEM_SLOT_GLOVES)
		user.visible_message(
			span_notice("[src] smoothly adjusts to fit [user]'s finger."),
			span_boldnotice("The ring seems to slowly adjust to your finger, tightening until it fits perfectly.")
		)

		user.apply_status_effect(/datum/status_effect/scp714_exhaustion)

		ADD_TRAIT(user, TRAIT_WEARING_SCP714, INNATE_TRAIT)

/obj/item/clothing/gloves/scp/scp714/dropped(mob/living/user)
	. = ..()

	user.remove_status_effect(/datum/status_effect/scp714_exhaustion)

	REMOVE_TRAIT(user, TRAIT_WEARING_SCP714, INNATE_TRAIT)
