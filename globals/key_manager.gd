extends Node

var keys: Array[Keycard]


func _ready() -> void:
	GameEvents.key_picked_up.connect(_on_key_picked_up)


func _on_key_picked_up(new_key: Keycard) -> void:
	keys.append(new_key)
	keys.sort_custom(sort_alpha)


func sort_alpha(a,b) -> bool:
	if a.color.naturalnocasecmp_to(b.color) < 0:
		return true
	return false
