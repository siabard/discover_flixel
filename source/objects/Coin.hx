package objects;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class Coin extends FlxSprite {
	private static var SCORE_AMOUNT:Int = 20;

	override public function update(elapsed:Float) {
		if (!Reg.pause)
			super.update(elapsed);
	}

	public function new(X:Float, Y:Float) {
		super(X, Y);

		loadGraphic(AssetPaths.items__png, true, 16, 16);

		animation.add("idle", [0, 1, 2, 3, 4], 16);
		animation.play("idle");
	}

	public function collect() {
		FlxG.sound.play("coin");
		Reg.score += SCORE_AMOUNT;
		Reg.coins++;

		if (Reg.coins >= 100) {
			Reg.lives++;
			Reg.coins = 0;
		}

		kill();
	}

	public function setFromBlock() {
		solid = false;
		acceleration.y = 420;
		velocity.y = -90;
		new FlxTimer().start(0.3, function(_) {
			collect();
		}, 1);
	}
}
