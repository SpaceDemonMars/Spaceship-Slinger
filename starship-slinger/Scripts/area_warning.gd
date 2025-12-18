extends Node2D

var symbols
var active = true
var setup = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var angle = 0
	symbols = get_children()
	for s in symbols:
		s.position += Vector2.RIGHT.rotated(deg_to_rad(angle)) * 128
		angle += 120
		s.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if active:
		rotation += 1 * delta
		for s in symbols:
			if setup:
				s.visible = true
			s.rotation = -self.rotation - get_parent().rotation
		setup = false
	else:
		for s in symbols:
			if setup:
				s.visible = false
		setup = false

func activate():
	active = !active
	setup = true
