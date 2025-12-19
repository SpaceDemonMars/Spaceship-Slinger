extends Node

@export var LevelScene : PackedScene
@export var ExpectedCompletionTime : float
@export var MaxCompletionTime : float
var backgroundManager: PackedScene = preload("res://Objects/obj_backgroundManager.tscn")

func _ready():
	var lvl = LevelScene.instantiate() as Node2D
	add_child(lvl)
	var bm = backgroundManager.instantiate() as Node2D
	lvl.add_child(bm)
