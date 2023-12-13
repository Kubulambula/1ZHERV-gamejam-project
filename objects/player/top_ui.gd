extends CanvasLayer


@onready var _label: RichTextLabel = %RichTextLabel
@onready var _timer_label: Label = %Label

func update_items() -> void:
	_label.clear()
	for item: String in BlackBoard.required_loot_table:
		var item_name = item.substr(4) if item.begins_with("ANY_") else item
		
		if BlackBoard.required_loot_table[item]:
			_label.append_text("[color=sea_green][s]%s[/s][/color]\n" % item_name)
		else:
			_label.append_text("[color=orange_red]%s[/color]\n" % item_name)


func _physics_process(_delta: float) -> void:
	update_items()
	@warning_ignore("integer_division")
	_timer_label.text = "%01d:%02d" % [int(BlackBoard.timer.time_left) / 60, int(BlackBoard.timer.time_left) % 60]
