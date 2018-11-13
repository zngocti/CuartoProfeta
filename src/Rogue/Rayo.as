package Rogue
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Rayo extends Proyectil
	{
		private var desapareceTimer:Timer = new Timer(3000, 1);
		private var first:Boolean = true;
		
		public function Rayo(pX:int = 100, pY:int = 100, mX:int = 50, mY:int = 50)
		{
			velocidad = 5;

			imagen = new Recursos.rayoClass();
			addChild(imagen);
			
			metaX = mX;
			metaY = mY;
			
			x = pX - (width/2);
			y = pY - (height/2);
		}
		
		public override function mover(num:int):void
		{
			if (first == true)
			{
				//si es la primera vez que se verifica esto inicia un timer para despues desaparecer
				first = false;
				desapareceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, desaparecer);
				desapareceTimer.start();
			}
			//los demas mueven el rayo para acercarlo a su meta
			if (metaX - x < velocidad && metaX > x)
			{
				x = metaX;
			}
				
			else if (x - metaX < velocidad && metaX < x)
			{
				x = metaX;
			}
			
			if (x > metaX)
			{
				x = x - velocidad;
			}
				
			else if(x < metaX)
			{
				x = x + velocidad;
			}
			
			if (metaY - y < velocidad && metaY > y)
			{
				y = metaY;
			}
				
			else if (y - metaY < velocidad && metaY < y)
			{
				y = metaY;
			}
			
			if (y > metaY)
			{
				y = y - velocidad;
			}
			else if (y < metaY)
			{
				y = y + velocidad;
			}
			//el rayo siempre sigue al jugador por eso despues vuelve a verificar la posicion del mismo para actualizar su meta
			metaX = Juego.getJugadorX();
			metaY = Juego.getJugadorY();
		}
		
		private function desaparecer(event:TimerEvent) : void
		{
			//como el rayo tiene la ventaja de estar dirigido tiene la contraparte de desaparecer despues de unos segundos
			desapareceTimer.reset();
			desapareceTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, desaparecer);
			imagen.alpha = 0;
			invisible = true;
		}
	}
}