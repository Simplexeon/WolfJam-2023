extends Node2D

# Properties
@export var spread : float;
@export var max_range : float;
@export var min_range : float;
@export var bullet_count : int;
@export var bullet_lifetime : float;


# Components
@onready var cooldown_timer : Timer = $CDTimer;
@onready var gun_head : Node2D = $GunHead;


var bullet_scene : PackedScene = preload("res://Player/Bullet.tscn");


func shoot(mouse_pos : Vector2) -> void:
	
	# If on cooldown, return early
	if(cooldown_timer.is_stopped()):
		return;
	
	# Spawn bullets
	var i : int = 0;
	while(i < bullet_count):
		
		# Get angle variance
		var angle : float = lerp(spread * -1, spread, randf());
		var bullet_dir : Vector2 = (mouse_pos - gun_head.global_position).normalized();
		bullet_dir = bullet_dir.rotated(deg_to_rad(angle));
		
		# Get distance variance
		var bullet_speed : float = lerp(min_range, max_range, randf());
		
		# Create the bullet
		var bullet_instance : Area2D = bullet_scene.instantiate();
		CreateNode.root.add_child(bullet_instance);
		bullet_instance.instantiate(gun_head.global_position, bullet_dir, bullet_speed, bullet_lifetime);
		
		# Increment the loop
		i += 1;
	
	# Start cooldown
	cooldown_timer.start();
