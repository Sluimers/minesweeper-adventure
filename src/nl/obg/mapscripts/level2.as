package nl.obg.mapscripts {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import nl.obg.controllers.*;
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.menus.*;
	import nl.obg.mine.*;
	
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class level2 {
		
		public static const done:Array = [ false, false, false, false, false ];
		
		public static function autoExec():void { 
			
			
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"This is level 2.\n" 
			);
		}
		
		public static function winGame():void {
			winGame();
		}
		
		public static function zoneSign6():void {
			if (!done[0]) {
				sign6();
				done[0] = true;
			}
		}
		
		public static function zoneSign7():void {
			if (!done[1]) {
				sign7();
				done[1] = true;
			}
		}
		
		public static function zoneSign8():void {
			if (!done[2]) {
				sign8();
				done[2] = true;
			}
		}
		
		public static function sign6():void {
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"Watch out for the random MineField!\n" 
			);
		}
		
		public static function sign7():void {
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"Let's have a brief look at that map, shall we?\n" 
			);
		}
		
		public static function sign8():void {
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"Phew!\n Now that wasn't easy, was it?" 
			);
		}
		
		public static function HighlightMines():void {
			MineMap.uncoverMines();
			Map.startTimer(100, 2, coverMines);
		}
		
		public static function coverMines(e:TimerEvent):void {
			MineMap.coverMines();
			Map.removeTimer(coverMines);
		}
	}
}