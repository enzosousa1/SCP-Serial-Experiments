#define STUN_049_COOLDOWN (3 MINUTES)
#define TRAIT_SCP049      "scp049"

// ============================================================
//  Antag — SCP-049-2 (zombie servant)
// ============================================================

/datum/antagonist/scp049_zombie
    name             = "SCP-049-2"
    show_in_antagpanel = TRUE
    silent           = FALSE

/datum/antagonist/scp049_zombie/on_gain()
    . = ..()
    var/datum/objective/O = new()
    O.owner          = owner
    O.explanation_text = "Obey SCP-049 and protect him at all costs."
    O.completed      = TRUE
    objectives      += O

/datum/antagonist/scp049_zombie/greet()
    to_chat(owner.current, span_userdanger("You have been claimed by the Good Doctor. You serve him now."))
    playsound(owner.current, 'sound/effects/hallucinations/wail.ogg', 0.8, FALSE)

// ============================================================
//  Surgery Operation — Modern Singleton System
// ============================================================

// The reanimation is the FINAL step of the surgery.
// SCP-049 must first perform the standard operations to set the states:
// 1. Incise (Scalpel) -> grants SURGERY_SKIN_OPEN
// 2. Retract (Retractor) -> keeps skin open, accesses internals
// 3. Saw (Saw) -> grants SURGERY_BONE_SAWED
// 4. Administer Cure (Hemostat/Cautery) -> Triggers this custom operation!

/datum/surgery_operation/basic/scp049_cure
    name = "administer the cure"
    desc = "Purge the pestilence from the patient and restore them anew."

    operation_flags = OPERATION_MORBID | OPERATION_NOTABLE

    // We ONLY include the final tools here. Removing the scalpel prevents
    // the game from skipping straight to this step on a fresh body.
    implements = list(
        TOOL_HEMOSTAT = 1,
        TOOL_CAUTERY = 2,
    )

    time = 8 SECONDS
    preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
    success_sound = 'sound/effects/hallucinations/wail.ogg'
    failure_sound = 'sound/effects/splat.ogg'

    // The target MUST have been opened and sawed by the standard tools first.
    all_surgery_states_required = SURGERY_SKIN_OPEN | SURGERY_BONE_SAWED
    any_surgery_states_blocked = SURGERY_VESSELS_UNCLAMPED
    target_zone = BODY_ZONE_CHEST
    required_biotype = MOB_HUMANOID

/datum/surgery_operation/basic/scp049_cure/state_check(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
    // Always call parent first to check base validity
    . = ..()
    if(!.)
        return FALSE

    if(!HAS_TRAIT(surgeon, TRAIT_SCP049))
        return FALSE

    if(!isliving(operating_on))
        return FALSE

    var/mob/living/L = operating_on

    if(L.stat == CONSCIOUS)
        to_chat(surgeon, span_warning("[L] struggles too much to administer the Cure."))
        return FALSE

    if(HAS_TRAIT(L, TRAIT_SCP049))
        return FALSE

    return TRUE

/datum/surgery_operation/basic/scp049_cure/on_preop(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
    var/mob/living/patient = operating_on

    display_results(
        surgeon,
        patient,
        span_notice("You begin administering the Cure to [patient]..."),
        span_warning("[surgeon] begins a horrifying surgical ritual on [patient]."),
        span_notice("[surgeon] begins operating on [patient]."),
    )

    if(patient)
        patient.emote("scream")

/datum/surgery_operation/basic/scp049_cure/on_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
    var/mob/living/carbon/human/target = operating_on

    if(!istype(target))
        return

    display_results(
        surgeon,
        target,
        span_notice("You successfully administer the Cure."),
        span_danger("[target]'s corpse violently convulses!"),
        span_notice("[surgeon] completes the Cure."),
    )

    if(target.stat != DEAD)
        target.death(FALSE) // FALSE prevents gibbing

    // Modern flag-based revival
    target.revive(HEAL_ALL)

    target.set_species(/datum/species/zombie)
    target.set_faction(FACTION_SCP)

    if(target.mind)
        target.mind.add_antag_datum(/datum/antagonist/scp049_zombie)

/datum/surgery_operation/basic/scp049_cure/on_failure(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
    var/mob/living/patient = operating_on

    if(!patient)
        return

    display_results(
        surgeon,
        patient,
        span_warning("You fail to administer the Cure."),
        span_warning("[surgeon] mutilates [patient]!"),
        span_notice("[surgeon] fails the operation."),
    )

    patient.adjust_brute_loss(40)

// ============================================================
//  Actions & Items
// ============================================================

/datum/action/cooldown/spell/conjure_item/spawn_surgery_kit
	name = "Manifest Surgical Implements"
	desc = "Summon the tools required to purge the pestilence."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "metalfoam"
	cooldown_time = 1 MINUTES
	spell_requirements = NONE
	delete_old = TRUE
	requires_hands = TRUE
	item_type = /obj/item/storage/medkit/surgery_syndie

/datum/action/cooldown/spell/conjure_item/spawn_surgery_kit/Remove(mob/living/remove_from)
	var/obj/item/existing = remove_from.is_holding_item_of_type(item_type)
	if(existing)
		qdel(existing)

	return ..()

/datum/action/cooldown/spell/conjure_item/spawn_surgery_kit/make_item(atom/caster)
	return new item_type(caster.loc)

// ============================================================
//  SCP-049 mob
// ============================================================

/mob/living/basic/scp/scp049
    name = "\improper SCP-049"
    desc = "A plague doctor of unknown origin, utterly convinced that humanity is afflicted by a pestilence only it can perceive — and cure."
    icon = 'scpse/icons/scps/scp-049.dmi'
    faction = list(FACTION_SCP)
    mob_biotypes = MOB_ORGANIC | MOB_HUMANOID
    health = 500
    maxHealth = 500
    speed = 1.4
    status_flags = CANPUSH
    COOLDOWN_DECLARE(stun_cooldown)
    var/datum/action/cooldown/spell/conjure_item/spawn_surgery_kit/kit

/mob/living/basic/scp/scp049/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SCP049, INNATE_TRAIT)
	AddElement(/datum/element/dextrous)
	AddComponent(/datum/component/basic_inhands)
	kit = new
	kit.Grant(src)

/mob/living/basic/scp/scp049/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(!isliving(attack_target) || !proximity_flag)
		return ..()

	var/mob/living/L = attack_target

	if(L == src || L.stat == DEAD)
		return ..()

	if(HAS_TRAIT(L, TRAIT_WEARING_SCP714))
		to_chat(L, span_userdanger("A suffocating numbness spreads through your body, but the ring resists, dragging your mind back from the brink."))
		to_chat(src, span_warning("The pestilence recoils. Something interferes with the Cure."))
		return ITEM_INTERACT_BLOCKING

	if(!COOLDOWN_FINISHED(src, stun_cooldown))
		to_chat(src, span_warning("Your touch has not yet regained its potency. ([DisplayTimeText(COOLDOWN_TIMELEFT(src, stun_cooldown))] remaining)"))
		return ITEM_INTERACT_BLOCKING

	L.visible_message(
		span_danger("[src] reaches out and touches [L]!"),
		span_userdanger("You feel an icy numbness spread from [src]'s touch..."),
	)

	L.AdjustSleeping(2 MINUTES)
	L.adjust_stamina_loss(100)

	COOLDOWN_START(src, stun_cooldown, STUN_049_COOLDOWN)

	return ITEM_INTERACT_SUCCESS
