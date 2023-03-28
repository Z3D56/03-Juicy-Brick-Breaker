extends Node2D

var target = Vector2.ZERO
export var speed = 10.0
var width = 121
var width_default = 0
var decay = 0.02
var Direction = "Left"

func _ready():
	width_default = width
	target = Vector2(Global.VP.x / 2, Global.VP.y - 80)

func _physics_process(_delta):
	target.x = clamp(target.x, 0, Global.VP.x - 2*width)
	if target.x < position.x:
		$Player.scale.x = -0.8
	else:
		$Player.scale.x = 0.8
	position = target
	for c in $Powerups.get_children():
		c.payload()

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit(_ball):
	var paddle_sound = get_node_or_null("/root/Game/Bounce")
	if paddle_sound != null:
		paddle_sound.play()

func powerup(payload):
	for c in $Powerups.get_children():
		if c.type == payload.type:
			c.queue_free()
	$Powerups.call_deferred("add_child", payload)
