extends Camera2D

# Get the player
@export var player : CharacterBody2D;

# Smoothing
@export var smoothing : float;

# Check if ready
var game_ready : bool = false;


## Start following the player
func _ready() -> void:
	game_ready = true;
	global_position = player.camera_pos.global_position;


## Follow the player
func _process(delta: float) -> void:
	
	# Exit early if game not ready
	if(!game_ready):
		return;
	
	global_position = lerp(global_position, ((player.camera_pos.global_position - global_position) * delta) + global_position, smoothing);
