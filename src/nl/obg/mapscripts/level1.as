package nl.obg.mapscripts {
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import nl.obg.controllers.*;
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.menus.*;
	import nl.obg.mine.*;
	import nl.obg.www.*;
	
	public class level1 {
		
		public static const done:Array = [ false, false, false, false, false ];
		
		public static function autoExec():void { 
			
		}
		
		public static function zoneSign1():void {
			if (!done[0]) {
				sign1();
				done[0] = true;
			}
		}
		
		public static function zoneSign2():void {
			if (!done[1]) {
				sign2();
				done[1] = true;
			}
		}
		
		public static function zoneSign3():void {
			if (!done[2]) {
				sign3();
				done[2] = true;
			}
		}
		
		public static function zoneSign4():void {
			if (!done[3]) {
				sign4();
				done[3] = true;
			}
		}
		
		public static function zoneSign5():void {
			if (!done[4]) {
				sign5();
				done[4] = true;
			}
		}
		
		public static function sign1():void {
			
			GameControl.saveState(new SaveState(10,10));
			
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"Are you our Minesweeper?\n That's Great!\n We're so glad you're here.\n" 
			);
		}
		
		public static function sign2():void {
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"Look out for those driods!\n" 
			);
		}
		
		public static function sign3():void {
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"Don't go this way!"
			);
		}
		
		public static function sign4():void {
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"Powerdown!\n Grab the powerdown and Press C to use it.\n Those droids will never know what hit them."
			);
		}
		
		public static function sign5():void {
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"Stealth!\n Grab the stealth and Press S to turn it on/off.\n You'll be so low on their radars \n they'll think you're just a cute bunny."
			);
		}
		
		public static function bomb():void {
			MineMap.removeRandomMine();
		}
		
		public static function Stealth():void {
			Engine.getPlayer().ent.setStealth(true);
		}
		
		public static function HighlightMines():void {
			MineMap.uncoverMines();
			Map.startTimer(100, 2, coverMines);
		}
		
		public static function coverMines(e:TimerEvent):void {
			MineMap.coverMines();
			Map.removeTimer(coverMines);
		}
		
		public static function reboot(e:TimerEvent):void {
			var droids:Array = GameModel.getDroids();
			for (var i:uint = droids.length; i--; ) droids[i].activate();
			Map.removeTimer(reboot);
		}
		
		public static function Powerdown():void {
			var droids:Array = GameModel.getDroids();
			for (var i:uint = droids.length; i--; ) droids[i].deactivate();
			Map.startTimer(1000, 2, reboot);
		}
		
		public static function winGame():void {
			GameControl.winGame();
			Map.Switch("level2");
			Engine.getPlayer().ent.move(0, 0, 0);
		}
	}
}