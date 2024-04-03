@tool
extends VBoxContainer
class_name QuestsContainer

@export var quest_gui: PackedScene

@export var quests: Array[Quest]: 
	set(value): 
		quests = value
		if !is_node_ready(): 
			await ready
			
		update()


func update() -> void: 
	for child in get_children(): 
		child.queue_free()
		
	for quest: EcoQuest in quests: 
		var gui: QuestGUI = quest_gui.instantiate()
		add_child(gui)
		gui.quest = quest