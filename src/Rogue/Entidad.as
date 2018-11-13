package Rogue
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class Entidad extends Sprite
	{
		protected var vida:uint = 100;
		protected var vidaMaxBase:uint = 100;
		protected var vidaMax:uint = 100;
		
		protected var estaVivo:Boolean = true;
		
		protected var ataqueBase:uint = 0;
		protected var ataqueTotal:uint = 0;
		
		protected var imagen:Bitmap = new Bitmap();
		protected var velocidad:uint = 8;
	
		protected var ataqueDisponible:Boolean = true;
		
		protected var poolAtaques:Vector.<Proyectil> = new Vector.<Proyectil>(maxPoolAtaques);
		public static const maxPoolAtaques:int = 50;
		
		public function Entidad()
		{
		}
		
		public function mover(num:int) : void
		{
			switch(num)
			{
				case 1:
					y = y - velocidad;
					break;
				case 2:
					x = x + velocidad;
					break;
				case 3:
					y = y + velocidad;
					break;
				case 4:
					x = x - velocidad;
					break;
			}
		}
		
		public function getImagen() : Bitmap
		{
			return imagen;
		}
		
		public function getAtaqueDisponible() : Boolean
		{
			return ataqueDisponible;
		}
		
		public function switchAtaqueDisponible() : void
		{
			ataqueDisponible = !ataqueDisponible;
		}
		
		public function getPoolAtaques(num:int) : Proyectil
		{
			if (num < maxPoolAtaques)
			{
				return poolAtaques[num];	
			}
			else
			{
				return poolAtaques[0]
			}
		}
		
		public function getEstaVivo() : Boolean
		{
			return estaVivo;
		}
	}
}