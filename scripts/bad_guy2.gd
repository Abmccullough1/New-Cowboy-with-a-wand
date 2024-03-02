extends CharacterBody2D


var health_visi = true
var health = 50
var invi = false
func _ready():
	update_healthbar()

# Called when the node enters the scene tree for the first time.
#func _physics_process(delta):
	
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
		await get_tree().create_timer(1).timeout	
		$"Bossrange".queue_free()
		$AnimatedSprite2D.queue_free()
		$tumbletweed.queue_free()
		$Bosshealth.queue_free()
		await get_tree().create_timer(10).timeout
		$victory.stop()
				
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
