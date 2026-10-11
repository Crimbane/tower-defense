extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 50


func _physics_process(_delta: float) -> void:
	velocity = Vector2.RIGHT * SPEED

	move_and_slide()

func takeDamage(damage: int) -> void:
	health -= damage
	print("damaged: ", damage)
	if health < 1:
		queue_free()
