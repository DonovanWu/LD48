package core 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import particles.Torpedo;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class Submarine extends FlxSprite
	{
		public var _end:FlxPoint;
		private var _end_reached:Boolean = false;
		private var _flip:Boolean;
		private var _ct:Number = 0;
		
		public function Submarine(start:FlxPoint, end:FlxPoint, flip:Boolean = false) 
		{
			this.x = start.x;
			this.y = start.y;
			this.loadGraphic(Resource.IMPORT_SUBMARINE);
			this._end = end;
			
			this._flip = flip;
			if (flip) {
				this.scale.x = -1;
			}
		}
		
		public function update_submarine(g:FishingGame):void {
			if (!_end_reached) {
				var ang:Number = Math.atan2(_end.y - this.y, _end.x - this.x);
				this.x += Math.cos(ang);
				this.y += Math.sin(ang);
				if (Math.abs(this.x - _end.x) <= 5 && Math.abs(this.y - _end.y) <= 5) {
					_end_reached = true;
				}
			} else {
				_ct = (_ct + 1) % 31416;
				this.x += Math.sin(_ct * Util.RADIAN);
				this.y += 0.1 * Math.cos(_ct * Util.RADIAN);
				
				var launch_time:Number = (_flip) ? 0:120;	// 600 ?
				if (_ct % 720 == launch_time) {	// test change point
					var x0:Number = (_flip) ? -60:700;
					var y0:Number = Util.random_float(450, 550);
					var ang_adj:Number = (_flip) ? 0:180;
					
					FlxG.play(Resource.IMPORT_SOUND_LAUNCHER, 0.5);
					g._torpedos.add(new Torpedo(x0, y0, ang_adj + Util.random_float( -15, 15)));
				}
			}
		}
		
	}

}