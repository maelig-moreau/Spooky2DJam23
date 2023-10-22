extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func shrink():
	$AnimationPlayer.play("bounce")
	$platform_shape.set_deferred("disabled",true)
	$Timer.start()
	$sound.play()


func _on_timer_timeout():
	visible = true
	$AnimationPlayer.play("idle",0.2)
	$platform_shape.set_deferred("disabled",false)
