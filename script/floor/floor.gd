# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Sprite

# const
const SCREEN_WIDTH = K.SCREEN_WIDTH
const SCREEN_WIDTH_EXT = SCREEN_WIDTH + 300
const SPEED_X = K.SPEED_X

const TMP_RPG404_FLOOR_FILE = "user://rpg404_floor.png"

# node
onready var HTTPRequest: HTTPRequest = $HTTPRequest

### default


func _ready():
	_bind_events()


func _process(dt):
	if G.game_state != K.GameState.RUNNING:
		return
	_move(dt)


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset() -> void:
	_reset_foreground_texture()


func _reset_foreground_texture() -> void:
	if MgrNft.is_rpg404() and MgrNft.NFT_TRAITS.floor:
		var image_url = "https://rpg404.com/nft/rpg404/texture/floor/%s.png" % [MgrNft.NFT_TRAITS.floor]
		_download_floor_texture(image_url)
	elif MgrNft.is_strxngers():
		var res = "res://texture/strxngers/floor_01.png"
		self.texture = load(res)
	else:
		push_warning("Wrong NFT floor traits.")


func _move(dt) -> void:
	if G.game_state != K.GameState.RUNNING:
		return

	self.position.x -= SPEED_X * G.factor * dt
	self.position.x = fmod(self.position.x + SCREEN_WIDTH_EXT, SCREEN_WIDTH_EXT)


func _download_floor_texture(image_url:String) -> void:
	K.http_download_texture(HTTPRequest, TMP_RPG404_FLOOR_FILE, image_url)


func _on_HTTPRequest_request_completed(result, response_code, _headers, _body):
	var texture = K.http_request_completed(result, response_code, TMP_RPG404_FLOOR_FILE)
	if texture:
		self.texture = texture
