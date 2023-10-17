extends Node2D


var pallet_of_dollars_scene: PackedScene = preload("res://collectibles/pallet_of_dollars.tscn")


func _ready() -> void:
	GameEvents.pallet_of_dollars_dropped.connect(_on_pallet_of_dollars_dropped)
	
	
func _on_pallet_of_dollars_dropped(pos, dir):
	var pallet_of_dollars: Area2D = pallet_of_dollars_scene.instantiate()
	pallet_of_dollars.setup(pos, dir)
	add_child(pallet_of_dollars)
