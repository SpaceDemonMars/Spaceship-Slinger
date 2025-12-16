extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen = get_viewport_rect()
	var newX = randf_range(screen.position.x,screen.end.x)
	var newY = randf_range(screen.position.y,screen.end.y)
	self.position = Vector2(newX,newY)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
