extends CharacterBody2D

var screen
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport_rect()
	setup_speeds()
	location_change()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	move_and_slide()

func setup_speeds() -> void:
	rotation = randi() % 360
	var speed = randi_range(200, 400)
	velocity = Vector2.RIGHT.rotated(rotation) * speed

func location_change() -> void:
	var center = screen.position - screen.size
	center = center.rotated(rotation + 45)
	
	position = Vector2(randf_range(center.x - screen.size.x,center.x + screen.size.x),randf_range(center.y - screen.size.y,center.y + screen.size.y))



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	location_change()
	$Timer.start()

func _on_timer_timeout() -> void:
	print("Shooting star timeout")
	location_change()
	$Timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Timer.stop()
