extends Node


func flip_h_sprite_direction(sprite: Sprite2D, dir: Vector2) -> void:
	if dir.x > 0.1:
		sprite.flip_h = false
	elif dir.x < -0.1:
		sprite.flip_h = true

func flip_v_sprite_direction(sprite: Sprite2D, dir: Vector2) -> void:
	if dir.x > 0.1:
		sprite.flip_v = false
	elif dir.x < -0.1:
		sprite.flip_v = true

func rotate_sprite_direction(sprite: Sprite2D, rot) -> void:
	if rot < PI/2 and rot >= -PI/2:
		sprite.flip_v = false
	else:
		sprite.flip_v = true


func get_spawn_point() -> Vector2:
	var path_follow = get_tree().get_nodes_in_group("spawn_points")[0]
	path_follow.progress_ratio = randf()
	return path_follow.global_position


func read_best_times(level: String) -> Array:
	level = level.to_lower()
	var save_path: String = "res://ui/scores/"+level+"_best_times.save"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var times = file.get_as_text()
		if times:
			return str_to_var(times)
	return [3599, 3599, 3599, 3599, 3599]
