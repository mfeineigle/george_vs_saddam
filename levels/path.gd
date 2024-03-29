extends PathFollow2D

@export var speed: float = 0.2
@export var follower: GroundVehicle
@export var reload_depot: ReloadDepot
## progress_ratio start pickup position (eg: 0.3)
@export var pick_up_lower: float
## progress_ratio done pickup position (eg: 0.31)
@export var pick_up_upper: float
## how long to wait during pickup
@export var wait_time: float = 1.0

@onready var timer := Timer.new()
var pick_up: bool = false


func _ready() -> void:
	timer.connect("timeout", _on_timer_timeout)
	timer.wait_time = wait_time
	timer.one_shot = true
	add_child(timer)


func _process(delta: float) -> void:
	follower.global_position = global_position
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
	if follower.can_spawn_troops or follower.can_spawn_guards:
		for i in follower.max_soldier_capacity:
			if reload_depot.total_soldiers > 0 and follower.deployable_soldiers < follower.max_soldier_capacity:
				reload_depot.total_soldiers -= 1
				follower.deployable_soldiers += 1
		if reload_depot.total_soldiers <= 0 and follower.deployable_soldiers <= 0:
			set_process(false)
		follower.spawn_soldier_timer.start()
