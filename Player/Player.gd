extends KinematicBody2D

var velocity = Vector2.ZERO
var state = MOVE
var roll_vector= Vector2.DOWN


const MAX_SPEED = 80
const acceleration = 500
const FRICTION = 500
const roll_speed = 120

onready var animationPlayer = $AnimationPlayer
onready var animationTree =$AnimationTree
onready var animationState =animationTree.get("parameters/playback")
onready var SwordHitbox = $HitboxPivot/SwordHitbox

enum{
	MOVE,
	ROLL,
	ATTACK
}



func _ready():
	animationTree.active = true
	SwordHitbox.knockback_vector = roll_vector
	

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)
	
	


func move_state(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		SwordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector) 
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position",input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, acceleration*delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	velocity = move_and_slide(velocity)
	
	
func roll_state(delta):
	velocity = roll_vector * roll_speed
	animationState.travel("Roll")
	move()

func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	state = MOVE

