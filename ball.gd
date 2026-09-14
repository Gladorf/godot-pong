extends CharacterBody2D


const START_SPEED = 300.0
const SPEED_INCREASE = 15.0
const IMPACT_STRENGTH = 0.5
const MAX_VERTICAL_RATIO = 1.0
const FLAT_TRAJECTORY_THRESHOLD = 0.2

var _current_speed = START_SPEED
var _stopped = false

signal point_scored(player)


func _ready():
	var direction_x = [-1, 1].pick_random()
	reset_ball(direction_x)
	
func _physics_process(_delta: float):
	# Save the velocity before move_and_slide(), because collisions can modify it.
	var velocity_before = velocity
	
	# Move the ball and let Godot detect collisions.
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		# Retrieve the first collision detected during this physics frame.
		var collision = get_slide_collision(0)
		
		# Retrieve the position of the paddle that was hit.
		var paddle_position = collision.get_collider().position
		
		# Compute where the ball hit the paddle vertically.
		# 0.0 means paddle center, about -1.0 means top edge,
		# and about +1.0 means bottom edge.
		var normalized_offset_y = (position.y - paddle_position.y) / 50.0
		
		# Mirror the horizontal component so the ball goes back
		# toward the opposite side.
		var direction_x = -velocity_before.x
		var direction_y
		
		# Coeff to determine if the trajectory is flat or not
		var vertical_ratio = abs(velocity_before.y / velocity_before.x)
		
		# Test if the trajectory is almost flat or not
		if vertical_ratio < FLAT_TRAJECTORY_THRESHOLD:
			# Trajectory is almost flat
			# impact position can create a new vertical direction
			direction_y = abs(direction_x) * normalized_offset_y
		else:
			# Trajectory is not flat enought so we must keep vertical direction
			# Increase the vertical influence depending on how far
			# from the paddle center the impact occurred.
			# At the center, coefficient = 1.0.
			# At the edge, coefficient can go up to 1.0 + IMPACT_STRENGTH.
			var coeff_vel_y = 1.0 + abs(normalized_offset_y) * IMPACT_STRENGTH
			
			# Keep the previous vertical direction, but amplify it
			# depending on the impact position.
			direction_y = velocity_before.y * coeff_vel_y
		
		# Compute the maximum allowed vertical component
		# relative to the horizontal component.
		var max_y = abs(direction_x) * MAX_VERTICAL_RATIO
		
		# Prevent the trajectory from becoming too vertical.
		direction_y = clamp(direction_y, -max_y, max_y)
		
		# Build the new rebound direction and normalize it
		# so only the angle matters here, not the vector length.
		var direction = Vector2(direction_x, direction_y).normalized()
		
		# Increase the ball speed after each paddle hit.
		_current_speed += SPEED_INCREASE
		
		# Apply the new direction with the current ball speed.
		velocity = direction * _current_speed
		
	# Bounce on the top and bottom limits of the play area.
	if position.y <= 110 or position.y >= 628:
		# Reverse the vertical component using the velocity from before movement.
		velocity.y = -velocity_before.y
		
		# Keep the ball strictly inside the vertical play area.
		position.y = clamp(position.y, 110, 628)
		
	# Ball completely exited on the left side.
	if position.x <= -10:
		# Reset the ball and launch it toward the right.
		reset_ball(1.0)
		
		# Notify the game manager that the right player scored.
		point_scored.emit("right")
		
	# Ball completely exited on the right side.
	if position.x >= 1162:
		# Reset the ball and launch it toward the left.
		reset_ball(-1.0)
		
		# Notify the game manager that the left player scored.
		point_scored.emit("left")
		
func reset_ball(direction_x: float):
	position = Vector2(576.0, 369.0)
	_current_speed = START_SPEED
	velocity = Vector2.ZERO
	
	await get_tree().create_timer(0.8).timeout
	
	if _stopped:
		return
	
	var direction_y = randf_range(-0.15, 0.15)
	var direction = Vector2(direction_x, direction_y).normalized()
	
	velocity = direction * START_SPEED
	
func stop():
	velocity = Vector2.ZERO
	_stopped = true
