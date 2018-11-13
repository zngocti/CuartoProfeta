package Rogue
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	public class Juego extends Sprite
	{
		private var jugando:Boolean = true;
		
		private var informacion:Interfaz = new Interfaz();
		
		private var jugador:Jugador = new Jugador();
		private var unPiso:Piso = new Piso();
		
		private static var oro:uint = 0;
		private static var oroExtra:uint = 0;
		
		private static var jugadorX:int = 0;
		private static var jugadorY:int = 0;
		
		private static var numeroRandom:int = 0;
		private static const masUno:int = 1;
		private static var contadorBuda:int = 0;
		
		private static var nivel:int = 1;
		private static var jugando:Boolean = true;
		
		private static var cantidadDeBosses:int = 1;
		
		private var kW:Boolean = false;
		private var kS:Boolean = false;
		private var kD:Boolean = false;
		private var kA:Boolean = false;
		
		private var kUp:Boolean = true;
		private var kDown:Boolean = true;
		private var kRight:Boolean = true;
		private var kLeft:Boolean = true;
		
		private static var hayPuertaUp:Boolean = true;
		private static var hayPuertaDown:Boolean = true;
		private static var hayPuertaRight:Boolean = true;
		private static var hayPuertaLeft:Boolean = true;
		
		private static var numeroDeEnemigos:int = 0;
		private static var numeroDeEnemigosTotales:int = 0;
		
		private var oscuridad:Shape = new Shape();
		private var oscuridadTimer:Timer = new Timer(50, 1);
		private var cambiandoLvl:Boolean = false;
		
		private var tpUp:Shape = new Shape();
		private var tpDown:Shape = new Shape();
		private var tpLeft:Shape = new Shape();
		private var tpRight:Shape = new Shape();
		private var tpL:Shape = new Shape();
		
		public static const cantidadDePuntitos:int = 7;
		private static var puntitos:Vector.<Shape> = new Vector.<Shape>(49); //el numero de constantes al cuadrado
		private static var numerosPuntitos:Vector.<int> = new Vector.<int>(cantidadDePuntitos);
		
		private static const punto1:int = 81;
		private static const punto2:int = 166;
		private static const punto3:int = 251;
		private static const punto4:int = 336;
		private static const punto5:int = 421;
		private static const punto6:int = 506;
		private static const punto7:int = 591;
		
		public function Juego()
		{
			//estos puntos son donde se generan enemigos
			numerosPuntitos[0] = punto1;
			numerosPuntitos[1] = punto2;
			numerosPuntitos[2] = punto3;
			numerosPuntitos[3] = punto4;
			numerosPuntitos[4] = punto5;
			numerosPuntitos[5] = punto6;
			numerosPuntitos[6] = punto7;
			Cuarto.iniciarPool(); //aca inicio el pool de enemigos
			generarPuntitos(); //aca genero los puntos en el mapa con shape, o sea, visibles, no son necesarios para el juego en si, los use para guiarme en lo que pensaba hacer

			oscuridad.graphics.beginFill(0x000000); //esta oscuridad es lo que tapa todo cuando pasas entre puertas para que sea un poco mas natural
			oscuridad.graphics.drawRect(0,0,672,672);
			oscuridad.graphics.endFill();
		}
		
		public function iniciarJuego(): void
		{
			//aca redefino algunas variables estaticas para poder empezar una nueva partida desde el menu sin que quede nada de la anterior
			jugando = true;
			oro = 0;
			nivel = 1;
			hayPuertaUp = true;
			hayPuertaDown = true;
			hayPuertaRight = true;
			hayPuertaLeft = true;
			numeroDeEnemigos = 0;
			numeroDeEnemigosTotales = 0;
			
			crearPiso(); //aca con esto creo el piso, el cual contiene todas las habitaciones
			addChild(unPiso);
			crearTps(); //esto crea los teletransportadores de las puertas
			crearPuntitos(); //esto crea los puntos que mencione mas arriba, son solo algo visual y ahora en el juego estan con alfa 0
			addChild(jugador);
			addChild(informacion); //la informacion es lo del costado, donde se muestra la vida, oro, nivel, etc

			Cuarto.cantidadDeEnemigosIniciales(); //esto es para que las variables estaticas del cuarto se redefinan por si se empieza una nueva partida
			
			oscuridadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, terminarOscuridad); //este es el timer para que la oscuridad al moverse de un cuarto a otro se termine
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
			stage.addEventListener(Event.EXIT_FRAME, exitFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		}
		
		private function crearPiso() : void
		{
			//la creacion del piso acepta un parametro el cual define cuantos bosses hay que matar para que se abra la proxima puerta
			
			if (nivel < 5)
			{
				unPiso = new Piso(1);
				cantidadDeBosses = 1;
			}
			
			else if (nivel < 7)
			{
				unPiso = new Piso(2);
				cantidadDeBosses = 2;
			}
			
			else if (nivel < 9)
			{
				unPiso = new Piso(3);
				cantidadDeBosses = 3;
			}
			
			else
			{
				unPiso = new Piso(4);
				cantidadDeBosses = 4;
			}
		}
		
		private function crearTps(): void
		{
			//los sprites de las puertas los arme con toda la pared, para usar solo 4 sprites
			//por lo que para la colision con las puerta y que te "teletransporte" hice 4 cuadrados
			//tpL es el que te teletransporta a un piso nuevo
			
			tpL.graphics.beginFill(0xFF0000);
			tpL.graphics.drawRect(0,0,32,32);
			tpL.graphics.endFill();
			tpL.x = 320;
			tpL.y = 320;
			tpL.alpha = 0;
			addChild(tpL);
			
			tpUp.graphics.beginFill(0xFF0000);
			tpUp.graphics.drawRect(0,0,32,32);
			tpUp.graphics.endFill();
			tpUp.x = 320;
			tpUp.alpha = 0;
			addChild(tpUp);
			
			tpDown.graphics.beginFill(0xFF0000);
			tpDown.graphics.drawRect(0,0,32,32);
			tpDown.graphics.endFill();
			tpDown.x = 320;
			tpDown.y = 640;
			tpDown.alpha = 0;
			addChild(tpDown);
			
			tpRight.graphics.beginFill(0xFF0000);
			tpRight.graphics.drawRect(0,0,32,32);
			tpRight.graphics.endFill();
			tpRight.x = 640;
			tpRight.y = 320;
			tpRight.alpha = 0;
			addChild(tpRight);
			
			tpLeft.graphics.beginFill(0xFF0000);
			tpLeft.graphics.drawRect(0,0,32,32);
			tpLeft.graphics.endFill();
			tpLeft.y = 320;
			tpLeft.alpha = 0;
			addChild(tpLeft);
		}
		
		public static function getNivel() : int
		{
			return nivel;
		}
		
		private function enterFrame (event:Event): void
		{
			if (jugando == true)
			{
				actualizarInfo(); //actualiza la informacion, la vida, el oro, stats en general
				movimiento(); //verifica el movimiento del jugador
				ataqueDeEnemigos(); //hace atacar a los enemigos
				moverAtaques(); //mueve los ataques
				unPiso.verificarPuertas(); //se fija que los sprites muestren puertas abiertas o cerradas segun lo necesario
				unPiso.verificarPuertaLvl(); //para que este abierta o cerada la puerta que lleva al otro nivel	
			}
		}
		
		private function exitFrame (event:Event) : void
		{
			if (jugando == true)
			{
				verificarTps(); //revisa los choques con los teletransportadores de las puertas para llevarte a otro cuarto o nivel
				verificarLimites(); //colisiones con las paredes
				verificarAtaques(); //mira los choques de los ataques con las paredes o entre jugador y enemigo
				verificarChoques(); //para cuando el jugador toca un enemigo
				verificarShield(); //para los escudos de los enemigos mientras haya un buda presente
				eliminarAtaques(); //remover ataques o hacerlos invisibles para despues removerlos
			}
		}
		
		private function onKeyDown (event:KeyboardEvent) : void
		{
			if (jugando == true)
			{
				//el movimiento esta hecho con el sistema de booleanos para que sea fluido y se puedan apretar 2 teclas
				if (event.keyCode == Keyboard.W)
				{
					kW = true;
				}
				
				else if (event.keyCode == Keyboard.S)
				{
					kS = true;
				}
				
				else if (event.keyCode == Keyboard.D)
				{
					kD = true;
				}
				
				else if (event.keyCode == Keyboard.A)
				{
					kA = true;
				}
				
				if (unPiso.getCuartoActual().getTieneShop() == true) //esto es para que los numeros funciones solo en la tienda
				{
					if (event.keyCode == Keyboard.NUMBER_1)
					{
						unPiso.getCuartoActual().getShop().compra(jugador,1);
					}
						
					else if (event.keyCode == Keyboard.NUMBER_2)
					{
						unPiso.getCuartoActual().getShop().compra(jugador,2);
					}
						
					else if (event.keyCode == Keyboard.NUMBER_3)
					{
						unPiso.getCuartoActual().getShop().compra(jugador,3);
					}	
				}
				
				else if (event.keyCode ==  Keyboard.UP || event.keyCode ==  Keyboard.DOWN || event.keyCode ==  Keyboard.RIGHT || event.keyCode ==  Keyboard.LEFT)
				{
					//esto es para los ataques del jugador
					//usa booleanos para que uno no mantenga apretado el boton y se disparen varios
					if (kUp == true && kDown == true && kRight == true && kLeft == true)
					{
						switch(event.keyCode)
						{
							case Keyboard.UP:
								kUp = false;
								break;
							case Keyboard.RIGHT:
								kRight = false;
								break;
							case Keyboard.DOWN:
								kDown = false;
								break;
							case Keyboard.LEFT:
								kLeft = false;
								break;
						}
						
						if (jugador.getAtaqueDisponible() == true)
						{
							//aca se inicia el cd, tiempo muerto para que haya un tiempo entre cuando y cuando se puede atacar
							jugador.switchAtaqueDisponible();
							jugador.iniciarCDAtaque();
							for(var i:int = 0; i < Entidad.maxPoolAtaques ; i++)
							{
								if(unPiso.getCuartoActual().contains(jugador.getPoolAtaques(i)) == false)
								{
									//si el cuarto no contiene al ataque del pool entonces lo usa
									switch(event.keyCode)
									{
										//esto inicia el ataque i del pool te ataques del jugador en direccion n
										//n seria 1 2 3 o 4 siendo arriba derecha abajo izquierda, en sentido reloj
										case Keyboard.UP:
											jugador.setPoolAtaques(i, 1);
											break;
										case Keyboard.RIGHT:
											jugador.setPoolAtaques(i, 2);
											break;
										case Keyboard.DOWN:
											jugador.setPoolAtaques(i, 3);
											break;
										case Keyboard.LEFT:
											jugador.setPoolAtaques(i, 4);
											break;
									}
									unPiso.getCuartoActual().addChild(jugador.getPoolAtaques(i));
									i = Entidad.maxPoolAtaques; //usa vez usado uno de los ataques del pool se sale del for
								}
							}
						}
					}
				}	
			}
		}
		
		private function onKeyUp (event:KeyboardEvent) : void
		{
			if (jugando == true)
			{
				//para volver false los booleanos de movimiento
				if (event.keyCode == Keyboard.W)
				{
					kW = false;
				}
					
				else if (event.keyCode == Keyboard.S)
				{
					kS = false;
				}
					
				else if (event.keyCode == Keyboard.D)
				{
					kD = false;
				}
					
				else if (event.keyCode == Keyboard.A)
				{
					kA = false;
				}
				
				else
				{
					//vuelve false los booleanos de ataque
					switch(event.keyCode)
					{
						case Keyboard.UP:
							kUp = true;
							break;
						case Keyboard.RIGHT:
							kRight = true;
							break;
						case Keyboard.DOWN:
							kDown = true;
							break;
						case Keyboard.LEFT:
							kLeft = true;
							break;
					}
				}	
			}
		}
		
		private function movimiento() : void
		{
			//mientras el bool de movimiento en una direccion sea verdadero el jugador se mueve
			//teniendo varios bool a la vez se puede mover en diagonal
			if (kW == true)
			{
				jugador.mover(1);
			}
			
			if (kS == true)
			{
				jugador.mover(3);
			}
			
			if (kD == true)
			{
				jugador.mover(2);
			}
			
			if (kA == true)
			{
				jugador.mover(4);
			}
		}
		
		private function moverAtaques(): void //esto mueve los atques de jugador y enemigos
		{
			for(var i:int = 0; i < Entidad.maxPoolAtaques ; i++)
			{
				if(unPiso.getCuartoActual().contains(jugador.getPoolAtaques(i)))
				{
					//esto mueve el ataque i del jugador en la direccion que se definio al crearlo
					jugador.getPoolAtaques(i).mover(jugador.getPoolAtaques(i).getDireccion());
				}
			}
			
			if (numeroDeEnemigos > 0) //si hay enemigos procede a mover sus ataques
			{
				for (i = 0; i < numeroDeEnemigosTotales ; i++)
				{
					if (unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i))) //se fija si se contiene al enemigo del pool
					{
						for (var c:int = 0; c < Entidad.maxPoolAtaques ; c++) //revisa el pool de ataques de ese enemigo
						{
							if (unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i).getPoolAtaques(c))) //si el ataque del pool esta, entonces lo mueve
							{
								//la direccion del ataque del enemigo se define cuando el enemigo ataca
								Cuarto.getEnemigo(i).getPoolAtaques(c).mover(Cuarto.getEnemigo(i).getPoolAtaques(c).getDireccion());
							}
						}
					}
				}
			}
		}

		private function ataqueDeEnemigos() : void //ordena a los enemigos a atacar
		{
			if (numeroDeEnemigos > 0 && unPiso.getIniciarAtaques() == true)
				//el bool iniciarAtaques cambia con un timer para que los enemigos no ataquen apenas uno entra al cuarto
			{
				for (var i:int = 0; i < numeroDeEnemigosTotales ; i++)
				{
					if (unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i)))
					{
						Cuarto.getEnemigo(i).atacar(unPiso.getCuartoActual()); //si el enemigo del pool esta en el cuarto, entonces ataca
					}
				}
			}
		}
		
		private function removerAtaquesJugador() : void //esto remueve los ataques del jugador cuando ya no se usan
		{
			for (var i:int = 0; i < Entidad.maxPoolAtaques; i++)
			{
				if (unPiso.getCuartoActual().contains(jugador.getPoolAtaques(i)))
				{
					unPiso.getCuartoActual().removeChild(jugador.getPoolAtaques(i));
				}
			}
		}
		
		private function verificarTps() : void
		{
			if(tpL.hitTestObject(jugador.getImagen()) && cantidadDeBosses == 0 && unPiso.getCuartoActual().getPuertaLvl() == true && unPiso.getCuartoActual().getPuertaLvlEstaAbierta() == true)
			{
				//si el jugador choca contra el teletransportador que lleva a otro nivel, ya no hay bosses
				//si el cuarto en el que esta tiene una puerta a otro nivel (el teletransportador esta siempre, pero no siempre activo)
				//y la puerta de nivel esta abierta entonces se activa
				cambiandoLvl = true; //este bool es para que no haga el cambio hasta que termine el contador de la pantalla en negro
				addChild(oscuridad);
				oscuridadTimer.start();
			}
			
			//los demas tp son todos iguales
			//si el jugador choca contra ese teleport, no hay enemigos en el cuarto y el tp donde choco corresponde a una puerta entonces hace el cambio
			if(tpUp.hitTestObject(jugador.getImagen()) && numeroDeEnemigos == 0 && hayPuertaUp == true)
			{
				addChild(oscuridad);
				oscuridadTimer.start();
				
				removerAtaquesJugador();
				unPiso.teleport(1);
				jugador.x = 320;
				jugador.y = 606;
			}
			
			if(tpRight.hitTestObject(jugador.getImagen()) && numeroDeEnemigos == 0 && hayPuertaRight == true)
			{
				addChild(oscuridad);
				oscuridadTimer.start();
				
				removerAtaquesJugador();
				unPiso.teleport(2);
				jugador.x = 34;
				jugador.y = 320;
			}
			
			if(tpDown.hitTestObject(jugador.getImagen()) && numeroDeEnemigos == 0 && hayPuertaDown == true)
			{
				addChild(oscuridad);
				oscuridadTimer.start();
				
				removerAtaquesJugador();
				unPiso.teleport(3);
				jugador.x = 320;
				jugador.y = 34;
			}
			
			if(tpLeft.hitTestObject(jugador.getImagen()) && numeroDeEnemigos == 0 && hayPuertaLeft == true)
			{
				addChild(oscuridad);
				oscuridadTimer.start();
				
				removerAtaquesJugador();
				unPiso.teleport(4);
				jugador.x = 606;
				jugador.y = 320;
			}
		}
		
		private function terminarOscuridad(event:TimerEvent) : void //esto es para que se vaya la pantalla en negro al cambiar de cuarto o nivel
		{
			oscuridadTimer.reset();
			if(contains(oscuridad)) //si es un cambio de cuarto solo se necesita esto
			{
				removeChild(oscuridad);
			}
			if (cambiandoLvl == true) //cuando es un cambio de nivel hace mas cosas
			{
				cambiandoLvl = false;
				
				removerAtaquesJugador() //remuevo los ataques del jugador
				removeChild(unPiso); //remuevo el piso entero con todos su cuartos
				removeChild(jugador); //remuevo el jugador y los tp
				removeChild(tpUp);
				removeChild(tpRight);
				removeChild(tpDown);
				removeChild(tpLeft);
				removeChild(tpL);				
				subirNivel(); //esto agrega 1 al contador de niveles estatico del juego
				crearPiso(); //hago una nueva creacion de piso, el cual esta relacionado con el nivel
				addChild(unPiso); //agrego el nuevo piso, jugador y todas las cosas
				addChild(jugador);
				addChild(tpUp);
				addChild(tpRight);
				addChild(tpDown);
				addChild(tpLeft);
				addChild(tpL);
				unPiso.teleport(5); //este metodo es el que hace los arreglos cuando paso de cuarto en cuarto
				//en el caso del cambio nivel hace cosas menores ya que hicimos todo en las lineas anteriores
				jugador.x = 320; //vuelvo a poner al jugador en el centro
				jugador.y = 320;
			}
		}
		
		private function verificarLimites() : void
		{
			//estas son las colisiones con las paredes y puertas
			if ((hayPuertaUp == false && jugador.y < 32) || (numeroDeEnemigos > 0 && jugador.y < 32))
			{
				jugador.y = 32;
			}
				
			else if ((jugador.y < 32 && jugador.x < 319) || (jugador.y < 32 && jugador.x > 330))
			{
				jugador.y = 32;
			}
			
			if ((hayPuertaRight == false && jugador.x > 608) || (numeroDeEnemigos > 0 && jugador.x > 608))
			{
				jugador.x = 608;
			}
				
			else if ((jugador.x > 608 && jugador.y < 319) || (jugador.x > 608 && jugador.y > 330))
			{
				jugador.x = 608;
			}
			
			if ((hayPuertaDown == false && jugador.y > 608)  || (numeroDeEnemigos > 0 && jugador.y > 608))
			{
				jugador.y = 608;
			}
				
			else if ((jugador.y > 608 && jugador.x < 319) || (jugador.y > 608 && jugador.x > 330))
			{
				jugador.y = 608;
			}
			
			if ((hayPuertaLeft == false && jugador.x < 32) || (numeroDeEnemigos > 0 && jugador.x < 32))
			{
				jugador.x = 32;
			}
				
			else if ((jugador.x < 32 && jugador.y < 319) || (jugador.x < 32 && jugador.y > 330))
			{
				jugador.x = 32;
			}
			
			jugadorX = jugador.x; //esto mantiene en todo momento unas variables estaticas actualizadas con la posicion del jugador
			jugadorY = jugador.y;
		}
		
		private function verificarAtaques() : void
		{
			//verifico que pasa con el ataque cuando choca con las paredes o contra un enemigo
			for(var i:int = 0; i < Entidad.maxPoolAtaques ; i++)
			{
				if(unPiso.getCuartoActual().contains(jugador.getPoolAtaques(i)))
				{
					if (jugador.getPoolAtaques(i).x < 32 || jugador.getPoolAtaques(i).x > 640 || jugador.getPoolAtaques(i).y < 32 || jugador.getPoolAtaques(i).y > 640)
					{
						jugador.getPoolAtaques(i).selfRemove();
					}
					
					else if (numeroDeEnemigos > 0)
					{
						impactoContraEnemigo(i); //aca se maneja el impacto del ataque del jugador contra el enemigo
					}
				}
			}
			if (numeroDeEnemigos > 0)
			{
				for(i = 0; i < numeroDeEnemigosTotales ; i++)
				{
					if (unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i)))
					{
						verificarAtaquesEnemigos(i); //aca verifico toda el pool de ataques del enemigo i
					}
				}
			}
		}
		
		private function verificarAtaquesEnemigos(num:int) : void
		{
			if(Cuarto.getEnemigo(num) is Ojo)
				//si el enemigo es un ojo verifica los detalles de su tipo de ataque, chocar contra paredes
			{
				for(var i:int = 0; i < Entidad.maxPoolAtaques ; i++)
				{
					if(unPiso.getCuartoActual().contains(Cuarto.getEnemigo(num).getPoolAtaques(i)))
					{
						if (Cuarto.getEnemigo(num).getPoolAtaques(i).x < 32 || Cuarto.getEnemigo(num).getPoolAtaques(i).x > 640 || Cuarto.getEnemigo(num).getPoolAtaques(i).y < 32 || Cuarto.getEnemigo(num).getPoolAtaques(i).y > 640)
						{
							Cuarto.getEnemigo(num).getPoolAtaques(i).selfRemove();
						}
						
						else if(Cuarto.getEnemigo(num).getPoolAtaques(i).getImagen().hitTestObject(jugador.getImagen()))
							//aca es cuando le pega al jugador
						{
							Cuarto.getEnemigo(num).reducirVidaA(jugador);
							Cuarto.getEnemigo(num).getPoolAtaques(i).selfRemove();
						}
					}
				}
			}
			
			else if (Cuarto.getEnemigo(num) is Torreta || Cuarto.getEnemigo(num) is Bloodball)
			{
				//los ataques de la torreta y la bloodball (el boss) son en base el mismo, aca se manejan
				for( i = 0; i < Entidad.maxPoolAtaques ; i++)
				{
					if(unPiso.getCuartoActual().contains(Cuarto.getEnemigo(num).getPoolAtaques(i)) && Cuarto.getEnemigo(num).getPoolAtaques(i).getExplotando() == false)
					{
						if (Cuarto.getEnemigo(num).getPoolAtaques(i).x == Cuarto.getEnemigo(num).getPoolAtaques(i).getMetaX() && Cuarto.getEnemigo(num).getPoolAtaques(i).y == Cuarto.getEnemigo(num).getPoolAtaques(i).getMetaY())
						{
							//esto hace que si el ataque llega a su punto de destino explote
							Cuarto.getEnemigo(num).getPoolAtaques(i).explotar();
							
							if (Cuarto.getEnemigo(num).getPoolAtaques(i).getAreaExplosion().hitTestObject(jugador.getImagen()))
							{
								//si al llegar al punto de destino y explotar el area de explosion toca al jugador le saca vida
								Cuarto.getEnemigo(num).reducirVidaA(jugador);
							}
						}
							
						else if(Cuarto.getEnemigo(num).getPoolAtaques(i).getAreaExplosion().hitTestObject(jugador.getImagen()))
						{
							//si antes de llegar al punto de destino el ataque pasa cerca del jugador entonces explota y saca vida
							Cuarto.getEnemigo(num).getPoolAtaques(i).explotar();
							Cuarto.getEnemigo(num).reducirVidaA(jugador);
						}
					}
				}
			}
			
			else if (Cuarto.getEnemigo(num) is Tesla)
			{
				//si el enemigo es una torre tesla (la que tira rayos)
				for( i = 0; i < Entidad.maxPoolAtaques ; i++)
				{
					if(unPiso.getCuartoActual().contains(Cuarto.getEnemigo(num).getPoolAtaques(i)))
					{
						if((Cuarto.getEnemigo(num).getPoolAtaques(i).getImagen().hitTestObject(jugador.getImagen()) == true) && (Cuarto.getEnemigo(num).getPoolAtaques(i).getInvisible() == false)) 
						{
							//este ataque sigue siempre al jugador, despues de un rato desaparece
							//esto verifica que solo saque vida si sigue estando visible
							Cuarto.getEnemigo(num).reducirVidaA(jugador);
							Cuarto.getEnemigo(num).getPoolAtaques(i).selfRemove();
						}
					}
				}
			}
		}
		
		private function impactoContraEnemigo(num:int) : void //ataque de jugador impacta contra enemigo
		{
			for(var i:int = 0; i < numeroDeEnemigosTotales ; i++)
			{
				if (unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i)) && Cuarto.getEnemigo(i).getEstaVivo() == true) //aca verifica que el enemigo golpeado este vivo
				{
					if((jugador.getPoolAtaques(num).getImagen().hitTestObject(Cuarto.getEnemigo(i).getImagen()) == true) && (jugador.getPoolAtaques(num).getInvisible() == false))
					{
						//aca vuelvo invisible el ataque utilizado, para despues removerlo
						jugador.getPoolAtaques(num).volverInvisible();
						jugador.reducirVidaA(Cuarto.getEnemigo(i)); //bajo la vida del enemigo
						jugador.regenerarVida(Cuarto.getEnemigo(i)); //curo al jugador (si es que tiene algun item de curacion al golpear)
					}
				}
			}
		}
		
		private function verificarChoques() : void //jugador impacta contra enemigo
		{
			if (numeroDeEnemigos > 0)
			{
				for(var i:int = 0; i < numeroDeEnemigosTotales; i++)
				{
					if(unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i)) && Cuarto.getEnemigo(i).getEstaVivo() == true)
					{
						if(jugador.getImagen().hitTestObject(Cuarto.getEnemigo(i).getImagen()))
						{
							Cuarto.getEnemigo(i).reducirVidaA(jugador); //esto le saca vida al jugador cuando choca con un enemigo
						}
					}
				}
			}
		}
		
		private function verificarShield() : void
		{
			if (numeroDeEnemigos > 0)
			{
				contadorBuda = 0; //este es el contador de cuantos budas hay
				for(var i:int = 0; i < numeroDeEnemigosTotales; i++)
				{
					if(unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i)) && (Cuarto.getEnemigo(i) is Buda) && Cuarto.getEnemigo(i).getEstaVivo() == true)
					{
						contadorBuda++; //revisa los enemigos que estan en el cuarto y si alguno es un buda sube el contador
					}
				}
				
				if (contadorBuda > 0)
				{
					for(i = 0; i < numeroDeEnemigosTotales; i++)
					{
						if(unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i)))
						{
							Cuarto.getEnemigo(i).activarEscudo(); //mientras haya por lo menos un buda se activan los escudos enemigos
						}
					}
				}
				else
				{
					for(i = 0; i < numeroDeEnemigosTotales; i++)
					{
						if(unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i)))
						{
							Cuarto.getEnemigo(i).desactivarEscudo(); //cuando ya no quedan budas los escudos se desactivan
						}
					}
				}
			}
		}
		
		private function eliminarAtaques() : void //aca se eliminan los ataques enemigos
		{
			for (var i:int = 0; i < numeroDeEnemigosTotales; i++)
			{
				if ((unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i)) == true) && (Cuarto.getEnemigo(i).getEstaVivo() == false))
				{
					for (var c:int = 0; c < Entidad.maxPoolAtaques ; c++)
					{
						if (unPiso.getCuartoActual().contains(Cuarto.getEnemigo(i).getPoolAtaques(c)))
						{
							Cuarto.getEnemigo(i).getPoolAtaques(c).volverInvisible();
						}
					}
				}
			}
		}
		
		public static function setPuertaUp(bool:Boolean) : void
		{
			hayPuertaUp = bool;
		}
		
		public static function setPuertaDown(bool:Boolean) : void
		{
			hayPuertaDown = bool;
		}
		
		public static function setPuertaRight(bool:Boolean) : void
		{
			hayPuertaRight = bool;
		}
		
		public static function setPuertaLeft(bool:Boolean) : void
		{
			hayPuertaLeft = bool;
		}
		
		public static function getNumeroDeEnemigos() : int
		{
			return numeroDeEnemigos;
		}
		
		public static function setNumeroDeEnemigos(num:int) : void
		{
			numeroDeEnemigos = num;
		}
		
		public static function restarUnEnemigo() : void
		{
			if (numeroDeEnemigos > 0)
			{
				numeroDeEnemigos--;
			}
		}
		
		public static function setNumeroDeEnemigosTotales(num:int) : void
		{
			numeroDeEnemigosTotales = num;
		}
		
		public static function getNumeroDeEnemigosTotales() : int
		{
			return numeroDeEnemigosTotales;
		}
		
		public static function subirNivel() : void
		{
			nivel++;
			Cuarto.aumentarEnemigos();
		}
		
		private function generarPuntitos() : void
		{
			var c:int = 0;
			var d:int = 0;
			for(var i:int = 0; i < puntitos.length; i++)
			{				
				puntitos[i] = new Shape();
				puntitos[i].graphics.beginFill(0x0000FF);
				puntitos[i].graphics.drawRect(0,0,5,5);
				puntitos[i].graphics.endFill();
				puntitos[i].alpha = 0;
				puntitos[i].x = numerosPuntitos[c];
				puntitos[i].y = numerosPuntitos[d];
				c++;
				if (c == numerosPuntitos.length)
				{
					c = 0;
					d++;
				}
			}
		}
		
		private function crearPuntitos() : void
		{
			for(var i:int = 0; i < puntitos.length; i++)
			{
				addChild(puntitos[i]);
			}
		}
		
		public static function getNumerosPuntitos(num:int) : int
		{
			//esto se fija en el lugar num de lista de puntos y muestra que numero hay
			if (num < numerosPuntitos.length)
			{
				return numerosPuntitos[num];	
			}
			else
			{
				return 0;
			}
		}
		
		public static function unNumeroPuntitos() : int
		{
			//esto entrega un numero random de la lista de puntos
			numeroRandom = Math.random() * numerosPuntitos.length;
			return numerosPuntitos[numeroRandom];
		}
		
		public static function getJugadorX() : int
		{
			return jugadorX;
		}
		
		public static function getJugadorY() : int
		{
			return jugadorY;
		}
		
		private function actualizarInfo() : void
		{
			//esto se encarga de enviar la inforamcion del jugador a la pantalla
			//tambien pone las armas en caso de que las haya
			informacion.setVida(jugador.getVida(),jugador.getVidaMax());
			informacion.setOro(oro);
			informacion.setNivel(nivel);
			informacion.setAtaque(jugador.getAtaque());
			informacion.setRecuperacionVida(jugador.getRecuperacionVida());
			informacion.setVelocidad(jugador.getVelocidad());
			if(jugador.getTieneArma() == true)
			{
				informacion.setArma(jugador.getArmaEquipada());
			}
			if(jugador.getTieneEscudo() == true)
			{
				informacion.setEscudo(jugador.getEscudoEquipado());
			}
			if(jugador.getEstaVivo() == false)
			{
				jugando = false;
			}
		}
		
		public static function aumentarOro(bool:Boolean = false) : void
		{
			//esto aumenta de manera aleatoria al matar a un enemigo
			numeroRandom = Math.random() * 100 + masUno;
			
			if (numeroRandom < 40)
			{
				oroExtra = Math.random() * 15 + 6;
			}
			else if (numeroRandom < 75)
			{
				oroExtra = Math.random() * 30 + 21;
			}
			else
			{
				oroExtra = Math.random() * 50 + 51;
			}
			
			if(bool == true)
			{
				//si el bool es true (usado solo cuando muere un boss) aumenta el oro de forma no aleatoria
				oroExtra = 500 * nivel;
			}
			
			oro = oro + oroExtra;			
		}
		
		public static function getOro() : int
		{
			return oro;
		}
		
		public static function setOro(num:uint) : void
		{
			oro = num;
		}
		
		public static function getCantidadDeBosses() : int
		{
			return cantidadDeBosses;
		}
		
		public static function restarBoss() : void
		{
			cantidadDeBosses = cantidadDeBosses - 1;
		}
		
		public function getJugando() : Boolean
		{
			return jugando;
		}
	}
}