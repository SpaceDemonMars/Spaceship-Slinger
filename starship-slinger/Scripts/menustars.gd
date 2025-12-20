extends Node2D

@export var numStars : int = 100
var star = preload("res://Objects/obj_shootingstar.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in numStars:
		var starInst = star.instantiate()
		add_child(starInst)
