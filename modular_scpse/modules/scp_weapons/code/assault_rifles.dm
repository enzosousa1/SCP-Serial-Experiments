/obj/item/gun/ballistic/automatic/scp/scarh
	name = "\improper SCAR-H"
	desc = "A modular assault rifle known for its reliability and high stopping power."
	icon = 'modular_scpse/modules/scp_weapons/icons/assault_rifles40x32.dmi'
	icon_state = "scar"
	inhand_icon_state = "scar"
	lefthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_lefthand.dmi'
	righthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_righthand.dmi'
	worn_icon = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_back.dmi'
	worn_icon_state = "scar"
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/scar
	can_suppress = TRUE
	fire_delay = 3
	burst_size = 1
	actions_types = list()
	spread = 2
	recoil = 0.6
	fire_sound = 'modular_scpse/modules/scp_weapons/sound/scar/scar_fire.ogg'
	rack_sound = 'modular_scpse/modules/scp_weapons/sound/scar/scar_cock.ogg'
	load_sound = 'modular_scpse/modules/scp_weapons/sound/scar/scar_mag_in.ogg'
	eject_sound = 'modular_scpse/modules/scp_weapons/sound/scar/scar_mag_out.ogg'

/obj/item/gun/ballistic/automatic/scp/scarh/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.24 SECONDS)

/obj/item/ammo_box/magazine/scar
	name = "\improper SCAR magazine"
	icon = 'modular_scpse/modules/scp_weapons/icons/gunsgalore_guns40x32.dmi'
	icon_state = "rifle_mag"
	ammo_type = /obj/item/ammo_casing/a223
	max_ammo = 30


/obj/item/gun/ballistic/automatic/scp/ak12
	name = "\improper AK12"
	desc = "A modernized 5.56 platform with controllable recoil and dependable internals."
	icon = 'modular_scpse/modules/scp_weapons/icons/assault_rifles40x32.dmi'
	icon_state = "ak12"
	inhand_icon_state = "ak12"
	lefthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_lefthand.dmi'
	righthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_righthand.dmi'
	worn_icon = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_back.dmi'
	worn_icon_state = "ak12"
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/ak12
	can_suppress = TRUE
	fire_delay = 2.5
	burst_size = 1
	actions_types = list()
	spread = 3
	recoil = 0.55
	fire_sound = 'modular_scpse/modules/scp_weapons/sound/ak12/ak12_shoot.ogg'
	rack_sound = 'modular_scpse/modules/scp_weapons/sound/ak12/ak12_back.ogg'

/obj/item/gun/ballistic/automatic/scp/ak12/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.22 SECONDS)

/obj/item/gun/ballistic/automatic/scp/g36c
	name = "\improper G36C"
	desc = "A compact assault rifle optimized for short-to-mid range engagements."
	icon = 'modular_scpse/modules/scp_weapons/icons/assault_rifles40x32.dmi'
	icon_state = "g36c"
	inhand_icon_state = "g36c"
	lefthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_lefthand.dmi'
	righthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_righthand.dmi'
	worn_icon = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_back.dmi'
	worn_icon_state = "g36c"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	accepted_magazine_type = /obj/item/ammo_box/magazine/g36
	can_suppress = TRUE
	fire_delay = 2.5
	burst_size = 1
	actions_types = list()
	spread = 2
	recoil = 0.45
	fire_sound = 'modular_scpse/modules/scp_weapons/sound/autorifle-1.ogg'

/obj/item/gun/ballistic/automatic/scp/g36c/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS)

/obj/item/ammo_box/magazine/ak12
	name = "\improper AK-12 magazine"
	icon = 'modular_scpse/modules/scp_weapons/icons/ammo.dmi'
	icon_state = "rifle_mag"
	ammo_type = /obj/item/ammo_casing/a223
	max_ammo = 30

/obj/item/ammo_box/magazine/g36
	name = "\improper G36 magazine"
	icon = 'modular_scpse/modules/scp_weapons/icons/ammo.dmi'
	icon_state = "rifle_mag"
	ammo_type = /obj/item/ammo_casing/a223
	max_ammo = 30
