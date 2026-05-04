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

/obj/item/clothing/mask/scp035
	name = "\improper SCP-035"
	desc = "A mask created from suffering. When you look into its eyes, it looks back."
	icon = 'scpse/icons/scps/scp035.dmi'
	icon_state = "035"
	inhand_icon_state = null
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	///Who is wearing this
	var/mob/living/carbon/human/local_user

/obj/item/clothing/mask/scp035/Destroy()
	local_user = null
	return ..()

/obj/item/clothing/mask/scp035/equipped(mob/living/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_MASK))
		return
	if(!ishuman(user) || !user.mind)
		return

	local_user = user

	// This is used for the "SCP-035-1" name and the "wants to be worn" message. It is not used for anything else.
	local_user.mind.add_antag_datum(/datum/antagonist/scp035)
	local_user.name = "SCP-035-1"

	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	to_chat(user, span_userdanger("[src] has a strong desire to be worn."))

/obj/item/clothing/mask/scp035/dropped(mob/M)
	local_user = null
	STOP_PROCESSING(SSobj, src)
	REMOVE_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	return ..()

/obj/structure/displaycase/scp035
	name = "SCP-035 Display Case"
	desc = "A display case for SCP-035. It is made of reinforced glass and has a secure locking mechanism."
	start_showpiece_type = /obj/item/clothing/mask/scp035
