@icon("res://addons/world_event_manager/class_icons/world-event-listener.png")
## Listens for a specific event, then emits event_called. Meant for other nodes to use by being connected to this event. 
extends Resource
class_name WorldEventListener

signal event_heard(event: WorldEvent, by: Node, args: Array)

@export var event: String = ""
@export var listen_once: bool
@export var disabled: bool: 
	set(value): 
		disabled = value
		if disabled && WorldEventManager.event_called.is_connected(_on_event_called): 
			WorldEventManager.event_called.disconnect(_on_event_called)


func _init() -> void: 
	WorldEventManager.event_called.connect(_on_event_called)


func _on_event_called(world_event: WorldEvent, by: Node, args: Array = []) -> void: 
	if world_event.is_id(event): 
		event_heard.emit(world_event, by, args)
		if listen_once:  
			disabled = true
			WorldEventManager.event_called.disconnect(_on_event_called)

