extends CharacterBody2D


const START_SPEED = 300.0
const SPEED_INCREASE = 15.0
const IMPACT_STRENGTH = 0.5
const MAX_VERTICAL_RATIO = 1.0

var _current_speed = START_SPEED

signal point_scored(player)


func _ready():
	var direction_x = [-1, 1].pick_random()
	reset_ball(direction_x)
	
func _physics_process(_delta: float):
	var velocity_before = velocity
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		## 1. Rebond par rapport a la zone de contact
		#var collision = get_slide_collision(0)
		#var paddle_position = collision.get_collider().position
		#var offset_y = position.y - paddle_position.y
		#var direction_y = offset_y / 50.0
		#var direction_x = -sign(velocity_before.x)
		#var direction = Vector2(direction_x, direction_y).normalized()
		#velocity = direction * SPEED
		## 2. Rebond miroir simple
		#velocity.x = -velocity_before.x
		#velocity.y = velocity_before.y
		## 3. Rebond mix entre offset et miroir
		var collision = get_slide_collision(0)
		var paddle_position = collision.get_collider().position
		
		var normalized_offset_y = (position.y - paddle_position.y) / 50.0
		var coeff_vel_y = 1.0 + abs(normalized_offset_y) * IMPACT_STRENGTH
		
		var direction_x = -velocity_before.x
		var direction_y = velocity_before.y * coeff_vel_y
		
		var max_y = abs(direction_x) * MAX_VERTICAL_RATIO
		direction_y = clamp(direction_y, -max_y, max_y)
		
		var direction = Vector2(direction_x, direction_y).normalized()
		_current_speed += SPEED_INCREASE
		velocity = direction * _current_speed
		
	if position.y <= 110 or position.y >= 628:
		velocity.y = -velocity_before.y
		position.y = clamp(position.y, 110, 628)
		
	if position.x <= -10:
		reset_ball(1.0)
		point_scored.emit("right")
		
	if position.x >= 1162:
		reset_ball(-1.0)
		point_scored.emit("left")
		
func reset_ball(direction_x: float):
	position = Vector2(576.0, 369.0)
	
	_current_speed = START_SPEED
	
	var direction_y = randf_range(-0.5, 0.5)
	var direction = Vector2(direction_x, direction_y).normalized()
	
	velocity = direction * START_SPEED
