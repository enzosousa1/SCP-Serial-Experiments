/obj/projectile/bullet/c44
	name = ".44 magnum bullet"
	damage = 45
	armour_penetration = 15

/obj/item/ammo_casing/c44
	name = ".44 magnum bullet casing"
	desc = "An empty casing from a .44 magnum round."
	caliber = "44magnum"
	projectile_type = /obj/projectile/bullet/c44
	icon_state = "357"
	base_icon_state = "357"

/obj/item/ammo_box/magazine/internal/cylinder/rev44
	name = ".44 magnum cylinder"
	ammo_type = /obj/item/ammo_casing/c44
	caliber = "44magnum"
	max_ammo = 6

/obj/item/gun/ballistic/revolver/scp
	icon = 'scpse/icons/weapons/revolvers.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM
	inhand_icon_state = "revolver"
	fire_sound = 'scpse/sound/weapons/fire_revolver1.ogg'
	fire_sound_volume = 100
	recoil = 0.7

/obj/item/gun/ballistic/revolver/scp/sw27
	name = "\improper SW-27 Revolver"
	desc = "A classic double-action revolver with a six-shot capacity. Famous for being the first to use the .357 Magnum caliber. Reliable and deadly."
	icon_state = "sw27"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rus357
	recoil = 0.65
	spread = 2

/obj/item/gun/ballistic/revolver/scp/sw29
	name = "\improper SW-29 Revolver"
	desc = "A large-frame revolver chambered in .44 Magnum, known for its stopping power and durability. You're feeling lucky?"
	icon_state = "sw29"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev44
	recoil = 1
	spread = 4
	w_class = WEIGHT_CLASS_BULKY
