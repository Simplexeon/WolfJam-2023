extends Node2D

@export var player : CharacterBody2D;
@export var Camera : Camera2D;
@onready var canvas : CanvasModulate = $CanvasModulate;


var death_transition_file : PackedScene = preload("res://Objects/Transition.tscn");

var fade_amount : float = 1.0;
var fade_timer : float = 0.0;

func _physics_process(delta: float) -> void:
	
	if(player.HP > 0):
		return
	
	fade_timer += fade_amount * delta;
	canvas.color.v = lerp(0.05, 1.0, fade_timer);
	canvas.color.h = lerp(canvas.color.h, 0.0, fade_timer);
	
	if(fade_timer >= 1.0):
		var transition_inst : Sprite2D = death_transition_file.instantiate();
		transition_inst.initialize(true, "res://Levels/Game Over.tscn");
		Camera.add_child(transition_inst);
		transition_inst.global_position = Camera.global_position + Vector2(-128,-128);
	
	
	
