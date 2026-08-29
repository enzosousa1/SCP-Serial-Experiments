/datum/antagonist/scp035
	name = "\improper SCP-035-1"
	show_in_antagpanel = TRUE
	show_name_in_check_antagonists = TRUE
	hijack_speed = 2
	antag_hud_name = "scp035"
	ui_name = "AntagInfoSCP035"
	suicide_cry = "HAHAHAHAHA!!"

/datum/antagonist/scp035/forge_objectives()
	if (!(locate(/datum/objective/survive) in objectives))
		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = owner
		objectives += survive_objective

/datum/antagonist/scp035/on_gain()
	. = ..()
	forge_objectives()


/obj/item/clothing/mask/scp
	gender = NEUTER

/obj/item/clothing/mask/scp/scp035
	name = "\improper SCP-035"
	desc = "A mask created from suffering. When you look into its eyes, it looks back."
	icon = 'modular_scpse/modules/scps/icons/scp-035.dmi'
	worn_icon = 'modular_scpse/modules/scps/icons/onmob_mask.dmi'
	icon_state = "scp035_0"
	inhand_icon_state = null
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	flags_inv = HIDEFACE | HIDEFACIALHAIR | HIDESNOUT

	/// Who is currently wearing this mask
	var/mob/living/carbon/human/local_user
	/// How long (in seconds) the mask has been worn by the current user
	var/time_worn = 0

/obj/item/clothing/mask/scp/scp035/Destroy()
	if(local_user)
		STOP_PROCESSING(SSobj, src)
	local_user = null
	return ..()

/obj/item/clothing/mask/scp/scp035/equipped(mob/living/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_MASK))
		return
	if(!ishuman(user) || !user.mind)
		return

	local_user = user
	time_worn = 0 // Reset the degradation timer

	// Add antagonist datum and rename the host
	local_user.mind.add_antag_datum(/datum/antagonist/scp035)
	local_user.name = "SCP-035-1"

	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	to_chat(local_user, span_userdanger("A cold, overwhelming consciousness forces its way into your mind. You are no longer in control."))

	// Start processing the degradation effect
	START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/scp/scp035/dropped(mob/user)
	STOP_PROCESSING(SSobj, src)
	local_user = null
	time_worn = 0
	REMOVE_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	return ..()

/obj/item/clothing/mask/scp/scp035/process(seconds_per_tick)
	if(!local_user)
		STOP_PROCESSING(SSobj, src)
		return

	// If the host dies, the body has decayed enough. Release the nodrop trait so a new host can put it on.
	if(local_user.stat == DEAD)
		REMOVE_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		STOP_PROCESSING(SSobj, src)
		return

	time_worn += seconds_per_tick

	// Progressive degradation phases
	switch(time_worn)
		if(1 to 120) // First 2 minutes: Minor symptoms
			if(prob(5 * seconds_per_tick))
				local_user.adjust_tox_loss(1 * seconds_per_tick)

		if(121 to 300) // 2 to 5 minutes: Active decay and bleeding
			if(prob(8 * seconds_per_tick))
				local_user.visible_message(
					span_danger("A viscous, black liquid begins to seep from the edges of [local_user]'s mask!"),
					span_userdanger("You feel your flesh rotting away underneath the porcelain. It burns!")
				)

			// CloneLoss represents cellular destruction (cannot be easily healed)
			local_user.adjust_tox_loss(1.5 * seconds_per_tick)
			local_user.adjust_tox_loss(2 * seconds_per_tick)

			if(prob(10 * seconds_per_tick))
				local_user.bleed(2) // Cause them to lose blood volume

		if(301 to INFINITY) // 5+ minutes: Rapid decomposition
			if(prob(15 * seconds_per_tick))
				local_user.visible_message(
					span_warning("[local_user]'s body looks severely decayed, dripping dark sludge onto the floor!"),
					span_userdanger("Your physical form is failing. You need a new host soon!")
				)

			// Accelerated organ and cellular failure
			local_user.adjust_brute_loss(3 * seconds_per_tick)
			local_user.adjust_tox_loss(4 * seconds_per_tick)
			local_user.adjust_organ_loss(ORGAN_SLOT_HEART, 2 * seconds_per_tick)
			local_user.bleed(5)
