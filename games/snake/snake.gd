extends Node2D

@onready var score_label = $ScoreLabel
@onready var game_over_label = $GameOverLabel
@onready var restart_label = $RestartLabel
var game_over = false
var score = 0
var board_width = 40
var board_height = 30
var cell_size = 20
var board_offset = Vector2(10, 10)
var item_size = 16 # smaller than cells so that the head, body, and tail appear with gaps
var snake = [
	Vector2i(20, 15),
	Vector2i(19, 15),
	Vector2i(18, 15)
]
var food = Vector2i(10, 10)
var direction = Vector2i.RIGHT
var move_timer = 0.0
var move_delay = 0.15 # slow moving snake to start

func _draw():
	draw_rect(
		Rect2(
			board_offset - Vector2(2.5, 2.5),
			Vector2(board_width, board_height) * cell_size + Vector2(5, 5)
		),
		Color(0.2, 0.8, 1.0),
		false,
		5
	)
	
	for segment in snake:
		var pixel_position = board_offset + Vector2(segment) * cell_size

		draw_rect(
			Rect2(pixel_position, Vector2(item_size, item_size)),
			Color.GREEN
		)
		
	draw_rect(
		Rect2(board_offset + Vector2(food) * cell_size, Vector2(item_size, item_size)),
		Color.RED
	)
		
func _ready():
	spawn_food()
	score_label.text = "Score: " + str(score)
	queue_redraw()
	
func _process(delta):
	move_timer += delta

	if move_timer >= move_delay:
		move_timer = 0
		if not game_over:
			move_snake()
		queue_redraw()
		
func move_snake():
	var new_head = snake[0] + direction

	# Check if the snake hit a wall
	if new_head.x < 0 or new_head.x >= board_width:
		end_game()
		return

	if new_head.y < 0 or new_head.y >= board_height:
		end_game()
		return

	# Check if the snake hit itself
	if snake.has(new_head):
		end_game()
		return

	var ate_food = new_head == food

	# Move the body
	for i in range(snake.size() - 1, 0, -1):
		snake[i] = snake[i - 1]

	# Move the head
	snake[0] = new_head

	# Grow if we ate food
	if ate_food:
		snake.append(snake[-1])
		score += 1
		score_label.text = "Score: " + str(score)
		spawn_food()
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R and game_over:
			get_tree().reload_current_scene()
			return
		
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

func spawn_food():
	food = Vector2i(
		randi_range(0,39),
		randi_range(0,29)
	)
	
func end_game():
	game_over = true
	game_over_label.visible = true
	restart_label.visible = true;
