extends TextureProgressBar

@export var player: CharacterBody3D

func _process(delta: float) -> void:
	value = player.player_sus
