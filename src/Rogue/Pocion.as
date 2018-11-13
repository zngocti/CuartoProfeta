package Rogue
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class Pocion extends Items
	{
		private var numeroRandom:int = 0;
		private const masUno:int = 1;

		private var vidaCura:int = 0;
		
		private var imagen:Bitmap = new Bitmap();
		
		public function Pocion()
		{
			numeroRandom = Math.random() * 11 + masUno;
			addChild(imagen);
			
			//la pocion se genera de manera random siendo una simple, mediana o grande
			//y su poder curativo depende del nivel
			
			if(numeroRandom > 9)
			{
				imagen = new Recursos.pota3Class();
				vidaCura = 50 + 10 * (Juego.getNivel() - 1);
				nombre = "Pocion Grande";
				precio = 300;
			}
			else if(numeroRandom > 5)
			{
				imagen = new Recursos.pota2Class();
				vidaCura = 25 + 5 * (Juego.getNivel() - 1);
				nombre = "Pocion Mediana";
				precio = 200;
			}
			else
			{
				imagen = new Recursos.pota1Class();
				vidaCura = 15 + 3 * (Juego.getNivel() - 1);
				nombre = "Pocion Simple";
				precio = 100;
			}
			
			addChild(imagen);
			imagen.x = -width/2;
			imagen.y = -width/2;
		}
		
		public function getCuracion() : int
		{
			return vidaCura;
		}
	}
}