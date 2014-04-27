package  
{
	public class Util 
	{
		public static var WID:Number = 640;
		public static var HEI:Number = 360;
		
		public static function random_float(min:Number, max:Number):Number {
			return min + Math.random() * (max - min);
		}
		
		public static function random_int(min:int, max:int):int {
			return Math.floor(random_float(min,max+1)) as int;
		}
	}

}