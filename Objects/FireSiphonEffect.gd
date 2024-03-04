extends Sprite2D
class_name FireSiphonEffect2D

# Export Vars
@export var Speed : float = 0;
@export var Acceleration : float = 0;
@export var AccelerationAcceleration : float = 150;

# Object Vars
var target_dir : Vector2 = Vector2.ZERO;
var target_dist : float = 0;


# Processes

func initialize(spawn_pos : Vector2, pyre : MegaPyre) -> void:
	global_position = spawn_pos;
	var target_vector : Vector2 = (pyre.global_position - global_position);
	target_dir = target_vector.normalized();
	target_dist = target_vector.length();

func _physics_process(delta: float) -> void:
	var movement : Vector2 = target_dir * Speed * delta;
	global_position += movement;
	
	target_dist -= movement.length();
	if(target_dist <= 0):
		queue_free();
	
	Speed += Acceleration * delta;
	Acceleration += AccelerationAcceleration * delta;
