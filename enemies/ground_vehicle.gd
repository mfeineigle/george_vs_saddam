class_name GroundVehicle
extends CharacterBody2D

@onready var vehicle_sprite: Sprite2D = $VehicleSprite

@export var speed: int

var direction: Vector2 = Vector2.ZERO
var destroyed: bool = false

func hit(dmg) -> void:
	$HealthComponent.damage(dmg)
