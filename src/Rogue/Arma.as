package Rogue
{
	import flash.display.Bitmap;

	public class Arma extends Items
	{
		private var n1:String = "";
		private var n2:String = "";
		private var nMedio:String = " Arma ";
		private var n3:String = "";
		private var n4:String = "";
		
		private var ataqueExtra:int = 0;
		private var recuperacionVida:int = 0;
		
		private var numeroRandom:int = 0;
		private const masUno:int = 1;
		
		private var imagen:Bitmap = new Bitmap();
		
		//las armas tienen un generador random para su calidad basado MUY PRECARIAMENTE en el sistema del diablo 2
		//mientras mas poderosa es el arma mas partes se le pegan al nombre
		
		public function Arma()
		{
			numeroRandom = Math.random() * 100 + masUno;
			//el numero random define la calidad y rareza del arma
			
			if(numeroRandom < 40)
			{
				//mientras mas rara es mas veces se usa el metodo forja
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
				precio = 1500; //el precio cambia segun su rareza
			}
			else
			{
				forja(1);
				forja(2);
				forja(3);
				forja(4); //cada numero de forja indica un lugar del nombre en el arma final
				precio = 5000;
			}
			nombre = n1 + n2 + nMedio + n3 + n4; //aca se usa la suma de partes para crear el nombre final
		}
		
		private function forja(num:int) : void
		{
			numeroRandom = Math.random() * 3;
			//cada parte del arma tiene 3 posibilidades
			switch(num)
			{
				case 1:
					switch(numeroRandom)
					{
						case 0:
							imagen = new Recursos.A1AClass();
							//cada uno de los caso le cambia la imagen al arma para que si esta es la ultima forja ya tenga una imagen preparada
							nMedio = " Mazo "; //este es el nombre del medio, el tipo de arma que es
							n3 = "del Bruto "; //este es uno de los modificadores
							ataqueExtra = ataqueExtra + 6; //esto es lo que hace efectivamente en las stats
							addChild(imagen);
							break;
						case 1:
							imagen = new Recursos.A1BClass();
							nMedio = " Lanza ";
							n3 = "del Valiente ";
							ataqueExtra = ataqueExtra + 7;
							addChild(imagen);
							break;
						case 2:
							imagen = new Recursos.A1CClass();
							nMedio = " Espada ";
							n3 = "del Guardian ";
							ataqueExtra = ataqueExtra + 3;
							addChild(imagen);
							break;
					}
					break;
				case 2:
					switch(numeroRandom)
					{
						case 0:
							removeChild(imagen);
							imagen = new Recursos.A2AClass(); //la segunda vez que pasa por la forja su imagen vuelve a cambiar
							nMedio = " Hacha "; //lo mismo su nombre principal
							n2 = " Impecable";
							ataqueExtra = ataqueExtra + 3 + Juego.getNivel(); //y aca los stats se van sumando a lo que habia
							addChild(imagen);
							break;
						case 1:
							removeChild(imagen);
							imagen = new Recursos.A2BClass();
							nMedio = " Espada ";
							n2 = " Noble";
							ataqueExtra = ataqueExtra + Juego.getNivel()*2;
							addChild(imagen);
							break;
						case 2:
							removeChild(imagen);
							imagen = new Recursos.A2CClass();
							nMedio = " Espada ";
							n2 = " Brillante";
							ataqueExtra = ataqueExtra + Juego.getNivel() + 8;
							addChild(imagen);
							break;
					}
					break;
				case 3:
					switch(numeroRandom)
					{
						case 0:
							removeChild(imagen);
							imagen = new Recursos.A3AClass();
							nMedio = " Mazo ";
							n1 = "La Justicia,";
							ataqueExtra = ataqueExtra + 7 * Juego.getNivel();
							addChild(imagen);
							break;
						case 1:
							removeChild(imagen);
							imagen = new Recursos.A3BClass();
							nMedio = " Espada ";
							n1 = "Imperio,";
							ataqueExtra = ataqueExtra + 12 * Juego.getNivel();
							addChild(imagen);
							break;
						case 2:
							removeChild(imagen);
							imagen = new Recursos.A3CClass();
							nMedio = " Estrella del Alba ";
							n1 = "El Castigo,";
							ataqueExtra = ataqueExtra + 15* Juego.getNivel();
							addChild(imagen);
							break;
					}
					break;
				case 4:
					switch(numeroRandom)
					{
						case 0:
							removeChild(imagen);
							imagen = new Recursos.A4AClass();
							nMedio = " Hacha ";
							n4 = "Desterrado";
							ataqueExtra = ataqueExtra + 400;
							addChild(imagen);
							break;
						case 1:
							removeChild(imagen);
							imagen = new Recursos.A4BClass();
							nMedio = " Hacha ";
							n4 = "Maldito";
							ataqueExtra = ataqueExtra + 50 * Juego.getNivel();
							recuperacionVida = recuperacionVida + 2;
							addChild(imagen);
							break;
						case 2:
							removeChild(imagen);
							nMedio = " Martillo ";
							n4 = "Hijo de Odin";
							imagen = new Recursos.A4CClass();
							ataqueExtra = ataqueExtra + 200;
							recuperacionVida = recuperacionVida + 4;
							addChild(imagen);
							break;
					}
					break;
			}
			imagen.x = -width/2;
			imagen.y = -width/2;
		}
		
		public function getAtaqueExtra() : int
		{
			return ataqueExtra;
		}
		
		public function getRecuperacionVida() : int
		{
			return recuperacionVida;
		}
		
		public function getImagen() : Bitmap
		{
			return imagen;
		}
		
		public function vaciarArma() : void
		{
			//esto borra todo dato del arma para crear un arma vacia
			ataqueExtra = 0;
			recuperacionVida = 0;
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