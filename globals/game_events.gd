extends Node

signal level_changed(path)
signal level_exited(next_level)

signal stats_changed
signal cycled_weapon(weapon)

signal player_hit(damage)
signal george_shot(dir, pos, weapon)

signal air_drop_called()
signal air_drop_updated()

# collectibles
signal weapon_picked_up(weapon)
signal pallet_of_dollars_dropped(position, direction)
signal key_picked_up(key)
signal secret_found(id, message)

# projectiles
signal scud_triggered(nearest_launch_point)
signal scud_fired(position)
signal mi_24_shot(dir, pos, weapon)
signal tu_22_bomb_dropped(position, direction)
signal soldier_shot(dir, pos, weapon)
signal tank_shot(shell)

# enemies
# Aircraft
signal spawn_an_26
signal spawn_mi_24
signal spawn_tu_22
# Ground Vehicles
signal spawn_jeep
signal spawn_soldier_transport
signal spawn_tank
# Soldiers
signal spawn_guard(position)
signal spawn_troop(position)
