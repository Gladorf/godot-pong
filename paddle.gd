extends CharacterBody2D

@export var up_action: StringName
@export var down_action: StringName
var _fixed_x: float

func _ready():
	_fixed_x = position.x

func _physics_process(_delta):
	var direction = Input.get_axis(up_action, down_action)
	
	velocity.x = 0
	velocity.y = direction * 300
	
	move_and_slide()
	
	position.x = _fixed_x
	position.y = clamp(position.y, 150, 588)
