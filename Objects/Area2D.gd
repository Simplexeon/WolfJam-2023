extends Area2D

# File Vars
@onready var fire_file : PackedScene = preload("res://Objects/FireSiphonEffect.tscn");


# Processes

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.enemy_dead.connect(get_parent()._fed_fire);
	if body is Enemy or body is BigEnemy:
		get_parent().enemies += 1;


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.enemy_dead.disconnect(get_parent()._fed_fire);
	if body is Enemy or body is BigEnemy:
		if(body.is_queued_for_deletion()):
			var FireEffect : FireSiphonEffect2D = fire_file.instantiate();
			FireEffect.initialize(body.global_position, get_parent());
			get_tree().current_scene.call_deferred("add_child", FireEffect);
		get_parent().enemies = max(get_parent().enemies - 1, 0);
