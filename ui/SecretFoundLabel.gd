extends Label


func _ready() -> void:
	hide()
	GameEvents.connect("secret_found", _on_secret_found)


func _on_secret_found(_id, message) -> void:
	text = "Secret Found!\n" + message
	self.modulate.a = 1
	show()
	await get_tree().create_timer(2).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.0)
	await tween.finished
	hide()
