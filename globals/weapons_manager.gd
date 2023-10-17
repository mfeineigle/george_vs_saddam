extends Node


var weapons: Array[Weapon]
var current_weapon: Weapon


func _ready() -> void:
	GameEvents.weapon_picked_up.connect(_on_weapon_picked_up)
	
	
func _on_weapon_picked_up(weapon) -> void:
	if weapons.size() <= 0:
		current_weapon = weapon
		GameEvents.cycled_weapon.emit(WeaponsManager.current_weapon)
	weapons.append(weapon)
	weapons.sort_custom(sort_alpha)
	weapon.call_deferred("reparent", self)


func sort_alpha(a,b) -> bool:
	if a.name.naturalnocasecmp_to(b.name) < 0:
		return true
	return false
	
