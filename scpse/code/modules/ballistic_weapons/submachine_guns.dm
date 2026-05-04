/obj/item/gun/ballistic/automatic/scp
	name = "\improper SCP weapon"
	desc = "An anomalous ballistic weapon."
	fire_delay = 3
	fire_sound_volume = 100

/obj/item/gun/ballistic/automatic/scp/p90
	name = "\improper FN P90"
	desc = "A compact submachine gun with a high rate of fire and a large magazine capacity. It is designed for close-quarters combat and is known for its distinctive bullpup design."
	icon = 'scpse/icons/weapons/submachine_guns.dmi'
	icon_state = "p90"
	inhand_icon_state = "p90"
	lefthand_file = 'scpse/icons/weapons/worn/gunsgalore_lefthand.dmi'
	righthand_file = 'scpse/icons/weapons/worn/gunsgalore_righthand.dmi'
	worn_icon = 'scpse/icons/weapons/worn/gunsgalore_back.dmi'
	worn_icon_state = "p90"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/p90
	can_suppress = FALSE
	fire_sound = 'scpse/sound/weapons/p90/p90_fire.ogg'
	rack_sound = 'scpse/sound/weapons/p90/p90_cock.ogg'
	load_sound = 'scpse/sound/weapons/p90/p90_magin.ogg'
	eject_sound = 'scpse/sound/weapons/p90/p90_magout.ogg'

/obj/item/gun/ballistic/automatic/scp/p90/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/ammo_box/magazine/p90
	name = "\improper FN P90 magazine"
	icon = 'scpse/icons/weapons/ammo/magazines.dmi'
	icon_state = "p90_mag"
	ammo_type = /obj/item/ammo_casing/c46x30mm
	max_ammo = 50

/obj/item/gun/ballistic/automatic/scp/mp5
	name = "\improper MP5"
	desc = "A compact, highly accurate submachine gun favored by tactical teams worldwide."
	icon = 'scpse/icons/weapons/gunsgalore_guns40x32.dmi'
	icon_state = "mp5"
	inhand_icon_state = "mp5"
	lefthand_file = 'scpse/icons/weapons/worn/gunsgalore_lefthand.dmi'
	righthand_file = 'scpse/icons/weapons/worn/gunsgalore_righthand.dmi'
	worn_icon = 'scpse/icons/weapons/worn/gunsgalore_back.dmi'
	worn_icon_state = "mp5"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/mp5
	can_suppress = TRUE
	fire_sound = 'scpse/sound/weapons/mp5/mp5_fire.ogg'
	rack_sound = 'scpse/sound/weapons/mp5/mp5_cock.ogg'
	load_sound = 'scpse/sound/weapons/mp5/mp5_magin.ogg'
	eject_sound = 'scpse/sound/weapons/mp5/mp5_magout.ogg'

/obj/item/gun/ballistic/automatic/scp/mp5/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/ammo_box/magazine/mp5
	name = "\improper MP5 magazine"
	icon = 'scpse/icons/weapons/gunsgalore_guns40x32.dmi'
	icon_state = "mp5_mag"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30
