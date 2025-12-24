extends CanvasLayer


@onready var scoreValue := $Panel/ScoreValue #set +text
@onready var totalValue := $Panel/TotalValue #set text
@onready var bestScore := $Panel/Bestscore #set visible
@onready var highScore := $Panel/Highscore #set visible

@onready var timeInfo := $Panel/TimeInfo #set visible
@onready var expectedTime := $Panel/TimeInfo/ETime #set text
@onready var actualTime := $Panel/TimeInfo/ATime #set text
@onready var speedText := $Panel/TimeInfo/Speed #set visible/text/color

@export var fastClr : Color
@export var fastText : String
@export var slowClr : Color
@export var slowText : String


# score = score for delivery
func popupInit(isBScore : bool = false, isHScore : bool = false, 
	hasTimeInfo : bool = false, eTime : String = "", aTime : String = "",
	speed : int = GameManager.SpeedRating.NONE) -> void:
	GameManager.settingsOpen = true;
	#scores
	scoreValue.text = "+%d" % GameManager.levelScore 
	totalValue.text = "%d" % GameManager.totalScore 
	if (isBScore): bestScore.visible = true
	if (isHScore): highScore.visible = true
	#time
	if (hasTimeInfo):
		expectedTime.text = eTime
		actualTime.text = aTime
		if (speed == GameManager.SpeedRating.FAST):
			speedText.text = fastText
			speedText.set("theme_override_colors/font_color", fastClr)
			speedText.visible = true
		elif (speed == GameManager.SpeedRating.SLOW):
			speedText.text = slowText
			speedText.set("theme_override_colors/font_color", slowClr)
			speedText.visible = true
		timeInfo.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Settings")): closePopUp()

func closePopUp() -> void:
	GameManager.settingsOpen = false;
	get_tree().paused = GameManager.settingsOpen
	if (GameManager.selectedLevelIndex < GameManager.allLevels.size() - 1):
		GameManager.selectedLevelIndex += 1
		GameManager.goToSelectedLevel() 
	else:
		GameManager.selectedLevelIndex = 0
		GameManager.goToCredits()
	queue_free() 	


func _on_button_pressed() -> void:
	closePopUp() # Replace with function body.
