extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.settingsOpen = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Settings")): closeSettingsMenu()

func closeSettingsMenu() -> void:
	GameManager.settingsOpen = false;
	get_tree().paused = GameManager.settingsOpen
	queue_free() 	
