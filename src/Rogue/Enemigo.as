package Rogue
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Enemigo extends Entidad
	{
		protected static var numeroRandom:int = 0;
		protected static const masUno:int = 1;
		
		protected var metaX:int = 0;
		protected var metaY:int = 0;
		
		protected var ataqueCD:Timer = new Timer(200, 1);
		
		protected var escudoActivado:Boolean = false;
		
		protected var escudo:Shape = new Shape();
		
		public function Enemigo()
		{
		}
				
		protected function calcularRadio() : int
		{
			if(imagen.width > imagen.height)
			{
				return imagen.width/2 + 5;
			}
			
			else
			{
				return imagen.height/2 + 5;
			}
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
		
		public function setMetaX(num:int = 100) : void
		{
			metaX = num;
		}
		
		public function setMetaY(num:int = 100) : void
		{
			metaY = num;
		}

		public function getMetaX() : int
		{
			return metaX;
		}
		
		public function getMetaY() : int
		{
			return metaY;
		}
		
		public function atacar(cuarto:Cuarto) : void
		{

		}
		
		protected function finCD(event:TimerEvent) : void
		{
			ataqueDisponible = true;
			ataqueCD.reset();
		}
		
		public function iniciarCDAtaque() : void
		{
			ataqueCD.start();
		}
		
		public function activarEscudo() : void
		{
			escudo.alpha = 0.3;
			escudoActivado = true;
		}
		
		public function desactivarEscudo() : void
		{
			escudo.alpha = 0;
			escudoActivado = false;
		}
		
		public function getEscudoActivado() : Boolean
		{
			return escudoActivado;
		}
		
		public function restarVida(num:uint) : void
		{
			//mientras no haya escudo se pierde vida cuando recibe un ataque
			if(escudoActivado == false)
			{
				if(vida <= num)
				{
					estaVivo = false;
					detenerAnim();
					imagen.alpha = 0;
					Juego.aumentarOro();
					Juego.restarUnEnemigo();
				}
				else
				{
					vida = vida - num;
				}
			}
		}
		
		public function reducirVidaA(jugador:Jugador):void
		{
			//esto es para atacar al jugador
			jugador.restarVida(ataqueTotal);
		}
		
		protected function detenerAnim() : void
		{
			
		}
	}
}