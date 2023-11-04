extends AudioStreamPlayer2D


func _ready() -> void:
	play(0.5);


func _on_finished() -> void:
	queue_free();
