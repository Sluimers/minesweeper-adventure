package nl.obg.menus {
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.controllers.*;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class GameMenu extends MapMenu {
		
		public function GameMenu() {
			super();
		}
		
		public override function init():void {
			const e:Engine = (parent as Engine);
			
			setSize(mapWidth, mapHeight);
			
			addCenterText("Title", "GAME OVER", Menu.TITLESIZE);
			addCenterText("Play again button", "Press enter to continue game\nPress esc to go back to the main menu", TEXTSIZE, Color.SILVER);
			addItemEventListener("Play again button", MouseEvent.CLICK, MenuControl.gameMenu);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, MenuControl.gameMenu);
		}
	}
}