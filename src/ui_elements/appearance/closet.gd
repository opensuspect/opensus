extends Control

onready var iconCharacter = preload("res://ui_elements/icon_character.tscn")

onready var character = $MenuMargin/HBoxContainer/CharacterBox/CenterCharacter/MenuCharacter
onready var items = $MenuMargin/HBoxContainer/ClosetBox/Panel/ItemList

var configData: Dictionary
var configList: Array

const NAMESPACE = "appearance"

# Item list config variables
const LIST_COLUMNS = 0 # Max columns
const LIST_SAME_WIDTH = true # Same column width
const ITEM_ICON_SIZE = Vector2(256, 256) # Icon size of items

# --Private Functions--

func _ready() -> void:
	character.setOutline(Color.black)
	Appearance.applyConfig()
	_configureItemList()
	_listItems()

func _configureItemList():
	items.max_columns = LIST_COLUMNS # Set the max columns
	items.same_column_width = LIST_SAME_WIDTH # Set the same column width
	items.fixed_icon_size = ITEM_ICON_SIZE # Configure the icon size

func _listItems() -> void:
	if GameData.exists(NAMESPACE):
		configData = GameData.read(NAMESPACE)
		_populateItems()

func _populateItems():
	for config in configData:
		configList.append(config)
		var texture = _getIconTexture(config)
		items.add_icon_item(texture)

func _getIconTexture(namespace) -> Texture:
	var config = configData[namespace]
	var outfit = config["Outfit"]
	var colors = config["Colors"]
	var iconInstance = iconCharacter.instance()
	self.add_child(iconInstance)
	iconInstance.hide()
	iconInstance.applyConfig(outfit, colors)
	var texture = iconInstance.texture
	return(texture)

# --Signal Functions--

func _on_Back_pressed() -> void:
	get_tree().change_scene("res://ui_elements/appearance/appearance_editor.tscn")

func _on_item_selected(index):
	var namespace = configList[index]
	var config = configData[namespace]
	var outfit = config["Outfit"]
	var colors = config["Colors"]
	character.setConfig(outfit, colors)