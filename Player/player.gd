extends CharacterBody2D

# Properties
@export var Speed : float;


# Movement directions
var up : bool = false;
var down : bool = false;
var left : bool = false;
var right : bool = false;
var move_direction : Vector2 = Vector2.ZERO;


# Mouse inputs
var shoot : bool = false;
var melee : bool = false;
var mouse_pos : Vector2 = Vector2.ZERO;


# Components
@onready var gun : Node2D = $Gun;
@onready var flank : Node2D = $Flank;


func _physics_process(delta: float) -> void:
	
	# Get keyboard input
	up = Input.is_action_pressed("up");
	down = Input.is_action_pressed("down");
	left = Input.is_action_pressed("left");
	right = Input.is_action_pressed("right");
	
	# Get mouse input
	shoot = Input.is_action_just_pressed("shoot");
	melee = Input.is_action_just_pressed("melee");
	mouse_pos = get_global_mouse_position();
	
	
	# Get movement direction
	move_direction = GetMovementDirection();
	
	
	# Rotate the player to face the mouse
	global_rotation = (mouse_pos - global_position).angle();
	
	# Move the player
	velocity = move_direction * Speed;
	move_and_slide();
	
	# Shoot
	if(shoot):
		gun.shoot(mouse_pos);
	


## Get the current movement direction on the player.
func GetMovementDirection() -> Vector2:
	var result : Vector2 = Vector2.ZERO;
	if(up):
		result.y -= 1;
	if(down):
		result.y += 1;
	if(left):
		result.x -= 1;
	if(right):
		result.x += 1;
	return result.normalized();
