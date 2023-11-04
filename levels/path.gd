extends PathFollow2D

@export var speed: float

@onready var unit = get_children()[0]


func _process(delta: float) -> void:
	unit.global_position = position
	if not (unit.get_node("HealthComponent").destroyed):
		progress_ratio += speed * delta
		if progress_ratio >= 1.0:
			progress_ratio = 0.0

