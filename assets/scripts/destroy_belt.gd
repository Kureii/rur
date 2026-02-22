extends MeshInstance3D

@export var slide_distance: float = 2.2
@export var slide_duration: float = 1.5

var _tween: Tween
signal destroy

func _on_takeble__emplace_item() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	_tween.tween_property(self, "position:x", position.x + slide_distance, slide_duration)
	_tween.tween_callback(destroy.emit)
