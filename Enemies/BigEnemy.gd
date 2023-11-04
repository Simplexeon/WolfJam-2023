extends CharacterBody2D

# Signals
signal died(death_pos : Vector2);


# Parameters
@export var speed : float = 100.0;
@export var hp : int = 2;


# Components
@onready var sprite : Sprite2D = $Sprite2D;
@onready var navigation : Node2D = $Navigation;
@onready var damage_light : PointLight2D = $DamageLight;
@onready var damage_timer : Timer = $DamageTimer;

# Files
var light_dissipation_file : PackedScene = preload("res://Objects/LightDimmer.tscn");
var pyre_file : PackedScene = preload("res://Objects/pyre.tscn");

func initialize(player : CharacterBody2D, type : int) -> void:
	
	
	# Set AI
	navigation.initialize(player, type);
	
	# Connect signals
	died.connect(player._on_enemy_died);
	
	damage_light.visible = false;


func _physics_process(delta: float) -> void:
	
	# Move
	var move_dir : Vector2 = navigation.get_next_pos();
	global_rotation = move_dir.angle();
	
	velocity = move_dir * speed;
	move_and_slide()


func damage() -> void:
	hp -= 1;
	damage_light.visible = true;
	damage_timer.start();
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


func _on_damage_timer_timeout() -> void:
	damage_light.visible = false;
