extends Node2D

signal game_start(player : CharacterBody2D);

# Components
@onready var enemy_spawner : Node2D = $EnemySpawner;
@onready var player : CharacterBody2D = $PlayerCharacter;

func _ready() -> void:
	#connect("game_start", CreateNode._on_game_start);
	game_start.emit(player);
