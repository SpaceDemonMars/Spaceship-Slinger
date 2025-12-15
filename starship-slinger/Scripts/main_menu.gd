extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Highscore.text = 'Highscore: ' + str(Global.highScore)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Settings") and !Global.settingsOpen): openSettingsMenu()
	$Settings.visible = !Global.settingsOpen
	$Play.visible = !Global.settingsOpen

func change_scene():
	#currently defaults to dev_testing, change this in final
	get_tree().change_scene_to_file("res://Scenes/dev_testing.tscn")

func openSettingsMenu() ->void:
	var settings = Global.settingsMenu.instantiate() as Control
	add_child(settings)	

func _on_play_pressed() -> void:
	call_deferred("change_scene") # Replace with function body.
func _on_settings_pressed() -> void:
	if (!Global.settingsOpen) : 
		openSettingsMenu()
