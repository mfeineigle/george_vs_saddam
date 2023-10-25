class_name GroundVehicle
extends CharacterBody2D

@onready var vehicle_sprite: Sprite2D = $VehicleSprite

@export var speed: int

var direction: Vector2 = Vector2.ZERO
var destroyed: bool = false


func _process(_delta):
	velocity = direction * speed
	Utils.flip_h_sprite_direction(vehicle_sprite, direction)
	if not $HealthComponent.destroyed:
		move_and_slide()
		
