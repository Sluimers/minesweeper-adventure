package nl.obg.junk
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	 
	public class SavedMapData extends MapData {
		
		public function SavedMapData() { }
		
		public var flags:Array;
		
		public function save(nwLayers:Array,  nwUncovered:Array, nwIsCovered:Array, nwHasMine:Array, nwEnts:Array):void {
			setMines(nwHasMine);
			setCovers(nwUncovered, nwIsCovered);
			setLayers(nwLayers);
			setEntities(nwEnts);
		}
		
		public function setLayers(nwLayers:Array):void {
			layers = nwLayers;
		}
		
		public function setFlags(nwFlags:Array):void {
			flags =  nwFlags;
		}
		
		public function setMines(nwMines:Array):void {
			mines =  nwMines;
			nMines = 0; // why bother counting them?
		}
		
		public function setCovers(nwCovers:Array, nwIsCovered:Array):void {
			covers = nwCovers;
		}
		
		public function setObs(nwObs:Array):void {
			obs = nwObs;
			obs[ -1] = nwObs[ -1];
		}
		
		public function setVSP(nwVSP:String):void {
			vsp = nwVSP;
		}
		
		public function setTileSize(nwTileWidth:uint, nwTileHeight:uint):void {
			tileWidth = nwTileWidth;
			tileHeight = nwTileHeight;
		}
		
		public function setEntities(nwEnts:Array):void {
			entities = nwEnts;
		}
		
		public function moveEntsOffMap(ents:Array):void {
			var e:Array = entities, i:int = e.length, j:int, k:int, m:int, eid:int;
		}
		
		public function setZones(nwZones:Array):void {
			zones = nwZones;
			zones[ -1] = nwZones[ -1];
		}
	}
}