# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Sprite

# const
const FPS = 8
const OFFSET_Y = 5
const DEFAULT_TIME_FPS = 1.0 / FPS
const FPS_FACTOR = 0.8

const TMP_RPG404_HEAD_FILE = "user://rpg404_head.png"

### public
var moving = false

# local var
var _time_per_frame: float = DEFAULT_TIME_FPS
var _tt = 0

# node
onready var HTTPRequest: HTTPRequest = $HTTPRequest

### default


func _ready():
	_bind_events()


func _process(dt):
	if G.game_state != K.GameState.RUNNING:
		return

	if !moving:
		# jumping
		self.position.y = 0
		return

	_time_per_frame = DEFAULT_TIME_FPS / ((G.factor - 1) * FPS_FACTOR + 1)
	_tt += dt
	if _tt > _time_per_frame:
		_tt -= _time_per_frame
		if self.position.y != 0:
			self.position.y = 0
		else:
			self.position.y = OFFSET_Y


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset() -> void:
	_reset_head_type()
	_reset_time_fps()
	_tt = 0


func _reset_time_fps() -> void:
	_time_per_frame = DEFAULT_TIME_FPS


func _reset_head_type() -> void:
	if MgrNft.is_rpg404() and MgrNft.NFT_TRAITS.head:
		_download_head_texture()
		visible = true
	elif MgrNft.is_strxngers():
		visible = false
	else:
		push_warning("Wrong NFT head traits.")


func _download_head_texture() -> void:
	var image_url = "https://rpg404.com/nft/rpg404/texture/head/%s.png" % [MgrNft.NFT_TRAITS.head]
	K.http_download_texture(HTTPRequest, TMP_RPG404_HEAD_FILE, image_url)


func _on_HTTPRequest_request_completed(result, response_code, _headers, _body):
	var texture = K.http_request_completed(result, response_code, TMP_RPG404_HEAD_FILE)
	if texture:
		self.texture = texture
