extends CharacterBody2D

# Parameters
@export var speed : float = 100.0;


# Components
@onready var sprite : Sprite2D = $Sprite2D;
@onready var navigation : Node2D = $Navigation;

var spriteA : Texture2D = preload("res://Art/enemies/VampireA.png");
var spriteB : Texture2D = preload("res://Art/enemies/VampireB.png");

func initialize(player : CharacterBody2D, type : int, nav_map : RID) -> void:
	
	# Set AI
	navigation.initialize(player, type, nav_map);
	
	# Set sprite
	if(round(randf()) == 1):
		sprite.texture = spriteA;
	else:
		sprite.texture = spriteB;


func _physics_process(delta: float) -> void:
	
	# Move
	velocity = navigation.get_next_pos() * speed;
	move_and_slide()
