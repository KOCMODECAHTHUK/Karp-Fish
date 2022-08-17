/obj/item/organ/tongue
	name = "язык"
	desc = "Мышца из плоти, в основном используется для того чтобы врать."
	icon_state = "tonguenormal"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb = list("лижет", "нализывает", "шлёпает", "французит", "язычит")
	var/list/languages_possible
	var/say_mod = "говорит"
	var/taste_sensitivity = 15 // lower is more sensitive.
	var/modifies_speech = FALSE
	var/static/list/languages_possible_base = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/ratvar
	))

/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_base

/obj/item/organ/tongue/proc/handle_speech(datum/source, list/speech_args)

/obj/item/organ/tongue/Insert(mob/living/carbon/M, special = 0)
	..()
	if (modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, .proc/handle_speech)
	M.UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/organ/tongue/Remove(mob/living/carbon/M, special = 0)
	..()
	UnregisterSignal(M, COMSIG_MOB_SAY, .proc/handle_speech)
	M.RegisterSignal(M, COMSIG_MOB_SAY, /mob/living/carbon/.proc/handle_tongueless_speech)

/obj/item/organ/tongue/could_speak_language(language)
	return is_type_in_typecache(language, languages_possible)

//Say_mod-Only Tongues
/obj/item/organ/tongue/golem_base
	name = "golem tongue"
	say_mod = "rumbles"

/obj/item/organ/tongue/golem_honk
	name = "bananium tongue"
	say_mod = "honks"

/obj/item/organ/tongue/toma
	name = "mutated tongue"
	say_mod = "mumbles"

//Other Tongues
/obj/item/organ/tongue/lizard
	name = "раздвоенный язык"
	desc = "Тонкая и длинная мышца, обычно такая есть у чешуйчатых рас. Так же выполняет роль носа."
	icon_state = "tonguelizard"
	say_mod = "шипит"
	taste_sensitivity = 10 // combined nose + tongue, extra sensitive
	modifies_speech = TRUE

/obj/item/organ/tongue/lizard/handle_speech(datum/source, list/speech_args)
	if(speech_args[SPEECH_LANGUAGE] == /datum/language/draconic) //WS edit - lizard tongues don't hiss when speaking Draconic
		return
	var/static/regex/lizard_hiss = new("s+", "g")
	var/static/regex/lizard_hiSS = new("S+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = lizard_hiss.Replace(message, "sss")
		message = lizard_hiSS.Replace(message, "SSS")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/fly
	name = "хоботок"
	desc = "Страшная мясная трубка, кажется через неё питаются."
	icon_state = "tonguefly"
	say_mod = "жужжит"
	taste_sensitivity = 25 // you eat vomit, this is a mercy
	modifies_speech = TRUE
	var/static/list/languages_possible_fly = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/buzzwords,
		/datum/language/ratvar
	))

