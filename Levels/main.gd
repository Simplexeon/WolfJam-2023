extends Node2D

signal game_start(root_node : Node2D);

func _ready() -> void:
	connect("game_start", CreateNode._on_game_start);
	game_start.emit(self);
