extends Area2D

func _ready() -> void:
	var dest = randi() % 7
	match dest:
		0:
			$Sprite2D.texture = load("res://Assets/Sprites/Ships/satellite_A.png")
		1:
			$Sprite2D.texture = load("res://Assets/Sprites/Ships/satellite_B.png")
		2:
			$Sprite2D.texture = load("res://Assets/Sprites/Ships/satellite_C.png")
		3:
			$Sprite2D.texture = load("res://Assets/Sprites/Ships/satellite_D.png")
		4:
			$Sprite2D.texture = load("res://Assets/Sprites/Ships/station_A.png")
		5:
			$Sprite2D.texture = load("res://Assets/Sprites/Ships/station_B.png")
		6:
			$Sprite2D.texture = load("res://Assets/Sprites/Ships/station_C.png")
			

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "ObjPlayer":
		#send signals to gamemanager to end the level
		GameManager.destinationEntered()
