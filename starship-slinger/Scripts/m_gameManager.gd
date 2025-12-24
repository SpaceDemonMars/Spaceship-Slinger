extends Node

#default save data
var defaultSaveData = {
	"High Score": 0,
	"Best Score": 0,
	"Selected Level Index" : 0,
	"Unlocked Level Index" : 0,
	"Master Volume": 10,
	"Background Music Volume": 10,
	"SFX Volume": 50
}

#player variables
var player: PackedScene = preload("res://Objects/obj_player.tscn")
var ship : PackedScene = preload("res://Scenes/ss_starter.tscn") 

#menu variables
@onready var gameTimer := 0.0
var mainMenu: PackedScene = preload("res://Scenes/main_menu.tscn")
var settingsMenu: PackedScene = preload("res://Scenes/settings_menu.tscn")
var levelSelect: PackedScene = preload("res://Scenes/level_select.tscn")
var information: PackedScene = preload("res://Scenes/tutorial.tscn")
var winScreen: PackedScene = preload("res://Scenes/win_screen.tscn")
var loseScreen: PackedScene = preload("res://Scenes/lose_screen.tscn")
var creditsScreen: PackedScene = preload("res://Scenes/credits_screen.tscn")

var isInMenu: bool = false
var settingsOpen: bool = false
#audio
var masterVol: float = defaultSaveData["Master Volume"]
var bgmVol: float = defaultSaveData["Background Music Volume"]
var bgmLoad = preload("res://Scenes/bgm_player.tscn")
var bgmPlayer
var sfxVol: float = defaultSaveData["SFX Volume"]
var sfxLoad = preload("res://Scenes/sfx_player.tscn")
var sfxPlayer

#level variables
var totalScore: int = 0 #cumulative 
var highScore: int = defaultSaveData["High Score"]
var levelScore: int = 0 # get this from active level data
var bestScore: int = defaultSaveData["Best Score"] #best level score

var selectedLevel : PackedScene
var activeLevel #nodes only
#IF I AM ASLEEP WHEN YOU MERGE YOUR LEVELS, UNCOMMENT THE FILEPATH BELOW
var levelsFolder := "res://Levels/"
var selectedLevelIndex : int = defaultSaveData["Selected Level Index"]
var allLevels : Array[PackedScene] = []
var unlockedLevelIndex: int = defaultSaveData["Unlocked Level Index"]


func _ready():
	bgmPlayer = bgmLoad.instantiate() as AudioStreamPlayer
	add_child(bgmPlayer)
	sfxPlayer = sfxLoad.instantiate() as AudioStreamPlayer
	add_child(sfxPlayer)
	loadGame()
	load_levels()
	#load level
	selectedLevel = allLevels[selectedLevelIndex]
	goToMainMenu()

func _process(delta: float) -> void:
	get_tree().paused = settingsOpen
	if (Input.is_action_just_pressed("Settings") and !settingsOpen): openSettingsMenu()
	if (!settingsOpen and !isInMenu):
		gameTimer += delta 
		if (activeLevel.hasMaxTime): 
			activeLevel.hud.setTimer(activeLevel.MaxCompletionTime - gameTimer)
			checkMaxTime()
		else:
			activeLevel.hud.setTimer(gameTimer)


func openSettingsMenu() ->void:
	var settings = settingsMenu.instantiate() as CanvasLayer
	add_child(settings)	
func openLevelSelect() ->void:
	var settings = levelSelect.instantiate() as CanvasLayer
	add_child(settings)	
func openInfoBoard():
	var info = information.instantiate() as CanvasLayer
	add_child(info)

func destinationEntered():
	var win = winScreen.instantiate() as CanvasLayer
	var speedScore = calculateScore()
	totalScore += levelScore
	activeLevel.hud.setScore()
	add_child(win)
	win.popupInit(checkBestScore(), checkHighScore(),
		true, utilConvertTimetoString(activeLevel.ExpectedCompletionTime), 
		utilConvertTimetoString(gameTimer), speedScore)
	#TODO: get time info from lvl data 			#TODO: find way to rate completion time
	saveGame()
	

enum SpeedRating {
	SLOW  = 0,
	NONE = 1,
	FAST = 2 }
