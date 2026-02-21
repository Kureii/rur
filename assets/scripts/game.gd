extends Node3D

func _on_try_again_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	get_tree().quit()
