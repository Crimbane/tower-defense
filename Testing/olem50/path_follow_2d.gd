extends PathFollow2D

@export var enemyScene: PackedScene

func _ready() -> void:
	loop = false

func _process(_delta: float) -> void:
	progress += 0.5
	
	if progress_ratio == 1.0:
		print("reached end of path")
		queue_free()
