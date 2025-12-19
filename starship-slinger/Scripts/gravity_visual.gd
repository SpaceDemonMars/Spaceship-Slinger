extends Area2D

var col = Color(Color.WHITE, .02)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 48, col)
