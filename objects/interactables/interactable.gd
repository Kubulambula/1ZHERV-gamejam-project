class_name Interactable
extends Area3D

@export var category: String = "other"

@export var _animation_player: AnimationPlayer = null
#@export var _item_spawn_point: Node3D = null

@export var _notification_label: Label3D = null

var _player_in_range: bool = false 
var _already_interacted: bool = false
var _item: String = ""

var audio: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	_notification_label.visible = false
	_notification_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_notification_label.no_depth_test = true
	_notification_label.pixel_size = 0.005
	_notification_label.font = preload("res://assets/fonts/COMIC.TTF")
	audio.stream = preload("res://assets/audio/select_007.ogg")
	add_child(audio)
	if not _animation_player:
		return
	if not _animation_player.has_animation("interact"):
		push_error("AnimationPlayer has no 'interact' animation!")


func _on_body_entered(body: Node3D) -> void:
	if body != BlackBoard.player:
		return
	_player_in_range = true


func _on_body_exited(body: Node3D) -> void:
	if body != BlackBoard.player:
		return
	_player_in_range = false


func _spawn_item() -> void:
	_item = BlackBoard.loot_table[category].pop_back() if not BlackBoard.loot_table[category].is_empty() else ""
	_notification_label.text += "\n%s" % (_item if not _item.is_empty() else "Nic")


func _pick_intem() -> void:
	if _item.is_empty():
		return
	
	if _item in BlackBoard.required_loot_table.keys():
		BlackBoard.required_loot_table[_item] = true
		#_item = ""
		_notification_label.text = _notification_label.text.split("\n")[0] + "\nNic"
		return
	
	for item: String in BlackBoard.required_loot_table:
		if not item.begins_with("ANY_"):
			continue
		
		BlackBoard.required_loot_table.erase(item)
		BlackBoard.required_loot_table[item.substr(4) + ": " + _item] = true
		_item = ""
		_notification_label.text = _notification_label.text.split("\n")[0] + "\nNic"
		break


#func _spawn_item() -> void:
	#var item_path: String = BlackBoard.loot_table[category].pop_back() if not BlackBoard.loot_table[category].is_empty() else ""
	#if item_path.is_empty():
		#return
	#var item_resource: Resource = load(item_path)
	#var item_scene: Node = (item_resource as PackedScene).instantiate()
	#get_tree().current_scene.add_child(item_scene)
	#item_scene.global_position = _item_spawn_point.global_position + Vector3(0, 0.1, 0)


func interact() -> void:
	audio.play()
	if not _already_interacted:
		if _animation_player:
			_animation_player.play("interact")
		_already_interacted = true
		_spawn_item()
	else:
		_pick_intem()


func highlight() -> void:
	_notification_label.visible = true


func unhighlight() -> void:
	_notification_label.visible = false
