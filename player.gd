extends Area2D
# Signal emmitted when player collides.
# Click the Signals tab next to the Inspector tab to see list of signals
signal hit

@export var speed = 400
var screen_size

# Create and show character at position 'pos'
func start(pos):
	position = pos
	show()
	# Shape has effect in the world
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Vector2 is a 2d Vector. Set velocity to zero vector
	var velocity = Vector2.ZERO
	
	# Input Logic
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# Normalize Diagonal Velocity. Pressing left+right => (1,1) is too fast
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $ is shorthand for .getNode() which gets a child node from the current node
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	# Update Position
	position += velocity * delta
	# Position (x, y) must be within screen size length and width (x,y)
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Flipping Direction
	if velocity.x != 0:
		# Use walk animation
		$AnimatedSprite2D.animation = "walk"
		# Don't flip vertically
		$AnimatedSprite2D.flip_v = false
		# Flip horizontally if sprite moves left. Otherwise, stay in the original position
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		#$AnimatedSprite2D.flip_h = false
		# Flip when sprite moves up
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	# When hit, player disappears
	hide()
	# Emit hit signal
	hit.emit()
	# Set "disabled" property of CollisionShape2D object to true
	$CollisionShape2D.set_deferred("disabled", true)
