extends Control

# --Signal Functions--
func _on_Exit_pressed():
	get_tree().quit()

func _on_Cancel_pressed():
	get_parent().setVisibleMenuWithLogo(0)
	queue_free()
