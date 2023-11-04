extends RichTextLabel

func _ready() -> void:
	text = "[center]" + str(Score.end_score) + "[/center]";
	bbcode_enabled = true;
