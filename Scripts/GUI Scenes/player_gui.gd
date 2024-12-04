extends Control


@onready var player = get_parent()


func _process(_delta: float) -> void:
	$CanvasLayer/VBoxContainer/HealthBar.max_value = player.max_health
	$CanvasLayer/VBoxContainer/StaminaBar.max_value = player.max_stamina
	
	$CanvasLayer/VBoxContainer/HealthBar.value = player.health
	$CanvasLayer/VBoxContainer/StaminaBar.value = player.stamina
	
	$CanvasLayer/VBoxContainer/HealthBar/HealthLabel.text = "%d/%d" % [player.health, player.max_health]
	$CanvasLayer/VBoxContainer/StaminaBar/StaminaLabel.text = "%d/%d" % [player.stamina, player.max_stamina]
