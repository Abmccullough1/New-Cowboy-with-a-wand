extends CharacterBody2D



var health = 50
var invi = false
func _ready():
	boss_music()

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	print(health)
	update_healthbar()
func update_healthbar():
	var health_bar = $Bosshealth
	health_bar.value = health
	
func take_arrow_damage():
	if health > 0 :
		health-=10
func take_super_arrow_damage():
	if health> 0 :
		health -= 50
func death():
	if health < 0 or health == 0:
		$Boss_music.stop()
		$victory.play()
		await get_tree().create_timer(10).timeout
		$AnimatedSprite2D.play("death")
		await get_tree().create_timer(1).timeout		
		queue_free()
func _on_tumbletweed_area_entered(area):
	if  area.name == "Arrow":
		take_arrow_damage()
	if area.name == "super_arrow":
		take_super_arrow_damage()
	death()

func boss_music():
	$Boss_music.play()



	
