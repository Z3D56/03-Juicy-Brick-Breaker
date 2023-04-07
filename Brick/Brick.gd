extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
export var time_appear = 0.5
export var time_fall = 0.8
export var time_rotate = 1.0
export var time_a = 0.8
export var time_s = 1.2
export var time_v = 1.5
export var sway_amplitude = 3.0
var sway_initial_position = Vector2.ZERO
var sway_randomizer = Vector2.ZERO
var powerup_prob = 0.1
var color_index = 0
var color_distance = 0
var color_completed = true

var Bricks = [("res://Brick/Waffle.tscn")
, load("res://Brick/Glacier.tscn")
, load("res://Brick/Honey.tscn")
, load("res://Brick/Moon.tscn")
, load("res://Brick/Purple.tscn")
, load("res://Brick/Soap.tscn")
]

func _ready():
	randomize()
	position.x = new_position.x
	position.y = -100
	$Tween.interpolate_property(self, "position", position, new_position, time_appear + randf()*2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	position = new_position

func _physics_process(_delta):
	if dying and not $Confetti.emitting and not $Tween.is_active():
		queue_free()

func hit(_ball):
	var brick_sound = get_node_or_null("/root/Game/Shake")
	if brick_sound != null:
		brick_sound.play()
	die()

func die():
	dying = true
	collision_layer = 0
	collision_mask = 0
	Global.update_score(score)
	get_parent().check_level()
	$Confetti.emitting = true
	$Tween.interpolate_property(self, "position", position, Vector2(position.x, 1000), time_fall, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.interpolate_property(self, "rotation", rotation, -PI + randf()*2*PI, time_rotate, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	if not Global.feverish:
		Global.update_fever(score)
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
