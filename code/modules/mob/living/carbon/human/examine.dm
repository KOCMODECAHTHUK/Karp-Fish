/mob/living/carbon/human/examine(mob/user)
//this is very slightly better than it was because you can use it more places. still can't do \his[src] though.
	var/t_He = p_they(TRUE)
	var/t_His = p_their(TRUE)
	var/t_his = p_their()
	var/t_has = p_have()
	var/t_is = p_are()

	var/t_on 	= ru_who(TRUE)
	var/t_ego 	= ru_ego()
	var/t_na 	= ru_na()
	var/t_a 	= ru_a()

	var/obscure_name

	var/list/obscured = check_obscured_slots()
	var/skipface = ((wear_mask?.flags_inv & HIDEFACE) || (head?.flags_inv & HIDEFACE))

	if(isliving(user))
		var/mob/living/L = user
		if(HAS_TRAIT(L, TRAIT_PROSOPAGNOSIA))
			obscure_name = TRUE

	. = list("")

	var/racetext
	if (ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.skin_tone != skin_tone)
			racetext = get_race_text()
	. += "<span class='info'>Это же <EM>[!obscure_name ? name : "Неизвестный"]</EM>, [racetext ? "<big class='interface'>[racetext]</big>" : "[get_age_text()]"]!<hr>"

	//head
	if(head)
		. += "На голове у н[t_ego] [head.get_examine_string(user)]."

	//eyes
	if(!(ITEM_SLOT_EYES in obscured))
		if(glasses)
			. += "Также на [t_na] [glasses.get_examine_string(user)]."
		else if(eye_color == BLOODCULT_EYE && iscultist(src) && HAS_TRAIT(src, CULT_EYES))
			. += "<span class='warning'><B>[ru_ego(TRUE)] глаза ярко-красные и они горят!</B></span>"

	//ears
	if(ears && !(ITEM_SLOT_EARS in obscured))
		. += "В ушах у н[t_ego] есть [ears.get_examine_string(user)]."

	//mask
	if(wear_mask && !(ITEM_SLOT_MASK in obscured))
		. += "На лице у н[t_ego] [wear_mask.get_examine_string(user)]."

	//neck
	if(wear_neck && !(ITEM_SLOT_NECK in obscured))
		. += "На шее у н[t_ego] [wear_neck.get_examine_string(user)]."

	//suit/armor
	if(wear_suit)
		//suit/armor storage
		var/suit_thing
		if(s_store && !(obscured & ITEM_SLOT_SUITSTORE))
			suit_thing += " вместе с [s_store.get_examine_string(user)]"

		. += "На [t_na] надет [wear_suit.get_examine_string(user)][suit_thing]."

	//uniform
	if(w_uniform && !(ITEM_SLOT_ICLOTHING in obscured))
		//accessory
		var/accessory_msg
		if(istype(w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.attached_accessory)
				accessory_msg += " с [icon2html(U.attached_accessory, user)] [U.attached_accessory]"

		. += "Одет[t_a] он[t_a] в [w_uniform.get_examine_string(user)][accessory_msg]."

	//back
	if(back)
		. += "Со спины у н[t_ego] свисает [back.get_examine_string(user)]."

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "В [get_held_index_name(get_held_index_of_item(I))] он[t_a] держит [I.get_examine_string(user)]."

	var/datum/component/forensics/FR = GetComponent(/datum/component/forensics)

	//gloves
	if(gloves && !(ITEM_SLOT_GLOVES in obscured))
		. += "А на руках у н[t_ego] [gloves.get_examine_string(user)]."
	else if(FR && length(FR.blood_DNA))
		if(num_hands)
			. += "<span class='warning'>[ru_ego(TRUE)] рук[num_hands > 1 ? "и" : "а"] также в крови!</span>"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/restraints/handcuffs/cable))
			. += "<span class='warning'>[t_on] [icon2html(handcuffed, user)] связан[t_a]!</span>"
		else
			. += "<span class='warning'>[t_on] [icon2html(handcuffed, user)] в наручниках!</span>"

	//belt
	if(belt)
		. += "И ещё на поясе у н[t_ego] [belt.get_examine_string(user)]."

	//shoes
	if(shoes && !(ITEM_SLOT_FEET in obscured))
		. += "А на [t_ego] ногах [shoes.get_examine_string(user)]."

	//ID
	if(wear_id)
		. += "И конечно же у н[t_ego] есть [wear_id.get_examine_string(user)]."

	. += "<hr>"

	//Status effects
	var/list/status_examines = status_effect_examines()
	if (length(status_examines))
		. += status_examines

	//Jitters
	switch(jitteriness)
		if(300 to INFINITY)
			. += "<span class='warning'><B>[t_on] бьётся в судорогах!</B></span>"
		if(200 to 300)
			. += "<span class='warning'>[t_on] нервно дёргается.</span>"
		if(100 to 200)
			. += "<span class='warning'>[t_on] дрожит.</span>"

	var/appears_dead = FALSE
	var/just_sleeping = FALSE

	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE

		var/obj/item/clothing/glasses/G = get_item_by_slot(ITEM_SLOT_EYES)
		var/are_we_in_weekend_at_bernies = G?.tint && buckled && istype(buckled, /obj/vehicle/ridden/wheelchair)

		if(isliving(user) && (HAS_TRAIT(user, TRAIT_NAIVE) || are_we_in_weekend_at_bernies))
			just_sleeping = TRUE

		if(!just_sleeping)
			if(suiciding)
				. += "<span class='warning'>[t_on] выглядит как суицидник... [t_ego] уже невозможно спасти.</span>"
			if(hellbound)
				. += span_warning("[t_ego] душа выглядит вырванной из [t_ego] тела. Воскрешение невозможно.")
			. += ""
			if(getorgan(/obj/item/organ/brain) && !key && !get_ghost(FALSE, TRUE))
				. += "<span class='deadsay'>[t_on] не реагирует на происходящее вокруг; нет признаков жизни и души...</span>"
			else
				. += "<span class='deadsay'>[t_on] не реагирует на происходящее вокруг; нет признаков жизни...</span>"

