extends Node2D
class_name  HealthComponent

@export var max_hp: int
#@export var death_component: DeathComponent

var hp: int
var destroyed: bool = false


func _ready():
	hp = max_hp


# could pass an attack object here instead of dmg
func damage(dmg) -> void:
	if destroyed:
		return
	hp -= dmg
	if hp <= 0:
		destroyed = true
		#get_owner().modulate = Color.RED
		#if death_component:
			#death_component.die()
