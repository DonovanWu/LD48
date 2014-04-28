package particles 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class WaterWeed extends FlxSprite
	{
		public var _amp:Number = 1;
		private var _ct:Number = 0;
		
		public function WaterWeed(x:Number, y:Number, ang:Number) 
		{
			this.loadGraphic(Resource.IMPORT_WATERWEED);
			this.x = x - this.width;
			this.y = y - this.height - 100;
			this.angle = 0;
			
			rotate_to(ang);
		}
		
		public function update_waterweed(g:FishingGame):void {
			_ct = (_ct + 1) % 314159;
			rotate(_amp*0.01*Math.sin(_ct*Util.RADIAN));
		}
		
		public function rotate_to(ang:Number):void {
			this.angle = ang;
			
			var hei:Number = this.height / 2;
			var wid:Number = this.width / 2;
			
			this.x += hei * Math.sin(ang * Util.RADIAN);
			this.y += hei * (1 - Math.cos(ang * Util.RADIAN));
			this.x += wid;
		}
		
		public function rotate(ang:Number):void {
			rotate_to(this.angle + ang);
		}
		
		public function green_version():WaterWeed {
			this.color = 0xFF156A15;
			this._amp = -1;
			return this;
		}
	}

}