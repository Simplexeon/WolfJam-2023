extends Node2D

# Exports
var player : CharacterBody2D;
var tilemap : TileMap;

# Variables
var spawn_count : int;
var points : float = 6.0;
var points_per_sec : float = 0.3;
var point_growth : float = 0.012;
var queued_basics : int = 0;
var queued_bigs : int = 0;
var new_wave_timer : float = 1.5;


# Point shop vars
var wave_points_minimum : float = 6.0;
var wave_points_maximum : float = 6.0;
var next_wave_points : int = 0;


# Files
var enemy_file : PackedScene = preload("res://Enemies/enemy.tscn");
var big_enemy_file : PackedScene = preload("res://Enemies/BigEnemy.tscn");
var boss_file : PackedScene = preload("res://Enemies/Boss.tscn");
var navigation_map : RID;

# Components
var root_node : Node2D;

var boss_spawned : bool = false;
var ultra_instinct_boss : bool = false;

# Enemy Types
enum EnemyType {
	BASIC,
	BIG
}

func _ready() -> void:
	root_node = get_tree().current_scene;
	root_node.game_start.connect(_game_ready);

func _game_ready(new_player : CharacterBody2D, new_tilemap : TileMap) -> void:
	spawn_count = get_child_count();
	player = new_player;
	tilemap = new_tilemap;
	
	next_wave_points = randi_range(wave_points_minimum, wave_points_maximum);
	


func _physics_process(delta: float) -> void:
	new_wave_timer = maxf(new_wave_timer - delta, 0);
	if(new_wave_timer <= 0):
		spawn_wave();
		new_wave_timer = 1.5;
	points += points_per_sec * delta;
	points_per_sec = points_per_sec * (1 + point_growth * delta);
	wave_points_minimum += (player.score / 10000) * delta;
	wave_points_maximum += (player.score / 10000) * delta;
	calculate_spawn();
	
	if(player.score >= 15000 and !boss_spawned):
		var boss_inst : Area2D = boss_file.instantiate();
		root_node.add_child(boss_inst);
		boss_inst.initialize(player);
		boss_inst.global_position = Vector2(562, -420);
		boss_spawned = true;
		points = 0;
	
	if(player.score >= 30000 and !ultra_instinct_boss):
		var boss_inst : Area2D = boss_file.instantiate();
		root_node.add_child(boss_inst);
		boss_inst.initialize(player);
		boss_inst.global_position = Vector2(562, -420);
		boss_spawned = true;
		points = 0;
		
		boss_inst = boss_file.instantiate();
		root_node.add_child(boss_inst);
		boss_inst.initialize(player);
		boss_inst.global_position = Vector2(562, 1320);
		boss_spawned = true;


func create_enemy(type : EnemyType, pos_id : int) -> void:
	var enemy_inst : CharacterBody2D;
	match(type):
		0:
			enemy_inst = enemy_file.instantiate();
		1:
			enemy_inst = big_enemy_file.instantiate();
	root_node.add_child(enemy_inst);
	enemy_inst.global_position = get_child(pos_id).global_position;
	enemy_inst.initialize(player, type);


func calculate_spawn() -> void:
	if(points > next_wave_points):
		while(points > 0):
			if(points > 4 and randf() > .75):
				queued_bigs += 1;
				points -= 4;
				continue;
			queued_basics += 1;
			points -= 1;
		
		next_wave_points = randi_range(int(wave_points_minimum), int(wave_points_maximum));


func spawn_wave() -> void:
	var places : Array[int] = [];
	places.resize(get_child_count());
	
	var i : int = 0;
	while(i < places.size()):
		places[i] = i;
		i += 1;
	
	var spawned : int = 0;
	while(spawned <= places.size()):
		while(queued_basics > 0 and places.size() >= 1):
			var spawn_index : int = randi_range(0, places.size() - 1);
			create_enemy(EnemyType.BASIC, spawn_index);
			places.remove_at(spawn_index);
			queued_basics -= 1;
			spawned += 1;
		while(queued_bigs > 0 and places.size() >= 1):
			var spawn_index : int = randi_range(0, places.size() - 1);
			create_enemy(EnemyType.BIG, spawn_index);
			places.remove_at(spawn_index);
			queued_bigs -= 1;
			spawned += 1;
		break;
	
