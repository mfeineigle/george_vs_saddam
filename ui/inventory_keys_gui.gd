extends Control

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var keys: Array[Keycard] = KeyManager.keys


func _ready() -> void:
	GameEvents.key_picked_up.connect(_on_key_picked_up)
	update()


func update():
	for i in range(min(slots.size(), keys.size())):
		slots[i].update_keys(keys[i])
	
	
func _on_key_picked_up(_delta):
	update()
