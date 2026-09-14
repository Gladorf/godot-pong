extends Node2D

const WINNING_SCORE = 5

var _score_left = 0
var _score_right = 0

func _ready():
	$Ball.point_scored.connect(_on_point_scored)

func _on_point_scored(player):
	if "left" == player:
		_score_left+=1
		$ScoreLeft.text = str(_score_left)
	elif "right" == player:
		_score_right+=1
		$ScoreRight.text = str(_score_right)
		
	if _score_left >= WINNING_SCORE:
		$WinnerLabel.text = "Left player wins!"
		$WinnerLabel.visible = true
		$Ball.stop()
	elif _score_right >= WINNING_SCORE:
		$WinnerLabel.text = "Right player wins!"
		$WinnerLabel.visible = true
		$Ball.stop()
