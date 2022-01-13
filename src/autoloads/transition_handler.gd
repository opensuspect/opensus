extends Node

var gameScene: Node 
var mainMenuScene: Node
var currentScene: Node

func _ready() -> void:
	## Preload the game scene
	var root: Node = get_tree().get_root()
	var game: Resource = ResourceLoader.load("res://game/game.tscn")
	## Save current (main menu) scene
	mainMenuScene = root.get_child(root.get_child_count() - 1)
	## Instantiate and save th game scene
	gameScene = game.instance()
	## Current scene is the main menu
	currentScene = mainMenuScene

func switchScene(nextScene: Node) -> void:
	## Removes current scene from scene tree
	var root: Node = get_tree().get_root()
	root.remove_child(currentScene)
	## Sets the next scene as the current scene
	root.add_child(nextScene)
	currentScene = nextScene
	get_tree().set_current_scene(currentScene)

func enterLobby() -> void:
	## Switch to the game scene
	switchScene(gameScene)
	## Load lobby map
	gameScene.loadMap("res://game/maps/lobby/lobby.tscn")

func showMainMenu() -> void:
	## Switch to main menu scene
	switchScene(mainMenuScene)

func startGame() -> void:
	assert(false, "Not implemented yet")

func returnLobby() -> void:
	assert(false, "Not implemented yet")
