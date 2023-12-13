extends CanvasLayer

signal done


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BlackBoard.phone_canvas = self


func say(what: String, for_how_long: int) -> void:
	$Phone/RichTextLabel.text = what
	$AnimationPlayer.play("swipe")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(for_how_long).timeout
	$AnimationPlayer.play_backwards("swipe")
	await $AnimationPlayer.animation_finished
	done.emit()
