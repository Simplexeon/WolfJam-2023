extends TextureRect

var transition_file : PackedScene = preload("res://Objects/Transition.tscn");

func _on_timer_timeout() -> void:
	var transition_inst : Sprite2D = transition_file.instantiate();
	transition_inst.initialize(false, "none");
	get_parent().add_child(transition_inst);
	queue_free();
