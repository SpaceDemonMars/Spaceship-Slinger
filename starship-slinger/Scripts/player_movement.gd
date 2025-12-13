extends CharacterBody2D

var shipAccel = 10		#How much the ship accelerates every physics frame while thrusting
var shipTurnRate = 5	#
var fuelTotal = 1000000000
var fuelLoss = 5
var inputVec : Vector2

var gravityHomeList: Array[Vector2]
var gravityStrList: Array[float]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	#Turning
	var turnDir = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	if turnDir != 0:
		rotate(turnDir * shipTurnRate * delta)
	
	#Forward motion
	if fuelTotal > 0 and Input.is_action_pressed("Thruster"):
		inputVec = Vector2(0, Input.get_axis("ThrustForward","ThrustBackwards"))
		self.velocity += inputVec.rotated(rotation) * shipAccel
		fuelTotal -= fuelLoss
	
	#Space friction and gravity from planets
	
	var gravityEffect := Vector2.ZERO
	for g in gravityStrList.size():
		var curGravStr = gravityStrList[g]
		var curGravPos = gravityHomeList[g]
		var curGravVec = (curGravPos - self.position).normalized()
		gravityEffect += curGravVec * curGravStr
	velocity = velocity + gravityEffect
	
	if inputVec.y == 0 && gravityEffect != Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, 4)
	
	move_and_slide()


func _on_gravity_area_area_entered(area: Area2D) -> void:
	if area.name == "GravityArea":
		gravityStrList.append(area.get_parent().gravityStr)
		gravityHomeList.append(area.get_parent().position)
