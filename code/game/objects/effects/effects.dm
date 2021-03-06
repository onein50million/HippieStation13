
//objects in /obj/effect should never be things that are attackable, use obj/structure instead.
//Effects are mostly temporary visual effects like sparks, smoke, as well as decals, etc...
/obj/effect
	icon = 'icons/effects/effects.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/use_fade = 1

/obj/effect/New()
	if(use_fade)
		alpha = 0
		..()
		animate(src, alpha = 255, time = 5)
	else
		..()

/obj/effect/proc/destroy_effect()
	if(use_fade)
		animate(src, alpha = 0, time = 5)
		QDEL_IN(src, 5)
	else
		qdel(src)

/obj/effect/attackby(obj/item/I, mob/living/user, params)
	return

/obj/effect/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	return

/obj/effect/fire_act(exposed_temperature, exposed_volume)
	return

/obj/effect/acid_act()
	return

/obj/effect/mech_melee_attack(obj/mecha/M)
	return 0

/obj/effect/blob_act()
	return

/obj/effect/ex_act(severity, target)
	if(target == src)
		qdel(src)
	else
		switch(severity)
			if(1)
				qdel(src)
			if(2)
				if(prob(60))
					qdel(src)
			if(3)
				if(prob(25))
					qdel(src)

/obj/effect/attack_hulk(mob/living/carbon/human/user, does_attack_animation = 0)
	return 0

/obj/effect/experience_pressure_difference()
	return

/obj/effect/singularity_act()
	qdel(src)
	return 0