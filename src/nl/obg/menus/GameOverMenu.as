package nl.obg.menus {
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import nl.obg.standards.*;
	import nl.obg.controllers.*;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class GameOverMenu extends MapMenu {
		
		public function GameOverMenu() {
			super();
		}
		
		public override function init():void {
			super.init();
			setSize(mapWidth, mapHeight);
			
			addCenterText("Title", "GAME OVER", Menu.TITLESIZE);
			addCenterText("Continue button", "Press ENTER to continue", TEXTSIZE, Color.SILVER);
			addCenterText("Quit button", "or Q to Quit", TEXTSIZE, Color.SILVER);
			addItemEventListener("Continue button", MouseEvent.CLICK, GameControl.continueGameM);
			addItemEventListener("Quit button", MouseEvent.CLICK, GameControl.quitGameM);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, GameControl.gameOverMenuKeys);
		}
	}
}