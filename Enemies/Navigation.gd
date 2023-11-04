extends Node2D

# Components
@onready var agent : NavigationAgent2D = $NavigationAgent2D;
@onready var timer : Timer = $NavigationTimer;
var player : CharacterBody2D;
var movement_dir : Vector2 = Vector2.ZERO;
var type : int = 0;

func initialize(set_player : CharacterBody2D, set_type : int) -> void:
	player = set_player;
	type = set_type;
	timer.start();

func get_next_pos() -> Vector2:
	return movement_dir;

func _on_navigation_timer_timeout() -> void:
	match(type):
		0:
			agent.target_position = player.global_position;
		1:
			pass
	
	movement_dir = (agent.get_next_path_position() - global_position).normalized();
	print(str(movement_dir));

