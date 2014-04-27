package  {
	import flash.display.Bitmap;
    import flash.utils.ByteArray;
	import flash.media.Sound;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	public class Resource {
		
		// accessories
		[Embed( source = "../resc/iceblock.png" )] public static var IMPORT_ICEBLOCK:Class;
		[Embed( source = "../resc/bait.png" )] public static var IMPORT_BAIT:Class;
		
		[Embed( source = "../resc/titlescreen.png" )] public static var IMPORT_TITLESCREEN:Class;
		
		// bg
		[Embed( source = "../resc/bg.png" )] public static var IMPORT_BG:Class;
		
		// core
		[Embed( source = "../resc/player.png" )] public static var IMPORT_PLAYER:Class;
		
		// dialogs
		[Embed( source = "../resc/dialog1.png" )] public static var IMPORT_DIALOG1:Class;
		[Embed( source = "../resc/dialog2.png" )] public static var IMPORT_DIALOG2:Class;
		[Embed( source = "../resc/dialog3.png" )] public static var IMPORT_DIALOG3:Class;
	}
}