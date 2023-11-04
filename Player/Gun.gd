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
@onready var muzzle_flash : PointLight2D = $MuzzleFlash;
@onready var muzzle_flash_timer : Timer = $MuzzleFlashTimer;
@onready var rifle_cd_timer : Timer = $RifleCDTimer;
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer;
var root_node : Node2D;

var bullet_scene : PackedScene = preload("res://Player/Bullet.tscn");
var rifle_bullet_scene : PackedScene = preload("res://Player/RifleBullet.tscn");


func _ready() -> void:
	root_node = get_tree().current_scene;
	muzzle_flash.visible = false;


func shoot(mouse_pos : Vector2) -> void:
	
	# If on cooldown, return early
	if(!cooldown_timer.is_stopped()):
		return;
	
	# Spawn bullets
	var i : int = 0;
	while(i < bullet_count):
		
		# Get angle variance
		var angle : float = lerp(spread * -1, spread, randf());
		var bullet_dir : Vector2 = (gun_head.global_position - global_position).normalized();
		bullet_dir = bullet_dir.rotated(deg_to_rad(angle));
		
		# Get distance variance
		var bullet_speed : float = lerp(min_range, max_range, randf());
		
		# Create the bullet
		var bullet_instance = bullet_scene.instantiate();
		root_node.add_child(bullet_instance);
		bullet_instance.initialize(gun_head.global_position, bullet_dir, bullet_speed, bullet_lifetime);
		
		# Increment the loop
		i += 1;
	
	# Muzzle flash
	muzzle_flash.visible = true;
	muzzle_flash_timer.start();
	audio_player.play();
	
	# Start cooldown
	cooldown_timer.start();


func rifle(mouse_pos : Vector2) -> void:
	# If on cooldown, return early
	if(!rifle_cd_timer.is_stopped()):
		return;
	
	var bullet_dir : Vector2 = (gun_head.global_position - global_position).normalized();
	
	# Get distance variance
	var bullet_speed : float = max_range;
		
	# Create the bullet
	var bullet_instance = rifle_bullet_scene.instantiate();
	root_node.add_child(bullet_instance);
	bullet_instance.initialize(gun_head.global_position, bullet_dir, bullet_speed * 2, bullet_lifetime);
	
	
	# Muzzle flash
	muzzle_flash.visible = true;
	muzzle_flash_timer.start();
	audio_player.play();
	
	# Start cooldown
	rifle_cd_timer.start();

func _on_muzzle_flash_timer_timeout() -> void:
	muzzle_flash.visible = false;
