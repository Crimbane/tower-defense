extends Node2D

#@export var towerScene: PackedScene

var ghostTower: Node2D = null
var isPlacing: bool = false
var canPlace: bool = true


func _ready() -> void:
	pass
	#startPlacement()


func _process(_delta: float) -> void:
	if isPlacing and ghostTower:
		ghostTower.global_position = get_global_mouse_position()
		checkValidPlacement()


func _unhandled_input(event: InputEvent) -> void:
	if not isPlacing:
		return
	
	if event.is_action_pressed("Left Click"):
		if canPlace:
			await get_tree().create_timer(0.1).timeout # delay isGhostShape = true
			placeTower()
		else:
			cancelPlacement()
	
	elif event.is_action_pressed("Right Click"):
		cancelPlacement()


func startPlacement(towerScene: PackedScene) -> void:
	print(towerScene)
	if isPlacing or towerScene == null:
		return
	isPlacing = true
	ghostTower = towerScene.instantiate()
	
	ghostTower.isGhostShape = true
	ghostTower.get_node("Attack Range").show()
	
	GameManager.UIManager.add_child(ghostTower)

func checkValidPlacement() -> void:
	var area = ghostTower.get_node("Placement Hitbox") as Area2D
	
	if area.has_overlapping_areas():
		canPlace = false
		ghostTower.modulate = Color(1, 0.3, 0.3, 0.6)
	else:
		canPlace = true
		ghostTower.modulate = Color(0.3, 1, 0.3, 0.6)

func placeTower() -> void:
	ghostTower.modulate = Color(1, 1, 1, 1)
	
	ghostTower.isGhostShape = false
	ghostTower.get_node("Attack Range").hide()
	
	ghostTower.payForTower()
	
	ghostTower = null
	isPlacing = false

func cancelPlacement() -> void:
	if ghostTower:
		ghostTower.queue_free()
		ghostTower = null
	isPlacing = false
