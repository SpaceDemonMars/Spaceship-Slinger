extends Button


var levelIndex : int

func _on_pressed() -> void:
	GameManager.selectedLevelIndex = levelIndex
	get_parent().get_parent().get_parent().close()
