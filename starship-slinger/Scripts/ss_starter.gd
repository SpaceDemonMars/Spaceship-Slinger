extends "res://Scripts/class_spaceShip.gd"

@onready var Ship = $Ship

func _ready() -> void:
	Ship.texture = shipAsset
