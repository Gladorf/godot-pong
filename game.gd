extends Node2D

var score_left = 0
var score_right = 0

func _ready():
	$Ball.point_scored.connect(_on_point_scored)

func _on_point_scored(player):
	if "left" == player:
		score_left+=1
		$ScoreLeft.text = str(score_left)
	if "right" == player:
		score_right+=1
		$ScoreRight.text = str(score_right)
