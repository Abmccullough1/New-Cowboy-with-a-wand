extends CharacterBody2D
var health= 100
const SPEED = 300
var invincible = false
const JUMP_VELOCITY = -500
var wand = true
var wand_cool_down = true
var arrow = preload("res://scenes/arrow.tscn")
var super_arrow = preload("res://scenes/super_arrow.tscn")
var bad_guy = preload("res://scenes/bad_guy2.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var mana = 100
var animation_lock = false

func _physics_process(delta):
	update_health()
	update_mana_bar()
	var direction = Input.get_vector("left", "right", "up", "down")
	if invincible == false:
		# Add the gravity.
		if not is_on_floor():
			animation_lock = true
			$AnimatedSprite2D.play("jump")
			velocity.y += gravity * delta
		else:
			animation_lock = false
			
			
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
			print(velocity.y)
			#if velocity.y == 0:
				#$AnimatedSprite2D.play("jump")
			#elif velocity.y >0:
				#$AnimatedSprite2D.play("jump_down")
			#elif velocity.y < 0:
				#$AnimatedSprite2D.play("jump_up")
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if animation_lock == false:
			if direction:
				$AnimatedSprite2D.play("Run")
				velocity.x = direction.x * SPEED
			else:
				$AnimatedSprite2D.play("Idle")
				velocity.x = move_toward(velocity.x, 0, SPEED)
	else:  
		print(invincible)
		if not is_on_floor():
			velocity.y += gravity * delta
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if direction:
			velocity.x = direction.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if direction.x >0:
		animated_sprite_2d.flip_h = false
	elif direction.x < 0 :
		animated_sprite_2d.flip_h = true
		

	move_and_slide()
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("attack") and wand and wand_cool_down:
		wand_cool_down = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		await get_tree().create_timer(0.4).timeout
		wand_cool_down = true
	if Input.is_action_just_pressed("super attack") and wand and wand_cool_down and  mana > 25 or mana == 25:
		wand_cool_down=false
		mana -= 25
		var super_arrow_instance = super_arrow.instantiate()
		super_arrow_instance.rotation = $Marker2D.rotation
		super_arrow_instance.global_position = $Marker2D.global_position
		add_child(super_arrow_instance)
		await get_tree().create_timer(0.4).timeout
		wand_cool_down = true
		$Timer2.start()
		
	if Input.is_action_just_pressed("heal"):
		heal()
	if Input.is_action_just_pressed("mana"):
		health_for_mana()
		
		
		
		
		
func update_health():
	var health_bar = $Health
	health_bar.value = health	
func update_mana_bar():
	var mana_bar = $Mana
	mana_bar.value = mana
func take_damage():
	if health > 0:
		health = health - 10
		$AnimatedSprite2D.play("Invincible")
		$invincible.start()
		invincible=true
func death():
	if health < 0 or health == 0:
		$AudioStreamPlayer2D.play()
func _on_area_2d_area_entered(area):
	
	if  area.name == "tumbletweed" and  invincible!=true:
		take_damage()
		
			
	death()
func _on_invincible_timeout():
	invincible = false
func heal(): 
	if mana ==25  or mana > 25 and health!=100 or health>100:
		health += 25
		mana -=25
		$Timer2.start()
	else:
		print("no mana")

func _on_timer_2_timeout():
	mana += 10
	if mana > 100:
		mana = 100

func health_for_mana():
	if health < 25  or mana == 100 or health == 25:
		pass
	else:
		health -=25
		mana += 25
