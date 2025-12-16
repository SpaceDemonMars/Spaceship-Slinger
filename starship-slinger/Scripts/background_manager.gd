extends Node2D

@export var starCount : int = 10
var star := preload("res://Objects/obj_backgroundStar.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in starCount:
		var starInstance = star.instantiate()
		add_child(starInstance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
