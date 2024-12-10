extends Area2D

@export var health_increase: int = 1
@export var speed_decrease: float = 10.0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.has_method("increase_health") and body.has_method("decrease_speed"):
		print_debug("Player got orb")
		body.increase_health(health_increase)
		body.decrease_speed(speed_decrease)
		var level_3 = get_tree().get_current_scene() as Node2D
		if level_3.has_method("start_dizzy_effect"):
			level_3.start_dizzy_effect()
		queue_free()
