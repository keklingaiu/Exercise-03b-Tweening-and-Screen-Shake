extends KinematicBody2D

onready var Ball = load("res://Ball/Ball.tscn")
onready var HUD = get_node("/root/Game/HUD")

export var speed = 30
export var distort = Vector2(1,1)

onready var collision_transform = $CollisionShape2D.get_transform().get_scale()	


onready var target_y = position.y

var color = Color8(230,73,128) #Pink 6

func _ready():
	HUD.connect("changed",self,"_on_HUD_changed")
	update_color()
	start_paddle()

func _physics_process(_delta):
	var target = get_viewport().get_mouse_position().x
	target = clamp(target, 0, get_viewport().size.x)

	var d = abs(target - position.x)						# distance between the mouse and the paddle
	var p = d / get_viewport().get_visible_rect().size.x	# percentage of the total viewport
	var t = clamp(d, d, speed)							# how much to move the paddle this cycle (maximum of speed)
	var s = sign(target - position.x)					# which direction to move
	
	position.x += s*t

	if HUD.paddle_stretch:
		var w = 1 + (distort.x * p)
		var h = 1 - (1/distort.y * p)
		change_size(w,h)



func change_size(w, h):
	$Color.rect_scale = Vector2(w, h)
	$CollisionShape2D.set_scale(Vector2(collision_transform.x*w, collision_transform.y*h))


func start_paddle():
	if HUD.paddle_appear:
		var target_pos = position
		var appear_duration = 2.0
		position.y = -100
		$Tween.interpolate_property(self, "position", position, target_pos, appear_duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		pass




func update_color():
	if HUD.color_paddle:
		$Color.color = color
	else:
		$Color.color = Color(1,1,1,1)

func emit_particle(pos):
	if HUD.particle_paddle:
		get_parent().find_node("Particles2D").global_position = pos
		get_parent().find_node("Particles2D").emitting = true
		get_parent().find_node("Particles2D").look_at(pos)

func _on_HUD_changed():
	update_color()
