extends CanvasLayer


@onready var scoreValue := $Panel/ScoreValue #set text
@onready var highScore := $Panel/Highscore #set visible

@onready var lossInfo := $Panel/LossInfo
@onready var causeLabel := $Panel/LossInfo/Info #set text

var causeText := ["", 
	"Ship Destroyed...", 
	"Exceeded Time Limit...",
	"Out of Fuel..."]

# score = score for delivery
func popupInit(isHScore : bool = false, cause : int = GameManager.LossCause.NONE) -> void:
	GameManager.settingsOpen = true;
	#scores
	scoreValue.text = "%d" % GameManager.totalScore 
	if (isHScore): highScore.visible = true
	#time
	if (cause != GameManager.LossCause.NONE):
		causeLabel.text = causeText[cause]
		lossInfo.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Settings")): closePopUp()

func closePopUp() -> void:
	GameManager.settingsOpen = false;
	get_tree().paused = GameManager.settingsOpen
	GameManager.gameTimer = 0.0
	#TODO: make this send u to main menu
	queue_free() 	


func _on_button_pressed() -> void:
	closePopUp() # Replace with function body.
