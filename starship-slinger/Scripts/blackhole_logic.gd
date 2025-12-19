extends Area2D

@export var gravityStr: float = 1
@export var wellSize : float = 1

var col = Color(Color.WHITE, .02)

func _ready() -> void:
	$GravityArea.scale = Vector2(wellSize,wellSize)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 96 * wellSize, col)
	draw_circle(Vector2.ZERO, 48 * (.5 * wellSize), Color.BLACK)
