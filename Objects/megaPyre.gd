extends Node2D
class_name MegaPyre

var current_scale : float = 0.5;
var max_scale : float = 2.5;
var dim_rate : float = 0.04;
var pyre_increase_rate : float = 1.05;

# Components
@onready var light : PointLight2D = $PointLight2D;
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D;
@onready var area_2d : CollisionShape2D = $Area2D/CollisionShape2D;
@onready var label : RichTextLabel = $Label;
@onready var label_timer : Timer = $LabelTimer;

var shrinking : bool = false;
var text : bool = true;
var text_fade_timer : float = 0.0;

func _ready() -> void:
	light.texture_scale = lerp(0.0, max_scale, current_scale);


func _physics_process(delta: float) -> void:
	
	if(!shrinking):
		return;
	
	if(text):
		text_fade_timer += 1.0 * delta;
		label.modulate.a = lerp(label.modulate.a, 0.0, text_fade_timer);
		if(label.modulate.a <=0.04):
			label.queue_free();
			text = false;
	
	light.texture_scale = lerp(0.0, max_scale, current_scale);
	current_scale -= dim_rate * delta;
	audio_player.max_distance = 200 * current_scale;
	if(current_scale < 0.05):
		var next_pyre : Node2D = load("res://Objects/megaPyre.tscn").instantiate();
		var parent : Node2D;
		while(parent == get_parent() or parent == null):
			parent = get_parent().get_parent().get_child(randi_range(0, 5));
		parent.add_child(next_pyre);
		next_pyre.global_position = parent.global_position;
		queue_free();


func _fed_fire() -> void:
	if(!shrinking):
		label_timer.start();
		shrinking = true;
		text = true;
	current_scale = current_scale * pyre_increase_rate;


func _on_audio_stream_player_2d_finished() -> void:
	audio_player.play();



func _on_label_timer_timeout() -> void:
	pass # Replace with function body.
