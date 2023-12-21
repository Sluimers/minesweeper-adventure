package nl.obg.debug {
	import flash.utils.getTimer;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class Benchmark
	{
		private static var a:Boolean = false;
		private static var b:Boolean = false;
		
		// for performance
		private static var now:int = 		getTimer();
		private static var oldTime:int =	getTimer(); 
		
		private static var frameSkip:int =	10; 
		
		private static var engine:Engine;
		
		public static function init():void {
			const i:uint = 10000000;
			test0(i);
		}
		
		private static function test0(i:uint):Number {
			const a:int = (((int(! !4) << 1 | int(! !0)) << 1 | int(! !2)) << 1 | int(! !5));
			const b:int = int(!!5);
			const c:int = (5);
			const d:int = int(!6);
			trace(a,b,c,d);
			return 0;
		}
		
		private static function test1(i:uint):Number {
			var startTime:Date = new Date();
			
			for (var j:uint = i; j--; ) {
				Engine.getLevel();
			}
			
			return (new Date()).getTime() - startTime.getTime(); 
		}
		
		private static function test2(i:uint):Number {
			var startTime:Date = new Date();
			
			for (var j:uint = i; j--; ) {
			}
			
			return (new Date()).getTime() - startTime.getTime(); 
		}
		
		// YOU READ THAT RIGHT, THIS IS THE EASY SORTING METHOD!!
		// The Hard way is trying to beat sortOn's quicksort with CataSort.
		private static function Easysorting(i:uint):Number {
			var startTime:Date = new Date();
			var sids:Array = [,,,,,,,,,,, [10 ,3, 0, 1, 2, 3, 6, 8], [1, 5, 5, 7, 7, 9, 4], [3, 2, 1],,,,,,,,,,,,,,,,, ];
			var yEntValues:Array = [11, 2, 33, 4, 99, 77, 55, 8, 6, 0, 99];
			var ids:Array = [];
			var spriteIDCs:Array = [];
			var yValues:Array = [];
			var spriteIDs:Array = [];
			var o:Object = { };
			var yValueString:String = "";
			var id:int;
			
			
			for (var j:uint = i; j--; ) {
				spriteIDCs = [];
				yValues = [];
				spriteIDs = [];
				for (var k:uint = sids.length; k--; ) {
					ids = sids[k];
					if (ids) {
						for (var l:int = ids.length; l--; ) {
							id = ids[l];
							if (!spriteIDCs[id]) {
								spriteIDCs[id] = true;
								spriteIDs.push(id);
								
								o = { id:id, y:yEntValues[spriteIDs.length - 1] };
								yValues.push(o);
							}
						}
					}
				}
				if (!j) {
					trace("-- unsorted --");
					for (k = yValues.length; k--; ) {
						yValueString += yValues[k].y + ",";
					}
					trace("spriteIds:" + spriteIDs);
					trace("yValues:" + yValueString);
				}
				yValues.sortOn("y", Array.NUMERIC, Array.DESCENDING);
			}
			
			
			
			trace("-- sorted --");
			//trace("sprite IDs:" + spriteIDsSorted);
			
			yValueString = "";
			
			// just so that I can see them
			for (k = yValues.length; k--; ) {
				spriteIDs[k] = yValues[k].id;
				yValueString += yValues[k].y + ",";
			}
			
			trace("id's:" + spriteIDs);
			trace("Y Values:" + yValueString);
			
			return (new Date()).getTime() - startTime.getTime(); 
		}
		
		// * END TEST FUNCITONS *//
	}

}