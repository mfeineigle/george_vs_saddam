extends CharacterBody2D

@onready var launch_points = get_tree().get_nodes_in_group("scudLaunchers")
@onready var saddam_sprite: Sprite2D = $SaddamSprite

@export var speed: int = 100
@export var rotation_speed: float = 0.5

var direction: Vector2 = Vector2.LEFT


func _process(delta):
	#velocity = direction * speed
	rotation += rotation_speed * delta
	Utils.rotate_sprite_direction(saddam_sprite, rotation)
	check_radar()
	move_and_slide()


func check_radar():
	for ray in get_node("Rays").get_children(): # NOTE optimize with area2D and programatically
		var collider = ray.get_collider()       # draw a few rays to test line of sight
		if collider in get_tree().get_nodes_in_group("player"):
			$AnimationPlayer.play("bug_eyes")
			var nearest_launch_point = launch_points[0]
			for launch_point in launch_points:
				if launch_point.global_position.distance_to(Globals.player_pos) \
					< nearest_launch_point.global_position.distance_to(Globals.player_pos):
					nearest_launch_point = launch_point
			GameEvents.scud_triggered.emit(nearest_launch_point)
			GameEvents.spawn_tu_22.emit()
