package Rogue
{
	import flash.display.Sprite;

	public class Items extends Sprite
	{
		protected var precio:int = 0;
		protected var nombre:String = "Nombre";
		
		public function Items()
		{

		}
	
		public function setX(num:int) : void
		{
			x = num;
		}
		
		public function setY(num:int) : void
		{
			y = num;
		}
		
		public function getX() : int
		{
			return x;
		}
		
		public function getY() : int
		{
			return y;
		}
		
		public function getPrecio() : int
		{
			return precio;
		}
		
		public function getNombre(): String
		{
			return nombre;
		}
	}
}