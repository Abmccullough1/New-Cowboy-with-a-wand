extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var wand = true
var wand_cool_down = true
var arrow = preload("res://scenes/arrow.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
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



