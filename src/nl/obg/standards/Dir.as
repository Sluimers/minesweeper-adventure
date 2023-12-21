package nl.obg.standards {
	/**
	 * ...
	 * @author ...
	 */
	public class Dir
	{
		public static const DOWN:uint = 0;
		public static const UP:uint = 1;
		public static const RIGHT:uint = 2;
		public static const LEFT:uint = 3;
		
		public static const DOWNRIGHT:uint = 4;
		public static const UPLEFT:uint = 5;
		public static const UPRIGHT:uint = 6;
		public static const DOWNLEFT:uint = 7;
		
		public static const OPPOSITE_DIRECTION:int = 0x01;
		
		public static const DOWN_BIT:uint = 		0x01; // 0001 | 0000 0001 
		public static const UP_BIT:uint = 			0x02; // 0010 | 0000 0010
		public static const RIGHT_BIT:uint = 		0x04; // 0100 | 0000 0100
		public static const LEFT_BIT:uint = 		0x08; // 1000 | 0000 1000
		
		public static const D4:uint =	 			0x0F; // 1111
		public static const D4_NO_DOWN:uint = 		0x0E; // 1110
		public static const D4_NO_UP:uint = 		0x0D; // 1101
		public static const D4_NO_RIGHT:uint =		0x0B; // 1011
		public static const D4_NO_LEFT:uint = 		0x07; // 0111
		
		public static const UP_DOWN:uint = 			0x03; // 0011
		public static const LEFT_RIGHT:uint = 		0x0C; // 1100
		
		public static const DOWNRIGHT_BIT:uint = 	0x10; // 0001 0000  
		public static const UPLEFT_BIT:uint = 		0x20; // 0010 0000 
		public static const UPRIGHT_BIT:uint = 		0x40; // 0100 0000 
		public static const DOWNLEFT_BIT:uint = 	0x80; // 1000 0000 
		
		public static const D8:uint = 				0xFF; // 1111 1111
		public static const D8_NO_DOWNRIGHT:uint = 	0x10; // 1110 1111  
		public static const D8_NO_UPLEFT:uint = 	0x20; // 1101 1111 
		public static const D8_NO_UPRIGHT:uint = 	0x40; // 0111 1111 
		public static const D8_NO_DOWNLEFT:uint = 	0x80; // 0111 1111 
		
		
		/*
		public static const FW:uint = 0;
		public static const BW:uint = 1;
		
		protected static const FW_BIT:uint =				0x01;	// 0001
		protected static const BW_BIT:uint =				0x02;	// 0010
		*/
	}
}