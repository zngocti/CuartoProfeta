package Rogue
{
	import flash.display.Bitmap;

	public class Escudo extends Items
	{
		//esto es igual que en el caso del arma
		//la unica diferencia es que el nombre principal no cambia nunca porque todos son escudos
		private var n1:String = "";
		private var n2:String = "";
		private var nMedio:String = " Escudo ";
		private var n3:String = "";
		private var n4:String = "";
		
		private var vidaExtra:int = 0;
		private var velocidadExtra:int = 0;
		
		private var numeroRandom:int = 0;
		private const masUno:int = 1;
		
		private var imagen:Bitmap = new Bitmap();
		
		public function Escudo()
		{
			numeroRandom = Math.random() * 100 + masUno;
			//teniendo 4 instancias de forja y solo 3 variaciones posibles en cada una hay 81 escudos diferentes
			//esto sin contar los que no fueron forjados tantas veces
			//en ese caso serian 120 escudos totales OOOO: !
			//con mas tiempo hubiera explotado mucho mas esta parte, es mi favorita
			//pero necesitaba tener algo con jugabilidad
			
			if(numeroRandom < 40)
			{
				forja(1);
				precio = 200;
			}
			else if (numeroRandom < 70)
			{
				forja(1);
				forja(2);
				precio = 500;
			}
			else if (numeroRandom < 90)
			{
				forja(1);
				forja(2);
				forja(3);
				precio = 1500;
			}
			else
			{
				forja(1);
				forja(2);
				forja(3);
				forja(4);
				precio = 5000;
			}
			nombre = n1 + n2 + nMedio + n3 + n4;
		}
		
		private function forja(num:int) : void
		{
			//la forja va agregando stats y partes del nombre en distintos lugares segun el numero ingresado
			//un escudo de mayor calidad se pasa por el metodo forja varias veces con distinto numero
			//para que quede un resultado completo con un nombre entero
			numeroRandom = Math.random() * 3;
			switch(num)
			{
				case 1:
					switch(numeroRandom)
					{
						case 0:
							imagen = new Recursos.S1AClass();
							n3 = "del Campeon ";
							vidaExtra = vidaExtra + 5;
							addChild(imagen);
							break;
						case 1:
							imagen = new Recursos.S1BClass();
							n3 = "del Heroe ";
							vidaExtra = vidaExtra + 7;
							addChild(imagen);
							break;
						case 2:
							imagen = new Recursos.S1CClass();
							n3 = "del Ladron ";
							vidaExtra = vidaExtra + 3;
							addChild(imagen);
							break;
					}
					break;
				case 2:
					switch(numeroRandom)
					{
						case 0:
							removeChild(imagen);
							imagen = new Recursos.S2AClass();
							n2 = " Gran";
							vidaExtra = vidaExtra + Juego.getNivel();
							addChild(imagen);
							break;
						case 1:
							removeChild(imagen);
							imagen = new Recursos.S2BClass();
							n2 = " Confiable";
							vidaExtra = vidaExtra + Juego.getNivel()*2;
							addChild(imagen);
							break;
						case 2:
							removeChild(imagen);
							imagen = new Recursos.S2CClass();
							n2 = " Resistente";
							vidaExtra = vidaExtra + Juego.getNivel() + 8;
							addChild(imagen);
							break;
					}
					break;
				case 3:
					switch(numeroRandom)
					{
						case 0:
							removeChild(imagen);
							imagen = new Recursos.S3AClass();
							n1 = "La Muralla,";
							vidaExtra = vidaExtra + 5 * Juego.getNivel();
							addChild(imagen);
							break;
						case 1:
							removeChild(imagen);
							imagen = new Recursos.S3BClass();
							n1 = "Bastion,";
							vidaExtra = vidaExtra + 7 * Juego.getNivel();
							addChild(imagen);
							break;
						case 2:
							removeChild(imagen);
							imagen = new Recursos.S3CClass();
							n1 = "Titan,";
							vidaExtra = vidaExtra + 15* Juego.getNivel();
							addChild(imagen);
							break;
					}
					break;
				case 4:
					switch(numeroRandom)
					{
						case 0:
							removeChild(imagen);
							imagen = new Recursos.S4AClass();
							n4 = "Olvidado";
							vidaExtra = vidaExtra + 400;
							addChild(imagen);
							break;
						case 1:
							removeChild(imagen);
							imagen = new Recursos.S4BClass();
							n4 = "Inmortal";
							vidaExtra = vidaExtra + 50 * Juego.getNivel();
							velocidadExtra = velocidadExtra + 2;
							addChild(imagen);
							break;
						case 2:
							removeChild(imagen);
							n4 = "Atormentado";
							imagen = new Recursos.S4CClass();
							vidaExtra = vidaExtra + 100;
							velocidadExtra = velocidadExtra + 1;
							addChild(imagen);
							break;
					}
					break;
			}
			imagen.x = -width/2;
			imagen.y = -width/2;
		}
		
		public function getVidaExtra() : int
		{
			return vidaExtra;
		}
		
		public function getVelocidadExtra() : int
		{
			return velocidadExtra;
		}
		
		public function getImagen() : Bitmap
		{
			return imagen;
		}
		
		public function vaciarEscudo() : void
		{
			//esto borra todo dato del escudo para crear un escudo vacio
			vidaExtra = 0;
			velocidadExtra = 0;
			imagen.alpha = 0;
			n1 = "";
			n2 = "";
			n3 = "";
			n4 = "";
			nMedio = "";
			nombre = "";
		}
	}
}