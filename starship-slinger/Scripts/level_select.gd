extends CanvasLayer

@onready var buttons = $ColorRect/LevelList
@onready var baseButton = preload("res://Scenes/level_select_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.settingsOpen = true
	var buttonGap = 2
	var listHeight = buttons.size.y - (GameManager.allLevels.size() -1) * buttonGap
	var buttonSize = listHeight / GameManager.allLevels.size()
	var test = "\n%f" % buttonSize + " = %f" % buttons.size.y + " / %f" %  GameManager.allLevels.size()
	print(test)
	var index = 0
	while index <= GameManager.unlockedLevelIndex:
		var buttonPos = (buttonSize * index) + (buttonGap * index)
		var newButton = baseButton.instantiate() as Button
		newButton.size.y = buttonSize
		newButton.position.y = buttonPos
		newButton.levelIndex = index
		newButton.text = "Level %d" % (index + 1) 
		buttons.add_child(newButton)
		newButton.size.y = buttonSize
		index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Settings")): close()

func close() -> void:
	GameManager.settingsOpen = false;
	get_tree().paused = GameManager.settingsOpen
	GameManager.saveGame()
	GameManager.goToMainMenu()
	queue_free() 	
