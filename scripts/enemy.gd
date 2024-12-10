extends StaticBody2D

@export var attack_range: float = 100.0  # Range of detection
@export var attack_damage: int = 10     # Damage dealt to the player
@export var attack_cooldown: float = 2.0  # Time between attacks

var can_attack: bool = true
@onready var player: CharacterBody2D = null  # Reference to the player (set dynamically)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))
	
func _physics_process(delta: float) -> void:
	if player and can_attack:
		var distance_to_player = position.distance_to(player.position)
		if distance_to_player <= attack_range:attack_player()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body  # Store the player reference
		pass # Replace with function body.

func attack_player() -> void:
	if not player:
		return  # No player to attack
		# Reduce the player's health (assuming the player script has a method for this)
	animated_sprite.play("attacking")
	if player.has_method("decrease_health"):
		player.decrease_health(attack_damage)
	print("Attacked player for", attack_damage, "damage!")
	# Start cooldown timer
	can_attack = false
	var timer = get_tree().create_timer(attack_cooldown)
	await timer.timeout
	can_attack = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player = null  # Clear the player reference
	pass # Replace with function body.

func stop_attack_animation() -> void:
	# Stop the attack animation and reset to idle or other default animation
	if animated_sprite.is_playing() and animated_sprite.animation == "attack":
		animated_sprite.stop()
		animated_sprite.play("idle")  # Play idle animation when player leaves
