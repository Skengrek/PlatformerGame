extends CharacterBody2D

@export var movement_data: PlayerMovementData
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer: Timer = $coyoteJumpTimer
@onready var starting_position = global_position

var air_jump = 0

func _physics_process(delta: float) -> void:
	var input_axis := Input.get_axis("ui_left", "ui_right")
	apply_gravity(delta)
	handle_jump(delta)
	handle_movment(delta, input_axis)
	update_animation(input_axis)
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall()
	move_and_slide()
	var just_left_floor = was_on_floor and not is_on_floor() and velocity.y >= 0.0
	if just_left_floor:
		coyote_jump_timer.start()
	var just_left_wall = was_on_wall and not is_on_wall() and velocity.y >= 0.0
	
func handle_jump(delta):
	if is_on_floor():
		air_jump = 0
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() or coyote_jump_timer.time_left>0.0:
			velocity.y = movement_data.jump_velocity                
		elif is_on_wall():
			var wall_normal = get_wall_normal()
			velocity.y = movement_data.jump_velocity
			velocity.x = wall_normal.x * movement_data.speed
		else:
			if air_jump < movement_data.nb_air_jump:
				velocity.y = movement_data.jump_velocity
				air_jump += 1
	
func handle_movment(delta, input_axis):
	if input_axis:
		velocity.x = move_toward(velocity.x, movement_data.speed*input_axis, movement_data.acceleration*delta)
	else:
		var friction = movement_data.friction
		if not is_on_floor():
			friction = movement_data.air_friction
		velocity.x = move_toward(velocity.x, 0, friction*delta)


func apply_gravity(delta):
	"""
	Always apply gravity unless you are on a wall
	"""
	var gravity =  get_gravity() * movement_data.gravity_scale
	if is_on_wall() and velocity.y >= 0:
		velocity += gravity * delta / 10
	else:
		velocity += gravity * delta


func update_animation(input_axis):
	if velocity.x != 0:
		animated_sprite_2d.flip_h = (velocity.x < 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		if is_on_wall():
			var wall_normal = get_wall_normal()
			print(wall_normal)
			animated_sprite_2d.play("walled")
		else:
			animated_sprite_2d.play("jump")


func _on_hitbox_area_entered(area: Area2D) -> void:
	global_position = starting_position
