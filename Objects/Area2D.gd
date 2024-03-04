extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.enemy_dead.connect(get_parent()._fed_fire);
	if body is Enemy or body is BigEnemy:
		get_parent().enemies += 1;


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.enemy_dead.disconnect(get_parent()._fed_fire);
	if body is Enemy or body is BigEnemy:
		get_parent().enemies = max(get_parent().enemies - 1, 0);
