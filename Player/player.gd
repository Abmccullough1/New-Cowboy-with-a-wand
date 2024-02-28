extends CharacterBody2D
var health= 100
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var wand = true
var wand_cool_down = true
var arrow = preload("res://scenes/arrow.tscn")
var bad_guy = preload("res://scenes/bad_guy.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	update_health()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		$AnimatedSprite2D.play("Run")
		velocity.x = direction.x * SPEED
	else:
		$AnimatedSprite2D.play("Idle")
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
		
func update_health():
	var health_bar = $Health
	health_bar.value = health
	


func _on_timer_timeout():
	if health <100:
		health = health + 10
		if health >100:
			health = 100
	if health<=0:
		health = 0

func take_damage():
	if health > 0:
		health = health - 10
		update_health()
		
func _on_area_2d_area_entered(area):
	var bad_guy_instance = bad_guy.instantiate()
	if bad_guy_instance:
		take_damage()
		update_health()

func _on_area_2d_area_exited(area):
	$Timer.start()
