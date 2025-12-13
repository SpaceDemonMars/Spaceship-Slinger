extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.settingsOpen = true;
	#grab saved settings
	setLabel($ColorRect/MasterVolume/label, 'Master Volume', Global.masterVol)
	setSlider($ColorRect/MasterVolume/HSlider, Global.masterVol)
	setLabel($ColorRect/BackgroundMusic/label, 'Background Music', Global.bgmVol)
	setSlider($ColorRect/BackgroundMusic/HSlider, Global.bgmVol)
	setLabel($ColorRect/SFXVolume/label, 'SFX Volume', Global.sfxVol)
	setSlider($ColorRect/SFXVolume/HSlider, Global.sfxVol)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Settings")): closeSettingsMenu()

func setLabel(label: Label, name: String, value: float) -> void:
	label.text = name + ': ' + str(int(value))
func setSlider(slider: HSlider, value: float) -> void:
	slider.value = value


func _on_masterVolume_slider_value_changed(value: float) -> void:
	Global.masterVol = value
	setLabel($ColorRect/MasterVolume/label, 'Master Volume', Global.masterVol)
func _on_backgroundMusic_slider_value_changed(value: float) -> void:
	Global.bgmVol = value
	setLabel($ColorRect/BackgroundMusic/label, 'Background Music', Global.bgmVol)
func _on_sfxVolume_slider_value_changed(value: float) -> void:
	Global.sfxVol = value
	setLabel($ColorRect/SFXVolume/label, 'SFX Volume', Global.sfxVol)

func closeSettingsMenu() -> void:
	Global.settingsOpen = false;
	queue_free() 	

func _on_close_pressed() -> void:
	closeSettingsMenu()
func _on_abandon_pressed() -> void:
	#end current run
	closeSettingsMenu()
