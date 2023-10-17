extends Control

onready var killButton: TextureButton = $KillButton
onready var reloadButton: TextureButton = $ReloadButton

var activeKill: bool = false

signal killButtonPressed
signal reoladButtonPressed

func _ready() -> void:
	killButton.disabled = not activeKill

func activateKillButton(active: bool) -> void:
	activeKill = active
	if killButton != null:
		killButton.disabled = not active

func showReloadButton() -> void:
	reloadButton.show()
	killButton.hide()

func showKillButton() -> void:
	reloadButton.hide()
	killButton.show()

func _on_KillButton_pressed():
	emit_signal("killButtonPressed")

func _on_ReloadButton_pressed():
	emit_signal("reoladButtonPressed")
