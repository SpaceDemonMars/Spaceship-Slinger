extends CharacterBody2D

var shipAccel = 10		#How much the ship accelerates every physics frame while thrusting
var shipTurnRate = 5	
var fuelTotal = 100
var fuelCurrent = fuelTotal
var fuelLoss = 5
@onready var GameplayHud = $"../GameplayHud" #move this to gameManager when made


var gravityStr = 0 #So that planets are not effected by the ship's gravity
var gravityHomeList: Array[Node2D]
var gravityStrList: Array[float]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameplayHud :
		GameplayHud.init_fuel(fuelTotal)


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	#Turning
	var turnDir = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	if turnDir != 0:
		rotate(turnDir * shipTurnRate * delta)
	
	#Forward motion
	var inputVec : Vector2
	if fuelCurrent > 0 and Input.is_action_pressed("Thruster"):
		inputVec = Vector2(0, Input.get_axis("ThrustForward","ThrustBackwards"))
		self.velocity += inputVec.rotated(rotation) * shipAccel
		fuelCurrent -= fuelLoss * delta
		if GameplayHud :
			GameplayHud.setFuel(fuelCurrent)
	
	#Space friction and gravity from planets
	var gravityEffect := Vector2.ZERO
	for g in gravityStrList.size():
		var curGravStr = gravityStrList[g]
		var curGravPos = gravityHomeList[g].position
		var curGravVec = (curGravPos - self.position).normalized()
		gravityEffect += curGravVec * curGravStr
	velocity += gravityEffect
	
	if inputVec.y == 0 && gravityEffect == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, 0.5)
	
	move_and_slide()


func _on_gravity_area_area_entered(area: Area2D) -> void:
	if area.name == "GravityArea":
		gravityStrList.append(area.get_parent().gravityStr)
		gravityHomeList.append(area.get_parent())


func _on_gravity_area_area_exited(area: Area2D) -> void:
	if area.name == "GravityArea":
		var gravityHomeSearch = area.get_parent().position
		for g in gravityHomeList.size():
			if gravityHomeList[g].position == gravityHomeSearch:
				gravityHomeList.remove_at(g)
				gravityStrList.remove_at(g)
				break;
