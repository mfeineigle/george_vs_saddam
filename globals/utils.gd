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


func read_secrets(level) -> Dictionary:
	var save_path: String = "res://ui/scores/"+level.to_lower()+"_secrets.save"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		file = file.get_as_text()
		return JSON.parse_string(file)
	else:
		return {}

# Prevent things from spawning outside of the NavMesh (like on boulders and houses)
func get_point_on_map(map, target_point: Vector2, min_dist_from_edge: float = 5.0) -> Vector2:
	var closest_point := NavigationServer2D.map_get_closest_point(map, target_point)
	var delta := closest_point - target_point
	var is_on_map = delta.is_zero_approx()
	if not is_on_map and min_dist_from_edge > 0:
		# Wasn't on the map, so push in from edge. If you have thin sections on
		# your navmesh, this could push it back off the navmesh!
		delta = delta.normalized()
		closest_point += delta * min_dist_from_edge
	return closest_point