/obj/item/organ/tongue/fly/handle_speech(datum/source, list/speech_args)
	var/static/regex/fly_buzz = new("z+", "g")
	var/static/regex/fly_buZZ = new("Z+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = fly_buzz.Replace(message, "zzz")
		message = fly_buZZ.Replace(message, "ZZZ")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/fly/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_fly

/obj/item/organ/tongue/abductor
	name = "суперязыковая матрица"
	desc = "Таинственная структура, которая позволяет мгновенно общаться с другими пользователями. Довольно интересная вещь, только есть не удобно."
	icon_state = "tongueayylmao"
	say_mod = "тараторит"
	taste_sensitivity = 101 // ayys cannot taste anything.
	modifies_speech = TRUE
	var/mothership

/obj/item/organ/tongue/abductor/attack_self(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/obj/item/organ/tongue/abductor/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	if(!istype(T))
		return

	if(T.mothership == mothership)
		to_chat(H, span_notice("[capitalize(src.name)] уже настроен на твой канал."))

	H.visible_message("<span class='notice'>[H] holds [src] in their hands, and concentrates for a moment.</span>", "<span class='notice'>You attempt to modify the attunation of [src].</span>")
	if(do_after(H, delay=15, target=src))
		to_chat(H, "<span class='notice'>You attune [src] to your own channel.</span>")
		mothership = T.mothership

/obj/item/organ/tongue/abductor/examine(mob/M)
	. = ..()
	if(HAS_TRAIT(M, TRAIT_ABDUCTOR_TRAINING) || HAS_TRAIT(M.mind, TRAIT_ABDUCTOR_TRAINING) || isobserver(M))
		if(!mothership)
			. += "<span class='notice'>It is not attuned to a specific mothership.</span>"
		else
			. += "<span class='notice'>It is attuned to [mothership].</span>"

/obj/item/organ/tongue/abductor/handle_speech(datum/source, list/speech_args)
	//Hacks
	var/message = speech_args[SPEECH_MESSAGE]
	var/mob/living/carbon/human/user = source
	var/rendered = "<span class='abductor'><b>[user.real_name]:</b> [message]</span>"
	user.log_talk(message, LOG_SAY, tag="abductor")
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		var/obj/item/organ/tongue/abductor/T = H.getorganslot(ORGAN_SLOT_TONGUE)
		if(!istype(T))
			continue
		if(mothership == T.mothership)
			to_chat(H, rendered)

	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered]")

	speech_args[SPEECH_MESSAGE] = ""

/obj/item/organ/tongue/zombie
	name = "гнилой язык"
	desc = "Благодаря разложению и тому факту, что он тут просто лежит вы задумываетесь о том, может ли язык выглядеть еще менее сексуально."
	icon_state = "tonguezombie"
	say_mod = "мычит"
	modifies_speech = TRUE
	taste_sensitivity = 32

/obj/item/organ/tongue/zombie/handle_speech(datum/source, list/speech_args)
	var/list/message_list = splittext(speech_args[SPEECH_MESSAGE], " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, -3) == "..."))//3 == length("...")
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("МОЗГИ", "Мозги", "Мооозгиииии", "МОООЗГИИИИИ")]...")

	speech_args[SPEECH_MESSAGE] = jointext(message_list, " ")

/obj/item/organ/tongue/alien
	name = "язык чужого"
	desc = "По мнению ведущих ксенобиологов, эволюционное преимущество от второго рта в том \"что это выглядит круто\"."
	icon_state = "tonguexeno"
	say_mod = "шипит"
	taste_sensitivity = 10 // lizardS ARE ALIENS CONFIRMED
	modifies_speech = TRUE // not really, they just hiss
	var/static/list/languages_possible_alien = typecacheof(list(
		/datum/language/xenocommon,
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/monkey))

/obj/item/organ/tongue/alien/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_alien

/obj/item/organ/tongue/alien/handle_speech(datum/source, list/speech_args)
	playsound(owner, "hiss", 25, TRUE, TRUE)

/obj/item/organ/tongue/bone
	name = "костяной \"язык\""
	desc = "Выяснилось, что скелеты используют вместо языка скрежет своих зубов, отсюда и постоянное дребезжание."
	icon_state = "tonguebone"
	say_mod = "костлявит"
	attack_verb = list("кусает", "прокусывает", "откусывает", "шутит", "костирует")
	taste_sensitivity = 101 // skeletons cannot taste anything
	modifies_speech = TRUE
	var/chattering = FALSE
	var/phomeme_type = "sans"
	var/list/phomeme_types = list("sans", "papyrus")
	var/static/list/languages_possible_skeleton = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/calcic,
		/datum/language/ratvar
	))

/obj/item/organ/tongue/bone/Initialize()
	. = ..()
	phomeme_type = pick(phomeme_types)
	languages_possible = languages_possible_skeleton

/obj/item/organ/tongue/bone/handle_speech(datum/source, list/speech_args)
	if (chattering)
		chatter(speech_args[SPEECH_MESSAGE], phomeme_type, source)
	switch(phomeme_type)
		if("sans")
			speech_args[SPEECH_SPANS] |= SPAN_SANS
		if("papyrus")
			speech_args[SPEECH_SPANS] |= SPAN_PAPYRUS

/obj/item/organ/tongue/bone/plasmaman
	name = "плазменная кость \"языка\""
	desc = "Как и у скелетов, плазмалюди используют вместо языка скрежет зубов чтобы общаться."
	icon_state = "tongueplasma"
	modifies_speech = FALSE

/obj/item/organ/tongue/robot
	name = "синтезатор голоса"
	desc = "Синтезатор голоса используемый для взаимодействия с органическими формами жизни."
	status = ORGAN_ROBOTIC
	organ_flags = NONE
	icon_state = "tonguerobot"
	say_mod = "констатирует"
	attack_verb = list("бипает", "бупает")
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue
	var/static/list/languages_possible_robot = typecacheof(subtypesof(/datum/language))

