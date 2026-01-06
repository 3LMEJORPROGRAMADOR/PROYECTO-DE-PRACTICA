extends CharacterBody2D

const speed := 130
const gravity := 900
const jump_speed := -500
const friction := 800

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_jumping: bool = false
var is_attacking: bool = false
var last_direction: int = 1

func _physics_process(delta: float) -> void:
	# --- GRAVEDAD ---
	if not is_on_floor():
		velocity.y += gravity * delta

		if not is_jumping and velocity.y < 0:
			sprite.play("Jump")
			sprite.flip_h = last_direction == -1
			is_jumping = true
	else:
		is_jumping = false

		if Input.is_action_pressed("UI_Jump"):
			velocity.y = jump_speed

	# --- MOVIMIENTO HORIZONTAL ---
	var direction := Input.get_axis("UI_Left", "UI_Right")

	if not is_attacking:
		if direction != 0 and is_on_floor():
			if Input.is_action_pressed("UI_Run"):
				velocity.x = direction * speed * 2
				sprite.play("Run")
			else:
				velocity.x = direction * speed
				sprite.play("Walk")

			if direction > 0:
				sprite.flip_h = false
				last_direction = 1
			else:
				sprite.flip_h = true
				last_direction = -1
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, friction * delta)
			sprite.play("Idle")
			sprite.flip_h = last_direction == -1

	move_and_slide()
