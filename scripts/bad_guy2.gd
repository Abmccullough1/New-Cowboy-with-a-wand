extends CharacterBody2D
var speed = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health_visi = true
var health = 50
var invi = false
var JUMP = 500
var attack_player = false
var player = null
var attack_pattern = false
var boss_attack = RandomNumberGenerator.new()
func _ready():
	update_healthbar()
func _physics_process(delta):
	if attack_player == true:
		if attack_pattern == false:
			var attack = boss_attack.randi_range(1, 100)
			attack_pattern = true
			position.x =416
			position.y = -378
			await get_tree().create_timer(5).timeout
			
			attack_pattern = false
			
		
			print("this is it: " + str(attack))
		
		position += (player.position - position)/speed
		
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
func update_healthbar():
	if health_visi !=false:
		var health_bar = $Bosshealth
		health_bar.value = health
	else:
		pass
func take_arrow_damage():
	if health > 0 :
		health-=10
func take_super_arrow_damage():
	if health> 0 :
		health -= 50
	

func death():
	if health < 0 or health == 0:
		health_visi = false
		$Boss_music.stop()
		$victory.play()
		$AnimatedSprite2D.play("death")
		$Bosshealth.queue_free()
		$tumbletweed.queue_free()
		await get_tree().create_timer(1).timeout	
		$AnimatedSprite2D.queue_free()
		$CollisionShape2D.queue_free()	
		gravity = 0
		await get_tree().create_timer(10).timeout	
		$victory.stop()
		 
		$"Bossrange".queue_free()
		
				
func _on_tumbletweed_area_entered(area):
	if  area.name == "Arrow":
		take_arrow_damage()
	if area.name == "super_arrow":
		take_super_arrow_damage()
	
	update_healthbar()
	death()





	


func _on_boss_range_area_entered(area):
	if area.name == "player":
		$Boss_music.play()
	else:
		pass


func _on_boss_range_area_exited(area):
	if area.name == "player":
		$Boss_music.stop()
	else:
		pass


func _on_bossrange_body_entered(body):
	print(body.name)
	if body.name == "CharacterBody2D":
		player = body
		attack_player = true
	


func _on_bossrange_body_exited(body):
	player = null
	attack_player = false


func _on_bossrange_area_entered(area):
	if area.name == "player":
		$Boss_music.play()
	else:
		pass
