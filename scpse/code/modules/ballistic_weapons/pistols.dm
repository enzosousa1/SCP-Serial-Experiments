/obj/item/gun/ballistic/automatic/pistol/scp
	name = "\improper SCP sidearm"
	desc = "A non-standard sidearm pattern used by SCP security teams."
	icon = 'scpse/icons/weapons/pistols.dmi'
	fire_delay = 1
	burst_size = 1
	burst_fire_selection = FALSE
	actions_types = list()

/obj/item/gun/ballistic/automatic/pistol/scp/usp45
	name = "\improper HK USP45"
	desc = "A full-sized .45 ACP service pistol with a reputation for reliability."
	icon_state = "usp45"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m45
	can_suppress = TRUE
	fire_delay = 1
	spread = 2
	recoil = 0.4

/obj/item/gun/ballistic/automatic/pistol/scp/m9
	name = "\improper Beretta M9"
	desc = "A standard-issue 9mm pistol with light recoil and fast follow-up shots."
	icon_state = "m9"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m9mm
	can_suppress = TRUE
	fire_delay = 0.8
	spread = 1
	recoil = 0.35
	fire_sound = 'scpse/sound/weapons/gunshot_9mm.ogg'
