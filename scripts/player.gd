extends CharacterBody2D

const JUMP_VELOCITY = -400.0
@export var max_health: int = 100
var health: int = 100
@export var base_speed: float = 200.0
var current_speed: float = 200.0
@export var health_depletion_rate: float = .0005  # Health points lost per second
@export var death_animation_duration: float = 2.0  # Duration before restarting or ending the game
var is_dead: bool = false  # Track if the player is dead

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = $ProgressBar
@onready var death_timer: Timer = $DeathTimer

@export var gems_collected: int = 0

func collect_gem():
	gems_collected += 1  # Increment the gem count
	$GemsLabel.text = "Gems: " + str(gems_collected)  # Update the label



func _ready() -> void:
	# Initialize the health bar value
	health_bar.max_value = max_health
	health_bar.value = health
	# Connect the timer timeout signal
	death_timer.connect("timeout", Callable(self, "_on_death_timer_timeout"))


func _physics_process(delta: float) -> void:
	if is_dead:
		# Let gravity act on the player after death
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return  # Prevent further input processing

	# Handle gravity and jumping
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		animated_sprite.play("jumping")
		velocity.y = JUMP_VELOCITY

	# Handle movement
	var direction := Input.get_axis("ui_walkleft", "ui_walkright")
	if is_on_floor():
		if direction != 0:
			animated_sprite.flip_h = direction < 0
			animated_sprite.animation = "walking"
		else:
			animated_sprite.animation = "idle"
	else:
		animated_sprite.flip_h = direction < 0
		animated_sprite.animation = "jumping"

	velocity.x = direction * current_speed if direction else move_toward(velocity.x, 0, current_speed)
	move_and_slide()

	# Deplete health over time
	#deplete_health(delta)

func increase_health(amount: int):
	if is_dead:
		return  # Prevent healing if the player is dead

	health = min(health + amount, max_health)
	health_bar.value = health
	print("Health increased to:", health)

func increase_speed(amount: float):
	if is_dead:
		return  # Prevent speed increase if the player is dead

	current_speed += amount
	print("Speed increased to:", current_speed)
	
func decrease_speed(amount: float):
	if is_dead:
		return  # Prevent speed increase if the player is dead

	current_speed -= amount

#func deplete_health(delta: float) -> void:
	# Calculate the health reduction based on 0.5% of max health per second
	var depletion = max_health * health_depletion_rate
	health -= depletion
	health = max(health, 0)  # Prevent negative health
	health_bar.value = health
	
	if health <= 0 and not is_dead:
		handle_death()

	
	if health <= 0 and not is_dead:
		handle_death()

func handle_death() -> void:
	is_dead = true
	print("Player is dead!")
	animated_sprite.play("death")  # Play the death animation
	velocity.x = 0  # Stop horizontal movement
	death_timer.start(death_animation_duration)  # Start the timer


func _on_death_timer_timeout() -> void:
	pass # Replace with function body.
