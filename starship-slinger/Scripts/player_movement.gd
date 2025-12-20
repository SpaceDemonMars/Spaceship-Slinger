extends CharacterBody2D

var shipAccel		#How much the ship accelerates every physics frame while thrusting
var shipTurnRate	
var fuelTotal
var fuelCurrent
var fuelLoss
var health
@onready var shipAsset = $Sprite2D
var GameplayHud #move this to gameManager when made


var gravityStr = 0 #So that planets are not effected by the ship's gravity
var gravityHomeList: Array[Node2D]
var gravityStrList: Array[float]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	getShipStats()
	
	GameplayHud = GameManager.activeLevel.hud
	
	if GameplayHud :
		GameplayHud.init_fuel(fuelTotal)
		GameplayHud.init_HP()
	
	


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

func takeDamage(dmg : int = 1):
	health -= dmg
	GameManager.activeLevel.hud.setHP()	
	if health <= 0:
		pass
	

func getShipStats():
	var shipStats = GameManager.ship.instantiate() as Node
	add_child(shipStats)
	shipAccel = shipStats.acceleration
	shipTurnRate = shipStats.turnSpeed
	fuelTotal = shipStats.maxFuel
	fuelLoss = shipStats.fuelUseRate
	fuelCurrent = fuelTotal
	health = shipStats.health
	GameManager.activeLevel.hud.setHP()
	shipAsset.texture = shipStats.shipAsset
	shipStats.queue_free()
	


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
