#define SCPSE_CLEARANCE_NONE 0
#define SCPSE_CLEARANCE_ONE 1
#define SCPSE_CLEARANCE_TWO 2
#define SCPSE_CLEARANCE_THREE 3
#define SCPSE_CLEARANCE_FOUR 4
#define SCPSE_CLEARANCE_FIVE 5
#define SCPSE_CLEARANCE_OMNI 6

/datum/id_trim
	/// SCP-style numeric clearance. Used by facility cardlocks.
	var/scpse_clearance_level = SCPSE_CLEARANCE_NONE

/obj/item/card/id
	/// Explicit SCP clearance override. If null, the card inherits it from its trim or access list.
	var/scpse_clearance_level

/obj/item/card/id/proc/scpse_get_clearance_level()
	if(isnum(scpse_clearance_level))
		return scpse_clearance_level

	if(isnum(trim?.scpse_clearance_level))
		return trim.scpse_clearance_level

	var/list/card_access = GetAccess()
	if(!length(card_access))
		return SCPSE_CLEARANCE_NONE

	if((ACCESS_CAPTAIN in card_access) || (ACCESS_CENT_CAPTAIN in card_access) || (ACCESS_CENT_GENERAL in card_access) || (ACCESS_CENT_SPECOPS in card_access))
		return SCPSE_CLEARANCE_FIVE

	if((ACCESS_COMMAND in card_access) || (ACCESS_HOP in card_access) || (ACCESS_HOS in card_access) || (ACCESS_CE in card_access) || (ACCESS_CMO in card_access) || (ACCESS_RD in card_access) || (ACCESS_QM in card_access))
		return SCPSE_CLEARANCE_FOUR

	if((ACCESS_SECURITY in card_access) || (ACCESS_ARMORY in card_access) || (ACCESS_SCIENCE in card_access) || (ACCESS_RESEARCH in card_access) || (ACCESS_MEDICAL in card_access) || (ACCESS_ENGINEERING in card_access))
		return SCPSE_CLEARANCE_THREE

	if((ACCESS_CARGO in card_access) || (ACCESS_SERVICE in card_access) || (ACCESS_MAINT_TUNNELS in card_access) || (ACCESS_ATMOSPHERICS in card_access) || (ACCESS_ROBOTICS in card_access))
		return SCPSE_CLEARANCE_TWO

	return SCPSE_CLEARANCE_ONE

/obj/item/card/id/advanced/scpse
	name = "foundation access card"
	desc = "A Foundation access card with a printed clearance level."
	icon = 'modular_scpse/master_files/icons/cards.dmi'
	icon_state = "level1"
	assigned_icon_state = null

/obj/item/card/id/advanced/scpse/update_icon_state()
	var/level = scpse_get_clearance_level()
	if(level >= SCPSE_CLEARANCE_ONE && level <= SCPSE_CLEARANCE_FIVE)
		icon_state = "level[level]"
	else
		icon_state = "levelX"
	return

/obj/item/card/id/advanced/scpse/update_overlays()
	return list()

/obj/item/card/id/advanced/scpse/examine(mob/user)
	. = ..()
	var/level = scpse_get_clearance_level()
	if(level >= SCPSE_CLEARANCE_OMNI)
		. += span_notice("It has unrestricted Foundation access.")
	else
		. += span_notice("It has Foundation clearance level [level].")

/obj/item/card/id/advanced/scpse/level_1
	scpse_clearance_level = SCPSE_CLEARANCE_ONE

/obj/item/card/id/advanced/scpse/level_2
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/obj/item/card/id/advanced/scpse/level_3
	scpse_clearance_level = SCPSE_CLEARANCE_THREE

/obj/item/card/id/advanced/scpse/level_4
	scpse_clearance_level = SCPSE_CLEARANCE_FOUR

/obj/item/card/id/advanced/scpse/level_5
	scpse_clearance_level = SCPSE_CLEARANCE_FIVE

/obj/item/card/id/advanced/scpse/level_x
	scpse_clearance_level = SCPSE_CLEARANCE_OMNI

/datum/id_trim/job/assistant
	scpse_clearance_level = SCPSE_CLEARANCE_ONE

/datum/id_trim/job/prisoner
	scpse_clearance_level = SCPSE_CLEARANCE_ONE

/datum/id_trim/job/atmospheric_technician
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/cargo_technician
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/chemist
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/coroner
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/geneticist
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/medical_doctor
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/paramedic
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/roboticist
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/scientist
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/station_engineer
	scpse_clearance_level = SCPSE_CLEARANCE_TWO

/datum/id_trim/job/detective
	scpse_clearance_level = SCPSE_CLEARANCE_THREE

/datum/id_trim/job/security_officer
	scpse_clearance_level = SCPSE_CLEARANCE_THREE

/datum/id_trim/job/security_officer/engineering
	scpse_clearance_level = SCPSE_CLEARANCE_THREE

/datum/id_trim/job/security_officer/medical
	scpse_clearance_level = SCPSE_CLEARANCE_THREE

/datum/id_trim/job/security_officer/science
	scpse_clearance_level = SCPSE_CLEARANCE_THREE

/datum/id_trim/job/security_officer/supply
	scpse_clearance_level = SCPSE_CLEARANCE_THREE

/datum/id_trim/job/warden
	scpse_clearance_level = SCPSE_CLEARANCE_THREE

/datum/id_trim/job/chief_engineer
	scpse_clearance_level = SCPSE_CLEARANCE_FOUR

/datum/id_trim/job/chief_medical_officer
	scpse_clearance_level = SCPSE_CLEARANCE_FOUR

/datum/id_trim/job/head_of_personnel
	scpse_clearance_level = SCPSE_CLEARANCE_FOUR

/datum/id_trim/job/head_of_security
	scpse_clearance_level = SCPSE_CLEARANCE_FOUR

/datum/id_trim/job/quartermaster
	scpse_clearance_level = SCPSE_CLEARANCE_FOUR

/datum/id_trim/job/research_director
	scpse_clearance_level = SCPSE_CLEARANCE_FOUR

/datum/id_trim/job/captain
	scpse_clearance_level = SCPSE_CLEARANCE_FIVE

/datum/id_trim/job/bridge_assistant
	scpse_clearance_level = SCPSE_CLEARANCE_FIVE

/datum/id_trim/centcom
	scpse_clearance_level = SCPSE_CLEARANCE_OMNI

/datum/id_trim/centcom/ert
	scpse_clearance_level = SCPSE_CLEARANCE_FIVE

/datum/id_trim/centcom/ert/commander
	scpse_clearance_level = SCPSE_CLEARANCE_OMNI

/datum/id_trim/centcom/deathsquad
	scpse_clearance_level = SCPSE_CLEARANCE_OMNI

#undef SCPSE_CLEARANCE_NONE
#undef SCPSE_CLEARANCE_ONE
#undef SCPSE_CLEARANCE_TWO
#undef SCPSE_CLEARANCE_THREE
#undef SCPSE_CLEARANCE_FOUR
#undef SCPSE_CLEARANCE_FIVE
#undef SCPSE_CLEARANCE_OMNI
