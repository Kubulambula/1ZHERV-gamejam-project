extends Camera3D

@onready var player: Node3D = get_parent()
@onready var camera_offset: Vector3 = position

func _ready() -> void:
	top_level = true # do not inherit parent transform


func _process(_delta: float) -> void:
	global_position = player.global_position + camera_offset
