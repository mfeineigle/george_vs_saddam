extends Node

var keys: Array


func add(new_key: String) -> void:
	keys.append(new_key.to_lower())
