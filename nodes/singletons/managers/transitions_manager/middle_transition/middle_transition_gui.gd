extends TransitionGUI
class_name MiddleTransitionGUI

enum EndCondition {
	NONE, 
	TIMEOUT, 
	LOADING_FINISHED, 
	SIGNAL, 
	WORLD_EVENT_CALLED, 
	ENTERED_TREE, 
}

@export var timer: Timer

var end_condition: EndCondition

func _play() -> void: 
	match end_condition: 
		EndCondition.TIMEOUT: 
			timer.timeout.connect(end, CONNECT_ONE_SHOT)
			timer.start()
		EndCondition.LOADING_FINISHED: 
			if SceneLoader.has_thread_load_loaded: 
				end()
				return
			if SceneLoader.thread_load_loaded.is_connected(_on_scene_loader_load_ended): 
				SceneLoader.thread_load_loaded.connect(_on_scene_loader_load_ended, CONNECT_ONE_SHOT)
		EndCondition.ENTERED_TREE: 
			# DOES NOT WORK
			SceneLoader.scene_entered_tree.connect(
				func(): 
					end() 
			, CONNECT_ONE_SHOT
			)
		EndCondition.SIGNAL: 
			pass
		EndCondition.WORLD_EVENT_CALLED: 
			pass


func _on_scene_loader_load_ended() -> void: 
	end()
	
	
