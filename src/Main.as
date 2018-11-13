package
{
	import Rogue.Juego;
	import Rogue.Menu;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	[SWF(width="1080",height="672", backgroundColor="#000000",frameRate="30")]
	public class Main extends Sprite
	{
		public function Main()
		{
			var nuevoMenu:Menu = new Menu();
			addChild(nuevoMenu);
		}
	}
}