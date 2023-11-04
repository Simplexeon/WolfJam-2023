extends Camera2D

# Get the player
@export var player : CharacterBody2D;

# Smoothing
@export var smoothing : float;
@export var base_screen_shake : float;
@export var shooting_screen_shake : float;
@export var screen_shake_decay : float;

# Check if ready
var game_ready : bool = false;

var screen_shake_amount : float = base_screen_shake;


## Start following the player
func _ready() -> void:
	game_ready = true;
	player.shoot_shake.connect(_shoot_shake);
	global_position = player.camera_pos.global_position;


## Follow the player
func _physics_process(delta: float) -> void:
	
	# Exit early if game not ready
	if(!game_ready):
		return;
	
	global_position = lerp(global_position, ((player.camera_pos.global_position - global_position) * delta) + global_position, smoothing);
	screen_shake_amount = lerpf(screen_shake_amount, base_screen_shake, screen_shake_decay);
	shake_screen(1.0);


func shake_screen(intensity : float) -> void:
	global_position += Vector2(randf_range(screen_shake_amount * -1, screen_shake_amount), randf_range(screen_shake_amount * -1, screen_shake_amount)) * intensity;

func _shoot_shake() -> void:
	screen_shake_amount += shooting_screen_shake;
