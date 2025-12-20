extends Node

#player variables
var player: PackedScene = preload("res://Objects/obj_player.tscn")
var ship : PackedScene = preload("res://Scenes/ss_starter.tscn") 

#menu variables
@onready var gameTimer := 0.0
var mainMenu: PackedScene = preload("res://Scenes/main_menu.tscn")
var settingsMenu: PackedScene = preload("res://Scenes/settings_menu.tscn")
var winScreen: PackedScene = preload("res://Scenes/win_screen.tscn")
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
var totalScore: int = 0 #cumulative 
var highScore: int = 0 #best ^ (without save/load this will always be totalScore)
var levelScore: int = 0 # get this from active level data
var bestScore: int = 0 #best level score
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
	get_tree().paused = settingsOpen
	if (Input.is_action_just_pressed("Settings") and !settingsOpen): openSettingsMenu()
	if (!settingsOpen and !isInMenu):
		gameTimer += delta
		activeLevel.hud.setTimer(gameTimer)
		

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
		

func openSettingsMenu() ->void:
	var settings = settingsMenu.instantiate() as CanvasLayer
	add_child(settings)	

func destinationEntered():
	var win = winScreen.instantiate() as CanvasLayer
	levelScore = (randi() % 20) + 1 #TODO: get this from level data/calculate bonus
	totalScore += levelScore
	activeLevel.hud.setScore()
	add_child(win)
	win.popupInit(checkBestScore(), checkHighScore(),
		true, utilConvertTimetoString(30.0), utilConvertTimetoString(gameTimer), 2)
	#TODO: get time info from lvl data 			#TODO: find way to rate completion time
	

func checkBestScore() -> bool:
	if (levelScore > bestScore) : 
		bestScore = levelScore
		return true
	return false
func checkHighScore() -> bool:
	if (totalScore > highScore) : 
		highScore = totalScore
		return true
	return false

func utilConvertTimetoString(time: float) -> String:
	@warning_ignore("integer_division")
	var minutes := int(time)/60 
	time -= (60*minutes)
	var m = "%d" % minutes
	var s = "%.2f" % time
	return m + ':' + s
	
func playerCrashed():
	activeLevel.player.takeDamage()
