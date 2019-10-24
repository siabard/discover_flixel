package states;

import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
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
	private var _entities:FlxGroup;

	private var _gameCamera:FlxCamera;
	private var _hudCamera:FlxCamera;

	public var map:FlxTilemap;
	public var player(default, null):Player;
	public var items(default, null):FlxTypedGroup<FlxSprite>;
	public var enemies(default, null):FlxTypedGroup<Enemy>;

	override public function create():Void {
		Reg.PS = this;
		Reg.pause = false;
		Reg.time = 300;

		_gameCamera = new FlxCamera();
		_hudCamera = new FlxCamera();

		FlxG.cameras.reset(_gameCamera);
		FlxG.cameras.add(_hudCamera);
		_hudCamera.bgColor = FlxColor.TRANSPARENT;
		FlxCamera.defaultCameras = [_gameCamera];

		_hud = new HUD();
		_hud.setCamera(_hudCamera);

		_entities = new FlxGroup();

		player = new Player();
		items = new FlxTypedGroup<FlxSprite>();
		enemies = new FlxTypedGroup<Enemy>();

		LevelLoader.loadLevel(this, "playground");
		add(player);

		_entities.add(items);
		_entities.add(enemies);

		add(_entities);
		add(_hud);

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);

		openSubState(new IntroSubState(FlxColor.BLACK));
		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (player.alive) {
			FlxG.collide(map, player);
			FlxG.overlap(_entities, player, collideEntities);
		}

		FlxG.collide(map, _entities);
		FlxG.collide(enemies, enemies);

		updateTime(elapsed);
	}

	function collideEntities(entity:FlxSprite, player:Player):Void {
		if (Std.is(entity, Coin))
			(cast entity).collect();

		if (Std.is(entity, Enemy))
			(cast entity).interact(player);
	}

	function collideItems(coin:Coin, player:Player):Void {
		coin.collect();
	}

	function collideEnemies(enemy:Enemy, player:Player):Void {
		enemy.interact(player);
	}

	private function updateTime(elapsed:Float) {
		if (!Reg.pause) {
			if (Reg.time > 0)
				Reg.time -= elapsed;
			else {
				Reg.time = 0;
				player.kill();
			}
		}
	}
}
