extends StaticBody2D

var current_scale : float = 1.0;
var max_scale : float = 1.0;
var dim_rate : float = 1.0;

# Components
@onready var light : PointLight2D = $PointLight2D;
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D;

func initialize(set_texture_size : float, set_dim_rate : float = dim_rate):
	max_scale = set_texture_size;
	dim_rate = set_dim_rate;


func _ready() -> void:
	light.texture_scale = max_scale;


func _physics_process(delta: float) -> void:
	light.texture_scale = lerp(0.0, max_scale, current_scale);
	current_scale -= dim_rate * delta;
	if(current_scale < 0.05):
		queue_free();


func _on_audio_stream_player_2d_finished() -> void:
	audio_player.play();
