package Rogue
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Bloodball extends Enemigo
	{
		//este es el boss
		private var animacionTimer:Timer = new Timer(200, 0); //timer para su animacion
		private var listaAnim:Vector.<Bitmap> = new Vector.<Bitmap>(7);
		private var contadorAnim:int = 1; //un contador para ver por donde va en su animacion
		private var animacionBack:Boolean = false; //la animacion va de 0 a 6 y de 6 a 0
		
		public function Bloodball()
		{
			//iniciar su pool de ataques
			for(var i:int = 0; i < maxPoolAtaques; i++)
			{
				poolAtaques[i] = new Fireball();
			}
			
			//se define su animacion
			listaAnim[0] = new Recursos.evilBlood1Class();
			listaAnim[1] = new Recursos.evilBlood2Class();
			listaAnim[2] = new Recursos.evilBlood3Class();
			listaAnim[3] = new Recursos.evilBlood4Class();
			listaAnim[4] = new Recursos.evilBlood5Class();
			listaAnim[5] = new Recursos.evilBlood6Class();
			listaAnim[6] = new Recursos.evilBlood7Class();
			
			ataqueCD = new Timer(750, 1);
			ataqueCD.addEventListener(TimerEvent.TIMER_COMPLETE, finCD);
			
			vidaMaxBase = 500 + (500 * (Juego.getNivel() - 1));
			vidaMax = vidaMaxBase;
			vida = vidaMax;
			
			ataqueBase = 5 + (10 * (Juego.getNivel() - 1));
			ataqueTotal = ataqueBase;
			
			imagen = listaAnim[0];
			
			imagen.scaleX = 3;
			imagen.scaleY = 3;
			
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
		
		private function nextSprite(event:TimerEvent) : void
		{
			//esto hace el cambio de sprite
			removeChild(imagen);
			imagen = listaAnim[contadorAnim];
			imagen.scaleX = 3;
			imagen.scaleY = 3;
			imagen.x = -(imagen.width/2);
			imagen.y = -(imagen.height/2);
			addChild(imagen);
			if (animacionBack == false)
			{
				if(contadorAnim == 6)
				{
					animacionBack = true;
				}
				else
				{
					contadorAnim ++;
				}
					
			}
			else
			{
				if(contadorAnim == 0)
				{
					animacionBack = false;
				}
				else
				{
					contadorAnim--;
				}
			}
		}
		
		protected override function detenerAnim():void
		{
			//esto detiene el timer de animacion
			animacionTimer.stop();
		}
		
		public override function atacar(cuarto:Cuarto):void
		{
			//aca ataca el boss con sus fireball
			if (ataqueDisponible == true && estaVivo == true)
			{
				ataqueDisponible = false;
				iniciarCDAtaque();
				for(var i:int = 0; i < Entidad.maxPoolAtaques ; i++)
				{
					if((cuarto.contains(poolAtaques[i])) == false)
					{
						poolAtaques[i] = new Fireball(336,336,0,0);
						cuarto.addChild(poolAtaques[i]);
						poolAtaques[i].setPosicion();
						poolAtaques[i].iniciarExplosion();
						i = Entidad.maxPoolAtaques;
					}
				}
			}
		}
		
		public override function restarVida(num:uint) : void
		{
			//el boss pierde vida
			if(escudoActivado == false)
			{
				if(vida <= num)
				{
					estaVivo = false;
					detenerAnim();
					imagen.alpha = 0;
					Juego.aumentarOro(true); //este es el unico caso donde se pasa true para aumentar oro
					Juego.restarUnEnemigo(); //el boss es un enemigo, por eso se resta
					Juego.restarBoss(); //como es un boss tambien se tiene que eliminar de este contador
				}
				else
				{
					vida = vida - num;
				}
			}
		}
	}
}