extends StaticBody2D

# When instantiating, must add an AnimationPlayer called DoorAnimationPlayer

@onready var door_animation_player: AnimationPlayer = $DoorAnimationPlayer
@onready var locked_door_rattle: AudioStreamPlayer = $LockedDoorRattle
@onready var door_opening: AudioStreamPlayer = $DoorOpening

@export var is_door_locked: bool = false
@export var lock_color: Keycard

var door_open: bool = false


func _on_door_open_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_door_locked:
		if lock_color in KeyManager.keys:
			is_door_locked = false
		else:
			locked_door_rattle.play()
	if body.is_in_group("player") and not is_door_locked:
		if not door_open:
			door_open = true
			door_animation_player.play("open_door")
			door_opening.play()
