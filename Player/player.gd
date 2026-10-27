extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const Gravity = 1000
@export var speed : int = 500
@export var jump: int = -400
@export var jumpx: int = 15000
enum State { Idle, Run, Jump}
var current_state: State

func _ready():
	current_state = State.Idle

func _physics_process(delta: float):
	player_falling(delta)
	player_Idle(delta)
	player_jump(delta)
	player_run(delta)

	
	move_and_slide()
	
	player_animations()

func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += Gravity * delta
		current_state = State.Jump


func player_Idle(delta: float):
	if is_on_floor():
		current_state = State.Idle

func player_run(delta: float):
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed*delta)
		
	if direction != 0 and is_on_floor():

		current_state = State.Run

		animated_sprite_2d.flip_h = false if direction > 0 else true

func player_jump(delta: float):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump
		current_state = State.Jump
	if !is_on_floor() and current_state == State.Jump:
		var direction :  float = Input.get_axis("move_left", "move_right")
		velocity.x += direction * delta * jumpx
		

func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("Run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("Jump")

func input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
