extends Area2D

var hit = false

func _process(_delta):
	if Player_Data.die && Player_Data.level == 8:
		queue_free()
	if hit && !Player_Data.die && !Player_Data.hurt:
		Player_Data.health -= 1
	if Player_Data.die:
		$hit.stop()
func _on_Sadis_body_entered(body):
	if body.name == "Player":
		hit = true
		if !Player_Data.hurt:
			$hit.start()

func _on_Sadis_body_exited(body):
	if body.name == "Player":
		hit = false
		if !Player_Data.hurt:
			$hit.stop()

func _on_hit_timeout():
	$Hit.play()
