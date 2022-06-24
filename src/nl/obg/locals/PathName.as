package nl.obg.locals {
	/**
	 * ...
	 * @author Rogier Sluimers
	 */ 
	public class PathName
	{
		
		public static const gfxDir:String = 			"gfx/";
		public static const sfxDir:String =				"sfx/";
		public static const mapsDir:String = 			"maps/";
		public static const tilesetsDir:String = 		"tilesets/";
		public static const menusDir:String = 			"menus/";
		
		public static const introDir:String = 			gfxDir + "intro/";
		public static const fontsDir:String = 			gfxDir + "fonts/";
		public static const imagesDir:String = 			gfxDir + "images/";
		public static const spritesDir:String = 		gfxDir + "sprites/";
		
		public static const mapSpritesDir:String =		spritesDir + "mapsprites/";
		public static const entitiesDir:String =		spritesDir + "entities/";
		
		public static const soundsDir:String = 			sfxDir + "sounds/";
		public static const musicDir:String = 			sfxDir + "music/";
		
		public static const introBackground:String = 	"OneBigGame.png";
		public static const introMovie:String =			"Storyboard Trailer Colour.swf";
		
		public static const introFiles:Array = 	[
													introBackground, introMovie
												].map(introFilesAdd);
		public static const fonts:Array = 		[
													"proggyclean.png"
												].map(fontsAdd);
		public static const images:Array =		[
													"Avatar.png"
												].map(imagesAdd);
		public static const mapSprites:Array = 	[
													"1.png", "2.png", "3.png", "4.png", "5.png", "6.png", "7.png", "8.png", "9.png",
													"Flag.png", "Mine.png", "Teleport.png", "Stealth.png", "Bomb.png",
													"TileIndicator.png", "Sign.png", "Powerdown.png", "HighlightMines.png"
												].map(mapSpritesAdd);
		public static const entities:Array = 	[
													"Player.png", "Guard.png", "LoSDroid.png", "MineLayer.png", "ProximityDroid.png",
													"Wallhugger.png", "Bullet.png", "TestDroid.png"
												].map(entitiesAdd);
		public static const maps:Array = 		Levels.names.slice(1).map(mapsAdd);
		public static const tilesets:Array = 	[
													"Beach.png"
												].map(tilesetsAdd);
		public static const menus:Array =		[
													"MainMenu.glade", "Test.glade"
												].map(menusAdd);
		
		public static const files:Array = introFiles.concat(maps.concat(tilesets.concat(entities.concat(mapSprites.concat(images.concat(fonts.concat(menus)))))));
		
		private static function mapsAdd(item:*, index:int, arr:Array):String {
			return mapsDir.concat(item + ".xml");
		}
		
		private static function tilesetsAdd(item:*, index:int, arr:Array):String {
			return tilesetsDir.concat(item);
		}
		
		private static function entitiesAdd(item:*, index:int, arr:Array):String {
			return entitiesDir.concat(item);
		}
		
		private static function mapSpritesAdd(item:*, index:int, arr:Array):String {
			return mapSpritesDir.concat(item);
		}
		
		private static function imagesAdd(item:*, index:int, arr:Array):String {
			return imagesDir.concat(item);
		}
		
		private static function fontsAdd(item:*, index:int, arr:Array):String {
			return fontsDir.concat(item);
		}
		
		private static function introFilesAdd(item:*, index:int, arr:Array):String {
			return introDir.concat(item);
		}
		
		private static function menusAdd(item:*, index:int, arr:Array):String {
			return menusDir.concat(item);
		}
	}

}