extends Sprite
var speed = 1

func _process(delta):
	if Player_Data.end:
		speed = 200
	position.x-=10 * speed * delta
	if position.x<-100:
		position.x = 1050
		position.y = rand_range(40,250)
