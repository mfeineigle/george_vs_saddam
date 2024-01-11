extends CanvasLayer


func _ready() -> void:
	GameEvents.air_drop_updated.connect(_on_air_drop_updated)
	GameEvents.cycled_weapon.connect(_on_cycled_weapon)
	GameEvents.stats_changed.connect(on_stats_changed)
	GameEvents.stats_changed.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _process(delta: float) -> void:
	Globals.time += delta
	Globals.mils = int(fmod(Globals.time, 1)*1000)
	Globals.secs = int(fmod(Globals.time, 60))
	Globals.mins = int(fmod(Globals.time, 60*60)/60)
	$Label.text = str(Globals.secs)+":"+str(Globals.mils)


func on_stats_changed() -> void:
	%OilLabel.text = "Oil: " + str(Globals.oil)
	%HPLabel.text = "HP: " + str(Globals.hp)


func _on_air_drop_updated() -> void:
	%AirDropBar.value = Globals.air_drop_timer


func _on_cycled_weapon(weapon) -> void:
	$WeaponHUD/ar15TextureRect.hide()
	$WeaponHUD/shotgunTextureRect.hide()
	$WeaponHUD/RocketLauncherTextureRect.hide()
	if weapon.name == "Rifle":
		$WeaponHUD/ar15TextureRect.show()
	if weapon.name == "Shotgun":
		$WeaponHUD/shotgunTextureRect.show()
	if weapon.name == "RocketLauncher":
		$WeaponHUD/RocketLauncherTextureRect.show()


func _on_time_taken_timer_timeout() -> void:
	Globals.time_taken += 0.1
