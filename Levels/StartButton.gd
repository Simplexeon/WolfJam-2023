extends TextureButton

var transition_file : PackedScene = preload("res://Objects/Transition.tscn");

func _on_pressed() -> void:
	var transition_inst : Sprite2D = transition_file.instantiate();
	transition_inst.initialize(true, "res://Levels/main.tscn");
	get_parent().add_child(transition_inst);
	
