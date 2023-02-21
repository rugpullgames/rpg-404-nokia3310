# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends ColorRect

### default


func _ready():
	_bind_events()


### private


func _bind_events():
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset():
	if (MgrNft.is_rpg404() or MgrNft.is_strxngers()) and MgrNft.NFT_TRAITS.background:
		if K.DATA_BACKGROUND.has(MgrNft.NFT_TRAITS.background):
			var sky_color = K.DATA_BACKGROUND.get(MgrNft.NFT_TRAITS.background).sky_color
			self.color = Color(sky_color)
		else:
			push_warning("Not found background id, " + MgrNft.NFT_TRAITS.background)
	else:
		push_warning("Wrong NFT sky trait.")
