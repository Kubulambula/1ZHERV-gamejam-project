extends Node

signal any_key_pressed

var player: Node = null
var phone_canvas: Node = null
var level_end: Node = null

var music: AudioStreamPlayer = AudioStreamPlayer.new()
var timer: Timer = Timer.new()

var current_level: int = 0

var required_loot_table_level1: Dictionary = {
	"Klíče": false,
	"Telefon": false,
	"Peněženka": false,
}

var required_loot_table_level2: Dictionary = {
	"Klíče": false,
	"Telefon": false,
	"Peněženka": false,
	"ANY_Dárek pro babičku": false,
}

var required_loot_table_level3: Dictionary = {
	"Klíče": false,
	"Telefon": false,
	"Peněženka": false,
	"ANY_Dárek pro bratra": false,
	"ANY_Dárek pro sestru": false,
	"ANY_Dárek pro tchýni": false,
}

var loot_table_level1: Dictionary = {
	"kitchen": [
		"Vidlička",
		"Chleba",
		"Instantní ramen",
		"Talíř",
	],
	"microwave": [
		"Klíče",
	],
	"bathroom": [
		"Toaletní papír",
		"Telefon",
		"Zubní kartáček",
	],
	"bedroom": [
		"Prášky na spaní",
		"Vodítko na psa",
		"Peněženka",
		"Knížka",
		"Sluchátka",
		"Akční figurka",
		"Časopis",
		"Rodinná fotografie",
		"Spodní prádlo",
	],
	"thermos": [
		"Čaj",
		"Kafe",
		"Párek", # Párek v termosce
		"Párek", # Párek v termosce
		"Párek", # Párek v termosce
	],
	"trash": [
		"Baterie",
		"Kapesník",
		"Ohryzek",
		"Myš",
		"Lahev od piva",
		"Plechovka",
		"Antidepresiva",
	],
	"bookcase": [
		"Knížka",
		"Časopis",
		"Křížovka",
		"Modlitební knížka",
		"Leták",
		"Pohlednice",
		"Fotoalbum",
	]
}


var loot_table_level2: Dictionary = {
	"kitchen": [
		"Vidlička",
		"Chleba",
		"Instantní ramen",
		"Talíř",
	],
	"microwave": [
		"Alobal",
	],
	"bathroom": [
		"Toaletní papír",
		"Deodorant",
		"Zubní kartáček",
	],
	"bedroom": [
		"Prášky na spaní",
		"Vodítko na psa",
		"Peněženka",
		"Klíče",
		"Sluchátka",
		"Akční figurka",
		"Časopis",
		"Rodinná fotografie",
		"Spodní prádlo",
	],
	"thermos": [
		"Čaj",
		"Kafe",
		"Párek", # Párek v termosce
		"Párek", # Párek v termosce
		"Párek", # Párek v termosce
	],
	"trash": [
		"Baterie",
		"Kapesník",
		"Ohryzek",
		"Myš",
		"Lahev od piva",
		"Plechovka",
		"Antidepresiva",
	],
	"bookcase": [
		"Telefon",
		"Fotoalbum",
	]
}

var loot_table_level3: Dictionary = {
	"kitchen": [
		"Telefon",
		"Instantní ramen",
		"Talíř",
	],
	"microwave": [
		"Alobal",
	],
	"bathroom": [
		"Toaletní papír",
		"Deodorant",
		"Zubní kartáček",
	],
	"bedroom": [
		"Prášky na spaní",
		"Vodítko na psa",
		"Peněženka",
		"Sluchátka",
		"Akční figurka",
		"Časopis",
		"Rodinná fotografie",
		"Spodní prádlo",
	],
	"thermos": [
		"Čaj",
		"Kafe",
		"Párek", # Párek v termosce
		"Párek", # Párek v termosce
		"Párek", # Párek v termosce
	],
	"trash": [
		"Klíče",
		"Kapesník",
		"Myš",
		"Lahev od piva",
		"Plechovka",
	],
	"bookcase": [
		"Knížka",
		"Časopis",
		"Křížovka",
		"Modlitební knížka",
		"Leták",
		"Pohlednice",
		"Fotoalbum",
	]
}

var failed: bool = false

var loot_table: Dictionary
var required_loot_table: Dictionary


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	phone_canvas = preload("res://scenes/phone_canvas.tscn").instantiate()
	add_child(phone_canvas)
	
	level_end = preload("res://scenes/level_end.tscn").instantiate()
	add_child(level_end)
	level_end.visible = false
	
	music.stream = preload("res://assets/audio/Ludum_Dare_38-Track_4.wav")
	add_child(music)
	
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)


func start_level_1():
	level_end.visible = false
	get_tree().paused = false
	required_loot_table = required_loot_table_level1.duplicate(true)
	loot_table = loot_table_level1.duplicate(true)
	shuffle_loot_table(loot_table)
	current_level = 1
	get_tree().change_scene_to_file("res://scenes/house.tscn")
	phone_canvas.say("Jestli přijedu domů a lednice nebude plná, tak si mě nepřej!", 5)
	timer.start(60)


func start_level_2():
	level_end.visible = false
	get_tree().paused = false
	required_loot_table = required_loot_table_level2.duplicate(true)
	loot_table = loot_table_level2.duplicate(true)
	shuffle_loot_table(loot_table)
	current_level = 2
	get_tree().change_scene_to_file("res://scenes/house.tscn")
	phone_canvas.say("Za chvíli odjíždíme na babiččiny narozeniny. Doufám, že pro ni máš dárek!", 5)
	timer.start(60)


func start_level_3():
	level_end.visible = false
	get_tree().paused = false
	required_loot_table = required_loot_table_level3.duplicate(true)
	loot_table = loot_table_level3.duplicate(true)
	shuffle_loot_table(loot_table)
	get_tree().change_scene_to_file("res://scenes/house.tscn")
	current_level = 3
	phone_canvas.say("Až budeš odcházet, tak vezmi vánoční dárky pro všechny! Snad jsi nezapomněl...", 5)
	timer.start(60)


func _on_timer_timeout():
	end_level(true)


func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventJoypadButton) and event.is_pressed() and not event.is_echo():
		if (event is InputEventKey and event.keycode == KEY_ESCAPE) or (event is InputEventJoypadButton and event.button_index == JOY_BUTTON_GUIDE):
			get_tree().quit()
		any_key_pressed.emit()


func shuffle_loot_table(table: Dictionary) -> void:
	randomize()
	for category in table:
		table[category].shuffle()


func end_level(timeout: bool = false) -> void:
	get_tree().paused = true
	level_end.visible = true
	if current_level == 1 or current_level == 0:
		level_end.evaluate_level1(timeout)
	elif current_level == 2:
		level_end.evaluate_level2(timeout)
	elif current_level == 3:
		level_end.evaluate_level3(timeout)
