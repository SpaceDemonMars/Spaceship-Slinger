extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.settingsOpen = true;
	#grab saved settings
	setLabel($ColorRect/MasterVolume/label, 'Master Volume', GameManager.masterVol)
	setSlider($ColorRect/MasterVolume/HSlider, GameManager.masterVol)
	setLabel($ColorRect/BackgroundMusic/label, 'Background Music', GameManager.bgmVol)
	setSlider($ColorRect/BackgroundMusic/HSlider, GameManager.bgmVol)
	setLabel($ColorRect/SFXVolume/label, 'SFX Volume', GameManager.sfxVol)
	setSlider($ColorRect/SFXVolume/HSlider, GameManager.sfxVol)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Settings")): closeSettingsMenu()

func setLabel(label: Label, lText: String, value: float) -> void:
	label.text = lText + ': ' + str(int(value))
func setSlider(slider: HSlider, value: float) -> void:
	slider.value = value


func _on_masterVolume_slider_value_changed(value: float) -> void:
	GameManager.masterVol = value
	setLabel($ColorRect/MasterVolume/label, 'Master Volume', GameManager.masterVol)
func _on_backgroundMusic_slider_value_changed(value: float) -> void:
	GameManager.bgmVol = value
	setLabel($ColorRect/BackgroundMusic/label, 'Background Music', GameManager.bgmVol)
func _on_sfxVolume_slider_value_changed(value: float) -> void:
	GameManager.sfxVol = value
	setLabel($ColorRect/SFXVolume/label, 'SFX Volume', GameManager.sfxVol)

func closeSettingsMenu() -> void:
	GameManager.settingsOpen = false;
	get_tree().paused = GameManager.settingsOpen
	queue_free() 	

func _on_close_pressed() -> void:
	closeSettingsMenu()
func _on_abandon_pressed() -> void:
	#end current run
	closeSettingsMenu()
