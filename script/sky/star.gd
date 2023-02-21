# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Sprite

# const
const SCREEN_WIDTH = K.SCREEN_WIDTH
const DEFAULT_POS_X = SCREEN_WIDTH + 10
const SPEED_X_MIN = K.SPEED_X / 15
const SPEED_X_MAX = K.SPEED_X / 10
const OFFSET_Y_MIN = 50
const OFFSET_Y_MAX = 250

# local var
var _speed_x = 0
var _cloud_type = "Day"
var _star_idx: int

### default


# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()


func _process(dt):
	if G.game_state != K.GameState.RUNNING:
		return
	_move(dt)


### private


func _bind_events():
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset():
	_reset_cloud_type()
	if _cloud_type == "Night":
		set_process(true)
		self.visible = true
		_reset_star()
		self.position.x = rand_range(-10, SCREEN_WIDTH + 10)
	else:
		set_process(false)
		self.visible = false


func _reset_cloud_type():
	if not MgrNft.NFT_TRAITS or not MgrNft.NFT_TRAITS.background:
		push_warning("Wrong NFT cloud traits.")
		return

	if not K.DATA_BACKGROUND.has(MgrNft.NFT_TRAITS.background):
		push_warning("Not found background id, " + MgrNft.NFT_TRAITS.background)
		return

	_cloud_type = K.DATA_BACKGROUND.get(MgrNft.NFT_TRAITS.background).cloud_type


func _reset_star():
	_speed_x = rand_range(SPEED_X_MIN, SPEED_X_MAX)
	self.position.x = DEFAULT_POS_X
	self.position.y = rand_range(OFFSET_Y_MIN, OFFSET_Y_MAX)
	_star_idx = randi() % K.STARS.size()
	var res = K.STARS[_star_idx]
	self.texture = load(res)


func _move(dt):
	self.position.x -= _speed_x * G.factor * dt
	if self.position.x < 0:
		self.position.x += SCREEN_WIDTH
