extends Camera2D

@export var decay :float = 1.0  # How quickly the shaking stops [0, 1].
@export var max_offset: Vector2 = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll: float = 0.1  # Maximum rotation in radians (use sparingly).
@export_node_path() var target  # Assign the node this camera will follow.

var trauma: float = 0.0  # Current shake strength.
var trauma_power: int = 2  # Trauma exponent. Use [2, 3].

@onready var noise = FastNoiseLite.new()
var noise_y = 0


func _ready():
	randomize()
	noise.seed = randi_range(1_000_000, 2_000_000) #NOTE randi() sometimes makes everything disappear?
	noise.frequency = 0.5
	#noise.noise_type = FastNoiseLite.TYPE_PERLIN


func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func add_trauma(amount: float = 1.0) -> void:
	trauma = min(trauma + amount, 1.0)

		
func shake() -> void:
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
