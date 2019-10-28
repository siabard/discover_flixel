package utils;

import flixel.math.FlxPoint;
import objects.WalkEnemy;
import objects.SpikeEnemy;
import objects.BonusBlock;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import states.PlayState;
import objects.Coin;
import objects.Goal;

class LevelLoader {
	public static function getLevelObjects(map:TiledMap, layer:String):Array<TiledObject> {
		if ((map != null) && (map.getLayer(layer) != null)) {
			var objLayer:TiledObjectLayer = cast map.getLayer(layer);
			return objLayer.objects;
		} else {
			trace("Object layer " + layer + " not found! ");
			return [];
		}
	}

	public static function loadLevel(state:PlayState, level:String) {
		var tiledMap = new TiledMap("assets/data/" + level + ".tmx");
		var mainLayer:TiledTileLayer = cast tiledMap.getLayer("main");

		state.map = new FlxTilemap();
		state.map.loadMapFromArray(mainLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, 1);

		var backLayer:TiledTileLayer = cast tiledMap.getLayer("back");
		var backMap = new FlxTilemap();
		backMap.loadMapFromArray(backLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, 1);
		backMap.solid = false;

		state.add(backMap);
		state.add(state.map);

		// Load  exit & check point
		for (object in getLevelObjects(tiledMap, "system")) {
			switch (object.type) {
				case "checkpoint":
					state.checkpoint = FlxPoint.get(object.x, object.y - 16);
				case "goal":
					state.items.add(new Goal(object.x, object.y - 16));
			}
		}

		var player:TiledObject = getLevelObjects(tiledMap, "player")[0];
		var playerPosition:FlxPoint = new FlxPoint();
		if (Reg.checkpointReached) {
			playerPosition = state.checkpoint;
		} else {
			playerPosition = FlxPoint.get(player.x, player.y - 16);
		}
		state.player.setPosition(playerPosition.x, playerPosition.y);
		for (coin in getLevelObjects(tiledMap, "coins")) {
			state.items.add(new Coin(coin.x, coin.y - 16));
		}

		// Load enemies
		for (enemy in getLevelObjects(tiledMap, "enemies")) {
			switch (enemy.type) {
				case "spike":
					state.enemies.add(new SpikeEnemy(enemy.x, enemy.y - 16));
				default:
					state.enemies.add(new WalkEnemy(enemy.x, enemy.y - 16));
			}
		}

		// Load bonus blocks
		for (block in getLevelObjects(tiledMap, "blocks")) {
			var blockToAdd = new BonusBlock(block.x, block.y - 16);
			blockToAdd.content = block.type;
			state.blocks.add(blockToAdd);
		}
	}
}
