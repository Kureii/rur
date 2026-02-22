extends Control



func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/core_scenes/prolog.tscn")


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
