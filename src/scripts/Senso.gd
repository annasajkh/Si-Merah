extends Area2D

export var velocityX = 1.0
export var speed = 1.0
var hit = false

onready var right = $Right
onready var left = $Left
var damage = 20

func _ready():
	$Sprite/AnimationPlayer.playback_speed = speed

func _physics_process(_delta):
	if Player_Data.die && Player_Data.level == 8:
		queue_free()
	if !right.is_colliding():
		velocityX = -speed
	if !left.is_colliding():
		velocityX = speed
	position.x +=velocityX
	if hit && !Player_Data.hurt:
		Player_Data.hit = true
		Player_Data.health -=damage
	if velocityX<0:
		$Sprite/AnimationPlayer.play_backwards("spin")
	else:
		$Sprite/AnimationPlayer.play("spin")
func _on_Senso_body_entered(body):
	if body.name == "Player" && !Player_Data.die:
		hit = true


func _on_RightWall_body_entered(body):
	if body.name != "Player":
		velocityX = -speed

func _on_LeftWall_body_entered(body):
	if body.name != "Player":
		if Player_Data.level != 8:
			velocityX = speed
		else:
			queue_free()

func _on_Senso_body_exited(body):
	if body.name == "Player":
		hit = false
