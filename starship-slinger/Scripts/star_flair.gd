extends Sprite2D

var growthDir := 1
@export var growthAmnt := 0.1
@export var scaleMax := 1.1
@export var scaleMin := .95
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if scale.x > scaleMax:
		growthDir = -1
	elif scale.x < scaleMin:
		growthDir = 1
		
	scale.x += growthAmnt * growthDir * delta
	scale.y += growthAmnt * growthDir * delta
