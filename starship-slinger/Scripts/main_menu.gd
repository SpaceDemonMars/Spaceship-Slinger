extends Control


@onready var settingsButton = $Settings
@onready var levelButton  = $Level
@onready var playButton = $Play
@onready var creditsButton = $Credits
@onready var highScore = $Highscore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levelButton.text = "Level %d" % (GameManager.selectedLevelIndex + 1) 
	if (GameManager.highScore > 0) :
		highScore.text = 'Highscore: ' + str(GameManager.highScore)
	else : highScore.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	settingsButton.visible = !GameManager.settingsOpen
	playButton.visible = !GameManager.settingsOpen
	creditsButton.visible = !GameManager.settingsOpen

func change_scene():
	GameManager.goToSelectedLevel()

func _on_play_pressed() -> void:
	call_deferred("change_scene") # Replace with function body.
func _on_settings_pressed() -> void:
	if (!GameManager.settingsOpen) : 
		GameManager.openSettingsMenu()
func _on_level_pressed() -> void:
	GameManager.openLevelSelect()
func _on_credits_pressed() -> void:
	GameManager.goToCredits()
