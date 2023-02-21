# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Area2D

# node
onready var SprPet: Sprite = $SprPet

# const
const SCREEN_WIDTH = K.SCREEN_WIDTH
const DEFAULT_POS_X = SCREEN_WIDTH + 100
const MIN_DEFAULT_POS_Y = 100
const MAX_DEFAULT_POS_Y = 200
const MIN_SPEED_X = K.SPEED_X * 1.2
const MAX_SPEED_X = K.SPEED_X * 2
const MIN_SPEED_Y = K.SPEED_X * 0.1
const MAX_SPEED_Y = K.SPEED_X * 0.4
const MIN_OFFSET_Y = 10
const MAX_OFFSET_Y = 50

# local var
var default_pos_y
var speed_x
var speed_y
var offset_limit
var direction

### default


func _ready():
	self.position.x = DEFAULT_POS_X
	default_pos_y = rand_range(MIN_DEFAULT_POS_Y, MAX_DEFAULT_POS_Y)
	self.position.y = default_pos_y
	speed_x = rand_range(MIN_SPEED_X, MAX_SPEED_X)
	speed_y = rand_range(MIN_SPEED_Y, MAX_SPEED_Y)
	offset_limit = rand_range(MIN_OFFSET_Y, MAX_OFFSET_Y)
	direction = pow(-1, randi() % 2)
	_bind_events()
	_reset()


func _process(dt):
	if G.game_state == K.GameState.READY:
		self.queue_free()
	elif G.game_state == K.GameState.RUNNING:
		_move(dt)


func _exit_tree():
	_unbind_events()


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _unbind_events() -> void:
	Events.disconnect("update_traits", self, "_reset")


func _reset() -> void:
	_reset_pet_type()


func _reset_pet_type() -> void:
	if (MgrNft.is_rpg404() or MgrNft.is_strxngers()) and MgrNft.NFT_TRAITS.pet:
		var res = "res://texture/pet/%s.png" % [MgrNft.NFT_TRAITS.pet]
		SprPet.texture = load(res)
	else:
		push_warning("Wrong NFT pet traits.")


func _move(dt) -> void:
	self.position.x -= speed_x * dt * G.factor
	if direction == 1:
		self.position.y += speed_y * dt * G.factor
	else:
		self.position.y -= speed_y * dt * G.factor
	if self.position.y >= default_pos_y + offset_limit:
		direction = -1
	elif self.position.y <= default_pos_y - offset_limit:
		direction = 1

	if self.position.x < -SCREEN_WIDTH - 100:
		self.queue_free()


func _on_Area2D_body_entered(body: KinematicBody2D) -> void:
	if not body:
		return

	if G.game_state == K.GameState.RUNNING:
		G.factor -= K.FACTOR_PET_DECR
		G.score += K.SCORE_PET_INCR
		body.play_audio_power_up()
		self.get_parent().play_boom_effect(self.position)
		self.queue_free()
