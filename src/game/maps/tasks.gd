extends YSort

var taskResources: Dictionary = {}
var interactAreas: Dictionary = {}

var tasksWithInput: Dictionary = {}

func _ready():
	var taskRes: TaskResource
	TransitionHandler.gameScene.setTaskHandler(self)
	var myCharacter: CharacterResource = null
	if not Connections.isDedicatedServer():
		myCharacter = Characters.getMyCharacterResource()
	for taskNode in get_children():
		taskRes = taskNode.taskResource
		taskResources[taskNode.name] = taskRes
		interactAreas[taskNode.interactArea] = taskRes
		for input in taskRes.inputVariables:
			if not input in tasksWithInput:
				tasksWithInput[input] = []
			tasksWithInput[input].append(taskRes)
		taskRes.init(taskNode)
# warning-ignore:return_value_discarded
		taskRes.connect("stateChanged", self, "taskChanged")
# warning-ignore:return_value_discarded
		taskRes.connect("action", self, "taskActionAttempt")
		if myCharacter != null:
# warning-ignore:return_value_discarded
			taskRes.connect("activateUi", myCharacter, "setTaskMode")
# warning-ignore:return_value_discarded
			taskRes.connect("deactivateUi", myCharacter, "endTaskMode")
	for taskName in taskResources:
		taskRes = taskResources[taskName]
		for output in taskRes.outputVariables:
			if not output in tasksWithInput:
				print("There is an output ", output, ", that isn't an input for any task")
				continue
			for connectedTaskRes in tasksWithInput[output]:
				connectedTaskRes.setInputProvider(output, taskRes)

func taskChanged(taskRes: TaskResource, newState: Dictionary) -> void:
	var taskData: Dictionary = {}
	var index: int = taskResources.values().find(taskRes)
	taskData["name"] = taskResources.keys()[index]
	taskData["newState"] = newState
	Connections.queueDataToSend("taskChanged", taskData, -1)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func taskActionAttempt(taskRes: TaskResource, actions: Dictionary) -> void:
	pass

func taskRemoteChanged(receivedData: Dictionary) -> Dictionary:
	var taskRes: TaskResource
	var newState: Dictionary = {}
	taskRes = taskResources[receivedData["name"]]
	newState = receivedData["newState"]
	if taskRes.stateRemoteChange(newState):
		for output in taskRes.outputVariables:
			for connectedTaskRes in tasksWithInput[output]:
				connectedTaskRes.stateRemoteChange({})
		return receivedData
	return {"name": receivedData["name"], "newState": taskRes.taskState}
	
