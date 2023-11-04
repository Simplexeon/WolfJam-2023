extends Sprite2D

@export var animation_speed : float = 12.0;
@export var fade_to_black : bool = false;
@export var next_scene : String = "none";


var timer : float = 0.0;
var final_frame : int = 0;

var ftob_anim = preload("res://Art/Transitions/FtoB.tres");
var ftoc_anim = preload("res://Art/Transitions/FtoC.tres");

func initialize(set_ftb : bool, target_scene : String):
	fade_to_black = set_ftb;
	next_scene = target_scene;

func _ready() -> void:
	if(fade_to_black):
		texture = ftob_anim;
		hframes = 3;
		vframes = 2;
		frame = 0;
		final_frame = 5;
	else:
		texture = ftoc_anim;
		hframes = 3;
		vframes = 3;
		frame = 0;
		final_frame = 9;


func _physics_process(delta: float) -> void:
	timer += animation_speed * delta;
	frame = int(timer);
	if(int(timer) == final_frame):
		if(next_scene != "none"):
			get_tree().change_scene_to_file(next_scene);
		else:
			queue_free();
