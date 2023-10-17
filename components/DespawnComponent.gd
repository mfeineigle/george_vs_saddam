extends Node2D

@onready var screensize = get_viewport_rect().size
@export var health_component: HealthComponent

func _process(_delta):
	if is_off_screen() or is_dead():
		get_owner().queue_free()

		
func is_off_screen() -> bool:
	if get_owner().position.distance_to(Globals.player_pos) > screensize.x * 1.5:
		return true
	return false


func is_dead() -> bool:
	if health_component and health_component.hp <= 0:
		return true
	return false
