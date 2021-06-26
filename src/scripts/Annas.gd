extends Node2D

####################
#      Annas       #
####################
onready var annas = $Annas
var n = 0
var amplitude = 4
var freq = 0.4


func _on_change_color_timeout():
	annas.position.y = sin(n * freq)*amplitude
	n+=1
	if n == 1000:
		n = 0
	$Label.add_color_override("font_color",Color(randf(),randf(),randf(),1))
