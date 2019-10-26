package objects;

import flixel.FlxSprite;

class PowerUp extends FlxSprite {
	private static inline var MOVE_SPEED:Int = 40;
	private static inline var GRAVITY:Int = 420;
	private static var SCORE_AMOUNT:Int = 20;

	public var direction:Int = -1;

	private var _moving:Bool = false;

	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(AssetPaths.items__png, true, 16, 16);
		animation.add("idle", [5]);
		animation.play("idle");

		velocity.y = -16;
	}

	override public function update(elapsed:Float) {
		if (!Reg.pause) {
			if (!_moving && (Math.floor(y) % 16 == 0)) {
				velocity.y = 0;
				acceleration.y = GRAVITY;
				_moving = true;
			}

			if (_moving)
				velocity.x = direction * MOVE_SPEED;
		}
		super.update(elapsed);
	}

	public function collect(player:Player) {
		kill();
		if (player.health == 0)
			player.powerUp();
		else
			Reg.score += SCORE_AMOUNT;
	}
}
