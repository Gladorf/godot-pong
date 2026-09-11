extends CharacterBody2D

@export var up_action: StringName
@export var down_action: StringName

func _physics_process(delta):
	var direction = Input.get_axis(up_action, down_action)
	
	velocity.y = direction * 300
	move_and_slide()
	
	position.y = clamp(position.y, 150, 588)
