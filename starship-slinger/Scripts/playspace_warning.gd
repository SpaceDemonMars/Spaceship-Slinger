extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "ObjPlayer":
		area.get_parent().get_node("../ObjPlayer/WarningContainer").activate()
		area.get_parent().get_node("../GameplayHud").warningPopup.visible = false


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "ObjPlayer":
		area.get_parent().get_node("../ObjPlayer/WarningContainer").activate()
		area.get_parent().get_node("../GameplayHud").warningPopup.visible = true
