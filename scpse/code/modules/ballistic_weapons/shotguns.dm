/obj/item/gun/ballistic/shotgun/scp
	name = "\improper SCP shotgun"
	desc = "A field-issued shotgun pattern used by SCP tactical personnel."
	icon = 'scpse/icons/weapons/shotguns40x32.dmi'
	fire_sound = 'scpse/sound/weapons/shotgun_shot.ogg'


/obj/item/gun/ballistic/shotgun/scp/doublebarrel
	name = "double-barreled shotgun"
	desc = "A double-barreled shotgun, known for its powerful close-range firepower."
	icon_state = "doublebarrel"
	base_icon_state = "doublebarrel"
	inhand_icon_state = "doublebarrel"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	force = 10
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/dual
	sawn_desc = "Groovy."
	obj_flags = UNIQUE_RENAME
	rack_sound_volume = 0
	semi_auto = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	can_be_sawn_off = TRUE
	pb_knockback = 3 // it's a super shotgun!
	var/opened = FALSE

/obj/item/gun/ballistic/shotgun/scp/doublebarrel/attack_self(mob/living/user)
	if(!opened)
		playsound(src, 'scpse/sound/weapons/doublebarrel_open.ogg')
		icon_state = "[base_icon_state]_open"
		opened = TRUE
	else
		playsound(src, 'scpse/sound/weapons/doublebarrel_close.ogg')
		icon_state = base_icon_state
		opened = FALSE
	. = ..()

/obj/item/gun/ballistic/shotgun/scp/doublebarrel/proc/is_slug_round(obj/item/ammo)
	if(istype(ammo, /obj/item/ammo_casing/shotgun/buckshot))
		return FALSE
	if(istype(ammo, /obj/item/ammo_casing/shotgun/rubbershot))
		return FALSE
	if(istype(ammo, /obj/item/ammo_casing/shotgun/dragonsbreath))
		return FALSE
	if(istype(ammo, /obj/item/ammo_casing/shotgun/dart))
		return FALSE
	if(istype(ammo, /obj/item/ammo_casing/shotgun/flechette))
		return FALSE
	return istype(ammo, /obj/item/ammo_casing/shotgun)

/obj/item/gun/ballistic/shotgun/scp/doublebarrel/load_gun(obj/item/ammo, mob/living/user)
	if(is_slug_round(ammo) && !opened)
		balloon_alert(user, "open the shotgun first!")
		return FALSE
	return ..()

/obj/item/gun/ballistic/shotgun/scp/doublebarrel/sawoff(mob/user, obj/item/saw, handle_modifications)
	. = ..()
	if(opened)
		return
	if(.)
		weapon_weight = WEAPON_MEDIUM

/obj/item/gun/ballistic/shotgun/scp/rem870
	name = "\improper Remington Model 870"
	desc = "A pump-action shotgun with excellent reliability and strong close-range pressure."
	icon_state = "rem870"
	base_icon_state = "rem870"
	inhand_icon_state = "rem870"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	fire_delay = 7 DECISECONDS
	spread = 6
	recoil = 0.7
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot

/obj/item/gun/ballistic/shotgun/scp/spas12
	name = "\improper Franchi SPAS-12"
	desc = "A semi-automatic combat shotgun. Hits hard, but kicks hard too."
	icon_state = "spas12"
	base_icon_state = "spas12"
	inhand_icon_state = "spas12"
	semi_auto = TRUE
	load_sound = 'scpse/sound/weapons/spas12/spas12_insert.ogg'
	load_sound_vary = TRUE
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/com
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	fire_delay = 9 DECISECONDS
	spread = 8
	recoil = 1

/obj/item/gun/ballistic/shotgun/scp/saiga12
	name = "\improper Saiga-12"
	desc = "A box-magazine-fed shotgun designed for rapid close-quarters fire."
	icon_state = "saiga12"
	base_icon_state = "saiga12"
	inhand_icon_state = "saiga12"
	internal_magazine = FALSE
	semi_auto = TRUE
	fire_sound = 'scpse/sound/weapons/saiga/saiga_shot.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/m12g
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	fire_delay = 6 DECISECONDS
	spread = 9
	recoil = 1.1
	mag_display = TRUE
	empty_indicator = TRUE
