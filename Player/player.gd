extends CharacterBody2D

# Properties
@export var Speed : float;
@export var KillScore : int;
@export var TimeScore : int;
@export var ScoreDisplay : RichTextLabel;
@export var Crosshair : Sprite2D;
@export var HP : int : set = set_hp;


# Movement directions
var up : bool = false;
var down : bool = false;
var left : bool = false;
var right : bool = false;
var move_direction : Vector2 = Vector2.ZERO;


# Mouse inputs
var shoot : bool = false;
var rifle : bool = false;
var mouse_pos : Vector2 = Vector2.ZERO;


# Scoring
var score : int = 0 : set = set_state;
func set_state(value):
	score = value;
	ScoreDisplay.text = str(value);
	ScoreDisplay.get_child(0).text = str(value);

var pyre_count : int = 0;


# Components
@onready var gun : Node2D = $Gun;
@onready var flank : Node2D = $Flank;
@onready var score_timer : Timer = $ScoreTimer;
@onready var camera_pos : Node2D = $CameraPos;
@onready var kill_count_timer : Timer = $KillCountTimer;
@onready var invulnerability_timer : Timer = $InvulnerabilityTimer;


# Files
var pyre_file : PackedScene = preload("res://Objects/pyre.tscn");


func _ready() -> void:
	score_timer.start();


func _physics_process(delta: float) -> void:
	
	# Get keyboard input
	up = Input.is_action_pressed("up");
	down = Input.is_action_pressed("down");
	left = Input.is_action_pressed("left");
	right = Input.is_action_pressed("right");
	
	# Get mouse input
	shoot = Input.is_action_just_pressed("shoot");
	rifle = Input.is_action_just_pressed("rifle");
	mouse_pos = get_global_mouse_position();
	
	
	# Get movement direction
	move_direction = GetMovementDirection();
	Crosshair.global_position = mouse_pos;
	
	
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


func _on_enemy_died(death_pos : Vector2) -> void:
	score += KillScore;
	
	if(kill_count_timer.wait_time <= 1):
		pyre_count += 1;
		kill_count_timer.start();
	
	if(pyre_count >= 5):
		var pyre_inst : StaticBody2D = pyre_file.instantiate();
		get_parent().call_deferred("add_child", pyre_inst);
		pyre_inst.global_position = death_pos;
		pyre_inst.initialize(1.0, 0.20);
		pyre_count = 0;
		


func set_hp(new_value : int):
	if(!is_node_ready()):
		HP = max(new_value, 0);
		return;
	if(invulnerability_timer.time_left > 0):
		return;
	HP = max(new_value, 0);
	invulnerability_timer.start();
	if(HP == 0):
		Score.end_score = score;
		get_tree().change_scene_to_file("res://Levels/Game Over.tscn");
	if(!is_node_ready()):
		return;
	Crosshair.frame = new_value - 1;


func _on_score_timer_timeout() -> void:
	score += TimeScore;


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		HP -= 1;
