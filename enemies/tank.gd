extends GroundVehicle

@onready var death_animation_player: AnimationPlayer = $DeathAnimationPlayer


func _ready():
	direction = Vector2.RIGHT


func hit(dmg) -> void:
	$HealthComponent.damage(dmg)
	if $HealthComponent.destroyed:
		$VehicleSprite.hide()
		$DestroyedVehicleSprite.show()
		for f in $Fires.get_children():
			f.show()
		die()

func die() -> void:
	print(name, " died.")
	death_animation_player.play("die")
