package nl.obg.mapscripts {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import nl.obg.www.*;
	
	public class tutorial {
		
		// Autoexec
		public static function init():void { }
		
		public static function callZoneLabel(s:String):void {
			switch(s) {
				case "teleport": teleport(); break;
				case "dialog": dialogTest(); break;
			}
		}
		
		public static function callZone(z:uint):void {
			switch(z) {
				case 1: teleport();			break;
				case 2: dialogTest();		break;
				case 3: stealth();			break;
				case 4: highlightMines();	break;
				case 5: powerdown();		break;
				case 6: bomb();				break;
			}
		}
		
		public static function teleport():void {
			Map.getPlayer().teleport(3,1,0);
		}
		
		public static function stealth():void {
			Map.getPlayer().setStealth(true);
		}
		
		public static function highlightMines():void {
			Map.uncoverMines();
			
			var myTimer:Timer = new Timer(100, 2);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, coverMines);
			
			myTimer.start();
		}
		
		public static function coverMines(e:TimerEvent):void {
			Map.coverMines();
		}
		
		public static function powerdown():void {
			var droids:Array = Engine.getDroids();
			for (var i:uint = droids.length; i--; ) droids[i].deactivate();
			Map.startTimer(1000, 2, reboot);
		}
		
		public static function bomb():void {
			Map.removeRandomMine();
		}
		
		public static function reboot(e:TimerEvent):void {
			var droids:Array = Engine.getDroids();
			for (var i:uint = droids.length; i--; ) droids[i].activate();
			Map.removeTimer(reboot);
		}
		
		public static function dialogTest():void {
			const d:DialogBox = new DialogBox();
			d.init();
			d.addDialogText(
			"Are you our Minesweeper? That's Great! We're so glad to see you.\n" 
							+"Duhrians rampaged our villages years ago and left these robots to guard the place,\n" 
							+"Now that they've been defeated, the robots started to walk around aimlessly.\n"
							+"But be careful Marcus, the robots are still highly lethal and worst of all THERE ARE MINES EVERYWHERE!\n" 
							+"You have to help us Marcus. We're told the only one that knows how to sweep these mines.\n" 
							+"We tried, but our best expert injured his legs while stepping on a mine.\n"
							+"He was lucky but too scared to try again."
							+"Now we have vested all our hopes are on you."
							+"Good luck Marcus!"
			);
		}
		
		public static function getZonePic(i:uint):String {
			switch(i) {
				case 1: return "teleport"; break;
				case 2: return "dialog"; break;
				case 3: return "stealth"; break;
				case 4: return "map"; break;
				case 5: return "powerdown"; break;
				case 6: return "bomb"; break;
				default: return "teleport"; break;
			}
		}
	}
}