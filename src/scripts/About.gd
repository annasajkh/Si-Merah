extends Control


var start = true

func _ready():
	$RichTextLabel.percent_visible = 0

func _process(_delta):
	if $RichTextLabel.percent_visible<1:
		$RichTextLabel.percent_visible+=0.002
		if start:
			$text_timer.start()
			start = false
	else:
		$text_timer.stop()
func _on_Back_pressed():
	if get_tree().change_scene("res://src/scenes/Menu.tscn") != OK:
		print("scene tidak ditemukan")


func _on_text_timer_timeout():
	$text.play()