func calculateScore() -> int:
	var retVal := SpeedRating.NONE
	if (!activeLevel.hasExpectedTime): 
		levelScore = activeLevel.goalValue
	else:
		if (gameTimer <= (activeLevel.ExpectedCompletionTime - activeLevel.scoringMargin)):
			retVal = SpeedRating.FAST
		elif (gameTimer >= (activeLevel.ExpectedCompletionTime + activeLevel.scoringMargin)):
			retVal = SpeedRating.SLOW
		var speedBonus = activeLevel.goalValue * retVal
		levelScore = (activeLevel.goalValue + speedBonus) * (activeLevel.ExpectedCompletionTime/gameTimer)
	return retVal

func checkBestScore() -> bool:
	if (levelScore > bestScore and levelScore != 0) : 
		bestScore = levelScore
		return true
	return false
func checkHighScore() -> bool:
	if (totalScore >= highScore and totalScore != 0) : 
		highScore = totalScore
		return true
	return false
func checkMaxTime():
	if (gameTimer >= activeLevel.MaxCompletionTime):
		playerLost(LossCause.SLOW)

func utilConvertTimetoString(time: float) -> String:
	@warning_ignore("integer_division")
	var minutes := int(time)/60 
	time -= (60*minutes)
	var m = "%d" % minutes
	var s = "%.2f" % time
	return m + ':' + s

func playerCrashed():
	activeLevel.player.takeDamage()

enum LossCause {
	NONE  = 0,
	DEATH = 1,
	SLOW = 2,
	SOFTLOCK = 3,
	ABANDONED = 4 }
func playerLost(cause : int = LossCause.NONE):
	var lose = loseScreen.instantiate() as CanvasLayer
	sfxPlayer.play()
	add_child(lose)
	lose.popupInit(checkHighScore(), cause)
	saveGame()


func goToMainMenu():	
	var menu = mainMenu.instantiate() as Node
	if (activeLevel): activeLevel.queue_free()
	activeLevel = menu
	add_child(activeLevel)
	levelScore = 0
	totalScore = 0
	isInMenu = true
func goToSelectedLevel():
	if (selectedLevelIndex >= allLevels.size()):
		selectedLevelIndex -= 1
		goToSelectedLevel()
	else:
		selectedLevel = allLevels[selectedLevelIndex]
		if (selectedLevelIndex > unlockedLevelIndex) : unlockedLevelIndex = selectedLevelIndex
		restartLevel()
func goToCredits():
	var credits = creditsScreen.instantiate() as Node
	if (activeLevel): activeLevel.queue_free()
	activeLevel = credits
	add_child(activeLevel)
	levelScore = 0
	totalScore = 0
	isInMenu = true

func restartLevel():
	var levelReload = selectedLevel.instantiate() as Node
	if (activeLevel): activeLevel.queue_free()
	activeLevel = levelReload
	add_child(activeLevel)
	

func updateBGMVolume():
	var scaledVolume = (bgmVol/100.0 * masterVol/100.0)
	bgmPlayer.volume_linear = scaledVolume
func updateSFXVolume():
	var scaledVolume = (sfxVol/100.0 * masterVol/100.0)
	sfxPlayer.volume_linear = scaledVolume
	pass

#save/load
@onready var saveDataPath := "user://saveData.save"
func saveGame(saveDefaults : Dictionary = {}):
	var saveFile = FileAccess.open(saveDataPath, FileAccess.WRITE)
	var saveData = {
		"High Score": highScore,
		"Best Score": bestScore,
		"Selected Level Index" : selectedLevelIndex,
		"Unlocked Level Index" : unlockedLevelIndex,
		"Master Volume": masterVol,
		"Background Music Volume": bgmVol,
		"SFX Volume": sfxVol
	} if (saveDefaults.is_empty()) else saveDefaults
	var jsonString = JSON.stringify(saveData)
	saveFile.store_line(jsonString)

func loadGame():
	if !FileAccess.file_exists(saveDataPath) : return #file DNE
	
	var saveFile = FileAccess.open(saveDataPath, FileAccess.READ)
	#we'd need this line if our save data was more than one dictionary
	#while saveFile.get_position() < saveFile.get_length(): 
	var jsonString = saveFile.get_line()
	var loadData = JSON.parse_string(jsonString)
	
	highScore = loadData["High Score"]
	bestScore = loadData["Best Score"]
	selectedLevelIndex = loadData["Selected Level Index"]
	unlockedLevelIndex = loadData["Unlocked Level Index"]
	masterVol = loadData["Master Volume"]
	bgmVol = loadData["Background Music Volume"]
	sfxVol = loadData["SFX Volume"]
	
	updateBGMVolume()
	updateSFXVolume()

func load_levels():
	if (!allLevels.is_empty()): allLevels.clear()
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
