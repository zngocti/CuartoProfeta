package Rogue
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Torreta extends Enemigo
	{
		public function Torreta()
		{
			//se inicia el pool de ataques
			for(var i:int = 0; i < maxPoolAtaques; i++)
			{
				poolAtaques[i] = new Fireball();
			}
			
			ataqueCD = new Timer(2500, 1); //tiempo muerto sin atacar
			ataqueCD.addEventListener(TimerEvent.TIMER_COMPLETE, finCD);
			
			vidaMaxBase = 100 + (20 * (Juego.getNivel() - 1));
			vidaMax = vidaMaxBase;
			vida = vidaMax;
			
			ataqueBase = 10 + (5 * (Juego.getNivel() - 1));
			ataqueTotal = ataqueBase;
			
			imagen = new Recursos.torretaFClass();
			imagen.x = -(imagen.width/2);
			imagen.y = -(imagen.height/2);
			
			addChild(imagen);
			velocidad = 0;
			
			escudo.graphics.beginFill(0xA9D3AE);
			escudo.graphics.drawCircle(0,0,25);
			escudo.graphics.endFill();
			addChild(escudo);
			escudo.x = - 0;
			escudo.y = - 0;
			escudo.alpha = 0;
		}
		
		public override function atacar(cuarto:Cuarto):void
		{
			if (ataqueDisponible == true && estaVivo == true)
			{
				ataqueDisponible = false;
				iniciarCDAtaque();
				for(var i:int = 0; i < Entidad.maxPoolAtaques ; i++)
				{
					if((cuarto.contains(poolAtaques[i])) == false)
					{
						poolAtaques[i] = new Fireball(x,y,Juego.getJugadorX(),Juego.getJugadorY());
						cuarto.addChild(poolAtaques[i]);
						i = Entidad.maxPoolAtaques;
					}
				}
			}
		}
	}
}