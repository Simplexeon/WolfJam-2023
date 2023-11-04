extends Area2D


# Signals
signal died(death_pos : Vector2);


# Parameters
@export var speed : float = 40.0;
@export var hp : int = 60;


# Components
@onready var sprite : Sprite2D = $Sprite2D;
@onready var animator : AnimationPlayer = $Sprite/AnimationPlayer;
var player : Player;

# Files
var light_dissipation_file : PackedScene = preload("res://Objects/LightDimmer.tscn");
var pyre_file : PackedScene = preload("res://Objects/pyre.tscn");

func initialize(set_player : CharacterBody2D) -> void:
	player = set_player;
	
	# Connect signals
	died.connect(player._on_enemy_died);
	


func _ready() -> void:
	animator.play("crawl");


func _physics_process(delta: float) -> void:
	
	# Move
	var move_dir : Vector2 = (player.global_position - global_position).normalized();
	global_rotation = move_dir.angle();
	
	global_position += move_dir * speed * delta;


func damage() -> void:
	hp -= 1;
	if(hp < 1):
		var light_dissipation_inst = light_dissipation_file.instantiate();
		get_parent().add_child(light_dissipation_inst);
		light_dissipation_inst.initialize(0.5, 0.8);
		
		var pyre_inst : StaticBody2D = pyre_file.instantiate();
		get_parent().call_deferred("add_child", pyre_inst);
		pyre_inst.global_position = global_position;
		pyre_inst.initialize(1.5, 0.20);
		
		died.emit(global_position);
		queue_free();

