extends Node2D

@onready var roof_animation_player: AnimationPlayer = $RoofAnimationPlayer
@onready var door_animation_player: AnimationPlayer = $DoorAnimationPlayer
@onready var locked_door_rattle: AudioStreamPlayer = $LockedDoorRattle
@onready var door_opening: AudioStreamPlayer = $DoorOpening
@onready var door_stripes: Sprite2D = $Door/DoorStripes

## A Node2D that must be added to hold the characters in the building
@export var occupants: Node2D
@export var is_door_locked: bool = false
@export var key: Keycard

var door_open: bool = false


func _ready() -> void:
	hide_occupants()
	if key:
		door_stripes.texture = key.stripes


func _on_open_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_door_locked:
		if key in KeyManager.keys:
			is_door_locked = false
		else:
			locked_door_rattle.play()
	if body.is_in_group("player") and not is_door_locked:
		roof_animation_player.play("fade_out")
		show_occupants()
		if not door_open:
			door_open = true
			door_animation_player.play("open_door")
			door_opening.play()


func _on_open_door_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and not is_door_locked:
		roof_animation_player.play_backwards("fade_out")
		hide_occupants()


func show_occupants() -> void:
	if occupants:
		for i in occupants.get_children():
			i.visible = true

func hide_occupants() -> void:
	if occupants:
		for i in occupants.get_children():
			i.visible = false
