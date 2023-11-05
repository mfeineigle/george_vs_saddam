extends PathFollow2D

@export var speed: float
@export var follower: GroundVehicle
@export var pick_up_lower: float
@export var pick_up_upper: float
@export var wait_time: float = 1.0

@onready var timer := Timer.new()
var pick_up: bool = false


func _ready() -> void:
	timer.connect("timeout", _on_timer_timeout)
	timer.wait_time = wait_time
	timer.one_shot = true
	add_child(timer)


func _process(delta: float) -> void:
	follower.global_position = position
	if not (follower.get_node("HealthComponent").destroyed) and not pick_up:
		if progress_ratio > pick_up_lower and progress_ratio < pick_up_upper:
			timer.start()
			pick_up = true
		progress_ratio += speed * delta
		if progress_ratio >= 1.0:
			progress_ratio = 0.0


func _on_timer_timeout() -> void:
	pick_up = false
	progress_ratio = pick_up_upper
