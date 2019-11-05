package objects;

import flixel.tweens.FlxTween;
import flixel.FlxObject;
import flixel.FlxSprite;

class BonusBlock extends FlxSprite {
	private var _empty:Bool = false;

	public var content:String;

	public function new(x:Float, y:Float) {
		super(x, y);
		solid = true;
		immovable = true;

		loadGraphic(AssetPaths.items__png, true, 16, 16);
		animation.add("idle", [7]);
		animation.add("empty", [8]);
		animation.play("idle");
	}

	public function hit(player:Player) {
		FlxObject.separateY(this, player);

		if (!_empty && (isTouching(FlxObject.DOWN))) {
			FlxTween.tween(this, {y: y - 4}, 0.05, {onComplete: createItem}).wait(0.05).then(FlxTween.tween(this, {y: y}, 0.05, {onComplete: empty}));
		}
	}

	private function empty(_):Void {
		_empty = true;
		animation.play("empty");
	}

	private function createItem(_) {
		switch (content) {
			case "powerup":
				var _pwrUp:PowerUp = new PowerUp(Std.int(x), Std.int(y));
				Reg.PS.items.add(_pwrUp);
			case "invincible":
				var _invic:InvincibilityBonus = new InvincibilityBonus(Std.int(x), Std.int(y));
				Reg.PS.items.add(_invic);
			default:
				var _coin:Coin = new Coin(Std.int(x), Std.int(y - 16));
				_coin.setFromBlock();
				Reg.PS.items.add(_coin);
		}
	}
}
