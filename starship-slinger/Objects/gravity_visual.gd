extends Area2D

var obj
var col

func _ready() -> void:
	obj = get_parent()
	col = Color(Color.WHITE, .02)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 48, col)
