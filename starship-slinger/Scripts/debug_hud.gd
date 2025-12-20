extends CanvasLayer

var player : CharacterBody2D
var startPos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = GameManager.activeLevel.player # Replace with function body.
	startPos = GameManager.activeLevel.playerStartPos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("DebugHud")) : visible = !visible
	
	var x = "%.2f" % player.position.x
	var y = "%.2f" % player.position.y
	var vx = "%.2f" % player.velocity.x
	var vy = "%.2f" % player.velocity.y
	$Pos.text = 'Position: ( ' +  x + ', ' + y + ')'
	$Velocity.text = 'Velocity: ( ' +  vx + ', ' + vy + ')'


func _on_reset_pressed() -> void:
	player.velocity = Vector2.ZERO
	player.position = startPos
