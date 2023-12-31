extends CharacterBody2D
@export var move_speed:int = 600
@export var jump_speed:int = 50
@export var gravity:float = 75
@export var friction:float = 50
@export var acceleration:float = 100
@export var jump_strength_burst:float = 1250
@export var coyote_time:int = 30
var ct_remaining:int = 0

var close_to_lamp = null
var has_firefly:bool = false
@onready var firefly = $firefly
var close_to_object = null
var is_carrying:bool = false
var can_petrify = null

var left_input_buffer:bool = false
var jumps:int = 2
const MAX_JUMPS = 2

@onready var i_sign = $interact_sign
@onready var sprite = $sprite

@onready var sfx_petrify = $petrify_sound
@onready var sfx_run = $run_sound
@onready var sfx_jump = $jump_sound
var run_sound_delay:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$firefly/fly.play("wuw")
	$firefly/buzz.play("bzz")
	i_sign.visible = false
	firefly.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if close_to_lamp != null and firefly.visible:
		i_sign.visible = true
		i_sign.text = "[Action] Dissipate Darkness"
	elif close_to_object != null and is_carrying == false:
		i_sign.visible = true
		i_sign.text = "[Action] Take object"
	elif is_carrying and can_petrify != null:
		if can_petrify.happy == false:
			i_sign.visible = true
			i_sign.text = "[Action] Petrify"
	else :
		i_sign.visible = false
			
			
func _physics_process(delta):
	var dir = get_input()
	if dir != Vector2.ZERO:
		sprite.set_flip_h(dir.x > 0)
		if ct_remaining > 0:
			if sprite.animation == "idle":
				sprite.play("run")
			if run_sound_delay > 0:
				run_sound_delay -= delta
			else:
				sfx_run.play()
				run_sound_delay = 0.4	
		accelerate(dir)
	else:
		if sprite.animation == "run":
			sprite.play("idle")
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
		sfx_jump.play()
	elif Input.is_action_just_pressed("jump") and is_on_wall_only():
		velocity.y = -jump_strength_burst
		velocity.x = -get_which_wall_collided() * move_speed*2
		ct_remaining = 0
		sfx_jump.play()
	else:
		velocity.y += gravity
		
func _input(event):
	if Input.is_action_just_pressed("interact"):
		if close_to_lamp != null and firefly.visible:
			close_to_lamp.lightup()
			firefly.visible = false
		elif close_to_object != null and is_carrying == false:
			close_to_object.is_carried = true
			is_carrying = true
		elif is_carrying and can_petrify != null:
			if can_petrify.happy == false:
				can_petrify.petrify()
				sfx_petrify.play()
				close_to_object.queue_free()
				is_carrying = false
		elif is_carrying:
			close_to_object.is_carried = false
			is_carrying = false
			close_to_object = null

func accelerate(direction):
	var horvel = velocity.move_toward(direction * move_speed,acceleration)
	velocity.x = horvel.x
	
func add_friction():
	var horvel = velocity.move_toward(Vector2.ZERO,friction)
	velocity.x = horvel.x

func finds_object(object):
	if close_to_object == null and is_carrying == false:
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
	velocity.y = -1300
	body.shrink()
