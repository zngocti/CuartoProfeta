package Rogue
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Producto extends Sprite
	{
		private var texto:TextField = new TextField();
		private var miFormato:TextFormat = new TextFormat();
		private var pocionVenta:Pocion = new Pocion();
		private var escudoVenta:Escudo = new Escudo();
		private var armaVenta:Arma = new Arma();
		
		//los productos genericos tienen ademas de texto, pocion, escudo y arma
		//pero al crearse solo se usa uno de estos
		//este sistema, como todo lo relacionado al shop y los items lo hice al final
		//por lo que no esta hecho de la mejor forma
		
		public function Producto(num:int)
		{
			switch(num)
			{
				case 1:
					texto.text = pocionVenta.getNombre() + ": cura " + pocionVenta.getCuracion() + " al comprarse." + "\n" + "\n" + "Precio: " + pocionVenta.getPrecio() + " Apreta 1.";
					addChild(pocionVenta);
					pocionVenta.x = 272;
					pocionVenta.y = 96;
					pocionVenta.scaleX = 1.5;
					pocionVenta.scaleY = 1.5;
					break;
				case 2:
					//el lugar 2 es el que tiene el texto del shop
					texto.text = "Apreta 1, 2 o 3 para comprar." + "\n" + "\n" + "Comprar un item reemplaza al equipado.";
					break;
				case 3:
					texto.text = armaVenta.getNombre() + "\n" + "\n" + "+ " + armaVenta.getAtaqueExtra() + " de ataque" + "\n" + armaVenta.getRecuperacionVida() + " recuperacion de vida por golpe" + "\n" + "\n" + "Precio: " + armaVenta.getPrecio() + " Apreta 2.";
					addChild(armaVenta);
					armaVenta.x = 96;
					armaVenta.y = -80;
					armaVenta.scaleX = 1.5;
					armaVenta.scaleY = 1.5;
					break;
				case 4:
					texto.text = escudoVenta.getNombre() + "\n" + "\n" + "+ " + escudoVenta.getVidaExtra() + " de vida" + "\n" + "+ " + escudoVenta.getVelocidadExtra()+ " de velocidad" + "\n" + "\n" + "Precio: " + escudoVenta.getPrecio() + " Apreta 3.";
					addChild(escudoVenta);
					escudoVenta.x = 96;
					escudoVenta.y = -80;
					escudoVenta.scaleX = 1.5;
					escudoVenta.scaleY = 1.5;
					break;
			}
			
			miFormato.size = 16;
			miFormato.bold = true;
			miFormato.leftMargin = 10;
			
			texto.width = 192;
			texto.height = 192;
			texto.wordWrap = true;
			texto.border = true;
			texto.borderColor = (0x000000);
			texto.background = true;
			texto.backgroundColor = (0xBAAAAA);
			texto.x = 0;
			texto.y = 5;
			texto.setTextFormat(miFormato);
			addChild(texto);
		}
		
		public function getPocion() : Pocion
		{
			return pocionVenta;
		}
		
		public function getArmaVenta() : Arma
		{
			return armaVenta;
		}
		public function getEscudoVenta() : Escudo
		{
			return escudoVenta;
		}
		
		public function cleanProducto() : void
		{
			//este metodo limpia el producto para que en el shop no se muestren los datos de un producto comprado
			texto.text = "";
			if(contains(pocionVenta))
			{
				removeChild(pocionVenta);
			}
			if(contains(escudoVenta))
			{
				removeChild(escudoVenta);
			}
			if(contains(armaVenta))
			{
				removeChild(armaVenta);
			}
		}
	}
}