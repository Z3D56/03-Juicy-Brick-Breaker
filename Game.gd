extends Node2D

export var margin = Vector2(145,105)
export var index = Vector2(100,40)

func _ready():
	if Global.level < 0 or Global.level >= len(Levels.levels):
		Global.end_game(true)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		var level = Levels.levels[Global.level]
		var layout = level["layout"]
		var Brick_Container = get_node_or_null("/root/Game/Brick_Container")
		Global.time = level["timer"]
		if Brick_Container != null:
			var Bricks = [load("res://Brick/Waffle.tscn")
			, load("res://Brick/Glacier.tscn")
			, load("res://Brick/Honey.tscn")
			, load("res://Brick/Moon.tscn")
			, load("res://Brick/Purple.tscn")
			, load("res://Brick/Soap.tscn")
			]
			var Brick = null
			for rows in range(len(layout)):
				for cols in range(len(layout[rows])):
					if layout[rows][cols] > 0:
						if layout[rows][cols] > 10:
							Brick = Bricks[0]
						if layout[rows][cols] > 20:
							Brick = Bricks[1]
						if layout[rows][cols] > 30:
							Brick = Bricks[2]
						if layout[rows][cols] > 40:
							Brick = Bricks[3]
						if layout[rows][cols] > 50:
							Brick = Bricks[4]
						else:
							Brick = Bricks[5]
						var brick = Brick.instance()
						brick.new_position = Vector2(margin.x + index.x*cols, margin.y + index.y*rows)
						brick.position = Vector2(brick.new_position.x,-100)
						brick.score = layout[rows][cols]
						Brick_Container.add_child(brick)
		var Instructions = get_node_or_null("/root/Game/UI/Instructions")
		if Instructions != null:
			Instructions.set_instructions(level["name"],level["instructions"])
