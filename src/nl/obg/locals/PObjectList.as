package nl.obg.locals {
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	 
	public class PObjectList
	{
		private static var pObjects:Array = [];
		private static var pObjectNames:Array = [];
		
		public static function setPreloadObjects(objects:Array, paths:Array):void {
			var i:int;
			for (i = objects.length; i--; ) {
				if(objects[i] is Bitmap) pObjects[i] = objects[i].bitmapData; 
				else pObjects[i] = objects[i]; 
			}
			for (i = paths.length; i--; ) {
				paths[i] = paths[i].replace("../", "");
				
				paths[i] = paths[i].replace(PathName.introDir + PathName.introMovie, LocalPathName.movies + PathName.introMovie);
				paths[i] = paths[i].replace(PathName.introDir + PathName.introBackground, LocalPathName.images + PathName.introBackground);
				paths[i] = paths[i].replace(PathName.mapSpritesDir, LocalPathName.mapSprites);
				paths[i] = paths[i].replace(PathName.entitiesDir, LocalPathName.entities);
				paths[i] = paths[i].replace(PathName.mapsDir, LocalPathName.maps);
				
				paths[i] = paths[i].replace(PathName.imagesDir, LocalPathName.images);
				paths[i] = paths[i].replace(PathName.fontsDir, LocalPathName.fonts);
				
				paths[i] = paths[i].replace(PathName.soundsDir, LocalPathName.sounds);
				paths[i] = paths[i].replace(PathName.musicDir, LocalPathName.music);
				
				
				paths[i] = paths[i].replace(PathName.gfxDir, LocalPathName.images);
				paths[i] = paths[i].replace(PathName.sfxDir, LocalPathName.sounds);
				pObjectNames[i] = paths[i];
			}
		}
		
		public static function getXMLData(name:String):XML {
			return XML(pObjects[pObjectNames.indexOf(name)]);
		}
		
		public static function getBitmapData(name:String):BitmapData {
			return pObjects[pObjectNames.indexOf(name)];
		}
		
		public static function getMovie(name:String):MovieClip {
			return pObjects[pObjectNames.indexOf(name)];
		}
	}

}