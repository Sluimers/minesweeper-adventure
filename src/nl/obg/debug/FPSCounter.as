package nl.obg.debug {
    import flash.utils.getTimer;

    public class FPSCounter{
        private static var lastTime:uint = getTimer();
        private static var ticks:uint = 0;
		private static var count:uint = 0;
		private static const timeRate:uint = 1000;
        private static var text:String = "--.- FPS";
		
        public static function update():String {
			
			var now:int = getTimer();
			count += now - lastTime;
			lastTime = now;
			++ticks;
			if (count > timeRate) {
				count -= timeRate;
				text = count.toFixed(1) + " FPS";
				ticks = 0;
			}
            return text;
        }
    }
}