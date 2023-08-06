extends Node

## HOW TO USE SCENE SWITCHER:
#
## back() -> void
# Goes back a scene, based on the order in sceneOrder. The function will instead call the function "_onBack"
# on the base scene, if the current scene matches lowestScenePath. The lowestScenePath is always at the front
# of sceneOrder.
#
## setBase(scene: Node, lowest: String) -> void
# Sets the base scene to a currently loaded scene. Should only be used if baseScene is unset. Lowest defines
# the path to set lowestScenePath.
# This function is specifically for setting the baseScene from a scene already instanced in the editor. After
# baseScene is set, switchBase() should be called instead to change the base scene.
#
## switchBase(path: String, lowest: String) -> void
# Switches out the base scene for the one defined in path. Lowest defines the path to set lowestScenePath.
# If the lowest is different then the path, it creates a new CanvasLayer and parents the lowest scene to
# the CanvasLayer.
#
## overlay(path: String) -> void
# Adds the scene specified by it's resource path. If a CanvasLayer doesn't yet exists it creates it.
# Adds the new path as a child of the CanvasLayer. All other child scenes are 
# hidden, and the newly overlayed scene is shown. If the scene is already loaded, it is just shown instead. 
# The _focus method, if it exists, is run on the scene.
#
## preloadOverlay(path: String) -> void
# Similar to overlay(), except the scene is loaded in the background, and not shown. The _focus method is not
# run on the scene either.

var baseScene: Node # Always loaded scene
var baseScenePath: String # Path3D of baseScene

# If the node has a canvaslayer, this variable refers to it. if it does not, this variable is null
var canvasNode: CanvasLayer = null

var lowestScenePath: String # Path3D to scene that won't be hidden by back

var loadedScenes: Dictionary # Loaded scenes with their paths as keys
var sceneOrder: Array # Order of scenes, with back being the top

# --Public Functions--

# Add a child scene to the base scene, and show it
func overlay(path: String, attachedResource: Resource = null) -> void:
	_hideAllLoaded() # Hide all loaded overlays
	if loadedScenes.has(path):
		_showLoaded(path, attachedResource) # Show the scene if it has already been loaded
	else:
		call_deferred("_deferredOverlay", path, true, attachedResource) # Otherwise load the scene
	if len(sceneOrder) == 0 or path != sceneOrder.back():
		sceneOrder.append(path) # Add the path to sceneOrder if it isn't already there

# Preload a child scene to the base scene, but don't show it
func preloadOverlay(path: String, onCanvasLayer: bool) -> void:
	if not loadedScenes.has(path):
		call_deferred("_deferredOverlay", path, false, onCanvasLayer) # Load the scene if not already loaded

# Set a new scene to be the base scene
func switchBase(path: String, lowest: String) -> void:
	## Clears all previous scene and references
	loadedScenes.clear()
	sceneOrder.clear()
	## Adds new lowest scene
	lowestScenePath = lowest
	sceneOrder.append(lowestScenePath)
	call_deferred("_deferredSwitchBase", path) ## Switch out the base scene

# Set the base scene from an already loaded scene. Only to be used if base scene hasn't been set.
func setBase(scene: Node, lowest: String) -> void:
	assert(baseScene == null) #,"Please use switchBase instead.")
	baseScene = scene
	baseScenePath = scene.scene_file_path
	canvasNode = null
	loadedScenes[baseScenePath] = baseScene
	lowestScenePath = lowest
	overlay(lowestScenePath)

# Switch back to the previous scene
func back() -> void:
	var index = sceneOrder.size() - 1
	if index > 0:
		sceneOrder.remove_at(index)
		overlay(sceneOrder.back())
	else:
		if baseScene.has_method("_onBack"):
			baseScene.call("_onBack")

# --Private Functions--

# Back on ui_cancel
func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		back()

# Deferred overlay function
func _deferredOverlay(path: String, focus: bool, attachedResource: Resource) -> void:
	## Loads new scene
	var newScene = load(path).instantiate()
	if canvasNode == null:
		canvasNode = CanvasLayer.new()
		baseScene.add_child(canvasNode)
	## Places scene as an overlay
	canvasNode.add_child(newScene)
	loadedScenes[path] = newScene
	if attachedResource != null:
		newScene.attachNewResource(attachedResource)
	if focus:
		_showLoaded(path, null)
	else:
		newScene.hide()

# Deferred switch base function
func _deferredSwitchBase(path: String) -> void:
	## Load new base scene
	baseScenePath = path
	canvasNode = null
	_reloadBase()
	## Set new base scene
	loadedScenes[baseScenePath] = baseScene
	get_tree().set_current_scene(baseScene)
	_hideAllLoaded() ## Hide all loaded overlays
	## If lowest scene is loaded
	if lowestScenePath in loadedScenes:
		_showLoaded(lowestScenePath, null) ## Overlay made visible
	else: ## Else
		## Load new overlay
		call_deferred("_deferredOverlay", lowestScenePath, true, null)

# Reload the base scene, performing the switchout
func _reloadBase() -> void:
	if baseScene != null:
		baseScene.free()
	baseScene = load(baseScenePath).instantiate()
	get_tree().get_root().add_child(baseScene)

# Hide all loaded child scenes
func _hideAllLoaded() -> void:
	for scene in loadedScenes.values():
		if scene != baseScene:
			scene.hide()

# Calls the _focus method if the scene has it
func _callFocusOnScene(scene: Node) -> void:
	if scene.has_method("_focus"):
		scene.call("_focus")

# Show the loaded scene matching the path
func _showLoaded(path: String, attachedResource: Resource) -> void:
	var scene = loadedScenes[path]
	if attachedResource != null:
		scene.attachNewResource(attachedResource)
	scene.show()
	_callFocusOnScene(scene)
