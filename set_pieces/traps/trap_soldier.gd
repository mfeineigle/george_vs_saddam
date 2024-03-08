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
			unit.process_mode = Node.PROCESS_MODE_DISABLED


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		Globals.trap_triggers += 1
		for unit in units.get_children():
			unit.set_process(true)
			unit.set_physics_process(true)
			unit.visible = true
			unit.process_mode = Node.PROCESS_MODE_INHERIT
			call_deferred("reparent_unit", unit)
	queue_free()


func reparent_unit(unit) -> void:
	unit.reparent(Globals.current_level.get_node("Enemies/Soldiers"))
