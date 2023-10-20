extends Node2D

var guard_scene: PackedScene = preload("res://enemies/guard.tscn")
var troop_scene: PackedScene = preload("res://enemies/troop.tscn")
var tu_22_scene: PackedScene = preload("res://enemies/tu_22.tscn")
var can_tu_22: bool = true
var jeep_scene: PackedScene = preload("res://enemies/jeep.tscn")


func _ready() -> void:
	
	GameEvents.spawn_guard.connect(_spawn_guard)
	GameEvents.spawn_troop.connect(_spawn_troop)
	GameEvents.spawn_tu_22.connect(_spawn_tu_22)
	
	GameEvents.spawn_jeep.connect(_spawn_jeep)


func _spawn_guard(pos, offset) -> void:
	var guard = guard_scene.instantiate()
	guard.setup(pos, offset)
	$Soldiers.add_child(guard)
	
	
func _spawn_troop(pos, offset) -> void:
	var troop = troop_scene.instantiate()
	troop.setup(pos, offset)
	$Soldiers.add_child(troop)


func _spawn_tu_22() -> void:
	if can_tu_22:
		var tu_22 = tu_22_scene.instantiate()
		$Aircraft.add_child(tu_22)
		$Aircraft/tu_22Timer.start()
		can_tu_22 = false

func _on_tu_22_timer_timeout() -> void:
	can_tu_22 = true


func _spawn_jeep() -> void:
	pass

#func _get_spawn_point():
#	%PathFollow2D.progress_ratio = randf()
#	print(%PathFollow2D.position)
