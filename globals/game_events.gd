extends Node

signal stats_changed
signal cycled_weapon(weapon)

signal player_hit(damage)
signal george_shot(dir)

signal air_drop_called()
signal air_drop_updated()

# collectibles
signal weapon_picked_up(weapon)
signal pallet_of_dollars_dropped(position, direction)

# projectiles
signal scud_triggered(nearest_launch_point)
signal scud_fired(position)
signal tu_22_bomb_dropped(position, direction)

# enemies
signal spawn_guard(position, offset)
signal spawn_troop(position, offset)
signal spawn_tu_22
signal spawn_jeep
