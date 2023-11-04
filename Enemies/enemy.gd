extends CharacterBody2D

@onready var sprite : Sprite2D = $Sprite2D;

var spriteA : Texture2D = preload("res://Art/enemies/VampireA.png");
var spriteB : Texture2D = preload("res://Art/enemies/VampireB.png");

func _ready() -> void:
	
	if(round(randf()) == 1):
		sprite.texture = spriteA;
	else:
		sprite.texture = spriteB;
