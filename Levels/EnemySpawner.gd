extends Node2D

# Exports
var player : CharacterBody2D;
var tilemap : TileMap;

# Variables
var spawn_count : int;
var points : float = 0.0;
var points_per_sec : float = 0.3;
var basic_cost : int = 1;
var flanker_cost : int = 2;

# Files
var enemy_file : PackedScene = preload("res://Enemies/enemy.tscn");
var navigation_map : RID;

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

func _game_ready(new_player : CharacterBody2D, new_tilemap : TileMap) -> void:
	spawn_count = get_child_count();
	player = new_player;
	tilemap = new_tilemap;
	
	navigation_map = tilemap.get_navigation_map(0);
	
	create_enemy(EnemyType.FLANKER);


func create_enemy(type : EnemyType) -> void:
	var enemy_inst : CharacterBody2D = enemy_file.instantiate();
	root_node.add_child(enemy_inst);
	enemy_inst.global_position = get_child(randi_range(0, spawn_count - 1)).global_position;
	enemy_inst.initialize(player, type, navigation_map);


func calculate_spawn() -> void:
	pass
