package Rogue
{
	import Rogue.Recursos;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.ui.Keyboard;

	public class Shop extends Sprite
	{
		private var imagen:Bitmap = new Recursos.perroClass();

		private var producto1:Producto = new Producto(1);
		private var producto2:Producto = new Producto(2);
		private var producto3:Producto = new Producto(3);
		private var producto4:Producto = new Producto(4);
		private var disponible1:Boolean = true;
		private var disponible2:Boolean = true;
		private var disponible3:Boolean = true;
		private var sonido:Sound = new Recursos.coinSonidoClass();
		
		public function Shop()
		{
			//el shop tiene una imagen y 4 productos
			//de los cuales uno es un producto vacio con palabras dando indicaciones
			addChild(imagen);
			imagen.x = 304;
			imagen.y = 304;
			
			producto1.x = 64;
			producto1.y = 64;
			addChild(producto1);
			
			producto2.x = 416;
			producto2.y = 64;
			addChild(producto2);
			
			producto3.x = 64;
			producto3.y = 416;
			addChild(producto3);
			
			producto4.x = 416;
			producto4.y = 416;
			addChild(producto4);
		}
		
		public function compra(jugador:Jugador, num:int) : void
		{
			if (num == 1 && disponible1 == true && Juego.getOro() >= producto1.getPocion().getPrecio())
			{
				//el primer productio es una pocion, aca se maneja su compra
				//si el jugador tiene oro y la pocion esta disponible enonces puede comprarla con el boton 1
				sonido.play(); //sonido al comprar
				disponible1 = false; //el producto deja de estar disponible
				jugador.sumarVida(producto1.getPocion().getCuracion()); //es de uso instantaneo por lo que al comprarla el jugador se cura
				Juego.setOro(Juego.getOro() - producto1.getPocion().getPrecio()); //se resta el oro
				producto1.cleanProducto(); //se borran los datos del producto para que desaparezca de la pantalla
			}
				
			else if (num == 2 && disponible2 == true && Juego.getOro() >= producto3.getArmaVenta().getPrecio())
			{
				//el producto comprado con el boton 2 es un arma
				sonido.play();
				disponible2 = false
				jugador.setArma(producto3.getArmaVenta()); //al comprar el arma el jugador se la pone reemplazando cualquier arma previa
				Juego.setOro(Juego.getOro() - producto3.getArmaVenta().getPrecio());;
				producto3.cleanProducto();
			}
				
			else if (num == 3 && disponible3 == true && Juego.getOro() >= producto4.getEscudoVenta().getPrecio())
			{
				//el boton 3 es un escudo
				sonido.play();
				disponible3 = false;
				jugador.setEscudo(producto4.getEscudoVenta()); //lo mismo que el arma, pero con el escudo
				Juego.setOro(Juego.getOro() - producto4.getEscudoVenta().getPrecio());
				producto4.cleanProducto();
			}
		}
	}
}