extends CharacterBody2D
class_name Enemy;

# Parameters
@export var speed : float = 100.0;
@export var hp : int = 2;


# Components
@onready var sprite : Sprite2D = $Sprite2D;
@onready var navigation : Node2D = $Navigation;
@onready var damage_light : PointLight2D = $DamageLight;
@onready var damage_timer : Timer = $DamageTimer;

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
		
	damage_light.visible = false;


func _physics_process(delta: float) -> void:
	
	# Move
	velocity = navigation.get_next_pos() * speed;
	move_and_slide()


func damage() -> void:
	hp -= 1;
	damage_light.visible = true;
	damage_timer.start();
	if(hp < 1):
		queue_free();


func _on_damage_timer_timeout() -> void:
	damage_light.visible = false;
