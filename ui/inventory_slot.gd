extends Panel

@onready var slotSprite: Sprite2D = $SlotSprite
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/ItemSprite


func update(item: Weapon) -> void:
	if not item:
		slotSprite.frame = 0
		itemSprite.visible = false
	else:
		slotSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = item.texture
		itemSprite.scale = Vector2(0.025, 0.025)

