extends CharacterBody2D
@export var move_speed:int = 600
@export var jump_speed:int = 50
@export var gravity:float = 100
var jump_strength:float = 0
@export var friction:float = 50
@export var acceleration:float = 100
@export var jump_strength_burst:float = 1500


var air_lock:float = 0

var left_input_buffer:bool = false
var jumps:int = 2
const MAX_JUMPS = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var dir = get_input()
	if dir != Vector2.ZERO:
		accelerate(dir)
	else:
		add_friction()
	jump(dir)
	move_and_slide()
	
		
func get_input():
	# take horizontal input
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("left","right")
	
	#flex keyboard input
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
		if left_input_buffer:
			input_dir.x = 1
		else:
			input_dir.x = -1
	else:
		if input_dir.x > 0:
			left_input_buffer = false
		elif input_dir.x < 0:
			left_input_buffer = true
	
	return input_dir
	
	
	
func jump(dir):
	if is_on_floor():
		jumps = MAX_JUMPS
	
	if Input.is_action_just_pressed("jump") and jumps > 0 and not is_on_wall_only():
		velocity.y = -jump_strength_burst
		jumps -= 1
	elif Input.is_action_just_pressed("jump") and is_on_wall_only():
		velocity.y = -jump_strength_burst
		velocity.x = -dir.x * move_speed*2
		print("walljump",velocity.x)
	else:
		velocity.y += gravity
		

func accelerate(direction):
	var horvel = velocity.move_toward(direction * move_speed,acceleration)
	velocity.x = horvel.x
	
func add_friction():
	var horvel = velocity.move_toward(Vector2.ZERO,friction)
	velocity.x = horvel.x
