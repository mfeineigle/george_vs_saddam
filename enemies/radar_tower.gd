extends StaticBody2D

@export var rotation_speed: float = 1.0

func _ready() -> void:
	var rays = get_node("Top").get_children()
	for ray in rays:
		print(ray)

func _process(delta):
	$Top.rotation += rotation_speed * delta
	check_radar()
	
func check_radar() -> void:
	for ray in get_node("Top").get_children(): # NOTE optimize with area2D and programatically
		var collider = ray.get_collider()       # draw a few rays to test line of sight
		if collider in get_tree().get_nodes_in_group("player"):
			print(collider.name)
			GameEvents.spawn_tu_22.emit()
			
func _on_detection_area_body_entered(body):
	print(body, " detected")


func _on_detection_area_body_exited(body):
	print(body, " out of range")
