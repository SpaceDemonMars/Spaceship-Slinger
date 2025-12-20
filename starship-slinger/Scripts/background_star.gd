extends Node2D

var spawnRange = 256 + 128
@export var doRelocate := true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if doRelocate:
		var screen = get_viewport_rect()
		var newX = randf_range(screen.position.x,screen.end.x)
		var newY = randf_range(screen.position.y,screen.end.y)
		self.position = Vector2(newX,newY)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if doRelocate:
		var player = GameManager.activeLevel.player
		var playerDir = player.velocity.normalized()
		var playerPos = player.position
		var screen = get_viewport_rect()
		
		var newPosCenter = playerPos + playerDir * screen.size.x
		var newPos : Vector2
		newPos.x = randf_range(newPosCenter.x - spawnRange, newPosCenter.x + spawnRange)
		newPos.y = randf_range(newPosCenter.y - spawnRange, newPosCenter.y + spawnRange)
		
		position = newPos
		#print(newPos)
