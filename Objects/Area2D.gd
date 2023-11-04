extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.enemy_dead.connect(get_parent()._fed_fire);


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.enemy_dead.disconnect(get_parent()._fed_fire);
