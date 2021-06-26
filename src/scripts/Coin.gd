extends Area2D

var taken = false

func _on_Coin_body_entered(body):
	if body.name == "Player" && !taken:
		Player_Data.coin+=1
		$AnimatedSprite.stop()
		$FadedAnim.play("faded")
		taken = true
