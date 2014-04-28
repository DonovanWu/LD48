package particles 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class Torpedo extends FlxSprite
	{
		private var _ct:Number = 0;
		private var _vel:Number;
		private var _ang:Number;
		private var _caught:Boolean = false;
		
		public function Torpedo(x:Number = 0, y:Number = 0, ang:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this._vel = 0;
			this.loadGraphic(Resource.IMPORT_TORPEDO);
			
			this.angle = ang;
			
			_ang = (Util.random_float(0, 2) <= 1) ? -0.2:0.2;
		}
		
		public function update_torpedo(g:FishingGame):void {
			_ct++;
			this.angle += Util.random_float( -0.1, 0.1) + _ang;
			
			if (_vel < 3) {
				_vel += 0.2;
			}
			this.x += _vel * Math.cos(this.angle * Util.RADIAN);
			this.y += _vel * Math.sin(this.angle * Util.RADIAN);
			
			if (this.y <= 360) {
				this.y = 360;
				_ct = 300;
				for (var i:int = 0; i < g._iceblocks.members.length; i++ ) {
					var itr_ice:IceBlocks = g._iceblocks.members[i];
					if (itr_ice.alive) {
						var ice_axis:Number = itr_ice.x + 20;
						if (Math.abs(this.x - ice_axis) <= g.POS_TOL*1.5) {
							itr_ice.kill();
						}
					}
				}
			}
		}
		
		public function should_remove():Boolean {
			return _ct >= 300;
		}
	}

}