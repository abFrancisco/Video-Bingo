extends Node2D

export(Array,Color) var color_pallete
export(int) var color_range=10
export(int) var number_range=60
export(int) var number_of_balls=30
export(float) var time_between_extraction=0.5
export(float) var ball_extraction_duration=3.0

enum States{IDLE,EXTRACTING,PAUSED,WAITING,DONE}
var state:int=States.IDLE

var ball_scene:PackedScene=preload("res://Ball.tscn")
var balls:Array=[]
var used_balls:Array=[]

var card_scene:PackedScene=preload("res://Card.tscn")
var card:GridContainer
export(Vector2) var card_size:Vector2=Vector2(5,3)
enum Orientation{HORIZONTAL,VERTICAL}
export(Orientation) var card_orientation:int=Orientation.HORIZONTAL

var reset_done:bool=false

func _ready():
	generate_card(true)

func _on_PlayButton_pressed():
	update_state()

func generate_card(blank:bool=false):
	if card:
		card.queue_free()
	card=card_scene.instance()
	card.setup(card_size,card_orientation,number_range,blank)
	$CanvasLayer/Control/VBoxContainer/CardContainer.add_child(card)

func generate_balls():
	var rng_helper:Array=[]
	for i in number_range:
		rng_helper.append(i)
	var numbers:Array=[]
	for i in number_of_balls:
		numbers.append(rng_helper.pop_at(randi()%rng_helper.size()))
	
	for n in numbers:
		var ball=ball_scene.instance()
		ball.number=n
		ball.color=color_pallete[n/color_range]
		balls.append(ball)

func extract_next():
	if balls:
		var ball=balls.pop_front()
		add_child(ball)
		ball.set_position($CanvasLayer/BallPathStart.rect_position)
		$Tween.interpolate_property(ball,"position",ball.position,$CanvasLayer/BallPathEnd.rect_position,ball_extraction_duration,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()
		used_balls.append(ball)
	else:
		state=States.WAITING
		yield(get_tree().create_timer(ball_extraction_duration), "timeout")
		print("done")
		state=States.DONE


func update_state():
	if state==States.IDLE:
		state=States.EXTRACTING
		generate_balls()
		generate_card()
		$ExtractionTimer.start(time_between_extraction)
	elif state==States.EXTRACTING:
		state=States.PAUSED
		$ExtractionTimer.stop()
	elif state==States.PAUSED:
		state=States.EXTRACTING
		$ExtractionTimer.start(time_between_extraction)
	elif state==States.DONE:
		reset()
		if reset_done:
			state=States.IDLE

func reset():
	card.reset()
	card=null
	for ball in used_balls:
		ball.queue_free()
	used_balls.clear()
	reset_done=true

func _on_ExtractionTimer_timeout():
	if state==States.EXTRACTING:
		extract_next()

func _on_Tween_tween_completed(object, key):
	if card.mark(object.number):
		$MarkSound.play()
	else:
		$FailSound.play()
