extends StaticBody2D

var current_scale : float = 0.5;
var max_scale : float = 2.5;
var dim_rate : float = 0.07;
var pyre_increase_rate : float = 1.05;

# Components
@onready var light : PointLight2D = $PointLight2D;
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D;
@onready var area_2d : CollisionShape2D = $Area2D/CollisionShape2D;


var mega_pyre_file : PackedScene = preload("res://Objects/megaPyre.tscn");

var shrinking : bool = false;

func _ready() -> void:
	light.texture_scale = current_scale;


func _physics_process(delta: float) -> void:
	
	if(!shrinking):
		return;
	
	light.texture_scale = lerp(0.0, max_scale, current_scale);
	current_scale -= dim_rate * delta;
	audio_player.max_distance = 200 * current_scale;
	area_2d.shape.radius = 323 * current_scale;
	if(current_scale < 0.05):
		var next_pyre : StaticBody2D = mega_pyre_file.instantiate();
		var parent : Node2D = get_parent().get_parent().get_child(randi_range(0, 5));
		parent.add_child(next_pyre);
		next_pyre.global_position = parent.global_position;
		queue_free();


func _fed_fire() -> void:
	if(!shrinking):
		shrinking = true;
	current_scale = current_scale * pyre_increase_rate;


func _on_audio_stream_player_2d_finished() -> void:
	audio_player.play();


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.enemy_dead.connect(_fed_fire);


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.enemy_dead.disconnect(_fed_fire);
