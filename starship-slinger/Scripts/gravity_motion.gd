extends CharacterBody2D

@export var gravityStr: float = 1
@export var gravityEffected := true #If moved by gravity
@export var startingSpeed : float = 0		#if it starts with some motion
@export var startingDir : float = 0 
@export var wellSize : float = 1 #size of an aoe the gravity on this object
@export var objWeight : float = 1

var gravityHomeList: Array[Node2D]
var gravityStrList: Array[float]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if startingSpeed > 0:
		print("Speed set")
		self.velocity = Vector2.RIGHT
		self.velocity = self.velocity.rotated(deg_to_rad(startingDir)) * startingSpeed
	
	$GravityArea.scale = Vector2(wellSize,wellSize)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if gravityEffected:
		var gravityEffect := Vector2.ZERO
		for g in gravityStrList.size():
			var curGravStr = gravityStrList[g]
			var curGravPos = gravityHomeList[g].position
			var curGravVec = (curGravPos - self.position).normalized()
			gravityEffect += curGravVec * curGravStr
		self.velocity += gravityEffect / objWeight
		#print(velocity)
		
	move_and_slide()

func _on_gravity_area_area_entered(area: Area2D) -> void:
	if gravityEffected and area.name == "GravityArea":
		gravityStrList.append(area.get_parent().gravityStr)
		gravityHomeList.append(area.get_parent())

func _on_gravity_area_area_exited(area: Area2D) -> void:
	if gravityEffected and area.name == "GravityArea":
		var gravityHomeSearch = area.get_parent().position
		for g in gravityHomeList.size():
			if gravityHomeList[g].position == gravityHomeSearch:
				gravityHomeList.remove_at(g)
				gravityStrList.remove_at(g)
				break;
