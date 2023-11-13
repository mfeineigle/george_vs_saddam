extends CPUParticles2D


func setup(pos) -> void:
	global_position = pos
	emitting = true
	look_away(Globals.player_pos)


func look_away(target_pos):
	rotate(get_angle_to(target_pos) + PI);


func _on_timer_timeout() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
