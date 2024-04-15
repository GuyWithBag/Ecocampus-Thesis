extends GUI
class_name QuestsMenu

@export var quests_container: QuestsContainer

var quests: Array[Quest]: 
	get: 
		return ExtendedQuestSystem.active.quests as Array[Quest]


func _ready() -> void: 
	update()
	ExtendedQuestSystem.quest_accepted.connect(_on_quest_accepted)


func _on_quest_accepted(_quest: Quest) -> void: 
	update()
	
	
func update() -> void: 
	quests_container.quests = quests

