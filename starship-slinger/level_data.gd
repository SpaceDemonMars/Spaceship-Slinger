extends Node

#GAME MANAGER NODE ACCESS
#var lvl
var player
var bgMan
var hud
var goalPos

#@export var LevelObjects : PackedScene
@export var playerStartPos : Vector2
@export var goalValue := 100
var hasExpectedTime : bool
@export var ExpectedCompletionTime : float
var hasMaxTime : bool
@export var MaxCompletionTime : float
#scoring margin is seconds +/- the expected time to give the fast/normal/slow ratings
@export var scoringMargin : float 
var playerScene: PackedScene = preload("res://Objects/obj_player.tscn")
var backgroundManager: PackedScene = preload("res://Objects/obj_backgroundManager.tscn")
var gameplayHud: PackedScene = preload("res://Scenes/gameplay_hud.tscn")

var debugMode := true
var debugHud: PackedScene = preload("res://Scenes/debug_hud.tscn")


func _ready():
	GameManager.gameTimer = 0.0
	hasExpectedTime = ExpectedCompletionTime > 0.0
	hasMaxTime = MaxCompletionTime > 0.0
	
	hud = gameplayHud.instantiate() as CanvasLayer
	add_child(hud)
	
	player = playerScene.instantiate() as CharacterBody2D
	player.position = playerStartPos
	add_child(player)
	
	bgMan = backgroundManager.instantiate() as Node2D
	add_child(bgMan)
	
	goalPos = get_node("ObjDestination").position
	
	if (debugMode):
		var dbHud = debugHud.instantiate() as CanvasLayer
		add_child(dbHud)
		
	GameManager.isInMenu = false
