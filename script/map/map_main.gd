# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Node

# const
const SPEED_X = K.SPEED_X
const SCORE_FACTOR: float = 1.0 / 8
const PLAYER_DEFAULT_POS_X = 15
const BGM_MOZART: AudioStream = preload("res://audio/bgm/mozart_triangle_wave.wav")

# node
onready var GameNode: Node2D = $Game
onready var ScoreMarker: Node2D = $Game/ScoreMarker
onready var Floors: Node2D = $Game/Floors
onready var player: KinematicBody2D = $Game/Player

### default


func _ready():
	print("Game Init")
	_bind_events()
	MgrNft.reload_nft()
	_reset()


func _process(dt):
	if G.game_state == K.GameState.READY:
		_update_player(dt)
	elif G.game_state == K.GameState.RUNNING:
		_update_marker(dt)
		_update_bgm()


### private


func _bind_events():
	var error_code = Events.connect("game_ready", self, "_ready_game")
	assert(error_code == OK, error_code)
	error_code = Events.connect("game_run", self, "_run_game")
	assert(error_code == OK, error_code)
	error_code = Events.connect("game_end", self, "_end_game")
	assert(error_code == OK, error_code)


func _reset():
	ScoreMarker.position = Vector2.ZERO


func _update_player(dt):
	player.position.x += SPEED_X * dt
	if player.position.x >= PLAYER_DEFAULT_POS_X:
		player.position.x = PLAYER_DEFAULT_POS_X
		Events.emit_signal("game_run")


func _update_marker(dt):
	ScoreMarker.position.x -= SPEED_X * dt
	G.score = abs(floor(ScoreMarker.position.x * SCORE_FACTOR))
	G.factor += K.FACTOR_DELTA * dt


func _update_bgm():
	AudioManager.set_music_pitch((G.factor - K.BGM_DEFAULT_PITCH_SCALE) * K.BGM_FACTOR)


func _ready_game():
	GameNode.visible = true
	Floors.visible = true
	player.position.x = 15
	player.position.y = 28
	ScoreMarker.position.x = 0
	G.factor = 1
	G.score = 0
	# AudioManager.set_music_pitch(K.BGM_DEFAULT_PITCH_SCALE)
	G.game_state = K.GameState.READY
	print("Game Ready")


func _run_game():
	GameNode.visible = true
	AudioManager.set_music_seek(0)
	if G.bgm_audio:
		AudioManager.play_music(BGM_MOZART)
		print("Play Mozart")
	G.game_state = K.GameState.RUNNING
	print("Game Start")


func _end_game():
	G.game_state = K.GameState.END
	GameNode.visible = false
	AudioManager.stop_music()
	Floors.visible = false
	print("Game Over")
