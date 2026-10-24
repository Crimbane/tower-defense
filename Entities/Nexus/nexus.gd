extends Node2D

@export var maxHealth: int = 10
@onready var currentHealth: int = maxHealth

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	GameManager.nexus = self

func _process(_delta: float) -> void:
	pass

func takeDamage(damage: int) -> void:
	currentHealth -= damage
	#print("damaged: ", damage)
	
	GameManager.UIManager.updateNexusHealthLabel(currentHealth)
	
	if currentHealth < 1:
		print("Game over")
		queue_free()
