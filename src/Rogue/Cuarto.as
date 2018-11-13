package Rogue
{
	import Rogue.Shop;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class Cuarto extends Sprite
	{
		private var especialDisponible:Boolean = true; //esto es para que si ya hay un cuarto especial no se pnga otro encima
		private var tienda:Shop = new Shop(); //todos los cuartos tienen shop, pero no todos lo tienen realmente activo
		
		private var esInicial:Boolean = false; //si es el primer cuarto
		private var esFinal:Boolean = false; //si es un cuarto sin salida (los laterales no cuentan como salida)
		
		//si tiene alguna de estas puertas
		private var puertaArriba:Boolean = false;
		private var puertaDerecha:Boolean = false;
		private var puertaAbajo:Boolean = false;
		private var puertaIzquierda:Boolean = false;
		
		//si tiene la puerta del nivel
		private var puertaLvl:Boolean = false;
		
		//si es alguno de los cuartos especiales
		private var tieneBoss:Boolean = false;
		private var tieneGold:Boolean = false;
		private var tieneShop:Boolean = false;
		private var tienePacto:Boolean = false;
		private var tieneHoly:Boolean = false;
		private var tieneDemon:Boolean = false;
		
		//si el cuarto es parte de una expansion horizontal o vertical
		private var esHorizontal:Boolean = false;
		private var esVertical:Boolean = false;

		//las estructuras son las paredes, esquinas y puertas
		//son sprites en su propia clase con metodos para que se cambien de abierto a cerrado
		//o de puerta a pared de forma rapida
		private var esquina1:Estructura = new Estructura();
		private var esquina2:Estructura = new Estructura();
		private var esquina3:Estructura = new Estructura();
		private var esquina4:Estructura = new Estructura();
		private var paredArriba:Estructura = new Estructura();
		private var paredAbajo:Estructura = new Estructura();
		private var paredIzquierda:Estructura = new Estructura();
		private var paredDerecha:Estructura = new Estructura();
		
		private var puertaLvlAbierta:Bitmap = new Recursos.puertaLvlAbiertaClass();
		private var puertaLvlCerrada:Bitmap = new Recursos.puertaLvlCerradaClass();
		
		//si la puerta del nivel esta abierta
		private var puertaLvlEstaAbierta:Boolean = false;
		
		//si las puertas comunes estan abiertas
		private var puertasAbiertas:Boolean = false;
		
		private var suelo:Shape = new Shape();
		
		//numeros de cantidad de enemigos posibles en cada cuarto
		private static var cantidadEnemigosMin:int = 1;
		private static var cantidadEnemigosMax:int = 4;
		
		private var cantidadEnemigos:int = 0;
		
		//este es el pool de enemigos, es uno solo para todos los cuartos
		private static var poolEnemigos:Vector.<Enemigo> = new Vector.<Enemigo>(10);
		
		
		private static var numeroRandom:int = 0;
		private static var ocupado:Boolean = false;
		
		private static const masUno:int = 1; //esto es para los random
		
		public function Cuarto(final:Boolean = false, direccion:int = 0, fija:Boolean = false)
		{
			//el primer bool es para ver si es un cuarto final o no
			//al ser final no sigue mas para su lado y se pone la pared
			//la direccion es 1 2 3 4 siendo arriba derecha abajo izquierda
			//fija se refiere a los cuartos que estan apenas empezas, el primer cuarto de cada lado
			//esos cuartos no pueden generar laterales por una limitacion que tenia al principio
			//pero nunca lo cambie
			
			if (final == false && direccion == 0 && fija == true) //esto define al cuarto inicial
				//tiene puertas para todos los lados, es fijo y no tiene direccion, por eso usa 0
			{
				esInicial = true;
				
				puertaArriba = true;
				puertaDerecha = true;
				puertaAbajo = true;
				puertaIzquierda = true;
			}
				
			else
			{
				//los otros cuartos se crean segun para donde vayan
				switch (direccion)
				{
					case 1:
						construirUp(final, fija);
						break;
					case 2:
						construirRight(final, fija);
						break;
					case 3:
						construirDown(final, fija);
						break;
					case 4:
						construirLeft(final, fija);
						break;
					default:
						break;
				}
			}
			generarParedes(); //esto genera los sprites de paredes y puertas
			generarEnemigos(); //aca se activa un random para ver cuantos enemigos tiene el cuarto
		}
		
		private function construirUp(esFinal:Boolean = false, esFija:Boolean = false) : void
		{
			//al construir para arriba deja de lado el parametro de direccion y se maneja con los demas
			esVertical = true;
			
			//dependiendo si es el ultimo cuarto o si es fijo pone puertas o no
			if (esFinal == true && esFija == false)
			{
				puertaAbajo = true;
				puertaArriba = false;
				randomVertical(); //en algunos casos tiene la posibilidad de poener cuartos a los costados
			}
			
			else if (esFinal == true && esFija == true)
			{
				puertaAbajo = true;
				puertaArriba = false;
				puertaIzquierda = false;
				puertaDerecha = false;
			}
			
			else if (esFinal == false && esFija == false)
			{
				puertaAbajo = true;
				puertaArriba = true;
				randomVertical();
			}
			
			else
			{
				puertaArriba = true;
				puertaAbajo = true;
				puertaIzquierda = false;
				puertaDerecha = false;
			}
		}
		
		//esto es equivalente a lo anterior pero a la derecha
		private function construirRight(esFinal:Boolean = false, esFija:Boolean = false) : void
		{
			esHorizontal = true;
			
			if (esFinal == true && esFija == false)
			{
				puertaIzquierda = true;
				puertaDerecha = false;
				randomHorizontal();
			}
				
			else if (esFinal == true && esFija == true)
			{
				puertaAbajo = false;
				puertaArriba = false;
				puertaIzquierda = true;
				puertaDerecha = false;
			}
				
			else if (esFinal == false && esFija == false)
			{
				puertaIzquierda = true;
				puertaDerecha = true;
				randomHorizontal();
			}
				
			else
			{
				puertaArriba = false;
				puertaAbajo = false;
				puertaIzquierda = true;
				puertaDerecha = true;
			}
		}
		
		//lo mismo abajo
		private function construirDown(esFinal:Boolean = false, esFija:Boolean = false) : void
		{
			esVertical = true;
			
			if (esFinal == true && esFija == false)
			{
				puertaAbajo = false;
				puertaArriba = true;
				randomVertical();
			}
				
			else if (esFinal == true && esFija == true)
			{
				puertaAbajo = false;
				puertaArriba = true;
				puertaIzquierda = false;
				puertaDerecha = false;
			}
				
			else if (esFinal == false && esFija == false)
			{
				puertaAbajo = true;
				puertaArriba = true;
				randomVertical();
			}
				
			else
			{
				puertaArriba = true;
				puertaAbajo = true;
				puertaIzquierda = false;
				puertaDerecha = false;
			}
		}
		
		//y finalmente izquierda
		private function construirLeft(esFinal:Boolean = false, esFija:Boolean = false) : void
		{
			esHorizontal = true;
			
			if (esFinal == true && esFija == false)
			{
				puertaIzquierda = false;
				puertaDerecha = true;
				randomHorizontal();
			}
				
			else if (esFinal == true && esFija == true)
			{
				puertaAbajo = false;
				puertaArriba = false;
				puertaIzquierda = false;
				puertaDerecha = true;
			}
				
			else if (esFinal == false && esFija == false)
			{
				puertaIzquierda = true;
				puertaDerecha = true;
				randomHorizontal();
			}
				
			else
			{
				puertaArriba = false;
				puertaAbajo = false;
				puertaIzquierda = true;
				puertaDerecha = true;
			}		
		}
		
		//esto crea puertas a los costados izquierda y derecha
		//aca solo se ponen las puertas
		//pero al generarse el piso hay un metodo que revisa esto y al haber crea los cuartos
		private function randomVertical() : void
		{
			numeroRandom = Math.random() * 100;
			
			if (numeroRandom < 51)
			{
				puertaDerecha = false;
				puertaIzquierda = false;
			}
				
			else if (numeroRandom < 71)
			{
				puertaDerecha = true;
				puertaIzquierda = false;
			}
				
			else if (numeroRandom < 90)
			{
				puertaDerecha = false;
				puertaIzquierda = true;
			}
				
			else
			{
				puertaDerecha = true;
				puertaIzquierda = true;
			}
		}
		
		//lo mismo pero para los puertas arriba y abajo
		private function randomHorizontal() : void
		{
			numeroRandom = Math.random() * 100;
			
			if (numeroRandom < 51)
			{
				puertaArriba = false;
				puertaAbajo = false;
			}
				
			else if (numeroRandom < 71)
			{
				puertaArriba = true;
				puertaAbajo = false;
			}
				
			else if (numeroRandom < 90)
			{
				puertaArriba = false;
				puertaAbajo = true;
			}
				
			else
			{
				puertaArriba = true;
				puertaAbajo = true;
			}
		}
		
		public function getHorizontal() : Boolean
		{
			return esHorizontal;
		}
		
		public function getVertical() : Boolean
		{
			return esVertical;
		}
		
		public function getArriba() : Boolean
		{
			return puertaArriba;
		}
		
		public function getDerecha() : Boolean
		{
			return puertaDerecha;
		}
		
		public function getAbajo() : Boolean
		{
			return puertaAbajo;
		}
		
		public function getIzquierda() : Boolean
		{
			return puertaIzquierda;
		}
		
		public function getBoss() : Boolean
		{
			return tieneBoss;	
		}
		
		public function setBoss(tiene:Boolean) : void
		{
			tieneBoss = tiene;
		}
		
		public function setPuertaLvl(tiene:Boolean) : void
		{
			puertaLvl = tiene;
		}
		
		public function getPuertaLvl() : Boolean
		{
			return puertaLvl;
		}
		
		public function getGold() : Boolean
		{
			return tieneGold;	
		}
		
		public function setGold(tiene:Boolean) : void
		{
			tieneGold = tiene;	
		}
		
		public function getTieneShop() : Boolean
		{
			return tieneShop;	
		}
		
		public function setShop(tiene:Boolean) : void
		{
			tieneShop = tiene;	
		}
		
		public function getPacto() : Boolean
		{
			return tienePacto;	
		}
		
		public function setPacto(tiene:Boolean) : void
		{
			tienePacto = tiene;	
		}
		
		public function getHoly() : Boolean
		{
			return tieneHoly;	
		}
		
		public function setHoly(tiene:Boolean) : void
		{
			tieneHoly = tiene;	
		}
		
		public function getDemon() : Boolean
		{
			return tieneDemon;	
		}
		
		public function setDemon(tiene:Boolean) : void
		{
			tieneDemon = tiene;	
		}
		
		public function getCantidadEnemigos() : int
		{
			return cantidadEnemigos;
		}
		
		public function limpiarEnemigos() : void
		{
			cantidadEnemigos = 0;
		}
		
		private function generarEnemigos() : void
		{
			//aca genera el numero de enemigos que tiene el cuarto
			numeroRandom = Math.random() * (cantidadEnemigosMax - cantidadEnemigosMin + masUno) + cantidadEnemigosMin;
			
			cantidadEnemigos = numeroRandom;
		}
		
		public static function aumentarEnemigos() : void
		{
			//esto aumenta el numero estatico de enemigos minimos y maximos posibles
			//lo hace en funcion al nivel
			if (Juego.getNivel() < 3)
			{
				cantidadEnemigosMin = 1;
				cantidadEnemigosMax = 4;
			}
			
			else if (Juego.getNivel() < 5)
			{
				cantidadEnemigosMin = 2;
				cantidadEnemigosMax = 6;
			}
			
			else if (Juego.getNivel() < 7)
			{
				cantidadEnemigosMin = 4;
				cantidadEnemigosMax = 8;
			}
			
			else
			{
				cantidadEnemigosMin = 6;
				cantidadEnemigosMax = 10;				
			}
		}
		
		public static function cantidadDeEnemigosIniciales() : void
		{
			//esto es para resetear las cantidades de enemigos a sus numeros originales
			cantidadEnemigosMin = 1;
			cantidadEnemigosMax = 4;
		}
		
		
		public function generarParedes() : void
		{
			//aca se ponen los sprites de las esquinas y las paredes
			esquina1.esquina();
			
			esquina2.esquina();
			esquina2.x = 640;
			
			esquina3.esquina();
			esquina3.x = 640;
			esquina3.y = 640;
			
			esquina4.esquina();
			esquina4.y = 640;
			
			paredArriba.x = 32;
			
			paredDerecha.x = 672;
			paredDerecha.y = 32;
			paredDerecha.rotation = 90;
			
			paredAbajo.x = 640;
			paredAbajo.y = 672;
			paredAbajo.rotation = 180;
			
			paredIzquierda.y = 640;
			paredIzquierda.rotation = 270;
			
			//y aca cambian segun los stats del cuarto
			
			if(puertaArriba == true)
			{
				paredArriba.puertaCerrada(); //los metodos de las estructuras son solo para cambiar facilmente de una a otra
			}
				
			else
			{
				paredArriba.pared();
			}
			
			if(puertaAbajo == true)
			{
				paredAbajo.puertaCerrada();
			}
				
			else
			{
				paredAbajo.pared();
			}
			
			if(puertaIzquierda == true)
			{
				paredIzquierda.puertaCerrada();
			}
				
			else
			{
				paredIzquierda.pared();
			}
			
			if(puertaDerecha == true)
			{
				paredDerecha.puertaCerrada();
			}
				
			else
			{
				paredDerecha.pared();
			}
			
			suelo.graphics.beginFill(0x4E4A4E);
			suelo.graphics.drawRect(0,0,672,672);
			suelo.graphics.endFill();
			
			addChild(suelo);
			
			addChild(esquina1);
			addChild(esquina2);
			addChild(esquina3);
			addChild(esquina4);
			
			addChild(paredArriba);
			addChild(paredAbajo);
			addChild(paredIzquierda);
			addChild(paredDerecha);
		}
		
		public function getPuertasAbiertas() : Boolean
		{
			return puertasAbiertas;
		}
		
		public function abrirPuertas() : void
		{
			//aca pasa las estructuras a puerta abierta si es que la tiene
			puertasAbiertas = true;
			
			if (puertaArriba == true)
			{
				paredArriba.puertaAbierta();
			}
			
			if (puertaAbajo == true)
			{
				paredAbajo.puertaAbierta();
			}
			
			if (puertaDerecha == true)
			{
				paredDerecha.puertaAbierta();
			}
			
			if (puertaIzquierda == true)
			{
				paredIzquierda.puertaAbierta();
			}
		}
		
		public static function iniciarPool() : void
		{
			//aca se inicia el pool de enemigos
			for(var i:int = 0; i < 10 ; i ++)
			{
				poolEnemigos[i] = new Torreta(); //es solo para iniciarlos, asi que no importa que tipo de enemigo es
			}
		}
		
		public function spawnearEnemigos() : void
		{
			if (tieneBoss == false)
			{
				//si el cuarto no tiene boss invoca enemigos de forma aleatoria
				for(var i:int = 0; i < cantidadEnemigos; i++)
				{
					numeroRandom = Math.random() * 4;
					
					switch(numeroRandom)
					{
						case 0:
							poolEnemigos[i] = new Torreta();
							break;
						case 1:
							poolEnemigos[i] = new Tesla();
							break;
						case 2:
							if (i > 1)
							{
								//el buda solo aparece si hay por lo menos un personaje diferente antes
								//ya que no tiene sentido que este solo, no ataca y su unica funcion es poner un escudo
								poolEnemigos[i] = new Buda();
								break;
							}
						case 3:
							poolEnemigos[i] = new Ojo();
							break;
						default:
							poolEnemigos[i] = new Ojo();
							break;
					}
					do{
						//el enemigo que va a ser invocado se tiene que posicionar en el cuarto
						ocupado = false;
						poolEnemigos[i].setX(Juego.unNumeroPuntitos());
						poolEnemigos[i].setY(Juego.unNumeroPuntitos());
						//primero se toman dos coordenadas que definen uno de los puntos preparados para tener a los enemigos
						//estos dos if se aseguran que los enemigos no aparezcan justo frente a las puertas
						if (poolEnemigos[i].getX() == Juego.getNumerosPuntitos((Juego.cantidadDePuntitos -1)/2) && (poolEnemigos[i].getY() == Juego.getNumerosPuntitos(0) || poolEnemigos[i].getY() == Juego.getNumerosPuntitos(Juego.cantidadDePuntitos -1)))
						{
							//la lista de puntos es una lista de 7 numeros, hay 49 puntos en total donde pueden aparecer enemigos
							//este if se fija que la x no sea justo la mitad cuando la y es una u otra esquina
							//lo cual daria un enemigo en la mitad contra la pared
							//o sea un enemigo en la puerta
							ocupado = true;
						}
						
						if (poolEnemigos[i].getY() == Juego.getNumerosPuntitos((Juego.cantidadDePuntitos -1)/2) && (poolEnemigos[i].getX() == Juego.getNumerosPuntitos(0) || poolEnemigos[i].getX() == Juego.getNumerosPuntitos(Juego.cantidadDePuntitos -1)))
						{
							//este if hace lo mismo pero para que no este contra las otras dos paredes
							ocupado = true;
						}

						for(var c:int = 0; c < i; c++)
						{
							//este for revisa que los enemigos no aparezcan donde ya hay otro enemigo
							if((poolEnemigos[i].getX() == poolEnemigos[c].getX()) && (poolEnemigos[i].getY() == poolEnemigos[c].getY()))
							{
								ocupado = true;
							}
						}
					} while (ocupado == true);
					//si sale del loop es porque no aparece ni en las puertas ni donde hay otro enemigo
					//entonces ahi lo agrego
					
					addChild(poolEnemigos[i]);
				}	
			}
		}
		
		public function generarEspeciales() : void
		{
			if (especialDisponible == true)
			{
				if(tieneShop == true)
				{
					//aca se agrega la tienda
					addChild(tienda);
				}
			}
		}
		
		public function spawnearBoss() : void
		{
			if (tieneBoss == true)
			{
				//si el cuarto tiene un boss
				if (puertaLvl == true)
				{
					//si el cuarto del boss tiene una puerta de nivel, aparece cerrada
					addChild(puertaLvlCerrada);
					puertaLvlCerrada.x = 320;
					puertaLvlCerrada.y = 320;	
				}
				
				//el cuarto del boss inicia sin enemigos, entonces es pone que tenga 5
				//y se avisa a todas las variables que manejan enemigos
				cantidadEnemigos = 5;
				Juego.setNumeroDeEnemigos(5);
				Juego.setNumeroDeEnemigosTotales(5);
				
				poolEnemigos[0] = new Bloodball(); //este es el boss, aparece en el centro
				poolEnemigos[0].x = 336;
				poolEnemigos[0].y = 336;
				
				//el cuarto de boss que cree no es random, tiene todo predefinido
				
				poolEnemigos[1] = new Buda();
				poolEnemigos[1].x = 166;
				poolEnemigos[1].y = 166;
				
				poolEnemigos[2] = new Buda();
				poolEnemigos[2].x = 506;
				poolEnemigos[2].y = 166;
				
				poolEnemigos[3] = new Buda();
				poolEnemigos[3].x = 166;
				poolEnemigos[3].y = 506;
				
				poolEnemigos[4] = new Buda();
				poolEnemigos[4].x = 506;
				poolEnemigos[4].y = 506;
				
				addChild(poolEnemigos[0]);
				addChild(poolEnemigos[1]);
				addChild(poolEnemigos[2]);
				addChild(poolEnemigos[3]);
				addChild(poolEnemigos[4]);
				
				tieneBoss = false;
			}
		}
		
		public function abrirPuertaLvl() : void
		{
			//esto abre la puerta del nivel
			puertaLvlEstaAbierta = true;
			removeChild(puertaLvlCerrada);
			addChild(puertaLvlAbierta);
			puertaLvlAbierta.x = 320;
			puertaLvlAbierta.y = 320;
		}
		
		public function getPuertaLvlEstaAbierta() : Boolean
		{
			return puertaLvlEstaAbierta;
		}
		
		public function getTieneBoss() : Boolean
		{
			return tieneBoss;
		}
		
		public function removerEnemigos() : void
		{
			for(var i:int = 0; i < 10; i++)
			{
				if(contains(poolEnemigos[i]))
				{
					removeChild(poolEnemigos[i]);	
				}
			}
		}
		
		public static function getEnemigo(num:int) : Enemigo
		{
			return poolEnemigos[num];
		}
		
		public function getShop() : Shop
		{
			return tienda;
		}
	}
}