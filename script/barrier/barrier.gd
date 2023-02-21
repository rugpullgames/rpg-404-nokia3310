# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Area2D

# const
const SCREEN_WIDTH = K.SCREEN_WIDTH
const DEFAULT_POS_X = SCREEN_WIDTH + 100
const SPEED_X = K.SPEED_X

# local var
var _moving = false
var Shape2d: CapsuleShape2D

# node
onready var SprBarrier: Sprite = $SprBarrier
onready var CollsionShape: CollisionShape2D = $CollisionShape2D

### default


func _ready():
	Shape2d = CollsionShape.shape as CapsuleShape2D


func _process(dt):
	if G.game_state == K.GameState.RUNNING and _moving:
		_move(dt)


### public


func reset(texture) -> void:
	if not texture:
		push_warning("Barrier texture is null.")
		return

	var texture_size = texture.get_size()
	SprBarrier.texture = texture
	SprBarrier.offset = -texture_size
	CollsionShape.position.x = -texture_size.x * 2.5
	CollsionShape.position.y = 0
	Shape2d.radius = texture_size.x / 2
	Shape2d.height = texture_size.y / 2

	_moving = true
	self.visible = true
	self.position.x = DEFAULT_POS_X


### private


func _move(dt) -> void:
	self.position.x -= SPEED_X * dt * G.factor
	if self.position.x < -SCREEN_WIDTH - 100:
		_moving = false
		self.visible = false


func _on_Barrier_body_entered(body: KinematicBody2D) -> void:
	if not body:
		return

	if G.game_state == K.GameState.RUNNING:
		Events.emit_signal("game_end")
