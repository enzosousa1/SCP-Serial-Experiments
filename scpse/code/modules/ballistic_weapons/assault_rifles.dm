/obj/item/gun/ballistic/automatic/scp/scarh
	name = "\improper SCAR-H"
	desc = "A modular assault rifle known for its reliability and high stopping power."
	icon = 'scpse/icons/weapons/gunsgalore_guns40x32.dmi'
	icon_state = "scar"
	inhand_icon_state = "scar"
	lefthand_file = 'scpse/icons/weapons/worn/gunsgalore_lefthand.dmi'
	righthand_file = 'scpse/icons/weapons/worn/gunsgalore_righthand.dmi'
	worn_icon = 'scpse/icons/weapons/worn/gunsgalore_back.dmi'
	worn_icon_state = "scar"
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/scar
	can_suppress = TRUE
	fire_delay = 2
	fire_sound = 'scpse/sound/weapons/scar/scar_fire.ogg'
	rack_sound = 'scpse/sound/weapons/scar/scar_cock.ogg'
	load_sound = 'scpse/sound/weapons/scar/scar_mag_in.ogg'
	eject_sound = 'scpse/sound/weapons/scar/scar_mag_out.ogg'

/obj/item/gun/ballistic/automatic/scp/scarh/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/ammo_box/magazine/scar
	name = "\improper SCAR magazine"
	icon = 'scpse/icons/weapons/gunsgalore_guns40x32.dmi'
	icon_state = "scar_mag"
	ammo_type = /obj/item/ammo_casing/a223
	max_ammo = 30
