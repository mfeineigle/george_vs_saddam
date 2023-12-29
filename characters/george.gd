extends CharacterBody2D


@onready var george_sprite: Sprite2D = $GeorgeSprite
@onready var rifle_flash: Sprite2D = $Guns/Rifle/RifleFlash
@onready var rocket_flash: Sprite2D = $Guns/RocketLauncher/RocketFlash
@onready var rocket_exhaust: Sprite2D = $Guns/RocketLauncher/RocketExhaust
@onready var shotgun_flash: Sprite2D = $Guns/Shotgun/ShotgunFlash
@onready var health_component: Node2D = $HealthComponent

@export var speed: int = 500
var direction: Vector2

var shoot_dir: Vector2
var last_shoot_dir: Vector2 = Vector2.RIGHT

# Cooldown when cycling weapons to prevent cycle spamming to avoid weapon cooldown
## Global cooldown flag after cycling weapons
var cycle_can_shoot: bool = true
## Global cooldown after cycling weapons
@export var cycle_shoot_delay: float = 0.5

var dashing: bool = false
var dashCount: int = 0
## How many times you can dash
@export var maxDashCount: int = 1
## How long a dash lasts (in seconds)
@export var dashTime: float = 0.1
## How long until the dash count resets (in seconds)
@export var dashDelay: float = 1.0
## Velocity multiplier during a dash
@export var dash_speed: float = 3.0

var knockback_vector: Vector2 = Vector2(0,0)
var is_knockback: bool = false
var knock_count: int = 0


func _ready():
	Globals.player_pos = position
	health_component.hp = Globals.hp
	GameEvents.player_hit.connect(hit)
	GameEvents.weapon_picked_up.connect(equip_first_weapon)
	cycle_weapon()


func _input(_event: InputEvent) -> void:
	# testing - spawn stuff
	if Input.is_action_just_pressed("spawn_test"):
		spawn()
	direction = Input.get_vector("left", "right", "up", "down")
	aim()
	if Input.is_action_just_pressed("air_drop"):
		GameEvents.air_drop_called.emit()
	if Input.is_action_just_pressed("cycle_weapon"):
		cycle_weapon()
	if Input.is_action_just_pressed("dash"):
		dash()


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	if dashing:
		velocity *= dash_speed
	if is_knockback:
		velocity = knockback_vector
		knock_count -= 1
		if knock_count <= 0:
			is_knockback = false
	move_and_slide()


func _process(_delta):
	if direction:
		$AnimationPlayer.play("walking")
	else:
		$AnimationPlayer.stop()
	if Input.is_action_pressed("shoot"):
		shoot()
	Utils.flip_h_sprite_direction(george_sprite, direction)
	Globals.player_pos = position


func aim() -> void:
	shoot_dir = Input.get_vector("fleft", "fright", "fup", "fdown")
	if not shoot_dir:
		shoot_dir = (get_global_mouse_position() - position).normalized()
	if shoot_dir:
		last_shoot_dir = shoot_dir
	$Guns.rotation = last_shoot_dir.angle()
	for gun in $Guns.get_children():
		Utils.flip_v_sprite_direction(gun, last_shoot_dir)
	var distance: int = 100
	$BulletSpawnPoint.position = Vector2(cos(last_shoot_dir.angle()),
										 sin(last_shoot_dir.angle())) * distance


func shoot() -> void:
	if cycle_can_shoot \
	and WeaponsManager.current_weapon \
	and WeaponsManager.current_weapon.can_shoot:
		GameEvents.george_shot.emit(last_shoot_dir,
									$BulletSpawnPoint.global_position,
									WeaponsManager.current_weapon)
		shoot_animation()

func shoot_animation() -> void:
	muzzle_flash(WeaponsManager.current_weapon)
	var tween = create_tween().set_loops(1)
	tween.tween_property($Guns, "position:y", 10, 0.05).from(40)
	tween.tween_property($Guns, "position:y", 40, 0.15).from(10)

