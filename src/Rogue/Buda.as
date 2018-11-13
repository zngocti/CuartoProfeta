package Rogue
{
	public class Buda extends Enemigo
	{
		public function Buda()
		{
			vidaMaxBase = 100 + (50 * Juego.getNivel() - 1);
			vidaMax = vidaMaxBase;
			vida = vidaMax;
			
			ataqueBase = 5 + (5 * (Juego.getNivel() - 1));;
			ataqueTotal = ataqueBase;
			
			for(var i:int = 0; i < maxPoolAtaques; i++)
			{
				poolAtaques[i] = new Blood();
			}
			
			imagen = new Recursos.budaAzulClass();
			imagen.x = -(imagen.width/2);
			imagen.y = -(imagen.height/2);
			
			addChild(imagen);
			velocidad = 0;
		}
		
		public override function activarEscudo():void
		{
			//el buda no tiene escudo
			escudoActivado = false;
		}
	}
}