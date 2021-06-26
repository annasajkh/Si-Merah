extends Area2D

export var speed_down = 6
export var speed_up = 1
var buk_velocity = 0
var hit = false
var camera 
var is_camera_shake = false
var is_shake_time_running = true
var damage = 30
var is_on_screen = false
var shake_power = 1


func _ready():
	if Player_Data.level == 8:
		shake_power = 3
		camera = $"../../Camera2D"
		buk_velocity = speed_down
	else:
		camera = $"../../".get_node("Player/Camera2D")
func _process(delta):
	if is_camera_shake && is_on_screen:
		camera.set_offset(Vector2(rand_range(-shake_power,shake_power),rand_range(-shake_power,shake_power)))
		if is_shake_time_running:
			$ShakeTime.start()
			is_shake_time_running = false
	if Player_Data.die && Player_Data.level == 8:
		queue_free()
	if hit && !Player_Data.hurt:
		Player_Data.health-=damage
		Player_Data.hit = true
	position.y += buk_velocity * 100 * delta

func _on_Timer_timeout():
	if Player_Data.level != 8:
		buk_velocity = speed_down

func _on_Buk_body_entered(body):
	if body.name == "Player":
		hit = true
		if buk_velocity>0 && !Player_Data.hurt:
			if body.position.x>position.x:
				Player_Data.knockbackX[0] = 400
			else:
				Player_Data.knockbackX[0] = -400
			Player_Data.knockbackX[1] = 10
	else:
		is_camera_shake = true
		if is_on_screen:
			$Crush.play()
		if Player_Data.level != 8:
			buk_velocity = -speed_up
		else:
			if Player_Data.is_enemy_red:
				$AnimationPlayer2.play("die")
			else:
				$AnimationPlayer.play("die")
			buk_velocity = 0

func _on_Buk_body_exited(body):
	if body.name == "Player":
		hit = false


func _on_ShakeTime_timeout():
	camera.set_offset(Vector2.ZERO)
	is_camera_shake = false
	is_shake_time_running = true


func _on_VisibilityNotifier2D_screen_entered():
	is_on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	is_on_screen = false
