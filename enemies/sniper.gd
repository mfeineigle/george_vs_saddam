extends Soldier

var is_running_away: bool = false


func _ready() -> void:
	weapon = $Weapons/Rifle
	print(weapon.bullet_scene)
	weapon.bullet_scene = preload("res://projectiles/sniper_bullet.tscn")
	print(weapon.bullet_scene)
	super._ready()


func _physics_process(_delta: float) -> void:
	if get_new_nav and not $NavigationAgent2D.is_navigation_finished():
		velocity = update_nav()
	direction = (Globals.player_pos - position).normalized()
	if not is_running_away:
		shoot()
	if is_running_away and not is_sentinel:
		look_away(Globals.player_pos)
		direction = (Globals.player_pos - position).normalized()
		velocity = speed * -direction
		move_and_slide()
	set_spirte_direction()


func look_away(target_pos):
	rotate(get_angle_to(target_pos) + PI);


func _on_run_away_area_inner_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_running_away = true

func _on_run_away_area_outer_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_running_away = false
