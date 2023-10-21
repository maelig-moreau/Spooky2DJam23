extends CharacterBody2D
@export var move_speed:int = 600
@export var jump_speed:int = 50
@export var gravity:float = 75
var jump_strength:float = 0
@export var friction:float = 50
@export var acceleration:float = 100
@export var jump_strength_burst:float = 1300
@export var coyote_time:int = 30
var ct_remaining:int = 0

var close_to_lamp = null
var has_firefly:bool = false
@onready var firefly = $firefly
var close_to_object = null

var air_lock:float = 0

var left_input_buffer:bool = false
var jumps:int = 2
const MAX_JUMPS = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	$firefly/fly.play("wuw")
	$firefly/buzz.play("bzz")

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
		ct_remaining = coyote_time
	elif ct_remaining > 0:
		jumps = MAX_JUMPS
		ct_remaining -= 1
	
	if Input.is_action_just_pressed("jump") and jumps > 0 and not is_on_wall_only():
		velocity.y = -jump_strength_burst
		ct_remaining = 0
		jumps -= 1
	elif Input.is_action_just_pressed("jump") and is_on_wall_only():
		velocity.y = -jump_strength_burst
		velocity.x = -get_which_wall_collided() * move_speed*2
		ct_remaining = 0
	else:
		velocity.y += gravity
		
func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("interact"):
			if close_to_lamp != null and firefly.visible:
				close_to_lamp.lightup()
				firefly.visible = false
			elif close_to_object != null:
				close_to_object.is_carried = true

func accelerate(direction):
	var horvel = velocity.move_toward(direction * move_speed,acceleration)
	velocity.x = horvel.x
	
func add_friction():
	var horvel = velocity.move_toward(Vector2.ZERO,friction)
	velocity.x = horvel.x

func finds_object(object):
	if close_to_object == null:
		close_to_object = object

func get_which_wall_collided():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_normal().x > 0:
			return -1
		elif collision.get_normal().x < 0:
			return 1
	return 0

func _on_bouncer_body_entered(body):
	jumps = MAX_JUMPS
	velocity.y = -1500
	body.shrink()
