extends Area2D

@export var health_increase: int = 50
@export var speed_decrease: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.has_method("increase_health") and body.has_method("decrease_speed"):
		print_debug("Player got orb")
		body.increase_health(health_increase)
		body.decrease_speed(speed_decrease)
		queue_free()
	pass # Replace with function body.
