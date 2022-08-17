/obj/item/energy_katana
	name = "Энергетическая катана"
	desc = "Катана, наполненная сильной энергией."
	icon_state = "energy_katana"
	item_state = "energy_katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 40
	throwforce = 20
	block_chance = 50
	armour_penetration = 50
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/blade1.ogg'
	block_sounds = list('sound/weapons/bladeb.ogg')
	attack_verb = list("атакует", "рубит", "втыкает", "разрезает", "кромсает", "разрывает", "нарезает", "режет")
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	sharpness = IS_SHARP
	max_integrity = 200
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/datum/effect_system/spark_spread/spark_system
	var/datum/action/innate/dash/ninja/jaunt
	var/dash_toggled = TRUE

/obj/item/energy_katana/Initialize()
	. = ..()
	jaunt = new(src)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/energy_katana/attack_self(mob/user)
	dash_toggled = !dash_toggled
	to_chat(user, span_notice("[dash_toggled ? "enable" : "disable"] функцию рывка на [src]."))

/obj/item/energy_katana/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(dash_toggled)
		jaunt.Teleport(user, target)
	if(proximity_flag && (isobj(target) || issilicon(target)))
		spark_system.start()
		playsound(user, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		playsound(user, 'sound/weapons/blade1.ogg', 50, TRUE)
		target.emag_act(user)

/obj/item/energy_katana/pickup(mob/living/user)
	. = ..()
	jaunt.Grant(user, src)
	user.update_icons()
	playsound(src, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/energy_katana/dropped(mob/user)
	. = ..()
	jaunt.Remove(user)
	user.update_icons()

//If we hit the Ninja who owns this Katana, they catch it.
//Works for if the Ninja throws it or it throws itself or someone tries
//To throw it at the ninja
/obj/item/energy_katana/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H.wear_suit, /obj/item/clothing/suit/space/space_ninja))
			var/obj/item/clothing/suit/space/space_ninja/SN = H.wear_suit
			if(SN.energyKatana == src)
				returnToOwner(H, 0, 1)
				return

	..()

/obj/item/energy_katana/proc/returnToOwner(mob/living/carbon/human/user, doSpark = 1, caught = 0)
	if(!istype(user))
		return
	forceMove(get_turf(user))

	if(doSpark)
		spark_system.start()
		playsound(get_turf(src), "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

	var/msg = ""

	if(user.put_in_hands(src))
		msg = "Энергетическая Катана телепортируется в мою руку!"
	else if(user.equip_to_slot_if_possible(src, ITEM_SLOT_BELT, 0, 1, 1))
		msg = "Энергетическая Катана телепортируется обратно ко мне, убирая себя в ножны!</span>"
	else
		msg = "Энергетическая Катана телепортируется ко мне!"

	if(caught)
		if(loc == user)
			msg = "Ловлю свою Энергетическую Катану!"
		else
			msg = "Энергетическая Катана приземляется у моих ног!"

	if(msg)
		to_chat(user, span_notice("[msg]"))


/obj/item/energy_katana/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/datum/action/innate/dash/ninja
	current_charges = 3
	max_charges = 3
	charge_rate = 30
	recharge_sound = null
