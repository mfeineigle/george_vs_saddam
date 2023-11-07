extends Node2D


# enemies
var tu_22_bomb_scene: PackedScene = preload("res://projectiles/tu_22_bomb.tscn")
var scud_scene: PackedScene = preload("res://projectiles/scud.tscn")


func _ready() -> void:
	GameEvents.george_shot.connect(_on_george_shot)
	GameEvents.scud_fired.connect(_on_scud_fired)
	GameEvents.tu_22_bomb_dropped.connect(_on_tu_22_bomb_dropped)
	GameEvents.soldier_shot.connect(_on_soldier_shot)
	GameEvents.tank_shot.connect(_on_tank_shot)


# george
func _on_george_shot(dir, pos, weapon) -> void:
	var bullets: Array = weapon.make_bullets(dir, pos)
	for bullet in bullets:
		bullet.set_collision_mask_value(1, false)
		bullet.add_to_group("player_bullets")
		add_child(bullet)

func _on_soldier_shot(dir, pos, weapon) -> void:
	var bullets: Array = weapon.make_bullets(dir, pos)
	for bullet in bullets:
		bullet.set_collision_mask_value(2, false)
		add_child(bullet)


# enemies
func _on_scud_fired(pos):
	var scud = scud_scene.instantiate()
	scud.setup(pos)
	add_child(scud)


func _on_tu_22_bomb_dropped(pos, rot) -> void:
	var tu_22_bomb = tu_22_bomb_scene.instantiate()
	tu_22_bomb.setup(pos, rot)
	add_child(tu_22_bomb)

func _on_tank_shot(shell) -> void:
	add_child(shell)
