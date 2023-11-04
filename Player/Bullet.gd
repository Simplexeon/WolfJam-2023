extends Area2D

# Info
var direction : Vector2 = Vector2.ZERO;
var speed : float = 0.0;

# Components
@onready var timer : Timer = $Timer;

# Triggers
var initialized : bool = false;

## Setup the bullet
func instantiate(start_pos : Vector2, bullet_dir : Vector2, bullet_speed : float, bullet_lifetime : float) -> void:
	global_position = start_pos;
	direction = bullet_dir;
	speed = bullet_speed;
	initialized = true;
	timer.start(bullet_lifetime);


## Move every frame
func _physics_process(delta: float) -> void:
	
	# Exit early if not setup
	if(!initialized):
		return;
	
	# Move
	global_position += direction * speed * delta;


## Delete the bullet
func _on_timer_timeout() -> void:
	queue_free();
