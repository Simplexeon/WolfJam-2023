extends StaticBody2D

var current_scale : float = 1.0;
var max_scale : float = 1.0;
var dim_rate : float = 1.0;

# Components
@onready var light : PointLight2D = $PointLight2D;

func initialize(set_texture_size : float, set_dim_rate : float = dim_rate):
	max_scale = set_texture_size;
	light.texture_scale = set_texture_size;
	dim_rate = set_dim_rate;


func _physics_process(delta: float) -> void:
	light.texture_scale = lerp(0.0, max_scale, current_scale);
	current_scale -= dim_rate * delta;
	if(current_scale < 0.05):
		queue_free();
