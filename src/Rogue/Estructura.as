package Rogue
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class Estructura extends Sprite
	{
		//estos metodos son solo para cambiar de uno a otro sprite con facilidad
		//y asi manejar comodamente la apertura y cierre de puertas o pasar de puertas a paredes
		private var dibujo:Bitmap = new Bitmap();
		
		public function Estructura()
		{
		}
		
		public function esquina() : void
		{
			dibujo = new Recursos.esquinaClass();
			addChild(dibujo);
		}
		
		public function pared() : void
		{
			dibujo = new Recursos.paredClass();
			addChild(dibujo);
		}
		
		public function puertaAbierta(): void
		{
			dibujo = new Recursos.puertaAbiertaClass();
			addChild(dibujo);
		}
		
		public function puertaCerrada(): void
		{
			dibujo = new Recursos.puertaCerradaClass();
			addChild(dibujo);
		}
		
		public function puertaLvlAbierta(): void
		{
			dibujo = new Recursos.puertaLvlAbiertaClass();	
			addChild(dibujo);
		}
		
		public function puertaLvlCerrada(): void
		{
			dibujo = new Recursos.puertaLvlCerradaClass();	
			addChild(dibujo);
		}
	}
}