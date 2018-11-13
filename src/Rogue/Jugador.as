package Rogue
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	public class Jugador extends Entidad
	{
		private var ataqueCD:Timer = new Timer(200, 1); //el tiempo muerto entre ataques del jugador
		private var escudoActivado:Boolean = false; //al perder vida hay un escudo automatico que lo hace invulnerable unos momentos
		private var duracionEscudo:Timer = new Timer(1000,1);
		private var escudo:Shape = new Shape();
		private var recuperacionVida:int = 0; //esto es para recuperar vida al golpear enemigos
		
		private var tieneArma:Boolean = false; //si tiene arma y escudo
		private var tieneEscudo:Boolean = false;
		
		private var armaEquipada:Arma = new Arma(); //cual arma y escudo tiene
		private var escudoEquipado:Escudo = new Escudo();
		
		private var velocidadBase:int = 8;
		
		private var sonidoAtaque:Sound = new Recursos.powerSonidoClass();
		private var hurt:Sound = new Recursos.hurtSonidoClass();
		
		public function Jugador()
		{
			velocidadBase = 8;
			velocidad = velocidadBase;
			
			ataqueBase = 35;
			ataqueTotal = ataqueBase;
			
			
			vidaMaxBase = 100;
			vidaMax = vidaMaxBase;
			vida= vidaMaxBase;
			
			//se inicia el pool de ataques del jugador
			for(var i:int = 0; i < maxPoolAtaques; i++)
			{
				poolAtaques[i] = new Ataque();
			}
			
			imagen = new Recursos.george1Class();
			addChild(imagen);
			
			escudo.graphics.beginFill(0xA0BEEF);
			escudo.graphics.drawCircle(0,0,25);
			escudo.graphics.endFill();
			addChild(escudo);
			escudo.x = imagen.width/2;
			escudo.y = imagen.height/2;
			escudo.alpha = 0;
			
			x = 320;
			y = 320;
			
			ataqueCD.addEventListener(TimerEvent.TIMER_COMPLETE, finCD);
			duracionEscudo.addEventListener(TimerEvent.TIMER_COMPLETE, finEscudo);
			
		}
		
		public function getEscudoActivado() : Boolean
		{
			return escudoActivado;
		}
		
		private function activarEscudo() : void
		{
			hurt.play(); //sonido de dolor
			escudoActivado = true;
			escudo.alpha = 0.3;
			duracionEscudo.start(); //inicia la duracion del escudo
		}
		
		private function finEscudo(event:TimerEvent) : void
		{
			//se termina el escudo
			duracionEscudo.reset();
			escudo.alpha = 0;
			escudoActivado = false;
		}
		
		public function iniciarCDAtaque() : void
		{
			//tiempo muerto del ataque
			sonidoAtaque.play();
			ataqueCD.start();
		}
		
		public function setPoolAtaques(num1:int = 0, num2:int = 0) : void
		{
			poolAtaques[num1] = new Ataque(num2, x, y);
		}
		
		private function finCD(event:TimerEvent) : void
		{
			ataqueDisponible = true;
			ataqueCD.reset();
		}
		
		public function reducirVidaA(enemigo:Enemigo) : void
		{
			//sacarle vida al enemigo pasando el ataque del jugador
			enemigo.restarVida(ataqueTotal);
		}
		
		public function restarVida(num:uint) : void
		{
			//si el escudo no esta activado se pierde vida
			//esto maneja la muerte del jugador tambien
			if(escudoActivado == false)
			{
				if(vida <= num)
				{
					vida = 0;
					estaVivo = false;
					imagen.alpha = 0;
				}
				else
				{
					vida = vida - num;
					activarEscudo();
				}
			}
		}
		
		public function getVida() : int
		{
			return vida;
		}
		
		public function getVidaMax() : int
		{
			return vidaMax;
		}
		
		public function sumarVida(num:int) : void
		{
			//esto es para curacion con pociones
			if (vida + num > vidaMax)
			{
				vida = vidaMax;
			}
			else
			{
				vida = vida + num;
			}
		}
		
		public function getAtaque() : int
		{
			return ataqueTotal;
		}
		
		public function getRecuperacionVida() : int
		{
			return recuperacionVida;
		}
		
		public function getVelocidad() : int
		{
			return velocidad;
		}
		
		public function getTieneArma() : Boolean
		{
			return tieneArma;
		}
		
		public function getTieneEscudo() : Boolean
		{
			return tieneEscudo;
		}
		
		public function setArma(arma:Arma) : void
		{
			//esto hace los cambios al ponerse un arma
			armaEquipada = arma;
			tieneArma = true;
			ataqueTotal = ataqueBase + armaEquipada.getAtaqueExtra();
			recuperacionVida = armaEquipada.getRecuperacionVida();
		}
		
		public function setEscudo(elEscudo:Escudo) : void
		{
			//esto hace los cambios al ponerse un escudo
			escudoEquipado = elEscudo;
			tieneEscudo = true;
			addChild(escudoEquipado);
			if(vidaMax > vidaMaxBase + escudoEquipado.getVidaExtra() && vida > vidaMaxBase + escudoEquipado.getVidaExtra())
			{
				vida = vidaMaxBase + escudoEquipado.getVidaExtra();
				vidaMax = vidaMaxBase + escudoEquipado.getVidaExtra();
			}
			else
			{
				vidaMax = vidaMaxBase + escudoEquipado.getVidaExtra();
			}
			velocidad = velocidadBase + escudoEquipado.getVelocidadExtra();
		}
		
		public function getArmaEquipada() : Arma
		{
			return armaEquipada;
		}
		
		public function getEscudoEquipado() : Escudo
		{
			return escudoEquipado;
		}
		
		public function regenerarVida(enemigo:Enemigo) : void
		{
			//esto es para curarse al pegarle a enemigos
			//funciona cuando no tienen escudo
			if(enemigo.getEscudoActivado() == false)
			{
				if(recuperacionVida + vida > vidaMax)
				{
					vida = vidaMax;
				}
				
				else
				{
					vida = vida + recuperacionVida;
				}
			}
		}
	}
}