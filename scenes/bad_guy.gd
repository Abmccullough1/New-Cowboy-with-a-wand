extends AnimatedSprite2D

var health = 1000
var invi = false
# Called when the node enters the scene tree for the first time.
func _ready():
	update_healthbar()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_healthbar()
	if health < 0 or health == 0:
		queue_free()
func _on_tumbletweed_area_entered(area):
	if  area.name == "Arrow":
		take_arrow_damage()
	if area.name == "super_arrow":
		take_super_arrow_damage()
func update_healthbar():
	var health_bar = $Bosshealth
	health_bar.value = health
func take_arrow_damage():
	if health > 0 :
		health-=10
func take_super_arrow_damage():
	if health> 0 :
		health -= 50
		
	
	
