extends Node2D

var cell_size = 20
var snake_size = 16 # smaller than cells so that the head, body, and tail appear with gaps
var snake = [
	Vector2i(20, 15),
	Vector2i(19, 15),
	Vector2i(18, 15)
]
var direction = Vector2i.RIGHT
var move_timer = 0.0
var move_delay = 0.15 # slow moving snake to start

func _draw():
	for segment in snake:
		var pixel_position = Vector2(segment) * cell_size

		draw_rect(
			Rect2(pixel_position, Vector2(snake_size, snake_size)),
			Color.GREEN
		)
		
func _process(delta):
	move_timer += delta

	if move_timer >= move_delay:
		move_timer = 0
		move_snake()
		queue_redraw()
		
func move_snake():
	for i in range(snake.size() - 1, 0, -1):
		snake[i] = snake[i - 1]

	snake[0] += direction
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_W:
			change_direction(Vector2i.UP)
		elif event.keycode == KEY_S:
			change_direction(Vector2i.DOWN)
		elif event.keycode == KEY_A:
			change_direction(Vector2i.LEFT)
		elif event.keycode == KEY_D:
			change_direction(Vector2i.RIGHT)

func change_direction(new_direction):
	if new_direction != -direction:
		direction = new_direction
