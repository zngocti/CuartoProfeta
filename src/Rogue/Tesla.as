package Rogue
{
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;

	public class Tesla extends Enemigo
	{
		private var animacionTimer:Timer = new Timer(500, 0);
		private var listaAnim:Vector.<Bitmap> = new Vector.<Bitmap>(3);
		private var contadorAnim:int = 1;
		private var sonido:Sound = new Recursos.laserSonidoClass();
		
		public function Tesla()
		{
			//se inicia el pool de ataques
			for(var i:int = 0; i < maxPoolAtaques; i++)
			{
				poolAtaques[i] = new Rayo();
			}
			//y la lista de animacion
			listaAnim[0] = new Recursos.tesla1Class();
			listaAnim[1] = new Recursos.tesla2Class();
			listaAnim[2] = new Recursos.tesla3Class();
			
			ataqueCD = new Timer(3000, 1); //tiempo muerto sin atacar
			ataqueCD.addEventListener(TimerEvent.TIMER_COMPLETE, finCD);
			
			vidaMaxBase = 80 + (15 * (Juego.getNivel() - 1));
			vidaMax = vidaMaxBase;
			vida = vidaMax;

			ataqueBase = 3 + (2 * (Juego.getNivel() - 1));
			ataqueTotal = ataqueBase;
			
			imagen = listaAnim[0];
			imagen.x = -(imagen.width/2);
			imagen.y = -(imagen.height/2);
			
			addChild(imagen);
			velocidad = 0;
			
			escudo.graphics.beginFill(0xA9D3AE);
			escudo.graphics.drawCircle(0,0,22);
			escudo.graphics.endFill();
			addChild(escudo);
			escudo.x = - 0;
			escudo.y = - -4;
			escudo.alpha = 0;
			
			animacionTimer.addEventListener(TimerEvent.TIMER, nextSprite);
			animacionTimer.start();
		}
		
		public override function atacar(cuarto:Cuarto):void
		{
			if (ataqueDisponible == true && estaVivo == true)
			{
				sonido.play(); //cuando ataca hace un sonido
				ataqueDisponible = false;
				iniciarCDAtaque();
				for(var i:int = 0; i < Entidad.maxPoolAtaques ; i++)
				{
					if((cuarto.contains(poolAtaques[i])) == false)
					{
						poolAtaques[i] = new Rayo(x,y,Juego.getJugadorX(),Juego.getJugadorY());
						cuarto.addChild(poolAtaques[i]);
						i = Entidad.maxPoolAtaques;
					}
				}
			}
		}
		
		private function nextSprite(event:TimerEvent) : void
		{
			//aca se maneja la animacion
			removeChild(imagen);
			imagen = listaAnim[contadorAnim];
			imagen.x = -(imagen.width/2);
			imagen.y = -(imagen.height/2);
			addChild(imagen);
			if(contadorAnim == 2)
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
			//esto detiene el timer de la animacion
			animacionTimer.stop();
		}
	}
}