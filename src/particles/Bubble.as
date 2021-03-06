package particles 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class Bubble extends FlxSprite
	{
		private var _ct:Number = 0;
		private var _vel:Number;
		private var _ang:Number;
		
		public function Bubble(x:Number = 0, y:Number = 0, ang:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this._ang = ang * Util.RADIAN;
			this._vel = Util.random_float(1, 2);
			this.loadGraphic(Resource.IMPORT_BUBBLE);
			
			this.angle = Util.random_float( -15, 15);
			
			var sc:Number = Util.random_float(0.75, 1.2);
			this.scale = new FlxPoint(sc, sc);
		}
		
		public function update_bubble(g:FishingGame):void {
			_ct++;
			this.x += _vel * Math.cos(_ang);
			this.y += _vel * Math.sin(_ang) + Math.cos(_ct * Util.RADIAN);
			this.alpha -= 0.005;
			this.scale.x *= 0.99;
			this.scale.y *= 0.99;
			
			if (this.y <= 360) {
				this.y = 360;
			}
		}
		
		public function should_remove():Boolean {
			return _ct >= 200;
		}
	}

}