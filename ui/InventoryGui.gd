extends Control

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var weapons: Array[Weapon] = WeaponsManager.weapons

func _ready() -> void:
	GameEvents.weapon_picked_up.connect(_on_weapon_picked_up)
	update()


func update():
	for i in range(min(slots.size(), weapons.size())):
		slots[i].update(weapons[i])
	
	
func _on_weapon_picked_up(_delta):
	update()
