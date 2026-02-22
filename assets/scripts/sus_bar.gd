extends TextureProgressBar

@export var player: RigidBody3D

func _process(delta: float) -> void:
	value = player.player_sus
