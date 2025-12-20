extends Node

#GAME MANAGER NODE ACCESS
#var lvl
var player
var bgMan
var hud

#@export var LevelObjects : PackedScene
@export var playerStartPos : Vector2
@export var ExpectedCompletionTime : float
@export var MaxCompletionTime : float
var playerScene: PackedScene = preload("res://Objects/obj_player.tscn")
var backgroundManager: PackedScene = preload("res://Objects/obj_backgroundManager.tscn")
var gameplayHud: PackedScene = preload("res://Scenes/gameplay_hud.tscn")

var debugMode := true
var debugHud: PackedScene = preload("res://Scenes/debug_hud.tscn")


func _ready():
	hud = gameplayHud.instantiate() as CanvasLayer
	add_child(hud)
	
	player = playerScene.instantiate() as CharacterBody2D
	player.position = playerStartPos
	add_child(player)
	
	bgMan = backgroundManager.instantiate() as Node2D
	add_child(bgMan)
	
	if (debugMode):
		var dbHud = debugHud.instantiate() as CanvasLayer
		add_child(dbHud)
		
	GameManager.isInMenu = false
