extends Resource
class_name CharacterResource

# the purpose of this class is to serve as the backend for the character node
# each character node will have a corresponding CharacterResource, which stores
# 	important info such as character state, position, tasks, etc.
# CharacterResource objects are kept track of in the Characters autoload

# --Public Variables--

# network id corresponding to this character
var networkId: int = -1 setget setNetworkId, getNetworkId

# the name of this player
var characterName: String

var mainCharacter: bool = false
# --Private Variables--

# the character node corresponding to this CharacterResource
var _characterNode: KinematicBody2D

# Names of the apparent team and role of the character. This might not be the
# "Real" role (that is stored on the server)
var _team: String
var _role: String

# the dictionary (?) that stores the tasks assigned to this CharacterResource
# this is a placeholder, not sure what this will look like because the
#	task system has not been implemented yet
var _tasks: Dictionary

# the dictionary (?) that stores outfit information
# this is a placeholder, not sure what this will look like because the
# 	outfit system has not been implemented yet
var _outfit: Dictionary
var _colors: Dictionary

# the speed at which the character moves/how many pixels it can move every frame
var _speed: float = 150

# --Public Functions--

func setNetworkId(newId: int) -> void:
	assert(networkId == -1, "attempting to change networkID on something that has been set")
	networkId = newId

func getNetworkId() -> int:
	return networkId

# function called when character is spawned
func spawn(coords: Vector2):
	_characterNode.spawn()
	setPosition(coords)

# PLACEHOLDER function for killing characters
func kill():
	# assert false because killing is not implemented yet
	assert(false, "Not implemented yet")

# function called to reset the character resource to default settings
# 	probably going to be used mostly between rounds when roles and stuff are
# 	changing
func reset():
	# assert false because resetting is not implemented yet
	assert(false, "Not implemented yet")

# get the character node that corresponds to this CharacterResource
func getCharacterNode() -> Node:
	return _characterNode

# set the character node that corresponds to this CharacterResource
func setCharacterNode(newCharacterNode: Node) -> void:
	# if there is already a character node assigned to this resource
	if _characterNode != null:
		printerr("Assigning a new character node to a CharacterResource that already has one")
		assert(false, "Should be unreachable")
	_characterNode = newCharacterNode
	if networkId == Connections.getMyId():
		_characterNode.setMainCharacter()
		mainCharacter = true

func getCharacterName() -> String:
	return characterName

func setCharacterName(newName: String) -> void:
	characterName = newName
	_characterNode.setCharacterName(characterName)

# get the Team of this chacter
func getTean() -> String:
	return _team

# set the role of this character
func setTeam(newTeam: String) -> void:
	_team = newTeam

# get the role of this chacter
func getRole() -> String:
	return _role

# set the role of this character
func setRole(newRole: String) -> void:
	_role = newRole

# set the color of the name for the character
func setColor(newColor: Color) -> void:
	_characterNode.setColor(newColor)

# get tasks assigned to this CharacterResource
func getTasks() -> Dictionary:
	# assert false because tasks aren't implemented yet
	assert(false, "Not implemented yet")
	return _tasks

# set tasks assigned to this CharacterResource
func setTasks(newTasks: Dictionary):
	# assert false because tasks aren't implemented yet
	assert(false, "Not implemented yet")
	_tasks = newTasks

# get the outfit information of this character
func getOutfit() -> Dictionary:
	return _outfit

func getColors() -> Dictionary:
	return _colors

# set the outfit information of this character
func setAppearance(newOutfit: Dictionary, newColors: Dictionary) -> void:
	_outfit = newOutfit
	_colors = newColors
	_characterNode.call_deferred("setAppearance", _outfit, _colors)

# get the speed of this character
func getSpeed() -> float:
	return _speed

# not sure we would really want to just overwrite speed but I'm putting this
# 	here for constincency
func setSpeed(value: float) -> void:
	_speed = value

# get the direction the character is looking
func getLookDirection() -> int:
	return _characterNode.getLookDirection()

# set the direction the character is looking
func setLookDirection(newLookDirection: int) -> void:
	_characterNode.setLookDirection(newLookDirection)

# get the position of the character
func getPosition() -> Vector2:
	## Get node position
	return _characterNode.getPosition()

# set the position of the character
func setPosition(newPos: Vector2) -> void:
	## Set node position
	_characterNode.setPosition(newPos)

# get the global position of the character
func getGlobalPosition() -> Vector2:
	return _characterNode.getGlobalPosition()

# set the global position of the character
func setGlobalPosition(newPos: Vector2):
	_characterNode.setPosition(newPos)

# --Private Functions--