//WSStaion Begin - Broken Bones

	var/list/splinted_stuff = list()
	for(var/obj/item/bodypart/B in bodyparts)
		if(B.bone_status == BONE_FLAG_SPLINTED)
			splinted_stuff += B.name
	if(splinted_stuff.len)
		. += "<span class='warning'><B>[t_His] [english_list(splinted_stuff)] [splinted_stuff.len > 1 ? "are" : "is"] splinted!</B></span>\n"

	if(get_bodypart(BODY_ZONE_HEAD) && !getorgan(/obj/item/organ/brain))
		. += "<span class='deadsay'>Похоже, что у н[t_ego] нет мозга...</span>\n"

	var/temp = getBruteLoss() //no need to calculate each of these twice

	var/list/msg = list()

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/list/disabled = list()
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(BP.bodypart_disabled)
			disabled += BP
		missing -= BP.body_zone
		for(var/obj/item/I in BP.embedded_objects)
			if(I.isEmbedHarmless())
				msg += "<B>[t_He] [t_has] \a [icon2html(I, user)] [I] stuck to [t_his] [BP.name]!</B>\n"
			else
				msg += "<B>[t_He] [t_has] \a [icon2html(I, user)] [I] embedded in [t_his] [BP.name]!</B>\n"

	for(var/X in disabled)
		var/obj/item/bodypart/BP = X
		var/damage_text
		if(!(BP.get_damage(include_stamina = FALSE) >= BP.max_damage)) //Stamina is disabling the limb
			damage_text = "выглядит бледновато"
		else
			damage_text = (BP.brute_dam >= BP.burn_dam) ? BP.heavy_brute_msg : BP.heavy_burn_msg
		msg += "<B>[capitalize(t_his)] [BP.name] is [damage_text]!</B>\n"

	//stores missing limbs
	var/l_limbs_missing = 0
	var/r_limbs_missing = 0
	for(var/t in missing)
		if(t==BODY_ZONE_HEAD)
			msg += "<span class='deadsay'><B>[ru_ego(TRUE)] [ru_exam_parse_zone(parse_zone(t))] отсутствует!</B></span>\n"
			continue
		if(t == BODY_ZONE_L_ARM || t == BODY_ZONE_L_LEG)
			l_limbs_missing++
		else if(t == BODY_ZONE_R_ARM || t == BODY_ZONE_R_LEG)
			r_limbs_missing++

		msg += "<span class='warning'><B>[ru_ego(TRUE)] [ru_exam_parse_zone(parse_zone(t))] отсутствует!</B></span>\n"

	if(l_limbs_missing >= 2 && r_limbs_missing == 0)
		msg += "[t_on] стоит на правой части.\n"
	else if(l_limbs_missing == 0 && r_limbs_missing >= 2)
		msg += "[t_on] стоит на левой части.\n"
	else if(l_limbs_missing >= 2 && r_limbs_missing >= 2)
		msg += "[t_on] выглядит как котлетка.\n"

	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(BP.limb_id != (dna.species.examine_limb_id ? dna.species.examine_limb_id : dna.species.id))
			msg += "<span class='info'>[t_He] [t_has] \an [BP.name].</span>\n"

	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		if(temp)
			if(temp < 25)
				msg += "[t_on] имеет незначительные ушибы.\n"
			else if(temp < 50)
				msg += "[t_on] <b>тяжело</b> ранен[t_a]!\n"
			else
				msg += "<B>[t_on] смертельно ранен[t_a]!</B>\n"

		temp = getFireLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_on] немного подгорел[t_a].\n"
			else if (temp < 50)
				msg += "[t_on] имеет <b>серьёзные</b> ожоги!\n"
			else
				msg += "<B>[t_on] имеет смертельные ожоги!</B>\n"

		temp = getCloneLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_on] имеет незначительные подтёки на теле.\n"
			else if(temp < 50)
				msg += "[t_on] имеет <b>обвисшую</b> кожу на большей части тела!\n"
			else
				msg += "<b>[t_on] имеет тело состоящее из кусков свисающей плоти!</b>\n"


	if(fire_stacks > 0)
		msg += "[t_on] в чем-то горючем.\n"
	if(fire_stacks < 0)
		msg += "[t_on] выглядит мокро.\n"


	if(pulledby && pulledby.grab_state)
		msg += "[t_on] удерживается захватом [pulledby].\n"

	if(nutrition < NUTRITION_LEVEL_STARVING - 50)
		msg += "[t_on] выглядит смертельно истощённо.\n"
	else if(nutrition >= NUTRITION_LEVEL_FAT)
		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
			msg += "[t_on] выглядит как толстенький, словно поросёнок. Очень вкусный поросёнок.\n"
		else
			msg += "[t_on] выглядит довольно плотно.\n"
	switch(disgust)
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			msg += "[t_on] выглядит немного неприятно.\n"
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			msg += "[t_on] выглядит очень неприятно.\n"
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			msg += "[t_on] выглядит отвратительно.\n"

	if(blood_volume < BLOOD_VOLUME_SAFE || skin_tone == "albino")
		msg += "[ru_ego(TRUE)] кожа бледная.\n"

	if(bleedsuppress)
		msg += "[t_on] чем-то перевязан.\n"
	else if(bleed_rate)
		if(reagents.has_reagent(/datum/reagent/toxin/heparin, needs_metabolizing = TRUE))
			msg += "<b>У н[t_ego] неконтролируемое кровотечение!</b>\n"
		else
			msg += "<B>[t_on] истекает кровью!</B>\n"

	if(reagents.has_reagent(/datum/reagent/teslium, needs_metabolizing = TRUE))
		msg += "[t_on] излучающий нежно-голубое свечение!\n"

	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				msg += "[t_He] [t_is][stun_absorption[i]["examine_message"]]\n"

	if(just_sleeping)
		msg += "[t_on] не реагирует ни на что вокруг и, кажется спит.\n"

	if(!appears_dead)
		if(drunkenness && !skipface) //Drunkenness
			switch(drunkenness)
				if(11 to 21)
					msg += "[t_on] немного пьян[t_a].\n"
				if(21.01 to 41) //.01s are used in case drunkenness ends up to be a small decimal
					msg += "[t_on] пьян[t_a].\n"
				if(41.01 to 51)
					msg += "[t_on] довольно пьян[t_a] и от н[t_ego] чувствуется запах алкоголя.\n"
				if(51.01 to 61)
					msg += "Очень пьян[t_a] и от н[t_ego] несёт перегаром.\n"
				if(61.01 to 91)
					msg += "[t_on] в стельку.\n"
				if(91.01 to INFINITY)
					msg += "[t_on] в говно!\n"

		if(src != user)
			if(HAS_TRAIT(user, TRAIT_EMPATH))
				if (a_intent != INTENT_HELP)
					msg += "[t_on] выглядит на готове.\n"
				if (getOxyLoss() >= 10)
					msg += "[t_on] выглядит измотанно.\n"
				if (getToxLoss() >= 10)
					msg += "[t_on] выглядит болезненно.\n"
				var/datum/component/mood/mood = src.GetComponent(/datum/component/mood)
				if(mood.sanity <= SANITY_DISTURBED)
					msg += "[t_on] выглядит расстроенным."
					SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "empath", /datum/mood_event/sad_empath, src)
				if (is_blind())
					msg += "[t_on] смотрит в пустоту.\n"
				if (HAS_TRAIT(src, TRAIT_DEAF))
					msg += "[t_on] не реагирует на шум.\n"

			msg += "</span>"

			if(HAS_TRAIT(user, TRAIT_SPIRITUAL) && mind?.holy_role)
				msg += "От н[t_ego] исходит святая аура.\n"
				SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "religious_comfort", /datum/mood_event/religiously_comforted)

		switch(stat)
			if(UNCONSCIOUS, HARD_CRIT)
				msg += "<span class='deadsay'>[t_on] не реагирует на происходящее вокруг.</span>\n"
			if(SOFT_CRIT)
				msg += "<span class='deadsay'>[t_on] едва в сознании.</span>\n"
			if(CONSCIOUS)
				if(HAS_TRAIT(src, TRAIT_DUMB))
					msg += "[t_on] имеет глупое выражение лица.\n"
		if(getorgan(/obj/item/organ/brain))
			if(!key)
				msg += "<span class='deadsay'>[t_on] выглядит не очень разумно.</span>\n"
			if(!key)
				msg += "<span class='deadsay'>[t_on] кататоник. Стресс от жизни в глубоком космосе сильно повлиял на н[t_ego]. Восстановление маловероятно.</span>\n"
	if (length(msg))
		. += "<span class='warning'>[msg.Join("")]</span>"

	switch(mothdust) //WS edit - moth dust from hugging
		if(1 to 50)
			. += "[t_on] немного пыльный."
		if(51 to 150)
			. += "[t_on] покрыт слоем сверкающей пыли."
		if(151 to INFINITY)
			. += "<b>[t_on] покрыт сверкающей пылью!</b>" //End WS edit

	var/trait_exam = common_trait_examine()
	if (!isnull(trait_exam))
		. += trait_exam

	var/traitstring = get_trait_string()

	var/perpname = get_face_name(get_id_name(""))
	if(perpname && (HAS_TRAIT(user, TRAIT_SECURITY_HUD) || HAS_TRAIT(user, TRAIT_MEDICAL_HUD)))
		var/datum/data/record/R = find_record("name", perpname, GLOB.data_core.general)
		if(R)
			. += "<hr><span class='deptradio'>Должность:</span> [R.fields["rank"]]\n<a href='?src=[REF(src)];hud=1;photo_front=1'>\[Фото\]</a><a href='?src=[REF(src)];hud=1;photo_side=1'>\[Альт.\]</a>"
		if(HAS_TRAIT(user, TRAIT_MEDICAL_HUD))
			var/cyberimp_detect
			for(var/obj/item/organ/cyberimp/CI in internal_organs)
				if(CI.status == ORGAN_ROBOTIC && !CI.syndicate_implant)
					cyberimp_detect += "[!cyberimp_detect ? "[CI.get_examine_string(user)]" : ", [CI.get_examine_string(user)]"]"
			if(cyberimp_detect)
				. += "<span class='notice ml-1'>Обнаружены кибернетические модификации:</span>"
				. += "<span class='notice ml-2'>[cyberimp_detect]</span>"
			if(R)
				var/health_r = R.fields["p_stat"]
				. += "<a href='?src=[REF(src)];hud=m;p_stat=1'>\[[health_r]\]</a>"
				health_r = R.fields["m_stat"]
				. += "<a href='?src=[REF(src)];hud=m;m_stat=1'>\[[health_r]\]</a>"
			R = find_record("name", perpname, GLOB.data_core.medical)
			if(R)
				. += "<a href='?src=[REF(src)];hud=m;evaluation=1'>\[Медицинское заключение\]</a><br>"
			if(traitstring)
				. += "<span class='notice ml-1'>Detected physiological traits:</span>"
				. += "<span class='notice ml-2'>[traitstring]</span>"

		if(HAS_TRAIT(user, TRAIT_SECURITY_HUD))
			if(!user.stat && user != src)
			//|| !user.canmove || user.restrained()) Fluff: Sechuds have eye-tracking technology and sets 'arrest' to people that the wearer looks and blinks at.
				var/criminal = "None"

				R = find_record("name", perpname, GLOB.data_core.security)
				if(R)
					criminal = R.fields["criminal"]

				. += "<span class='deptradio'>Criminal status:</span> <a href='?src=[REF(src)];hud=s;status=1'>\[[criminal]\]</a>"
				. += jointext(list("<span class='deptradio'>Заметки:</span> <a href='?src=[REF(src)];hud=s;view=1'>\[View\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_citation=1'>\[Добавить цитату\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_crime=1'>\[Добавить нарушениеe\]</a>",
					"<a href='?src=[REF(src)];hud=s;view_comment=1'>\[Просмотреть комментарии\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_comment=1'>\[Добавить комментарий\]</a>"), "")
	else if(isobserver(user) && traitstring)
		. += "<span class='info'><b>Черты:</b> [traitstring]</span>"

	//No flavor text unless the face can be seen. Prevents certain metagaming with impersonation.
	var/invisible_man = skipface || get_visible_name() == "Неизвестный"
	if(invisible_man)
		. += "...?"
	else
		var/flavor = print_flavor_text()
		if(flavor)
			. += flavor
	. += "</span>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/mob/living/proc/status_effect_examines(pronoun_replacement) //You can include this in any mob's examine() to show the examine texts of status effects!
	var/list/dat = list()
	if(!pronoun_replacement)
		pronoun_replacement = ru_who(TRUE)
	for(var/V in status_effects)
		var/datum/status_effect/E = V
		if(E.examine_text)
			var/new_text = replacetext_char(E.examine_text, "SUBJECTPRONOUN", pronoun_replacement)
			dat += "[new_text]\n" //dat.Join("\n") doesn't work here, for some reason
	if(dat.len)
		return dat.Join()

/mob/living/carbon/human/examine_more(mob/user)
	. = ..()
	if ((wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE)))
		return
	var/age_text
	switch(age)
		if(-INFINITY to 25)
			age_text = "очень молод[ru_aya()]"
		if(26 to 35)
			age_text = "молод[ru_aya()]"
		if(36 to 55)
			age_text = "среднего возраста"
		if(56 to 75)
			age_text = "достаточно взросл[ru_aya()]"
		if(76 to 100)
			if(gender == FEMALE)
				age_text = "старуха"
			else
				age_text = "старик"
		if(101 to INFINITY)
			age_text = "сейчас превратится в пыль"
	. += list(span_notice("<hr>[ru_who(TRUE)] на вид [age_text]."))
