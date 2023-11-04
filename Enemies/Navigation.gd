extends Node2D

# Components
@onready var agent : NavigationAgent2D = $NavigationAgent2D;
@onready var timer : Timer = $NavigationTimer;
var player : CharacterBody2D;
var movement_dir : Vector2 = Vector2.ZERO;
var type : int = 0;

func initialize(set_player : CharacterBody2D, set_type : int, nav_map : RID) -> void:
	player = set_player;
	agent.set_navigation_map(nav_map);
	if(set_type > 0):
		agent.set_navigation_layer_value(2, true);
	
	timer.start();

func get_next_pos() -> Vector2:
	return movement_dir;

func _on_navigation_timer_timeout() -> void:
	agent.target_position = player.global_position;
	
	movement_dir = (agent.get_next_path_position() - global_position).normalized();

