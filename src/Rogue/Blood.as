package Rogue
{
	public class Blood extends Proyectil
	{
		public function Blood(num:int = 0, pX:int = 100, pY:int = 100)
		{
			//el proyectil del ojo
			velocidad = 12;
			imagen = new Recursos.sangreClass();
			imagen.scaleX = 0.25;
			imagen.scaleY = 0.25;
			addChild(imagen);
			imagen.x = - width/2;
			imagen.y = - height/2;
			switch(num)
			{
				case 1:
					x = pX - (width/2);
					y = pY - height;
					break;
				case 2:
					rotation = 90;
					x = pX + width;
					y = pY - (height/2);
					break;
				case 3:
					rotation = 180;
					x = pX + (width/2);
					y = pY + height;
					break;
				case 4:
					rotation = 270;
					x = pX - width;
					y = pY + (height/2);
					break;
			}
			direccion = num;
		}
	}
}