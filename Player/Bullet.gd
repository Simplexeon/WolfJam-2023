extends Area2D

# Parameters
@export var max_rotation_speed : float = 1200.0;
@export var min_rotation_speed : float = 400.0;

# Info
var direction : Vector2 = Vector2.ZERO;
var speed : float = 0.0;

# Components
@onready var timer : Timer = $Timer;
@onready var sprite : Sprite2D = $Sprite2D;

# Triggers
var initialized : bool = false;
var rotation_speed : float = 0.0;
var rotation_dir : int = 0;

## Setup the bullet
func initialize(start_pos : Vector2, bullet_dir : Vector2, bullet_speed : float, bullet_lifetime : float) -> void:
	
	# Movement
	global_position = start_pos;
	direction = bullet_dir;
	speed = bullet_speed;
	
	# Rotation
	rotation_speed = lerp(min_rotation_speed, max_rotation_speed, randf());
	rotation_dir = 1 * (-1 * randi_range(0, 1));
	
	# Sprite
	sprite.frame = randi_range(0, 3);
	
	# Finalize
	initialized = true;
	timer.start(bullet_lifetime);


## Move every frame
func _physics_process(delta: float) -> void:
	
	# Exit early if not setup
	if(!initialized):
		return;
	
	# Move
	global_position += direction * speed * delta;
	
	# Rotate
	global_rotation_degrees += rotation_speed * float(rotation_dir) * delta;


## Delete the bullet
func _on_timer_timeout() -> void:
	queue_free();
