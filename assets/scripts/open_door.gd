extends MeshInstance3D

@export var slide_distance: float = 2.2
@export var slide_duration: float = 1.5

var _tween: Tween

func _on_open_door() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position:x", position.x + slide_distance, slide_duration)
