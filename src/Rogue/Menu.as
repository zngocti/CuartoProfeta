package Rogue
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.ui.Mouse;
	import flash.utils.Timer;

	public class Menu extends Sprite
	{		
		private var fondoMenu:Bitmap = new Recursos.menuBackClass();
		private var fondoMenu2:Bitmap = new Recursos.menuBackClass();
		
		private var titulo:Bitmap = new Recursos.tituloClass();
		
		private var instrucciones:Bitmap = new Recursos.instruccionesClass();
		private var creditos:Bitmap = new Recursos.creditosClass();
		
		private var botonIniciarDown:Bitmap = new Recursos.botonDownIniciarClass();
		private var botonInstruccionesDown:Bitmap = new Recursos.botonDownInstruccionesClass();
		private var botonCreditosDown:Bitmap = new Recursos.botonDownCreditosClass();
		private var botonVolverMenuDown:Bitmap = new Recursos.botonDownVolverMenuClass();
		
		private var botonIniciarOv:Bitmap = new Recursos.botonOverIniciarClass();
		private var botonInstruccionesOv:Bitmap = new Recursos.botonOverInstruccionesClass();
		private var botonCreditosOv:Bitmap = new Recursos.botonOverCreditosClass();
		private var botonVolverMenuOv:Bitmap = new Recursos.botonOverVolverMenuClass();
	
		private var botonIniciarUp:Bitmap = new Recursos.botonUpIniciarClass();
		private var botonInstruccionesUp:Bitmap = new Recursos.botonUpInstruccionesClass();
		private var botonCreditosUp:Bitmap = new Recursos.botonUpCreditosClass();
		private var botonVolverMenuUp:Bitmap = new Recursos.botonUpVolverMenuClass();
		
		private var botonIniciar:SimpleButton = new SimpleButton(botonIniciarUp,botonIniciarOv,botonIniciarDown,botonIniciarDown);
		private var botonInstrucciones:SimpleButton = new SimpleButton(botonInstruccionesUp,botonInstruccionesOv,botonInstruccionesDown,botonInstruccionesDown);
		private var botonCreditos:SimpleButton = new SimpleButton(botonCreditosUp,botonCreditosOv,botonCreditosDown,botonCreditosDown);
		private var botonVolverMenu:SimpleButton = new SimpleButton(botonVolverMenuUp,botonVolverMenuOv,botonVolverMenuDown,botonVolverMenuDown);
		
		private var botonVolverMenu2:SimpleButton = new SimpleButton(botonVolverMenuUp,botonVolverMenuOv,botonVolverMenuDown,botonVolverMenuDown);
		private var botonVolverMenu3:SimpleButton = new SimpleButton(botonVolverMenuUp,botonVolverMenuOv,botonVolverMenuDown,botonVolverMenuDown);
		
		private var musica:Sound = new Recursos.musicaClass();
		private var musicaTimer:Timer = new Timer(100,1);
		private var channel:SoundChannel = new SoundChannel();
		
		private var jugando:Boolean = false;
		private var juego:Juego = new Juego();
		private var sonidoGameOver:Sound = new Recursos.gameOverSonidoClass();
		
		private var imagenGO:Bitmap = new Recursos.gameOverImagenClass();
		
		private var btn1:Bitmap = new Recursos.botonUpVolverMenuClass();
		private var btn2:Bitmap = new Recursos.botonUpVolverMenuClass();
		
		public function Menu()
		{
			addChild(fondoMenu);
			addChild(titulo);
			
			botonIniciar.x = 40;
			botonIniciar.y = 390;
			
			botonInstrucciones.x = 120;
			botonInstrucciones.y = 480;

			botonCreditos.x = 180;
			botonCreditos.y = 570;
			
			addChild(botonIniciar);
			addChild(botonInstrucciones);
			addChild(botonCreditos);
			
			botonIniciar.addEventListener(MouseEvent.CLICK, iniciarActivado);
			botonInstrucciones.addEventListener(MouseEvent.CLICK, instruccionesActivado);
			botonCreditos.addEventListener(MouseEvent.CLICK, creditosActivado);	
			
			musica.addEventListener(Event.COMPLETE, loopMusica);
			musicaTimer.addEventListener(TimerEvent.TIMER_COMPLETE, pausaMusica);
			musicaTimer.start();
			
			addEventListener(Event.ENTER_FRAME, jugadorVive)
		}
		
		private function jugadorVive(event:Event) : void //este metodo es el que me muestra el game over y pone el boton para volver al menu
		{
			if(jugando == true)
			{
				if(juego.getJugando() == false)
				{				
					jugando = false;
					sonidoGameOver.play();
					addChild(imagenGO);
					imagenGO.x = 336 - (imagenGO.width)/2;
					imagenGO.y = 336 - (imagenGO.height)/2;
					addChild(btn2);
					btn2.x = 336 - (btn2.width/2);
					btn2.y = 336 + (imagenGO.height/2) - (btn2.height/2);
					addChild(botonVolverMenu);
					botonVolverMenu.addEventListener(MouseEvent.CLICK, volverAlMenu);
					botonVolverMenu.x = 336 - 139;
					botonVolverMenu.y = 336 + (imagenGO.height/2) - 25;
				}
			}
		}
		
		private function loopMusica(event:Event) : void
		{
			musicaTimer.start();
		}
		
		private function pausaMusica(event:TimerEvent) : void
		{
			musicaTimer.reset();
			channel = musica.play();
			channel.addEventListener(Event.SOUND_COMPLETE,loopMusica);
		}
		
		private function iniciarActivado(event:MouseEvent):void //iniciar el juego
		{
			juego = new Juego();
			addChild(juego);
			juego.iniciarJuego();
			jugando = true;
		}
		
		private function instruccionesActivado(event:MouseEvent):void //ir a las instrucciones
		{
			botonIniciar.removeEventListener(MouseEvent.CLICK, iniciarActivado);
			botonInstrucciones.removeEventListener(MouseEvent.CLICK, instruccionesActivado);
			botonCreditos.removeEventListener(MouseEvent.CLICK, creditosActivado);
			removeChild(botonIniciar);
			removeChild(botonInstrucciones);
			removeChild(botonCreditos);
			
			addChild(fondoMenu2);
			addChild(instrucciones);
			instrucciones.x = (width/2) - (instrucciones.width/2);
			instrucciones.y = (height/2) - (instrucciones.height/2) - (botonVolverMenu2.height/2)- 50;
			addChild(btn1);
			btn1.x = 800;
			btn1.y = 550;
			addChild(botonVolverMenu2);
			botonVolverMenu2.x = 800;
			botonVolverMenu2.y = 550;
			
			botonVolverMenu2.addEventListener(MouseEvent.CLICK, volverAlMenuIns);
		}
		
		private function creditosActivado(event:MouseEvent):void //ir a los creditos
		{
			botonIniciar.removeEventListener(MouseEvent.CLICK, iniciarActivado);
			botonInstrucciones.removeEventListener(MouseEvent.CLICK, instruccionesActivado);
			botonCreditos.removeEventListener(MouseEvent.CLICK, creditosActivado);
			removeChild(botonIniciar);
			removeChild(botonInstrucciones);
			removeChild(botonCreditos);
			
			addChild(fondoMenu2);
			addChild(creditos);
			creditos.x = (width/2) - (creditos.width/2) - 30;
			creditos.y = (height/2) - (creditos.height/2) - 50;
			addChild(btn1);
			btn1.x = 800;
			btn1.y = 550;
			addChild(botonVolverMenu3);
			botonVolverMenu3.x = 800;
			botonVolverMenu3.y = 550;
			
			
			botonVolverMenu3.addEventListener(MouseEvent.CLICK, volverAlMenuCreditos);
		}
		
		private function volverAlMenuCreditos(event:MouseEvent) : void //volver al menu desde los creditos
		{
			removeChild(fondoMenu2);
			removeChild(creditos);
			botonVolverMenu3.removeEventListener(MouseEvent.CLICK, volverAlMenuCreditos);
			removeChild(botonVolverMenu3);
			removeChild(btn1);
			
			addChild(botonIniciar);
			addChild(botonInstrucciones);
			addChild(botonCreditos);
			botonIniciar.addEventListener(MouseEvent.CLICK, iniciarActivado);
			botonInstrucciones.addEventListener(MouseEvent.CLICK, instruccionesActivado);
			botonCreditos.addEventListener(MouseEvent.CLICK, creditosActivado);
		}
		
		private function volverAlMenuIns(event:MouseEvent) : void //volver al menu desde las instrucciones
		{
			removeChild(fondoMenu2);
			removeChild(instrucciones);
			botonVolverMenu2.removeEventListener(MouseEvent.CLICK, volverAlMenuIns);
			removeChild(botonVolverMenu2);
			removeChild(btn1);
			
			addChild(botonIniciar);
			addChild(botonInstrucciones);
			addChild(botonCreditos);
			botonIniciar.addEventListener(MouseEvent.CLICK, iniciarActivado);
			botonInstrucciones.addEventListener(MouseEvent.CLICK, instruccionesActivado);
			botonCreditos.addEventListener(MouseEvent.CLICK, creditosActivado);
		}
		
		private function volverAlMenu(event:MouseEvent) : void //este es el metodo que remueve el juego y todo lo demas cuando se apreta el boton que aparece con el game over
		{
			if(contains(juego))
			{
				removeChild(juego);
				removeChild(imagenGO);
				removeChild(btn2);
				botonVolverMenu.removeEventListener(MouseEvent.CLICK, volverAlMenu);
				removeChild(botonVolverMenu);
			}
		}
	}
}