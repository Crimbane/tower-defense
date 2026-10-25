extends PanelContainer

@export_enum(
	"Arrow", "Fire", "Slime", "Cannon", "Next Wave", "Autoplay") var parentType: String = "Arrow"

@export var costLabel: Label
@export var textLabel: Label
@export var functionLabel: Label

@onready var parent = self.get_parent()

func _ready() -> void:
	hide()
	
	parent.mouse_entered.connect(onMouseEntered)
	parent.mouse_exited.connect(onMouseExited)

func _process(_delta: float) -> void:
	if visible:
		var positionParent = GameManager.UIManager.nexusHealthLabel
		#global_position = positionParent.global_position + Vector2(-100,340)
		
		updateTooltip()

func onMouseEntered() -> void:
	show()

func onMouseExited() -> void:
	hide()

func updateTooltip() -> void:
	costLabel.show()
	textLabel.show()
	functionLabel.show()
	
	var cost: int 
	var title: String = ""
	var function: String = ""
	
	match parentType:
		"Arrow":
			title = "Ballista"
			cost = GameManager.arrowTowerCost
			function = "Shoots arrows"
		"Fire":
			title = "Flamethrower"
			cost = GameManager.fireTowerCost
			function = "Burns armor"
		"Slime":
			title = "Slime Cannon"
			cost = GameManager.slimeTowerCost
			function = "Slows enemies"
		"Cannon":
			title = "Cannon"
			cost = GameManager.cannonTowerCost
			function = "Shoots exploding cannonballs"
		"Next Wave":
			title = "Start \nNext Wave"
			costLabel.hide()
			functionLabel.hide()
		"Autoplay":
			title = "Toggle \nAuto Wave Start"
			costLabel.hide()
			functionLabel.hide()
	
	textLabel.text = title
	costLabel.text = "Cost: " + str(cost)
	functionLabel.text = function
