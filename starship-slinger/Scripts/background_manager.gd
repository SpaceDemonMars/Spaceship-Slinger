extends Node2D

@export var starCount : int = 10
@export var starSkewstr := .001
@export var skewSpeed = 600
var star := preload("res://Objects/obj_backgroundStar.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in starCount:
		var starInstance = star.instantiate()
		add_child(starInstance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var playerSpeed = $"../ObjPlayer".velocity.length()
	var playerDir = $"../ObjPlayer".velocity.angle()
	var stars = get_children()
	if playerSpeed >= skewSpeed:
		for s in stars:
			s.rotation = playerDir
			s.scale.x = playerSpeed * starSkewstr
	elif playerSpeed <= skewSpeed:
		for s in stars:
			s.rotation = 0
			s.scale = Vector2.ONE
