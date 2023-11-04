extends PointLight2D

var current_scale : float = 1.0;
var max_scale : float = 1.0;
var dim_rate : float = 1.0;


func initialize(set_texture_size : float, set_dim_rate : float):
	max_scale = set_texture_size;
	texture_scale = set_texture_size;
	dim_rate = set_dim_rate;


func _physics_process(delta: float) -> void:
	texture_scale = lerp(0.0, max_scale, current_scale);
	current_scale -= dim_rate * delta;
	if(current_scale < 0.05):
		queue_free();
