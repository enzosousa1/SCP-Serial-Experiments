/obj/item/gun/ballistic/automatic/scp
	name = "\improper SCP weapon"
	desc = "An anomalous ballistic weapon."
	fire_delay = 2.5
	fire_sound_volume = 100
	burst_size = 1
	actions_types = list()

/obj/item/gun/ballistic/automatic/scp/p90
	name = "\improper FN P90"
	desc = "A compact submachine gun with a high rate of fire and a large magazine capacity. It is designed for close-quarters combat and is known for its distinctive bullpup design."
	icon = 'modular_scpse/modules/scp_weapons/icons/submachine_guns.dmi'
	icon_state = "p90"
	inhand_icon_state = "p90"
	lefthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_lefthand.dmi'
	righthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_righthand.dmi'
	worn_icon = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_back.dmi'
	worn_icon_state = "p90"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/p90
	can_suppress = FALSE
	spread = 4
	recoil = 0.5
	fire_sound = 'modular_scpse/modules/scp_weapons/sound/p90/p90_fire.ogg'
	rack_sound = 'modular_scpse/modules/scp_weapons/sound/p90/p90_cock.ogg'
	load_sound = 'modular_scpse/modules/scp_weapons/sound/p90/p90_magin.ogg'
	eject_sound = 'modular_scpse/modules/scp_weapons/sound/p90/p90_magout.ogg'

/obj/item/gun/ballistic/automatic/scp/p90/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.22 SECONDS)

/obj/item/ammo_box/magazine/p90
	name = "\improper FN P90 magazine"
	icon = 'modular_scpse/modules/scp_weapons/icons/ammo/magazines.dmi'
	icon_state = "p90_mag"
	ammo_type = /obj/item/ammo_casing/c46x30mm
	max_ammo = 50

/obj/item/gun/ballistic/automatic/scp/mp5
	name = "\improper MP5"
	desc = "A compact, highly accurate submachine gun favored by tactical teams worldwide."
	icon = 'modular_scpse/modules/scp_weapons/icons/submachine_guns40x32.dmi'
	icon_state = "mp5"
	inhand_icon_state = "mp5"
	lefthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_lefthand.dmi'
	righthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_righthand.dmi'
	worn_icon = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_back.dmi'
	worn_icon_state = "mp5"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/mp5
	can_suppress = TRUE
	fire_delay = 3
	spread = 2
	recoil = 0.35
	fire_sound = 'modular_scpse/modules/scp_weapons/sound/mp5/mp5_fire.ogg'
	rack_sound = 'modular_scpse/modules/scp_weapons/sound/mp5/mp5_cock.ogg'
	load_sound = 'modular_scpse/modules/scp_weapons/sound/mp5/mp5_magin.ogg'
	eject_sound = 'modular_scpse/modules/scp_weapons/sound/mp5/mp5_magout.ogg'

/obj/item/gun/ballistic/automatic/scp/mp5/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.26 SECONDS)

/obj/item/ammo_box/magazine/mp5
	name = "\improper MP5 magazine"
	icon = 'modular_scpse/modules/scp_weapons/icons/gunsgalore_guns40x32.dmi'
	icon_state = "mp5_mag"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/gun/ballistic/automatic/scp/krvector
	name = "\improper KRISS Vector"
	desc = "A compact .45 ACP SMG with an aggressive cyclic rate and strong close-range stopping power."
	icon = 'modular_scpse/modules/scp_weapons/icons/submachine_guns40x32.dmi'
	icon_state = "vector"
	inhand_icon_state = "vector"
	lefthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_lefthand.dmi'
	righthand_file = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_righthand.dmi'
	worn_icon = 'modular_scpse/modules/scp_weapons/icons/worn/gunsgalore_back.dmi'
	worn_icon_state = "vector"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/vector45
	can_suppress = TRUE
	fire_delay = 2
	spread = 5
	recoil = 0.7
	fire_sound = 'modular_scpse/modules/scp_weapons/sound/vector45/vector45_fire.ogg'
	rack_sound = 'modular_scpse/modules/scp_weapons/sound/vector45/vector_back.ogg'

/obj/item/gun/ballistic/automatic/scp/vecttor/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.18 SECONDS)

// Typo-compatible alias for map-placed references.
/obj/item/gun/ballistic/automatic/scp/vector
	parent_type = /obj/item/gun/ballistic/automatic/scp/krvector

/obj/item/ammo_box/magazine/vector45
	name = "\improper KRISS Vector magazine (.45)"
	icon = 'modular_scpse/modules/scp_weapons/icons/ammo.dmi'
	icon_state = "vector_mag"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 25
