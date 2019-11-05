package objects;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.effects.particles.FlxParticle;
import flixel.FlxObject;
import flixel.FlxSprite;

/// 깨지는 블럭
class BrickBlock extends FlxSprite {
	private static var SCORE_AMOUNT:Int = 10;
	private static var GRAVITY:Int = 600;

	public function new(x:Float, y:Float) {
		super(x, y);
		immovable = true;

		loadGraphic(AssetPaths.items__png, true, 16, 16);
		animation.add("idle", [6]);
		animation.play("idle");
	}

	override public function update(elapsed:Float) {
		if (isOnScreen() && !Reg.pause) {
			super.update(elapsed);
		}
	}

	public function hit(player:Player) {
		FlxObject.separate(this, player);

		if (!isTouching(FlxObject.DOWN))
			return;

		if (player.health > 0) {
			Reg.score += SCORE_AMOUNT;
			for (i in 0...4) {
				var debris:FlxParticle = new FlxParticle();
				debris.loadGraphic(AssetPaths.items__png, true, 8, 8);
				debris.animation.add("spin", [28, 29, 38, 39], 12);
				debris.animation.play("spin");
				FlxG.sound.play("brick");

				var countX:Int = (i % 2 == 0) ? 1 : -1;
				var countY:Int = (Math.floor(i / 2)) == 0 ? -1 : 1;

				debris.setPosition(4 + x + countX * 4, 4 + y + countY * 4);
				debris.lifespan = 3;
				debris.acceleration.y = GRAVITY;
				debris.velocity.y = -160 + (10 * countY);
				debris.velocity.x = 40 * countX;
				debris.exists = true;

				Reg.PS.add(debris);
			}

			kill();
		} else {
			var currentY = y;
			FlxTween.tween(this, {y: currentY - 4}, 0.05).wait(0.05).then(FlxTween.tween(this, {y: currentY}, 0.05));
		}
	}
}
