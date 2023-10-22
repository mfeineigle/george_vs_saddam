extends StaticBody2D

@export var rotation_speed: float = 1.0


func _ready() -> void:
	var rays = get_node("Top").get_children()
	for ray in rays:
		print(ray)


func _process(delta):
	check_radar(delta)
	
	
func check_radar(delta) -> void:
	if not $HealthComponent.destroyed:
		$Top.rotation += rotation_speed * delta
		for ray in get_node("Top").get_children(): # NOTE optimize with area2D and programatically
			var collider = ray.get_collider()       # draw a few rays to test line of sight
			if collider in get_tree().get_nodes_in_group("player"):
				print("radar collider: ", collider.name)
				GameEvents.spawn_tu_22.emit()
			
func _on_detection_area_body_entered(body):
	print("radar detected ", body)

func _on_detection_area_body_exited(body):
	print("radar out of range ", body)
	
	
func hit(dmg) -> void:
	$HealthComponent.damage(dmg)
