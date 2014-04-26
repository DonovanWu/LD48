package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class FishingGame extends FlxState
	{
		public var _camera_icon:FlxSprite = new FlxSprite();
		
		
		public override function create():void {
			super.create();
			
			// placeholder for camera trace
			_camera_icon.width = 2;
			_camera_icon.height = 2;
			_camera_icon.set_position(Util.WID / 2, Util.HEI / 2);
			_camera_icon.fill(0xFF66CCFF);
			_camera_icon.visible = false;
			
			FlxG.camera.follow(_camera_icon);
		}
		
		public override function update():void {
			super.update();
		}
	}

}