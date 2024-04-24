@tool
extends HBoxContainer
class_name CosmeticsDisplayCardContainer

signal updated

enum OverrideCosmeticState {
	NONE, 
	LOCKED, 
	UNLOCKED,
}

@export var cosmetics_collection: CosmeticsCollection: 
	set(value): 
		cosmetics_collection = value
		if !is_node_ready(): 
			await ready
		if cosmetics_collection: 
			update()
		else: 
			clear()
			
@export var only_show_unlocked: bool: 
	set(value): 
		only_show_unlocked = value
		update()


@export var show_default_cosmetic: bool: 
	set(value): 
		show_default_cosmetic = value
		update()
		
@export var override_cosmetic_state: OverrideCosmeticState: 
	set(value): 
		override_cosmetic_state = value
		update()
		
@export var card_theme_type_variation: String = ""
@export var override_custom_minimum: Vector2

func update() -> void: 
	if !is_node_ready(): 
		await ready
		
	clear()
	for cosmetic: Cosmetic in cosmetics_collection.cosmetics: 
		if cosmetic.is_default && !show_default_cosmetic: 
			continue
		var gui: CosmeticDisplayCard = CosmeticDisplayCard.create(self, cosmetic, card_theme_type_variation)
		if override_custom_minimum != Vector2.ZERO: 
			gui.custom_minimum_size = override_custom_minimum
			#gui.size = custom_minimum_size
		match override_cosmetic_state: 
			OverrideCosmeticState.LOCKED: 
				gui.state = Cosmetic.CosmeticState.LOCKED
			OverrideCosmeticState.UNLOCKED: 
				gui.state = Cosmetic.CosmeticState.UNLOCKED
				
	if only_show_unlocked: 
		for child: CosmeticDisplayCard in get_children(): 
			if child.cosmetic.state == Cosmetic.CosmeticState.LOCKED: 
				child.visible = false
		#printerr(cosmetic.name)
		#printerr(cosmetic.female_icon)
	updated.emit()
	
	
func clear() -> void: 
	for child: Node in get_children(): 
		child.queue_free()
