extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@export var Wait_time : int = 1
@export var Gravity : int = 300
@export var Speed : int = 900

var direction: Vector2 = Vector2.LEFT
@export var patrol_points : Node
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int
enum State { Idle, Run}
var current_state :  State
var can_walk : bool

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else: 
		print("no point nodes")
	current_state = State.Idle
	timer.wait_time =  Wait_time

func _physics_process(delta: float):
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_run(delta)
	
	move_and_slide()
	
	enemy_animations()

func enemy_gravity(delta:float):
	velocity.y += Gravity * delta

func enemy_idle(delta:float):
	
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, Speed * delta)
		current_state = State.Idle

func enemy_run(delta:float):
	if !can_walk:
		return

	if abs(position.x -current_point.x) > 0.5:
		velocity.x = direction.x * Speed * delta
		current_state = State.Run
	else:
		current_point_position += 1
		if current_point_position >= number_of_points:
			current_point_position = 0
	
		current_point = point_positions[current_point_position]
	
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		can_walk = false
		timer.start()

	
	animated_sprite_2d.flip_h = direction.x > 0

func enemy_animations():
	if current_state == State.Idle and !can_walk:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run and can_walk:
		animated_sprite_2d.play("Run")

func _on_timer_timeout() -> void:
	can_walk = true
