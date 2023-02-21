# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Node

const SCREEN_WIDTH = 900.0
const SCREEN_HEIGHT = 300.0
const SPEED_X = 300.0
const FACTOR_DELTA = 0.05
const FACTOR_PET_DECR = 0.1
const SCORE_PET_INCR = 10.0
const BGM_FACTOR: float = 0.05
const BGM_DEFAULT_PITCH_SCALE = 0.9

const GameState = {INIT = 0, READY = 1, RUNNING = 2, END = 3}

# collision layers
enum CollsionLayer { BASEFLOOR = 0, PLAYER, BARRIER, PET }

const DATA_BACKGROUND_RAW = preload("res://script/data/data_background.gd").background
const DATA_MUSIC_RAW = preload("res://script/data/data_music.gd").music
const DATA_BACKGROUND = {}
const DATA_MUSIC = {}
const DATA_NFT_STRXNGERS = preload("res://script/data/data_nft_strxngers.gd").nft

const CLOUDS = {
	"Day":
	[
		"res://texture/cloud/cloud_day_01.png",
		"res://texture/cloud/cloud_day_02.png",
		"res://texture/cloud/cloud_day_03.png",
		"res://texture/cloud/cloud_day_04.png",
		"res://texture/cloud/cloud_day_05.png",
		"res://texture/cloud/cloud_day_06.png",
		"res://texture/cloud/cloud_day_07.png",
		"res://texture/cloud/cloud_day_08.png",
		"res://texture/cloud/cloud_day_09.png",
		"res://texture/cloud/cloud_day_10.png",
		"res://texture/cloud/cloud_day_11.png",
		"res://texture/cloud/cloud_day_12.png",
		"res://texture/cloud/cloud_day_13.png",
		"res://texture/cloud/cloud_day_14.png",
		"res://texture/cloud/cloud_day_15.png",
		"res://texture/cloud/cloud_day_16.png",
		"res://texture/cloud/cloud_day_17.png",
		"res://texture/cloud/cloud_day_18.png",
		"res://texture/cloud/cloud_day_19.png",
		"res://texture/cloud/cloud_day_20.png",
		"res://texture/cloud/cloud_day_21.png",
		"res://texture/cloud/cloud_day_22.png",
		"res://texture/cloud/cloud_day_23.png",
		"res://texture/cloud/cloud_day_24.png",
		"res://texture/cloud/cloud_day_25.png",
		"res://texture/cloud/cloud_day_26.png",
		"res://texture/cloud/cloud_day_27.png",
		"res://texture/cloud/cloud_day_28.png",
		"res://texture/cloud/cloud_day_29.png",
		"res://texture/cloud/cloud_day_30.png",
	],
	"Night":
	[
		"res://texture/cloud/cloud_night_01.png",
		"res://texture/cloud/cloud_night_02.png",
		"res://texture/cloud/cloud_night_03.png",
		"res://texture/cloud/cloud_night_04.png",
		"res://texture/cloud/cloud_night_05.png",
		"res://texture/cloud/cloud_night_06.png",
		"res://texture/cloud/cloud_night_07.png",
	]
}

const STARS = [
	"res://texture/stars/star_01.png",
	"res://texture/stars/star_02.png",
	"res://texture/stars/star_03.png",
	"res://texture/stars/star_04.png",
]

### default


func _ready():
	_init_screen()
	_clean_data()


### public


func http_download_texture(http_request: HTTPRequest, user_file: String, img_url: String) -> void:
	if OS.get_name() != "HTML5":
		http_request.set_use_threads(true)
	http_request.set_download_file(user_file)

	var error_code = http_request.request(img_url)
	if error_code != OK:
		push_error("An error occurred in the HTTP request.")


func http_request_completed(result: int, response_code: int, user_file: String) -> Texture:
	if result == OK:
		if response_code == 200:
			var texture = ImageTexture.new()
			var image = Image.new()
			image.load(user_file)
			texture.create_from_image(image, 1)
			return texture
		else:
			push_warning("response_code = %s" % response_code)
	else:
		push_warning("result = %s" % result)
	return null


### private


func _init_screen():
	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_2D,
		SceneTree.STRETCH_ASPECT_KEEP,
		Vector2(SCREEN_WIDTH, SCREEN_HEIGHT),
		1.0
	)


func _clean_data():
	_clean_data_aux(DATA_BACKGROUND, DATA_BACKGROUND_RAW)
	_clean_data_aux(DATA_MUSIC, DATA_MUSIC_RAW)


func _clean_data_aux(tar, raw):
	for key in raw:
		var id = key.to_lower().replace(" ", "_")
		tar[id] = raw[key]
		tar[id].id = id
