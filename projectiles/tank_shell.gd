extends Bullet

@onready var target: Vector2 = Globals.player_pos

@export var splash_damage: int

var targets: Array = []


func _ready() -> void:
	direction = (target - global_position).normalized()
	target += direction * 50


func _process(_delta):
	position += direction.normalized() * speed
	var distance: float = position.distance_to(target)
	if is_target_reached(distance):
		_explode_sequence()


func is_target_reached(distance) -> bool:
	if distance < 50:
		return true
	return false


func _on_body_entered(body) -> void:
	if body.is_in_group("player") and body.has_method("hit"):
		body.hit(damage) # the initial direct hit, base damage
		_explode_sequence()


func _explode_sequence() -> void:
	set_process(false) #stop moving and prevent additional explosions
	$AnimationPlayer.play("explode")
	$AudioStreamExplosion.play()
	for t in targets: # deal splash_damage to all targets including
		if t.has_method("hit"): # the direct hit which will take
			t.hit(splash_damage) # a total of (damage + splash_damage)
	$CollisionShape2D.set_deferred("disabled", true)
	$ExplodeArea/ExplodeCollision.set_deferred("disabled", true)
	await $AudioStreamExplosion.finished
	queue_free()


func _on_explode_area_body_entered(body):
	targets.append(body)

func _on_explode_area_body_exited(body):
	targets.erase(body)
