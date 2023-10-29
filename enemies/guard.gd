extends Soldier

@onready var shield_sprite: Sprite2D = $Shield/ShieldSprite
var stunned: bool = false


func _physics_process(_delta):
	if not stunned:
		super(_delta)
		Utils.rotate_sprite_direction(shield_sprite, rotation)

func _on_shield_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		area.queue_free()
		stun()
	
func stun() -> void:
	$Timers/StunTimer.start()
	stunned = true

func _on_stun_timer_timeout() -> void:
	stunned = false
