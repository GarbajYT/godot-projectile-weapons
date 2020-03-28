extends KinematicBody

var speed = 7
var acceleration = 50
var gravity = 20
var jump = 10

var damage = 100

var mouse_sensitivity = 0.03

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

onready var head = $Head
onready var aimcast = $Head/Camera/AimCast
onready var muzzle = $Head/Gun/Muzzle

func _ready():
	pass
	
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	
	direction = Vector3()
	
	if Input.is_action_just_pressed("fire"):
		if aimcast.is_colliding():
			var bullet = get_world().direct_space_state
			var collision = bullet.intersect_ray(muzzle.transform.origin, aimcast.get_collision_point())
			
			if collision:
				var target = collision.collider
				
				if target.is_in_group("Enemy"):
					print("hit enemy")
					target.health -= damage
					
	
	if not is_on_floor():
		fall.y -= gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		
	
	if Input.is_action_pressed("move_forward"):
	
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		
		direction -= transform.basis.x			
		
	elif Input.is_action_pressed("move_right"):
		
		direction += transform.basis.x
			
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 
	move_and_slide(fall, Vector3.UP)
	
