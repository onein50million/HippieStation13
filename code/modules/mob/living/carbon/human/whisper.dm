/mob/living/carbon/human/whisper(message as text)
	if(!IsVocal())
		return
	if(!message)
		return

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	if(stat == DEAD)
		return


	message = trim(html_encode(message))
	if(!can_speak(message))
		return

	message = "[message]"
	log_whisper("[src.name]/[src.key] : [message]")

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			src << "<span class='danger'>You cannot whisper (muted).</span>"
			return

	log_whisper("[src.name]/[src.key] : [message]")

	var/alt_name = get_alt_name()

	var/whispers = "whispers"
	var/critical = InCritical()

	// We are unconscious or we are in critical, so don't allow them to whisper.
	if(stat == UNCONSCIOUS || critical)
		return

	message = treat_message(message)

	var/list/listening_dead = list()
	for(var/mob/M in player_list)
		if(M.stat == DEAD && M.client && ((M.client.prefs.chat_toggles & CHAT_GHOSTWHISPER) || (get_dist(M, src) <= 7)))
			listening_dead |= M

	var/list/listening = get_hearers_in_view(1, src)
	listening |= listening_dead
	var/list/eavesdropping = get_hearers_in_view(2, src)
	eavesdropping -= listening
	var/list/watching  = hearers(5, src)
	watching  -= listening
	watching  -= eavesdropping

	var/rendered
	whispers = "whispers something."
	rendered = "<span class='game say'><span class='name'>[src.name]</span> [whispers]</span>"
	for(var/mob/M in watching)
		M.show_message(rendered, 2)

	var/spans = list(SPAN_ITALICS)
	whispers = "whispers"
	rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] [whispers], <span class='message'>\"[attach_spans(message, spans)]\"</span></span>"

	for(var/atom/movable/AM in listening)
		if(istype(AM,/obj/item/device/radio))
			continue
		AM.Hear(rendered, src, languages_spoken, message, , spans)

	message = stars(message)
	rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] [whispers], <span class='message'>\"[attach_spans(message, spans)]\"</span></span>"
	for(var/atom/movable/AM in eavesdropping)
		if(istype(AM,/obj/item/device/radio))
			continue
		AM.Hear(rendered, src, languages_spoken, message, , spans)
