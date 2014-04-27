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
		private var _vel:FlxPoint;
		private var _acc:FlxPoint;
		private var _end:FlxPoint;
		private var _r:Number;
		private var _ang:Number;
		public const ADJ_COE:Number = 0.8;
		
		public function Bubble(x:Number = 0, y:Number = 0, ang:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this._ang = ang;
			this._vel = new FlxPoint(Util.random_float(-1, 1), Util.random_float(-1, 1));
			this.loadGraphic(Resource.IMPORT_BUBBLE);
			
			var r:Number = Util.random_float(125, 200);
			this._end = new FlxPoint(this.x + r * Math.cos(ang * Util.RADIAN), this.y + r * Math.sin(ang * Util.RADIAN));
			this._acc = new FlxPoint(0, 0);
			
			this.angle = Util.random_float( -15, 15);
			
			var sc:Number = Util.random_float(0.8, 1.5);
			this.scale = new FlxPoint(sc, sc);
		}
		
		public function update_bubble(g:FishingGame):void {
			_ct++;
			this.x += _vel.x;
			this.y += _vel.y;
			this.alpha -= 0.01;
			this.scale.x *= 0.99;
			this.scale.y *= 0.99;
			
			var r2:Number = Math.pow((_end.x - this.x),2) + Math.pow((_end.y - this.y),2);
			_acc.x = (_end.x - this.x) / r2 * ADJ_COE;
			_acc.y = (_end.y - this.y) / r2 * ADJ_COE;
			
			if (Math.abs(this.x - _end.x) >= 1) {
				_vel.x += _acc.x;
			} else {
				_vel.x = 0;
			}
			if (Math.abs(this.y - _end.y) >= 1) {
				_vel.y += _acc.y;
			}
			
			if (this.y <= 360) {
				this.y = 360;
			}
		}
		
		public function should_remove():Boolean {
			return _ct >= 200;
		}
	}

}