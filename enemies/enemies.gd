extends Node2D

# Aircraft
var an_26_scene: PackedScene = preload("res://enemies/an_26.tscn")
var mi_24_scene: PackedScene = preload("res://enemies/mi_24.tscn")
var tu_22_scene: PackedScene = preload("res://enemies/tu_22.tscn")
var can_tu_22: bool = true

# Ground Vehicles
var jeep_scene: PackedScene = preload("res://enemies/jeep.tscn")
var soldier_transport_scene: PackedScene = preload("res://enemies/soldier_transport.tscn")
var tank_scene: PackedScene = preload("res://enemies/tank.tscn")

# Soldiers
var guard_scene: PackedScene = preload("res://enemies/guard.tscn")
var troop_scene: PackedScene = preload("res://enemies/troop.tscn")


func _ready() -> void:
	# Aircraft
	GameEvents.spawn_an_26.connect(_spawn_an_26)
	GameEvents.spawn_mi_24.connect(_spawn_mi_24)
	GameEvents.spawn_tu_22.connect(_spawn_tu_22)
	# Ground Vehicles
	GameEvents.spawn_jeep.connect(_spawn_jeep)
	GameEvents.spawn_soldier_transport.connect(_spawn_soldier_transport)
	# Soldiers
	GameEvents.spawn_guard.connect(_spawn_guard)
	GameEvents.spawn_troop.connect(_spawn_troop)


func _spawn_an_26() -> void:
	var an_26 = an_26_scene.instantiate()
	$Aircraft.call_deferred("add_child", an_26)


func _spawn_mi_24() -> void:
	var mi_24 = mi_24_scene.instantiate()
	$Aircraft.call_deferred("add_child", mi_24)


func _spawn_tu_22() -> void:
	if can_tu_22:
		var tu_22 = tu_22_scene.instantiate()
		$Aircraft.add_child(tu_22)
		$Aircraft/tu_22Timer.start()
		can_tu_22 = false

func _on_tu_22_timer_timeout() -> void:
	can_tu_22 = true


# ground vehicles
func _spawn_soldier_transport() -> void:
	pass


func _spawn_jeep() -> void:
	pass


# soldiers
func _spawn_guard(pos) -> void:
	var guard = guard_scene.instantiate()
	guard.setup(pos)
	$Soldiers.add_child(guard)


func _spawn_troop(pos) -> void:
	var troop = troop_scene.instantiate()
	troop.setup(pos)
	$Soldiers.add_child(troop)


#func _get_spawn_point():
#	%PathFollow2D.progress_ratio = randf()
#	print(%PathFollow2D.position)
