extends Node2D

@export var towerScene: PackedScene

var previewTower: Node2D = null
var isPlacing: bool = false
var canPlace: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startPlacement()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if isPlacing and previewTower:
		previewTower.global_position = get_global_mouse_position()
		checkValidPlacement()
	


func _unhandled_input(event: InputEvent) -> void:
	if not isPlacing:
		return
	
	if event.is_action_pressed("Left Click"):
		if canPlace:
			placeTower()
	elif event.is_action_pressed("Right Click"):
		cancelPlacement()
	


func startPlacement() -> void:
	isPlacing = true
	previewTower = towerScene.instantiate()
	
	previewTower.isGhostShape = true
	
	add_child(previewTower)

func checkValidPlacement() -> void:
	var area = previewTower.get_node("Placement Hitbox") as Area2D
	
	if area.has_overlapping_areas():
		canPlace = false
		previewTower.modulate = Color(1, 0.3, 0.3, 0.6)
	else:
		canPlace = true
		previewTower.modulate = Color(0.3, 1, 0.3, 0.6)

func placeTower() -> void:
	previewTower.modulate = Color(1, 1, 1, 1)
	
	previewTower.isGhostShape = false
	
	previewTower = null
	isPlacing = false


func cancelPlacement() -> void:
	if previewTower:
		previewTower.queue_free()
		previewTower = null
	isPlacing = false
