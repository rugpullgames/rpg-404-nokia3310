# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends KinematicBody2D

# const
const GRAVITY = 1500
const JUMP_FORCE = 400
const LONG_JUMP_TIME = 0.1
const WEAPON_JUMP_UP_OFFSET = Vector2(-10, 10)
const WEAPON_JUMP_DOWN_OFFSET = Vector2(10, 15)
const WEAPON_MOVE_OFFSET = Vector2()

# local variables
var _velocity = Vector2()
var _long_jump = false
var _tt = 0

# nodes
onready var Emo: Sprite = $Emo
onready var Head: Sprite = $Head
onready var Weapon: Sprite = $Weapon
onready var Pants: AnimatedSprite = $Pants
onready var StrxngerCloud: AnimatedSprite = $StrxngerCloud
onready var AudioJump: AudioStreamPlayer2D = $AudioJump
onready var AudioDie: AudioStreamPlayer2D = $AudioDie
onready var AudioPowerUp: AudioStreamPlayer2D = $AudioPowerUp

### default


func _ready():
	_bind_events()


func _physics_process(dt):
	if G.game_state == K.GameState.READY:
		Pants.playing = true
		StrxngerCloud.playing = true
		return
	elif G.game_state == K.GameState.END:
		Pants.playing = false
		StrxngerCloud.playing = false
		return
	elif G.game_state == K.GameState.RUNNING:
		_velocity.y += dt * GRAVITY

		if is_on_floor():
			_long_jump = false
			_tt = 0

		if Input.is_action_pressed("jump") and is_on_floor():
			_velocity.y = -JUMP_FORCE
			Emo.show_emo()
			if G.sfx_audio:
				AudioJump.play()

		if Input.is_action_pressed("jump") and not _long_jump and _tt >= LONG_JUMP_TIME:
			_velocity.y = -JUMP_FORCE * 1.3
			_long_jump = true
			if G.sfx_audio and !AudioJump.is_playing():
				AudioJump.play()

		_velocity = move_and_slide(_velocity, Vector2.UP)

		if Input.is_action_pressed("jump"):
			_tt += dt

		if is_on_floor():
			# move
			Pants.playing = true
			StrxngerCloud.playing = true
			Head.moving = true
			Weapon.moving = true
			Weapon.offset = WEAPON_MOVE_OFFSET
		else:
			# jump
			Pants.playing = false
			Pants.frame = 0 if _velocity.y < 0 else 1
			StrxngerCloud.playing = false
			StrxngerCloud.frame = 2 if _velocity.y < 0 else 0
			Head.moving = false
			Weapon.moving = false
			Weapon.offset = WEAPON_JUMP_UP_OFFSET if _velocity.y < 0 else WEAPON_JUMP_DOWN_OFFSET

			# prevent player going out of screen
			# prevent player gDOWNng out of screen
		self.position.y = clamp(self.position.y, 0, K.SCREEN_HEIGHT)


### public methods


func play_audio_power_up() -> void:
	if G.sfx_audio:
		AudioPowerUp.play()


### private methods


func _bind_events() -> void:
	var error_code = Events.connect("game_end", self, "_player_die")
	assert(error_code == OK, error_code)


func _player_die() -> void:
	_play_audio_die()


func _play_audio_die() -> void:
	if G.sfx_audio:
		AudioDie.play()
