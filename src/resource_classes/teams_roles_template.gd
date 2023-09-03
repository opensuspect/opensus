extends Resource
class_name TeamsRolesTemplate

var teamNames: Array = [] # A list of the teams
var roleNames: Dictionary = {} # A list of roles for each team
var teamRoleColors: Dictionary = {} # A list of team, role, color pairings

func init():
	teamNames = ["Agents"]
	roleNames = {"Agents": ["Agent"]}
	teamRoleColors = {["Agents", "Agent"]: Color.white}

func getRoleColor(team: String, role: String) -> Color:
	var textColor: Color = Color.white
	var searchBase: Array = [team, role]
	if searchBase in teamRoleColors:
		textColor = teamRoleColors[searchBase]
	return textColor

func assignTeamsRoles(characterList: Array) -> Dictionary:
# warning-ignore:unassigned_variable
	var teamsRoles: Dictionary
	for character in characterList:
		teamsRoles[character] = {"team": "Agents", "role": "Agent"}
	return teamsRoles

# This function shows how someone with a certain team and role sees everyone else
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func getVisibleTeamRole(realTeamsRoles: Dictionary, myTeam: String, myRole: String) -> Dictionary:
	return realTeamsRoles

# This function tells the role announcement scene what teams and roles should be
# displayed.
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func getTeamsRolesToShow(realTeamsRoles: Dictionary, myTeam: String, myRole: String) -> Array:
	return [{"team": "Agents", "role": "Agent"}]
	
# warning-ignore:unused_argument
func assignAbilities(characterList: Array, teamsRoles: Dictionary) -> Dictionary:
# warning-ignore:unassigned_variable
	var abilities: Dictionary
	for character in characterList:
		abilities[character] = []
	return abilities

# warning-ignore:unused_argument
func getAbilityByName(name: String) -> Ability:
	return null
