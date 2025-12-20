extends Control


var playScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Highscore.text = 'Highscore: ' + str(GameManager.highScore)
	playScene = GameManager.allLevels[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Settings") and !GameManager.settingsOpen): openSettingsMenu()
	$Settings.visible = !GameManager.settingsOpen
	$Play.visible = !GameManager.settingsOpen

func change_scene():
	#currently defaults to dev_testing, change this in final
	GameManager.activeLevel = playScene.instantiate() as Node2D
	get_parent().add_child(GameManager.activeLevel)
	queue_free()

func openSettingsMenu() ->void:
	var settings = GameManager.settingsMenu.instantiate() as Control
	add_child(settings)	

func _on_play_pressed() -> void:
	call_deferred("change_scene") # Replace with function body.
func _on_settings_pressed() -> void:
	if (!GameManager.settingsOpen) : 
		openSettingsMenu()
