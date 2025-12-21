extends Area2D

@export var gravityStr: float = 1
@export var wellSize : float = 1
@export var colorKey : int = 0
@export var sibling : Node2D
var canTransport := true

var col = Color(Color.WHITE, .02)

func _ready() -> void:
	if sibling == null:
		print("Missing Sibling!!")
	scale = Vector2(wellSize,wellSize)
	match colorKey:
		1:
			$"GravityArea/GPUParticles2D".process_material.color = Color.BLUE
		2:
			$"GravityArea/GPUParticles2D".process_material.color = Color.RED
		_:
			pass

func _draw() -> void:
	draw_circle(Vector2.ZERO, 96 * wellSize, col)
	draw_circle(Vector2.ZERO, 48 * (.5 * wellSize), Color.BLACK)


func _on_area_entered(area: Area2D) -> void:
	var obj = area.get_parent()
	if obj.name == "ObjPlayer" and canTransport:
		obj.position = sibling.position
		obj.velocity *= 1.5
		sibling.canTransport = false
		self.canTransport = false
		$Timer.start()
		sibling.get_node("Timer").start()

func _on_timer_timeout() -> void:
	canTransport = true
