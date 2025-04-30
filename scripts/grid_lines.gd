extends Node2D

var line_color = Color(0.22, 0.28, 0.40, 0.15)
var line_width = 0.5

func _draw():
	# Draw vertical lines
	for x in range(100, 800, 100):
		draw_line(Vector2(x, 0), Vector2(x, 600), line_color, line_width)
	
	# Draw horizontal lines
	for y in range(100, 600, 100):
		draw_line(Vector2(0, y), Vector2(800, y), line_color, line_width)
	
	# Draw atmospheric streaks
	draw_line(Vector2(0, 100), Vector2(800, 200), Color(0.56, 0.62, 0.67, 0.1), 40)
	draw_line(Vector2(0, 300), Vector2(800, 350), Color(0.56, 0.62, 0.67, 0.1), 20)
	draw_line(Vector2(0, 450), Vector2(800, 410), Color(0.56, 0.62, 0.67, 0.1), 30)
