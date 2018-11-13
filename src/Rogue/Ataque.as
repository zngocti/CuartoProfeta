package Rogue
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Ataque extends Proyectil
	{		
		public function Ataque(num:int = 0, pX:int = 100, pY:int = 100)
		{
			velocidad = 12;
			imagen = new Recursos.ataqueNormalClass();
			addChild(imagen);
			imagen.x = - width/2;
			imagen.y = - height/2;
			switch(num)
			{
				case 1:
					rotation = 270;
					x = pX + 16;
					y = pY - 8;
					break;
				case 2:
					x = pX + 40;
					y = pY + 16;
					break;
				case 3:
					rotation = 90;
					x = pX + 16;
					y = pY + 40;
					break;
				case 4:
					rotation = 180;
					x = pX - 8;
					y = pY + 16;
					break;
			}
			direccion = num;
		}
	}
}