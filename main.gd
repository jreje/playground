extends Node

var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func new_game():
	score = 0
	$Player1.start($Player1StartPosition.position)
	
