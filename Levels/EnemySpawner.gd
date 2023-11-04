extends Node2D

# Exports
var player : CharacterBody2D;

# Variables
var spawn_count : int;

# Files
var enemy_file : PackedScene = preload("res://Enemies/enemy.tscn");

# Components
var root_node : Node2D;

# Enemy Types
enum EnemyType {
	BASIC,
	FLANKER
}

func _ready() -> void:
	root_node = get_tree().current_scene;
	root_node.game_start.connect(_game_ready);

func _game_ready(new_player : CharacterBody2D) -> void:
	spawn_count = get_child_count();
	player = new_player;
	
	create_enemy(EnemyType.BASIC);


func create_enemy(type : EnemyType) -> void:
	var enemy_inst : CharacterBody2D = enemy_file.instantiate();
	root_node.add_child(enemy_inst);
	enemy_inst.global_position = get_child(randi_range(0, spawn_count - 1)).global_position;
	enemy_inst.initialize(player, type);
