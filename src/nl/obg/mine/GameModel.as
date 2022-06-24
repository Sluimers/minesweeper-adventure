package nl.obg.mine {
	
	import nl.obg.entities.*;
	import nl.obg.mapsprites.*;
	import nl.obg.www.*;
	
	import nl.obg.engine.*;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class GameModel
	{
		public static var tileIndicator:TileIndicator;
		
		/* Specific entity IDLs */
		
		// droid Arrays
		public static var droids:Array = [];
		public static var droidIDLs:Array = [];
		
		// item Arrays
		public static var itemIDLs:Array = [];
		
		public static var saveState:SaveState = new SaveState();
		
		/* END entity IDLs */
		
		public static function setTileIndicator(t:TileIndicator):void {
			tileIndicator = t;
		}
		
		// not sure if this is correct
		public static function addDroid(droid:Droid):void {
			var id:uint = Engine.spriteIDs[Engine.spriteIDs.length - 1];
			droidIDLs[id] = Engine.entIDs.length - 1;
			droids.push(droid);
		}
		
		public static function removeDroid(id:int):void {
			droidIDLs[id] = undefined;
		}
		
		public static  function getDroids():Array {
			return droids;
		}
		
		public static function addItem(item:Powerup):void {
			const id:uint = item.id;
			itemIDLs[id] = Engine.spriteIDLs[id];
		}
		
		public static function removeItem(id:int):void {
			itemIDLs[id] = undefined;
		}
	}

}