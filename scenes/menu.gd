extends ColorRect

signal any_key

var started_cutscene: bool = false


func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventJoypadButton) and event.is_pressed() and not event.is_echo():
		if not started_cutscene:
			if (event is InputEventKey and event.keycode == KEY_X) or (event is InputEventJoypadButton and event.button_index == JOY_BUTTON_X):
				%Licenses.visible = !%Licenses.visible
				return
			%Licenses.visible = false
			started_cutscene = true
			manage_cutscene()
		else:
			any_key.emit()


func manage_cutscene() -> void:
	var player: AnimationPlayer = $AnimationPlayer
	var label: RichTextLabel = $Phone/RichTextLabel
	var audio: AudioStreamPlayer = $PhoneAccept
	player.play("fade")
	await player.animation_finished
	player.play("cutscene")
	
	await player.animation_finished
	label.text = "Ahoj zlato!"
	
	await any_key
	audio.playing = true
	label.text = "Koupil jsi to mléko na bábovku, jak jsem ti říkala?"
	
	await any_key
	audio.playing = true
	label.text = "."
	
	await any_key
	audio.playing = true
	label.text = ".."
	
	await any_key
	audio.playing = true
	label.text = "..."
	
	await any_key
	audio.playing = true
	label.text = "Ty absolutně"
	
	await any_key
	audio.playing = true
	label.text = "Ty absolutně NESCHOPNEJ"
	
	await any_key
	audio.playing = true
	label.text = "Ty absolutně NESCHOPNEJ [tornado radius=3 freq=27]IMBECILE!!![/tornado]"
	
	await any_key	
	audio.playing = true
	label.text = "NECHÁPU, JAK JSEM SI MOHLA VZÍT NĚKOHO TAK [tornado radius=3 freq=27]NESHCOPNÝHO??!!!"
	
	await any_key
	audio.playing = true
	label.text = "OKAMŽITĚ JEĎ DO OBCHODU A NEŽ SE VRÁTÍM, TAK CHCI DOMA [tornado radius=3 freq=27][color=yellow]PLNOU LEDNICI[/color]!!!"
	
	await any_key
	audio.playing = true
	label.text = "Budu doma za 5 minut, takže hodně štěstí..."
	
	await any_key
	audio.playing = true
	label.text = "Zatím!"
	
	await any_key
	audio.playing = true
	$Phone.visible = false
	
	await get_tree().create_timer(0.65).timeout
	BlackBoard.music.play()
	await get_tree().create_timer(0.5).timeout
	BlackBoard.start_level_1()
