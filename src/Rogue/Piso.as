package Rogue
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.sampler.NewObjectSample;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;

	public class Piso extends Sprite
	{
		private var iniciarAtaques:Boolean = false; //este bool y el timer de paz son para que los enemigos no ataquen apenas entra alguien
		private var timerPaz:Timer = new Timer(1100, 1);
		
		private const cuartoInicial:int = 1; //cantidad de cuartos iniciales
		private const cuartosFijos:int = 4; //cantidad de cuartos fijos que hay en el juego
		//al principio iba a usar un sistema diferente para crear los cuartos aleatorios
		//era mas limitado y necesitaba tener un cuarto fijo en cada lado despues no lo cambie
		//pero no es muy complicado agregar un par de verificaciones para que se expanda mas y mejor
		private const cuartosFijosUp:int = 1; //cuantos cuartos fijos hay de cada lado
		private const cuartosFijosRight:int = 1;		
		private const cuartosFijosDown:int = 1;
		private const cuartosFijosLeft:int = 1;
		private const cuartosRandomMax:int = 8; //la cantidad maxima de cuartos aleatorios que se generan
		private const cuartosRandomMin:int = 4; //la cantidad minima de cuartos aleatorios
		//estas cantidades no son los random totales
		//son la suma de que tan lejos en linea recta se pueden expandir desde el cuarto inicial
		//cada cuarto que no sea fijo y se genere puede expandirse un cuarto por cada lateral
		//este sistema es bastante limitado
		//pero es porque al principio lo iba a hacer con listas de cuartos y no con una matriz
		//en algun juego futuro seguro haga una version mejorada de esto con la matriz expandiendose para cualquier lado
		
		//estos son cuantos cuartos pueden haber como mucho de ancho y alto en la matriz
		private var cuartosHorizontalesMax:int = cuartoInicial + cuartosFijosRight + cuartosFijosLeft + cuartosRandomMax;
		private var cuartosVerticalesMax:int = cuartoInicial + cuartosFijosUp + cuartosFijosDown + cuartosRandomMax;
		
		private var cuartosRandom:int = 0; //esta es la cantidad de cuartos aleatorios que se generen
		private var cuartosRandomUsables:int = 0; //esta variable esta para ir restando cuando los voy usando
		private var cuartosRandomUp:int = 0;
		private var cuartosRandomRight:int = 0;
		private var cuartosRandomDown:int = 0;
		private var cuartosRandomLeft:int = 0;
		
		private var cuartosUp:int = cuartosRandomUp + cuartosFijosUp;
		private var cuartosRight:int = cuartosRandomRight + cuartosFijosRight;
		private var cuartosDown:int = cuartosRandomDown + cuartosFijosDown;
		private var cuartosLeft:int = cuartosRandomLeft + cuartosFijosLeft;		
		
		private var bossDisponible:Boolean = true; //si el boss todavia no fue puesto en ningun cuarto
		private var bosses:int = 1;
		
		private var goldDisponible:Boolean = true; //no llegue a esto, pero era para un cuarto especial
		private var shopDisponible:Boolean = true; //la tienda si la termine en la version updateada
		private var holyDisponible:Boolean = true; //los demas cuartos tampoco los llegue a armar
		private var demonDisponible:Boolean = true;
		private var pactoDisponible:Boolean = true;
		
		private var puertaLvlDisponible:Boolean = true; //esto es para que haya solo una puerta a otro nivel
		
		private var i:int = 0;
		private var numeroRandom:int = 0;
		
		//esta es la matriz de cuartos
		private var matrizCuartos:Vector.<Vector.<Cuarto>> = new Vector.<Vector.<Cuarto>>(cuartosHorizontalesMax);	
	
		private static var matrizX:int = 0; //estos numeros estaticos son los numeros del cuarto actual en la matriz
		private static var matrizY:int = 0;
		
		private const masUno:int = 1 //esto es para los random
			
		public function Piso(numeroDeBosses:int = 1)
		{
			//se definen cuantos cuartos random hay
			cuartosRandom = (Math.random() * (cuartosRandomMax - cuartosRandomMin + masUno)) + cuartosRandomMin;
			cuartosRandomUsables = cuartosRandom;
			
			//de esos cuartos random se saca una cantidad y se usan en linea recta para arriba desde el cuarto inicial
			cuartosRandomUp = Math.random() * (cuartosRandomUsables + masUno);
			cuartosRandomUsables = cuartosRandomUsables - cuartosRandomUp;
			
			//de los que quedan se toma un numero para la derecha
			cuartosRandomRight = Math.random() * (cuartosRandomUsables + masUno);
			cuartosRandomUsables = cuartosRandomUsables - cuartosRandomRight;
			
			//lo mismo abajo
			cuartosRandomDown = Math.random() * (cuartosRandomUsables + masUno);
			cuartosRandomUsables = cuartosRandomUsables - cuartosRandomDown;
			
			//y los que queden a la izquierda
			cuartosRandomLeft = cuartosRandomUsables;
			
			//se definen los cuartos totales para cada lado sumando los aleatorios y el fijo
			cuartosUp = cuartosRandomUp + cuartosFijosUp;
			cuartosRight = cuartosRandomRight + cuartosFijosRight;
			cuartosDown = cuartosRandomDown + cuartosFijosDown;
			cuartosLeft = cuartosRandomLeft + cuartosFijosLeft;
			
			for(var i:int = 0; i < matrizCuartos.length ; i++)
			{
				matrizCuartos[i] = new Vector.<Cuarto>(cuartosVerticalesMax); //se inicia la matriz de cuartos
			}
			
			bosses = numeroDeBosses; //se define el numero de bosses del piso con el parametro puesto
			
			generadorCuartos(); //esto genera los cuartos y sus estadisticas
			verificarBoss(); //esto verifica si quedan bosses por posicionar despues de haber creado los cuartos
			
			timerPaz.addEventListener(TimerEvent.TIMER_COMPLETE, activarAtaques); //este es el timer para que no ataquen los enemigos
			
			addChild(matrizCuartos[cuartosLeft][cuartosUp]); //es el cuarto inicial
			
			matrizX = cuartosLeft;
			matrizY = cuartosUp;
			//estos son la x e y de la matriz, al principio el cuarto inicial queda en las pociciones definidas por los cuartos a la izquierda y arriba
			/* si por ejemplo hay 2 cuartos a la  izquierda y 1 arriba del cuarto principal quedaria asi
			
			0,0 1,0 2,0
			0,1 1,1 2,1
			
			ignorando la cantidad de cuartos abajo y a la derecha el cuarto 1,2 seria el inicial
			con 2 cuartos a su izquierda y 1 para arriba
			en la matriz se pondria matrizCuartos[2][1]
			si, esta al revez de como se deberian numerar las matrices
			pero me di cuenta tarde como para cambiarlo*/
		}
		
		private function generadorCuartos() : void
		{
			//matrizCuartos [horizontal][vertical]
			
			matrizCuartos[cuartosLeft][cuartosUp] = new Cuarto(false,0,true);
			//cuarto inicial
		
			if(cuartosRandomLeft > 0) //si hay por lo menso 1 cuarto mas alla del fijo a la izquierda
			{
				matrizCuartos[cuartosRandomLeft][cuartosUp] = new Cuarto(false,4,true);
				//primero hago el cuarto fijo a la izquierda del inicial, moviendome restando o sumando a los indices de la matriz
				//en este caso puse cuartosRandomLeft porque los cuartos random no cuentan al fijo, que si esta en cuartosLeft
				//por eso no puse la resta
				//los cuartos fijos no son afectados por el generador especial para que puedan ser usados por los bosses de ser necesario
				//tampoco usan el verificador extra porque al principio tenia una limitacion que no me permitia crear los cuartos laterales en la primer habitacion
				//despues no lo cambie
				
				for (i = 0; i < cuartosRandomLeft; i++) //aca se generan todos los cuartos random a la izquierda
				{
					if (i == cuartosRandomLeft - 1) //si es el ultimo cuarto random a la izquierda
					{
						matrizCuartos[cuartosRandomLeft-1-i][cuartosUp] = new Cuarto(true,4,false); //creo un cuarto final
						//se define como cuarto final con los parametros que le paso a la creacion del cuarto
						generadorEspecial(matrizCuartos[cuartosRandomLeft-1-i][cuartosUp]);
						//esto define si el cuarto que estoy creando tiene un boss o una tienda o lo que fuera especial
					}
					
					else
					{
						matrizCuartos[cuartosRandomLeft-1-i][cuartosUp] = new Cuarto(false,4,false);
						//si no es un cuarto final los crea a todos de esta forma
						//cada cuarto en sus stats tiene chance de tener cuartos laterales sin que yo tenga que definirlo
					}
					
					verificadorExtra(cuartosRandomLeft-1-i,cuartosUp,matrizCuartos[cuartosRandomLeft-1-i][cuartosUp]);
					//aca verifico si el cuarto que cree tiene habitaciones laterales y las crea
				}
			}
			
			else
			{
				matrizCuartos[cuartosRandomLeft][cuartosUp] = new Cuarto(true,4,true);
				//si no hay cuarrtos random solo armo el cuarto fijo izquierdo
			}
			
			//lo mismo va para los demas lados, aca la derecha
			if (cuartosRandomRight > 0)
			{
				matrizCuartos[cuartosLeft + cuartoInicial][cuartosUp] = new Cuarto(false,2,true);
				//cuarto fijo derecho
				
				for (i = 0; i < cuartosRandomRight; i++)
				{
					if (i == cuartosRandomRight - 1) //si es el ultimo cuarto
					{
						matrizCuartos[cuartosLeft + cuartoInicial + 1 + i][cuartosUp] = new Cuarto(true,2,false); //creo un cuarto final
						generadorEspecial(matrizCuartos[cuartosLeft + cuartoInicial + 1 + i][cuartosUp]);
					}
						
					else
					{
						matrizCuartos[cuartosLeft + cuartoInicial + 1 + i][cuartosUp] = new Cuarto(false,2,false);	
					}
					
					verificadorExtra(cuartosLeft + cuartoInicial + 1 + i,cuartosUp,matrizCuartos[cuartosLeft + cuartoInicial + 1 + i][cuartosUp]);
				}
			}
			else
			{
				matrizCuartos[cuartosLeft + cuartoInicial][cuartosUp] = new Cuarto(true,2,true);
				//solo cuarto fijo derecho	
			}			
			
			//arriba
			if (cuartosRandomUp > 0)
			{
				matrizCuartos[cuartosLeft][cuartosRandomUp] = new Cuarto(false,1,true);
				//cuarto fijo arriba
				
				for (i = 0; i < cuartosRandomUp; i++)
				{
					if (i == cuartosRandomUp - 1) //si es el ultimo cuarto
					{
						matrizCuartos[cuartosLeft][cuartosRandomUp-1-i] = new Cuarto(true,1,false); //creo un cuarto final
						generadorEspecial(matrizCuartos[cuartosLeft][cuartosRandomUp-1-i]);
					}
						
					else
					{
						matrizCuartos[cuartosLeft][cuartosRandomUp-1-i] = new Cuarto(false,1,false);	
					}
					
					verificadorExtra(cuartosLeft,cuartosRandomUp-1-i,matrizCuartos[cuartosLeft][cuartosRandomUp-1-i]);
				}
			}
			else
			{
				matrizCuartos[cuartosLeft][cuartosRandomUp] = new Cuarto(true,1,true);
				//solo cuarto fijo arriba
			}
			
			//abajo
			if (cuartosRandomDown > 0)
			{
				matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial] = new Cuarto(false,3,true);
				//cuarto fijo abajo
				
				for (i = 0; i < cuartosRandomDown; i++)
				{
					if (i == cuartosRandomDown - 1) //si es el ultimo cuarto
					{
						matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial + 1 + i] = new Cuarto(true,3,false); //creo un cuarto final
						generadorEspecial(matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial + 1 + i]);
					}
						
					else
					{
						matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial + 1 + i] = new Cuarto(false,3,false);	
					}
					
					verificadorExtra(cuartosLeft,cuartosUp + cuartoInicial + 1 + i,matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial + 1 + i]);
				}
			}
			else
			{
				matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial] = new Cuarto(true,3,true);
				//solo cuarto fijo abajo
			} 
			
		}
		
		private function verificadorExtra(num1:int, num2:int, elCuarto:Cuarto) : void
		{
			//los parametros que se ponen en los cuartos que se crean aca son para que haya solo una puerta y no continue
			if (elCuarto.getHorizontal() == true) //si es horizontal sus cuartos extra son arriba y abajo
			{
				if (matrizCuartos[num1][num2].getArriba() == true) //verifico si tiene puerta extra arriba
				{
					matrizCuartos[num1][num2-1] = new Cuarto(true,1,true); //creo un cuarto nuevo arriba
					generadorEspecial(matrizCuartos[num1][num2-1]);
				}
				if (matrizCuartos[num1][num2].getAbajo() == true) //verifico si tiene otra puerta extra abajo
				{
					matrizCuartos[num1][num2+1] = new Cuarto(true,3,true); //lo mismo abajo, ambos generando la posibilidad de tener boss o shop
					generadorEspecial(matrizCuartos[num1][num2+1]);
				}
			}
			
			else if (elCuarto.getVertical() == true) //si es vertical sus cuartos extra son izquierda y derecha
			{
				if (matrizCuartos[num1][num2].getDerecha() == true) //verifico si tiene puerta extra derecha
				{
					matrizCuartos[num1+1][num2] = new Cuarto(true,2,true);
					generadorEspecial(matrizCuartos[num1+1][num2]);
				}
				if (matrizCuartos[num1][num2].getIzquierda() == true) //verifico si tiene otra puerta extra izquierda
				{
					matrizCuartos[num1-1][num2] = new Cuarto(true,4,true);
					generadorEspecial(matrizCuartos[num1-1][num2]);
				}
			}
		}
		
		private function generadorEspecial(elCuarto:Cuarto) : void
		{
			numeroRandom = Math.random()* 20 + masUno;
			
			//dependiendo los numeros que salgan el cuarto puede o no ser especial
			switch(numeroRandom)
			{
				case 8:
				case 9:
				case 10:
					if (bossDisponible == true) //si hay un boss disponible crea un cuarto con boss
					{
						elCuarto.limpiarEnemigos(); //elimino los enemigos originales del cuarto
						elCuarto.setBoss(true); //le marco que tiene un boss
						restarBoss(); //resto un boss del contador de bosses disponibles para poner
						if (puertaLvlDisponible == true) //el primer boss creado tiene la puerta al proximo nivel
						{
							puertaLvlDisponible = false;
							elCuarto.setPuertaLvl(true);
						}
					}
					break;
				case 11:
				case 12:
					if (goldDisponible == true) //no termine este cuarto, por lo que queda vacio
					{
						elCuarto.limpiarEnemigos();
						elCuarto.setGold(true);
						goldDisponible = false;
					}
					break;
				case 13:
				case 14:
				case 15:
				case 16:
				case 17:
					if (shopDisponible == true) //aca se genera el shop
					{
						elCuarto.limpiarEnemigos();
						elCuarto.setShop(true);
						shopDisponible = false;
					}
					break;
				case 18:
					if (pactoDisponible == true) //otro cuarto vacio
					{
						elCuarto.limpiarEnemigos();
						elCuarto.setPacto(true);
						pactoDisponible = false;
					}
					break;
				case 19:
					if (holyDisponible == true) //vacio
					{
						elCuarto.limpiarEnemigos();
						elCuarto.setHoly(true);
						holyDisponible = false;
					}
					break;
				case 20:
					if (demonDisponible == true) //vacio
					{
						elCuarto.limpiarEnemigos();
						elCuarto.setDemon(true);
						demonDisponible = false;
					}
					break;
				default:
					break;
			}
			elCuarto.generarEspeciales(); //esto hace que la tienda se habilite en el cuarto si la tiene
			//si hubieran mas cuartos especiales haria mas cosas
		}
		
		private function restarBoss() : void
		{
			bosses--;
			
			if (bosses == 0)
			{
				bossDisponible = false;
			}
		}
		
		private function verificarBoss() : void
		{
			//si al crearse todos los cuartos random no se llego a poner el boss este metodo lo revisa
			while (bossDisponible == true)
			{
				numeroRandom = Math.random() * 4 + masUno;
				//este metodo pone al boss en uno de los 4 cuartos fijos
				//y lo hace con todos los bosses que quedan disponibles
				//saca los enemigos y pone la puerta a otro nivel en caso de ser necesario
				switch (numeroRandom)
				{
					case 1:
						if (matrizCuartos[cuartosLeft][cuartosRandomUp].getBoss() == false)
						{
							matrizCuartos[cuartosLeft][cuartosRandomUp].limpiarEnemigos();
							matrizCuartos[cuartosLeft][cuartosRandomUp].setBoss(true);
							restarBoss();
							if (puertaLvlDisponible == true)
							{
								puertaLvlDisponible = false;
								matrizCuartos[cuartosLeft][cuartosRandomUp].setPuertaLvl(true);
							}
						}
						break;
					case 2:
						if (matrizCuartos[cuartosLeft + cuartoInicial][cuartosUp].getBoss() == false)
						{
							matrizCuartos[cuartosLeft + cuartoInicial][cuartosUp].limpiarEnemigos();
							matrizCuartos[cuartosLeft + cuartoInicial][cuartosUp].setBoss(true);
							restarBoss();
							if (puertaLvlDisponible == true)
							{
								puertaLvlDisponible = false;
								matrizCuartos[cuartosLeft + cuartoInicial][cuartosUp].setPuertaLvl(true);
							}
						}
						break;
					case 3:
						if (matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial].getBoss() == false)
						{
							matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial].limpiarEnemigos();
							matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial].setBoss(true);
							restarBoss();
							if (puertaLvlDisponible == true)
							{
								puertaLvlDisponible = false;
								matrizCuartos[cuartosLeft][cuartosUp + cuartoInicial].setPuertaLvl(true);
							}
						}
						break;
					case 4:
						if (matrizCuartos[cuartosRandomLeft][cuartosUp].getBoss() == false)
						{
							matrizCuartos[cuartosRandomLeft][cuartosUp].limpiarEnemigos();
							matrizCuartos[cuartosRandomLeft][cuartosUp].setBoss(true);
							restarBoss();
							if (puertaLvlDisponible == true)
							{
								puertaLvlDisponible = false;
								matrizCuartos[cuartosRandomLeft][cuartosUp].setPuertaLvl(true);
							}
						}
						break;
				}
			}
		}
		
		public function teleport(num:int) : void
		{
			//este es el metodo que te mueve entre cuartos
			//1 2 3 4 son arriba derecha abajo izquierda respectivamente
			switch (num)
			{
				case 1:
					matrizCuartos[matrizX][matrizY].removerEnemigos(); //elimina los enemigos
					matrizCuartos[matrizX][matrizY].limpiarEnemigos(); //pone las variables relacionadas en cero
					removeChild(matrizCuartos[matrizX][matrizY]); //saca el cuarto actual
					matrizY = matrizY - 1; //aca me muevo por la matriz cambiado la variable necesaria
					setPuertas(matrizCuartos[matrizX][matrizY]); //agrego las puertas y paredes segun los datos del cuarto
					addChild(matrizCuartos[matrizX][matrizY]); //agrego al nuevo cuarto
					Juego.setNumeroDeEnemigos(matrizCuartos[matrizX][matrizY].getCantidadEnemigos());
					//el juego usa variables estaticas de cuantos enemigos hay y cuantos quedan, para eso estan los dos seteos de enemigos
					Juego.setNumeroDeEnemigosTotales(matrizCuartos[matrizX][matrizY].getCantidadEnemigos());
					matrizCuartos[matrizX][matrizY].spawnearEnemigos(); //crea los enemigos que tiene el cuarto
					matrizCuartos[matrizX][matrizY].spawnearBoss(); //crea el boss (si lo hay)
					iniciarPaz(); //inicia el tiempo donde los enemigos no atacan apenas entras
					break;
				case 2:
					matrizCuartos[matrizX][matrizY].removerEnemigos();
					matrizCuartos[matrizX][matrizY].limpiarEnemigos();
					removeChild(matrizCuartos[matrizX][matrizY]);
					matrizX = matrizX + 1;
					setPuertas(matrizCuartos[matrizX][matrizY]);
					addChild(matrizCuartos[matrizX][matrizY]);
					Juego.setNumeroDeEnemigos(matrizCuartos[matrizX][matrizY].getCantidadEnemigos());
					Juego.setNumeroDeEnemigosTotales(matrizCuartos[matrizX][matrizY].getCantidadEnemigos());
					matrizCuartos[matrizX][matrizY].spawnearEnemigos();
					matrizCuartos[matrizX][matrizY].spawnearBoss();
					iniciarPaz();
					break;
				case 3:
					matrizCuartos[matrizX][matrizY].removerEnemigos();
					matrizCuartos[matrizX][matrizY].limpiarEnemigos();
					removeChild(matrizCuartos[matrizX][matrizY]);
					matrizY = matrizY + 1;
					setPuertas(matrizCuartos[matrizX][matrizY]);
					addChild(matrizCuartos[matrizX][matrizY]);
					Juego.setNumeroDeEnemigos(matrizCuartos[matrizX][matrizY].getCantidadEnemigos());
					Juego.setNumeroDeEnemigosTotales(matrizCuartos[matrizX][matrizY].getCantidadEnemigos());
					matrizCuartos[matrizX][matrizY].spawnearEnemigos();
					matrizCuartos[matrizX][matrizY].spawnearBoss();
					iniciarPaz();
					break;
				case 4:
					matrizCuartos[matrizX][matrizY].removerEnemigos();
					matrizCuartos[matrizX][matrizY].limpiarEnemigos();
					removeChild(matrizCuartos[matrizX][matrizY]);
					matrizX = matrizX - 1;
					setPuertas(matrizCuartos[matrizX][matrizY]);
					addChild(matrizCuartos[matrizX][matrizY]);
					Juego.setNumeroDeEnemigos(matrizCuartos[matrizX][matrizY].getCantidadEnemigos());
					Juego.setNumeroDeEnemigosTotales(matrizCuartos[matrizX][matrizY].getCantidadEnemigos());
					matrizCuartos[matrizX][matrizY].spawnearEnemigos();
					matrizCuartos[matrizX][matrizY].spawnearBoss();
					iniciarPaz();
					break;
				case 5:
					//el caso 5 es para moverse a otro nivel, todo lo relevante para esto esta en la clase juego ya que es un cambio de piso
					//lo unico que se maneja aca es poner las nuevas puertas, que en este caso matrizX e Y son un nuevo cuarto inicial
					setPuertas(matrizCuartos[matrizX][matrizY]);
					break;
			}
		}
		
		private function setPuertas(cuarto:Cuarto) : void
		{
			Juego.setPuertaUp(cuarto.getArriba());
			Juego.setPuertaDown(cuarto.getAbajo());
			Juego.setPuertaRight(cuarto.getDerecha());
			Juego.setPuertaLeft(cuarto.getIzquierda());
		}
		
		public function verificarPuertas() : void
		{
			//esto abre las puertas cuando no hay enemigos y todavia estan cerradas
			if (Juego.getNumeroDeEnemigos() == 0 && matrizCuartos[matrizX][matrizY].getPuertasAbiertas() == false)
			{
				matrizCuartos[matrizX][matrizY].abrirPuertas();
			}
		}
		
		public function verificarPuertaLvl() : void
		{
			//esto abre la puerta lvl si se cumplen las condiciones de que no hayan bosses
			//la puerta este todavia cerrada y no hayan enemigos en ese cuarto
			if (Juego.getCantidadDeBosses() == 0 && matrizCuartos[matrizX][matrizY].getPuertaLvl() == true && matrizCuartos[matrizX][matrizY].getPuertaLvlEstaAbierta() == false && Juego.getNumeroDeEnemigos() == 0)
			{
				matrizCuartos[matrizX][matrizY].abrirPuertaLvl();
			}
		}
		
		public function getCuartoActual() : Cuarto
		{
			return matrizCuartos[matrizX][matrizY];
		}
		
		private function iniciarPaz() : void
		{
			//para que los enemigos no ataquen apenas entras
			if (matrizCuartos[matrizX][matrizY].getCantidadEnemigos() > 0)
			{
				iniciarAtaques = false;
				timerPaz.start();	
			}
		}
		
		private function activarAtaques(event:TimerEvent) : void
		{
			//para que los enemigos puedan atacar despues del timer
			timerPaz.reset();
			iniciarAtaques = true;
		}
		
		public function getIniciarAtaques() : Boolean
		{
			return iniciarAtaques;
		}
	}
}