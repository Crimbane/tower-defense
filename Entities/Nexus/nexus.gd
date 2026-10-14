extends Node2D

@export var maxHealth: int = 10
@onready var currentHealth: int = maxHealth

@onready var healthBar = $"Health Bar"
@onready var sprite: Sprite2D = $Sprite2D

var healthBarSizeHeight = 80
var healthBarOffsetHeight = -200

func _ready() -> void:
	GameManager.nexus = self
	placeHealthBar()

func _process(_delta: float) -> void:
	pass

func takeDamage(damage: int) -> void:
	currentHealth -= damage
	#print("damaged: ", damage)
	if currentHealth < 1:
		print("Game over")
		queue_free()
	
	healthBar.value = currentHealth
	healthBar.visible = true


func placeHealthBar() -> void:
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth
	
	var spriteWidth = sprite.get_rect().size.x
	var spriteHeight = sprite.get_rect().size.y
	healthBar.size = Vector2(spriteWidth, healthBarSizeHeight)
	
	healthBar.position.x = -healthBar.size.x / 2
	healthBar.position.y = -spriteHeight / 2 - healthBar.size.y - healthBarOffsetHeight
