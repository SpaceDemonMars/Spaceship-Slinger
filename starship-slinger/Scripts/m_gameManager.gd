extends Node

#player variables
var player: PackedScene = preload("res://Objects/obj_player.tscn")
var ship : PackedScene = preload("res://Scenes/ss_starter.tscn") 

#menu variables
var isTimePaused := false
@onready var gameTimer := 55.0
var mainMenu: PackedScene = preload("res://Scenes/main_menu.tscn")
var settingsMenu: PackedScene = preload("res://Scenes/settings_menu.tscn")
#win/lose screens
var isInMenu: bool = false
var settingsOpen: bool = false
#audio
var masterVol: float = 0
var bgmVol: float = 0
var sfxVol: float = 0

#level variables
#THIS IS TEMPORARILY HARDCODED
#we could do totalScore = sum(score = expectedTime/actualTime)
var highScore: int = 0
var activeLevel
var levelsFolder := "res://Levels/"
var playLevel
var allLevels : Array[PackedScene] = []


func _ready():
	load_levels()
	#load level
	activeLevel = mainMenu.instantiate() as Node
	add_child(activeLevel)
	isInMenu = true
	#sync hud
	#activeLevel.lvl.hud.setTimer(gameTimer)

func _process(delta: float) -> void:
	if (!isInMenu):
		gameTimer += delta
		activeLevel.hud.setTimer(gameTimer)
		

func sync_hud():
		activeLevel.hud.setTimer(gameTimer)
		activeLevel.hud.setFuel(activeLevel.player.fuelCurrent)
	

func load_levels():
	var folder = DirAccess.open(levelsFolder)
	if folder:
		folder.list_dir_begin()
		var file_name = folder.get_next()
		while file_name != "":
			# Check for scene file extensions
			if file_name.ends_with(".tscn") or file_name.ends_with(".scn"):
				var full_path = levelsFolder + file_name
				# Use ResourceLoader.load to load the scene dynamically
				var packed_scene: PackedScene = ResourceLoader.load(full_path)
				if packed_scene:
					allLevels.append(packed_scene)
			file_name = folder.get_next()
		folder.list_dir_end()
		
