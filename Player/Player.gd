extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const ROLL_SPEED = 120
const FRICTION = 500	# an wand langlaufen --> langsam

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

onready var animationPlayer = $AnimationPlayer
	# ..oder --> var animationPlayer = null
	# --> func _ready():
		# --> animation_player = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")
	
func _ready():
	animationTree.active = true
	
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector		# sonst rollt der char auf der stelle
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = input_vector
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO

	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func move():
	velocity = move_and_slide(velocity * MAX_SPEED)
	
func roll_state():
	velocity = roll_vector * 1.1
	animationState.travel("Roll")
	move()
	
func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE
