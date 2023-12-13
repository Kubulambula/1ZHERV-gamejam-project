extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != BlackBoard.player:
		return
	
	BlackBoard.timer.stop()
	if BlackBoard.current_level == 1 or BlackBoard.current_level == 0: # if in debug
		BlackBoard.end_level()
		#BlackBoard.start_level_2.call_deferred()
	elif BlackBoard.current_level == 2:
		BlackBoard.end_level()
		#BlackBoard.start_level_3.call_deferred()
	elif BlackBoard.current_level == 3:
		BlackBoard.end_level()
		#print("konec")
