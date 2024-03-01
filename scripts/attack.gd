extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var attack_speed = 300.0

	var attack = Input.get_vector("attack","attack","attack","attack")
	if attack:
		velocity.x = attack * attack_speed


