extends Area2D

@export var boostStr : float = 500

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "ObjPlayer":
		var addedSpeed = Vector2.UP.rotated(rotation) * boostStr
		print(addedSpeed)
		area.get_parent().velocity += addedSpeed
