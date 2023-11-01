extends PathFollow2D

@export var speed: float
var dir: int = 1

func _process(delta: float) -> void:
	if not $jeep/HealthComponent.destroyed:
		progress_ratio += speed * delta
		if progress_ratio >= 1.0:
			progress_ratio = 0.0
	
