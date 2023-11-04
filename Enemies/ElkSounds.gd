extends Area2D

@onready var gremlin_maxing : AudioStreamPlayer2D = $GremlinMaxing;

var player_in_range : bool = false;


func _physics_process(delta: float) -> void:
	if(player_in_range and !gremlin_maxing.playing and randf() > .9):
		gremlin_maxing.play();


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		gremlin_maxing.play();
		player_in_range = true;


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false;;
