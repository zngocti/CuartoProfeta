package Rogue
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;

	public class Fireball extends Proyectil
	{
		private var expTimer:Timer = new Timer(200,3); //este es el timer para la animcacion de la explosion
		private var contador:int = 0; //y este contador es para ver en que parte de la animacion esta
		private var sonido:Sound = new Recursos.explosionSonidoClass();
		private var numeroRandom:int = 0;
		
		public function Fireball(pX:int = 100, pY:int = 100, mX:int = 50, mY:int = 50)
		{
			velocidad = 6;
			
			areaExplosion = new Shape();
			areaExplosion.graphics.beginFill(0x0000FF);
			areaExplosion.graphics.drawCircle(0,0,30);
			areaExplosion.graphics.endFill();
			areaExplosion.alpha = 0;
			addChild(areaExplosion);
			areaExplosion.x = this.width/7;
			areaExplosion.y = this.height/7;
			
			imagen = new Recursos.fireballClass();
			addChild(imagen);
			
			if(mX == 0 && mY == 0) //si se pasan estos numeros el fireball actua un poco diferente a lo normal
			{
				//esto esta hecho para que lo use solo el boss
				numeroRandom = Math.random()* 4;
				if(numeroRandom == 0) //tiene un porcentaje de enviar un ataque dirigido a la posicion donde esta el jugador en ese momento
				{
					//este numero no se actualiza, si el jugador se mueve lo puede esquivar
					mX = Juego.getJugadorX(); //estos son los numeros meta, o sea a donde tiene que llegar el ataque para explotar
					mY = Juego.getJugadorY();
				}
				
				//los demas if son para atacar a zonas definidas dependiendo de donde este el jugador
				//son 9 zonas definidas entre los 49 puntos generados en el mapa
				else if(Juego.getJugadorX() <= 224 && Juego.getJugadorY() <= 224)
				{
					do{
						mX = Juego.unNumeroPuntitos();
						mY = Juego.unNumeroPuntitos();			
					}while ((mX > 224 || mY > 224) || (mX == 336 && mY == 336))	
				}
				
				else if(Juego.getJugadorX() >= 224 && Juego.getJugadorX() <= 448 && Juego.getJugadorY() <= 224)
				{
					do{
						mX = Juego.unNumeroPuntitos();
						mY = Juego.unNumeroPuntitos();			
					}while ((mX < 224 || mX < 448 || mY > 224) || (mX == 336 && mY == 336))	
				}
				
				else if(Juego.getJugadorX() >= 448 && Juego.getJugadorY() <= 224)
				{
					do{
						mX = Juego.unNumeroPuntitos();
						mY = Juego.unNumeroPuntitos();			
					}while ((mX < 448 || mY > 224) || (mX == 336 && mY == 336))	
				}
				
				else if(Juego.getJugadorX() <= 224 && Juego.getJugadorY() >= 224 && Juego.getJugadorY() <= 448)
				{
					do{
						mX = Juego.unNumeroPuntitos();
						mY = Juego.unNumeroPuntitos();			
					}while ((mX > 224 || mY < 224 ||  mY > 448) || (mX == 336 && mY == 336))	
				}
				
				else if(Juego.getJugadorX() >= 224 && Juego.getJugadorX() <= 448 && Juego.getJugadorY() >= 224 && Juego.getJugadorY() <= 448)
				{
					do{
						mX = Juego.unNumeroPuntitos();
						mY = Juego.unNumeroPuntitos();			
					}while ((mX < 224 || mX > 448 || mY < 224 ||  mY > 448) || (mX == 336 && mY == 336))	
				}
				
				else if(Juego.getJugadorX() >= 448 && Juego.getJugadorY() >= 224 && Juego.getJugadorY() <= 448)
				{
					do{
						mX = Juego.unNumeroPuntitos();
						mY = Juego.unNumeroPuntitos();			
					}while ((mX < 448 || mY < 224 ||  mY > 448) || (mX == 336 && mY == 336))	
				}
				
				else if(Juego.getJugadorX() <= 224 && Juego.getJugadorY() >= 448)
				{
					do{
						mX = Juego.unNumeroPuntitos();
						mY = Juego.unNumeroPuntitos();			
					}while ((mX > 224 || mY < 448) || (mX == 336 && mY == 336))	
				}
				
				else if(Juego.getJugadorX() >= 224 && Juego.getJugadorX() <= 448 && Juego.getJugadorY() >= 448)
				{
					do{
						mX = Juego.unNumeroPuntitos();
						mY = Juego.unNumeroPuntitos();			
					}while ((mX < 224 || mX > 448 || mY < 448) || (mX == 336 && mY == 336))	
				}
				
				else if(Juego.getJugadorX() >= 448 && Juego.getJugadorY() >= 448)
				{
					do{
						mX = Juego.unNumeroPuntitos();
						mY = Juego.unNumeroPuntitos();			
					}while ((mX < 448 || mY < 448) || (mX == 336 && mY == 336))	
				}
				
			}
			
			//cuando el fireball es tirado por una torreta comun el mx y el mx son los definidos en los parametros
			//pero cuando lo usa el boss tiene que pasar por ese proceso y ahi se define, luego el movimiento es igual
			
			metaX = mX;
			metaY = mY;
			
			x = pX - (width/2);
			y = pY - (height/2);
			
			expTimer.addEventListener(TimerEvent.TIMER, onTick); //cada fireball tiene su timer de explosion para la animacion
		}
		
		public override function mover(num:int):void
		{
			//el fireball trata de acercarse siempre a su meta definida
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
		}
		
		public override function explotar() : void
		{
			//aca inicia la explosion con su sonido incluido
			explotando = true;
			metaX = x;
			metaY = y;
			removeChild(imagen);
			expTimer.start();
			imagen = new Recursos.explosion1Class();
			imagen.x = -width/2;
			imagen.y = -width/2;
			addChild(imagen);
			if (alpha != 0)
			{
				sonido.play(0,0);
			}
		}
		
		public function onTick(event:TimerEvent) : void
		{
			//esto maneja la animacion de la explosion y elimina el ataque despues
			if (contador == 0)
			{
				removeChild(imagen);
				imagen = new Recursos.explosion2Class();
				imagen.x = -width/2;
				imagen.y = -width/2;
				addChild(imagen);
				contador++;
			}
			
			else if (contador == 1)
			{
				removeChild(imagen);
				imagen = new Recursos.explosion3Class();
				imagen.x = -width/2;
				imagen.y = -width/2;
				addChild(imagen);
				contador++;
			}
			else
			{
				selfRemove();
			}
		}
	}
}