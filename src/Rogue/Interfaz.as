package Rogue
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Interfaz extends Sprite
	{
		private var miFormato:TextFormat = new TextFormat();
		private var formatoInventario:TextFormat = new TextFormat();
		
		private var datosNivel:TextField = new TextField();
		private var datosVida:TextField = new TextField();
		private var datosOro:TextField = new TextField();
		private var datosAtaque:TextField = new TextField();
		private var datosRecuperacionVida:TextField = new TextField();
		private var datosVelocidad:TextField = new TextField();
		private var datosArma:TextField = new TextField();
		private var datosEscudo:TextField = new TextField();
		private var armaEquipada:Arma = new Arma();
		private var escudoEquipado:Escudo = new Escudo();
		
		public function Interfaz()
		{
			//aca estan los datos que aparecen a la derecha y como se actualizan
			
			miFormato.size = 25;
			miFormato.bold = true;
			miFormato.leftMargin = 10;
			
			formatoInventario.size = 20;
			formatoInventario.bold = true;
			formatoInventario.leftMargin = 150;
			
			datosNivel.text = "NIVEL: "+ Juego.getNivel();
			datosNivel.width = 370;
			datosNivel.height = 35;
			datosNivel.wordWrap = true;
			datosNivel.x = 695;
			datosNivel.y = 20;
			datosNivel.background = true;
			datosNivel.backgroundColor = 0xBAAAAA;
			datosNivel.border = true;
			datosNivel.borderColor = 0x000000;
			datosNivel.setTextFormat(miFormato);
			
			datosVida.text = "VIDA: "+ 0 + " / " + 0;
			datosVida.width = 370;
			datosVida.height = 35;
			datosVida.wordWrap = true;
			datosVida.x = 695;
			datosVida.y = 65;
			datosVida.background = true;
			datosVida.backgroundColor = 0xBAAAAA;
			datosVida.border = true;
			datosVida.borderColor = 0x000000;
			datosVida.setTextFormat(miFormato);
			
			datosOro.text = "ORO: "+ 0;
			datosOro.width = 370;
			datosOro.height = 35;
			datosOro.wordWrap = true;
			datosOro.x = 695;
			datosOro.y = 110;
			datosOro.background = true;
			datosOro.backgroundColor = 0xBAAAAA;
			datosOro.border = true;
			datosOro.borderColor = 0x000000;
			datosOro.setTextFormat(miFormato);
			
			datosAtaque.text = "ATAQUE: "+ 0;
			datosAtaque.width = 370;
			datosAtaque.height = 35;
			datosAtaque.wordWrap = true;
			datosAtaque.x = 695;
			datosAtaque.y = 155;
			datosAtaque.background = true;
			datosAtaque.backgroundColor = 0xBAAAAA;
			datosAtaque.border = true;
			datosAtaque.borderColor = 0x000000;
			datosAtaque.setTextFormat(miFormato);
			
			datosRecuperacionVida.text = "RECUPERACION DE VIDA POR GOLPE: "+ 0;
			datosRecuperacionVida.width = 370;
			datosRecuperacionVida.height = 35;
			datosRecuperacionVida.wordWrap = true;
			datosRecuperacionVida.x = 695;
			datosRecuperacionVida.y = 200;
			datosRecuperacionVida.background = true;
			datosRecuperacionVida.backgroundColor = 0xBAAAAA;
			datosRecuperacionVida.border = true;
			datosRecuperacionVida.borderColor = 0x000000;
			datosRecuperacionVida.setTextFormat(miFormato);
			
			datosVelocidad.text = "VELOCIDAD: "+ 0;
			datosVelocidad.width = 370;
			datosVelocidad.height = 35;
			datosVelocidad.wordWrap = true;
			datosVelocidad.x = 695;
			datosVelocidad.y = 245;
			datosVelocidad.background = true;
			datosVelocidad.backgroundColor = 0xBAAAAA;
			datosVelocidad.border = true;
			datosVelocidad.borderColor = 0x000000;
			datosVelocidad.setTextFormat(miFormato);
			
			datosArma.text = "";
			datosArma.width = 370;
			datosArma.height = 181;
			datosArma.wordWrap = true;
			datosArma.x = 695;
			datosArma.y = 290;
			datosArma.background = true;
			datosArma.backgroundColor = 0xBAAAAA;
			datosArma.border = true;
			datosArma.borderColor = 0x000000;
			datosArma.setTextFormat(miFormato);
			
			datosEscudo.text = "";
			datosEscudo.width = 370;
			datosEscudo.height = 181;
			datosEscudo.wordWrap = true;
			datosEscudo.x = 695;
			datosEscudo.y = 481;
			datosEscudo.background = true;
			datosEscudo.backgroundColor = 0xBAAAAA;
			datosEscudo.border = true;
			datosEscudo.borderColor = 0x000000;
			datosEscudo.setTextFormat(miFormato);
			
			addChild(datosNivel);
			addChild(datosVida);
			addChild(datosOro);
			addChild(datosAtaque);
			addChild(datosRecuperacionVida);
			addChild(datosVelocidad);
			addChild(datosArma);
			addChild(datosEscudo);
			
			escudoEquipado.x = 70 + 690;
			escudoEquipado.y = 90 + 481;
			
			armaEquipada.x = 70 + 690;
			armaEquipada.y = 90 + 290;
			
			armaEquipada.getImagen().alpha = 0;
			escudoEquipado.getImagen().alpha = 0;
			
			addChild(armaEquipada);
			addChild(escudoEquipado);
		}
		
		public function setVida(num1:int, num2:int) : void
		{
			datosVida.text = "VIDA: "+ num1 + " / " + num2;
			datosVida.setTextFormat(miFormato);
		}
		
		public function setOro(num:int) : void
		{
			datosOro.text = "ORO: "+ num;
			datosOro.setTextFormat(miFormato);
		}
		
		public function setNivel(num:int) : void
		{
			datosNivel.text = "NIVEL: "+ num;
			datosNivel.setTextFormat(miFormato);
		}
		
		public function setAtaque(num:int) : void
		{
			datosAtaque.text = "ATAQUE: "+ num;
			datosAtaque.setTextFormat(miFormato);
		}
		
		public function setRecuperacionVida(num:int) : void
		{
			datosRecuperacionVida.text = "VIDA POR GOLPE: "+ num;
			datosRecuperacionVida.setTextFormat(miFormato);
		}
		
		public function setVelocidad(num:int) : void
		{
			datosVelocidad.text = "VELOCIDAD: "+ num;
			datosVelocidad.setTextFormat(miFormato);
		}
		
		public function setArma(arma:Arma) : void
		{
			if(armaEquipada != arma)
			{
				removeChild(armaEquipada);
				armaEquipada = arma;
				addChild(armaEquipada);	
				armaEquipada.x = 70 + 690;
				armaEquipada.y = 90 + 290;
				datosArma.text = armaEquipada.getNombre() + "\n" + "\n" + "\n" + "\n"+ "+ " + armaEquipada.getAtaqueExtra() + " de ataque" + "\n" + armaEquipada.getRecuperacionVida() + " recuperacion de vida por golpe";
				datosArma.setTextFormat(formatoInventario);
				
			}			
		}
		
		public function setEscudo (escudo:Escudo) : void
		{
			if(escudoEquipado != escudo)
			{
				removeChild(escudoEquipado);
				escudoEquipado = escudo;
				addChild(escudoEquipado),
				escudoEquipado.x = 70 + 690;
				escudoEquipado.y = 90 + 481;
				datosEscudo.text = escudoEquipado.getNombre() + "\n" + "\n" + "\n" + "\n" + "+ " + escudoEquipado.getVidaExtra() + " de vida" + "\n" + "+ " + escudoEquipado.getVelocidadExtra()+ " de velocidad";
				datosEscudo.setTextFormat(formatoInventario);
			}			
		}
	}
}