package Rogue
{
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Ojo extends Enemigo
	{
		private var animacionTimer:Timer = new Timer(800, 0);
		private var listaAnim:Vector.<Bitmap> = new Vector.<Bitmap>(4);
		private var contadorAnim:int = 2;
		
		public function Ojo()
		{
			//se inicia el pool de ataques
			for(var i:int = 0; i < maxPoolAtaques; i++)
			{
				poolAtaques[i] = new Blood();
			}
			
			//la lista de animacion del ojo
			listaAnim[0] = new Recursos.ojo1Class();
			listaAnim[1] = new Recursos.ojo2Class();
			listaAnim[2] = new Recursos.ojo3Class();
			listaAnim[3] = new Recursos.ojo2Class();
			
			ataqueCD = new Timer(800, 1); //tiempo muerto para los ataques
			ataqueCD.addEventListener(TimerEvent.TIMER_COMPLETE, finCD);
			
			vidaMaxBase = 150 + (25 * (Juego.getNivel() - 1));
			vidaMax = vidaMaxBase;
			vida = vidaMax;
			
			ataqueBase = 5 + (10 * (Juego.getNivel() - 1));
			ataqueTotal = ataqueBase;
			
			imagen = listaAnim[1];
			
			imagen.scaleX = 0.5;
			imagen.scaleY = 0.5;
			
			imagen.x = -(imagen.width/2);
			imagen.y = -(imagen.height/2);
			
			addChild(imagen);
			velocidad = 0;
			
			escudo.graphics.beginFill(0xA9D3AE);
			escudo.graphics.drawCircle(0,0,25);
			escudo.graphics.endFill();
			addChild(escudo);
			escudo.x = - 0;
			escudo.y = - 0;
			escudo.alpha = 0;
			
			animacionTimer.addEventListener(TimerEvent.TIMER, nextSprite);
			animacionTimer.start();
		}
		
		public override function atacar(cuarto:Cuarto):void
		{
			//a la hora de atacar usa un numero random entre 1 y 4 para la direccion a la que manda su disparo
			if (ataqueDisponible == true && estaVivo == true)
			{
				ataqueDisponible = false;
				iniciarCDAtaque();
				for(var i:int = 0; i < Entidad.maxPoolAtaques ; i++)
				{
					if((cuarto.contains(poolAtaques[i])) == false)
					{
						numeroRandom = (Math.random() * 4)+ masUno;
						poolAtaques[i] = new Blood(numeroRandom,x,y);
						cuarto.addChild(poolAtaques[i]);
						i = Entidad.maxPoolAtaques;
					}
				}
			}
		}
		
		private function nextSprite(event:TimerEvent) : void
		{
			//esto maneja la animacion de forma constante
			removeChild(imagen);
			imagen = listaAnim[contadorAnim];
			imagen.scaleX = 0.5;
			imagen.scaleY = 0.5;
			imagen.x = -(imagen.width/2);
			imagen.y = -(imagen.height/2);
			addChild(imagen);
			if(contadorAnim == 3)
			{
				contadorAnim = 0;
			}
			else
			{
				contadorAnim++
			}
		}
		
		protected override function detenerAnim():void
		{
			//detiene el timer de animacion
			animacionTimer.stop();
		}
	}
}