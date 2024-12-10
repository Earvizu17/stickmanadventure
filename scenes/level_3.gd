extends Node2D

@export var swirl_effect_duration: float = 5.0
@export var swirl_effect_max_strength: float = 1.0

var swirl_effect_timer: Timer
var swirl_color_rect: ColorRect

func _ready() -> void:
	swirl_color_rect = $SwirlEffect
	swirl_effect_timer = Timer.new()
	swirl_effect_timer.connect("timeout", self, "_on_swirl_timer_timeout")
	add_child(swirl_effect_timer)
	swirl_color_rect.visible = false

func start_dizzy_effect():
	swirl_color_rect.visible = true
	swirl_effect_timer.start(swirl_effect_duration)
	var tween = create_tween()
	tween.tween_property(swirl_color_rect.material, "shader_param/swirl_strength", swirl_effect_max_strength, swirl_effect_duration)

func _on_swirl_timer_timeout():
	var tween = create_tween()
	tween.tween_property(swirl_color_rect.material, "shader_param/swirl_strength", 0, swirl_effect_duration)
	tween.tween_callback(self, "_hide_swirl_effect")

func _hide_swirl_effect():
	swirl_color_rect.visible = false
