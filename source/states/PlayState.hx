package states;

import flixel.group.FlxGroup.FlxTypedGroup;
import objects.Player;
import objects.Coin;
import objects.Enemy;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.FlxState;
import utils.LevelLoader;

class PlayState extends FlxState {
	private var _hud:HUD;

	public var map:FlxTilemap;
	public var player(default, null):Player;
	public var items(default, null):FlxTypedGroup<FlxSprite>;
	public var enemies(default, null):FlxTypedGroup<Enemy>;

	override public function create():Void {
		items = new FlxTypedGroup<FlxSprite>();
		_hud = new HUD();
		player = new Player();
		enemies = new FlxTypedGroup<Enemy>();

		LevelLoader.loadLevel(this, "playground");
		add(player);
		add(items);
		add(_hud);
		add(enemies);

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);
		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(map, player);
		FlxG.overlap(items, player, collideItems);
		FlxG.overlap(enemies, player, collideEnemies);

		FlxG.collide(map, enemies);
		FlxG.collide(enemies, enemies);
	}

	function collideItems(coin:Coin, player:Player):Void {
		coin.collect();
	}

	function collideEnemies(enemy:Enemy, player:Player):Void {
		enemy.interact(player);
	}
}