/obj/item/organ/tongue/robot/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_robot

/obj/item/organ/tongue/robot/emp_act(severity)
	owner.apply_effect(EFFECT_STUTTER, 120)
	owner.emote("scream")
	to_chat(owner, "<span class='warning'>Alert: Vocal cords are malfunctioning.</span>")

/obj/item/organ/tongue/robot/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/tongue/snail
	name = "snailtongue"
	say_mod = "slurs"
	modifies_speech = TRUE

/obj/item/organ/tongue/snail/handle_speech(datum/source, list/speech_args)
	var/new_message
	var/message = speech_args[SPEECH_MESSAGE]
	for(var/i in 1 to length(message))
		if(findtext_char("АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя", message[i])) //Im open to suggestions
			new_message += message[i] + message[i] + message[i] //aaalllsssooo ooopppeeennn tttooo sssuuuggggggeeessstttiiiooonsss
		else
			new_message += message[i]
	speech_args[SPEECH_MESSAGE] = new_message

/obj/item/organ/tongue/squid
	name = "язык кальмара"
	desc = "Маленькое щупальце, используемое для синтеза речи"
	icon_state = "tonguesquid"
	var/static/list/languages_possible_squid = typecacheof(list(
		/datum/language/rylethian,
		/datum/language/common,
		/datum/language/xenocommon,
		/datum/language/aphasia,
		/datum/language/narsie,
		/datum/language/monkey,
		/datum/language/shadowtongue,
		/datum/language/ratvar
		))

/obj/item/organ/tongue/squid/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_squid

/obj/item/organ/tongue/ethereal
	name = "электрический разрядник"
	desc = "Сложный эфирный орган, способный синтезировать речь с помощью электрических разрядов."
	icon_state = "electrotongue"
	say_mod = "искрит"
	attack_verb = list("шокирует", "жалит", "ебошит током")
	taste_sensitivity = 101 // Not a tongue, they can't taste shit
	var/static/list/languages_possible_ethereal = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/ratvar,
	))

/obj/item/organ/tongue/ethereal/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_ethereal

/obj/item/organ/tongue/slime //I really can't be asked to make an icon for this. Besides nobody is ever going to pull your tongue out in the first place.
	name = "slime 'tongue'"
	desc = "A glob of slime that somehow lets slimepeople speak."
	alpha = 150
	say_mod = "blorbles"
	var/static/list/languages_possible_slime = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/ratvar,
		/datum/language/slime
	))

/obj/item/organ/tongue/slime/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_slime
/obj/item/organ/tongue/moth
	name = "хоботок"
	desc = "Мясистая трубка, которая сворачивается, когда не используется. Хотя она смутно напоминает хоботок их генетических предков, \
	он является фактически вестигиальным, полезным только для произнесения жужжащих слов."
	say_mod = "трепещет"
	var/static/list/languages_possible_moth = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/buzzwords
	))

/obj/item/organ/tongue/moth/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_moth


/obj/item/organ/tongue/uwuspeak
	name = "кошачий язык"
	desc = "Обычно встречается в устах кошолюдов."
	say_mod = "муякаут"
	modifies_speech = TRUE

/obj/item/organ/tongue/uwuspeak/handle_speech(datum/source, list/speech_args)
	var/static/regex/uwuspeak_lr2w = new("(\[lr])", "g")
	var/static/regex/uwuspeak_LR2W = new("(\[LR])", "g")
	var/static/regex/uwuspeak_nya = new("(\[Nn])(\[aeiou])|(\[n])(\[AEIOU])", "g")
	var/static/regex/uwuspeak_NYA = new("(N)(\[AEIOU])", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = uwuspeak_lr2w.Replace(message, "w")
		message = uwuspeak_LR2W.Replace(message, "W")
		message = uwuspeak_nya.Replace(message, "$1$3y$2$4")
		message = uwuspeak_NYA.Replace(message, "$1Y$2")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/kepori
	say_mod = "chirps"
	var/static/list/languages_possible_kepi = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/teceti_unified
	))

/obj/item/organ/tongue/kepori/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_kepi

/obj/item/organ/tongue/vox
	name = "hindtongue"
	desc = "Some kind of severed bird tongue."
	say_mod = "shrieks"
	var/static/list/languages_possible_vox = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/vox_pidgin
	))

/obj/item/organ/tongue/vox/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_vox
