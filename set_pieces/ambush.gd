extends Area2D

# to use this node:
# add a CollisionShape2D (and shape)
# add a Node2D to hold the units
# assign that Node2D to "Units" export
# add units under the "Units" folder

## Holds the units the ambush controls
@export var units: Node2D
## Do the units start invisible?
@export var invisible_units: bool = false
var triggered: bool = false


func _ready() -> void:
	for unit in units.get_children():
		unit.set_process(false)
		unit.set_physics_process(false)
		if invisible_units:
			unit.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		for unit in units.get_children():
			unit.set_process(true)
			unit.set_physics_process(true)
			unit.visible = true


func _on_all_units_dead_timer_timeout() -> void:
	if len(units.get_children()) <= 0:
		queue_free()