func muzzle_flash(weapon) -> void:
	var tween = get_tree().create_tween()
	match weapon.name:
		"Rifle":
			rifle_flash.show()
			tween.tween_property(rifle_flash, "scale", Vector2(0.3, 0.3), 0.1)
			tween.tween_property(rifle_flash, "scale", Vector2(0.0, 0.0), 0.1)
			await tween.finished
			rifle_flash.hide()
		"RocketLauncher":
			var exhaust_tween = get_tree().create_tween()
			rocket_flash.show()
			rocket_exhaust.show()
			tween.tween_property(rocket_flash, "scale", Vector2(1, 1), 0.1)
			tween.tween_property(rocket_flash, "scale", Vector2(0.0, 0.0), 0.1)
			exhaust_tween.tween_property(rocket_exhaust, "scale", Vector2(1, 1), 0.1)
			exhaust_tween.tween_property(rocket_exhaust, "scale", Vector2(0.0, 0.0), 0.3)
			await exhaust_tween.finished
			rocket_flash.hide()
			rocket_exhaust.hide()
		"Shotgun":
			shotgun_flash.show()
			tween.tween_property(shotgun_flash, "scale", Vector2(0.7, 0.7), 0.05)
			tween.tween_property(shotgun_flash, "scale", Vector2(0.0, 0.0), 0.1)
			await tween.finished
			shotgun_flash.hide()

# The first weapon you pick up will instantly equip and become active
func equip_first_weapon(_weapon):
	if WeaponsManager.weapons.size() <= 1:
		cycle_weapon()

func cycle_weapon() -> void:
	if WeaponsManager.weapons.size() <= 0:
		return
	var idx: int = WeaponsManager.weapons.find(WeaponsManager.current_weapon)
	idx += 1
	if idx >= WeaponsManager.weapons.size():
		idx = 0
	WeaponsManager.current_weapon = WeaponsManager.weapons[idx]
	GameEvents.cycled_weapon.emit(WeaponsManager.current_weapon)
	set_wielded_weapon(WeaponsManager.current_weapon)
	cycled_weapon_cooldown() #prevents spam cycling to reset weapon internal cooldown
	
func set_wielded_weapon(weapon) -> void:
	for gun in $Guns.get_children():
		gun.hide()
	match weapon.name:
		"Rifle":
			$Guns/Rifle.show()
			$Guns/Rifle/RifleLoad.play()
		"RocketLauncher":
			$Guns/RocketLauncher.show()
			$Guns/RocketLauncher/RocketLoad.play()
		"Shotgun":
			$Guns/Shotgun.show()
			$Guns/Shotgun/ShotgunLoad.play()
	
# A cooldown to prevent cycle spamming to avoid weapon cooldowns
func cycled_weapon_cooldown() -> void:
	cycle_can_shoot = false
	$Timers/CanShootTimer.start(cycle_shoot_delay)

func _on_can_shoot_timer_timeout():
	cycle_can_shoot = true


func hit(dmg) -> void:
	if Globals.invincible:
		return
	if dmg > 2:
		$Camera2D.add_trauma()
	health_component.damage(dmg)
	Globals.hp = health_component.hp
	Globals.total_damage_taken += dmg
	if Globals.hp <= 0:
		die()

func die() -> void:
	print(name, " died.")
	GameEvents.level_exited.emit()

func dash() -> void:
	if dashCount < maxDashCount:
		george_sprite.texture = load("res://assets/characters/george_dash.png")
		dashCount += 1
		dashing = true
		$Timers/CanDashTimer.start(dashDelay)
		$Timers/DashingTimer.start(dashTime)

func _on_can_dash_timer_timeout():
	dashCount = 0

func _on_dashing_timer_timeout():
	george_sprite.texture = load("res://assets/characters/george.png")
	dashing = false


func knockback(dir, knock_strength) -> void:
	is_knockback = true
	knock_count = 5
	knockback_vector = dir * knock_strength


func spawn() -> void:
	GameEvents.spawn_an_26.emit()
