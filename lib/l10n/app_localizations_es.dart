// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Avoid Things Todo';

  @override
  String get appTagline => 'Mantente productivo evitando lo que te frena.';

  @override
  String get language => 'Idioma';

  @override
  String get addThingToAvoid => 'Agregar algo que evitar';

  @override
  String get whatToAvoid => 'Que necesitas evitar?';

  @override
  String get category => 'Categoria';

  @override
  String get priority => 'Prioridad';

  @override
  String get addToAvoidList => 'Anadir a la lista de evitacion';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get editItem => 'Editar elemento';

  @override
  String get search => 'Buscar';

  @override
  String get noItemsYet => 'Aun no hay cosas que evitar';

  @override
  String get archive => 'Archivo';

  @override
  String get statistics => 'Estadisticas';

  @override
  String get menu => 'Menú';

  @override
  String get about => 'Acerca de';

  @override
  String get aboutDescription =>
      'No vuelvas a olvidar lo que necesitas evitar.';

  @override
  String get close => 'Cerrar';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get noArchivedItems => 'Aun no hay elementos archivados';

  @override
  String get avoidedOn => 'Evitado el';

  @override
  String get restore => 'Restaurar';

  @override
  String get deletePermanently => 'Eliminar permanentemente';

  @override
  String get deleteConfirmation =>
      'Esta accion no se puede deshacer. Estas seguro?';

  @override
  String get delete => 'Eliminar';

  @override
  String get weeklyActivity => 'Actividad semanal';

  @override
  String get byCategory => 'Por categoria';

  @override
  String get mostAvoided => 'Mas evitado';

  @override
  String get times => 'veces';

  @override
  String get avoided => 'Evitado';

  @override
  String get active => 'Activo';

  @override
  String get keepGoing => 'Sigue asi!';

  @override
  String avoidedThisWeek(int count) {
    return '$count evitados esta semana';
  }

  @override
  String get goalsTitle => 'Objetivos';

  @override
  String get yourGoal => 'Tu objetivo';

  @override
  String get addGoal => 'Agregar objetivo';

  @override
  String get addAGoal => 'Agregar un objetivo';

  @override
  String get tapToAddGoal => 'Toca para agregar un objetivo';

  @override
  String get goalTypeStreak => 'Racha';

  @override
  String get goalTypeMonthlySavings => 'Ahorro mensual';

  @override
  String get goalHabit => 'Habito';

  @override
  String get goalTargetStreakDays => 'Racha objetivo (dias)';

  @override
  String get goalTargetSavings => 'Ahorro objetivo (\$)';

  @override
  String get createGoal => 'Crear objetivo';

  @override
  String get swipeToAvoid => 'Desliza a la derecha para marcar como evitado';

  @override
  String get itemRestored => 'Elemento restaurado a la lista activa';

  @override
  String get itemAvoided => 'evitado!';

  @override
  String get undo => 'Deshacer';

  @override
  String get health => 'Salud';

  @override
  String get productivity => 'Productividad';

  @override
  String get social => 'Social';

  @override
  String get other => 'Otro';

  @override
  String get high => 'Alta';

  @override
  String get medium => 'Media';

  @override
  String get low => 'Baja';

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get followDeviceLanguage => 'Seguir el idioma del dispositivo';

  @override
  String get spanish => 'Español';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Portugués';

  @override
  String get german => 'Alemán';

  @override
  String get avoidedLabel => 'Evitado!';

  @override
  String get totalAvoided => 'Total evitado';

  @override
  String get byPriority => 'Por prioridad';

  @override
  String get moneySaved => 'Dinero ahorrado';

  @override
  String get tags => 'Etiquetas';

  @override
  String get newTag => 'Nueva etiqueta';

  @override
  String get tagName => 'Nombre de la etiqueta';

  @override
  String get create => 'Crear';

  @override
  String get relapseTrigger => 'Desencadenante de recaida';

  @override
  String get triggerNote => 'Nota del desencadenante';

  @override
  String get badges => 'Insignias y logros';

  @override
  String get badge24hTitle => 'Libertad de 24 h';

  @override
  String get badge24hDesc => 'Te mantuviste firme durante 24 horas';

  @override
  String get badge7dTitle => 'Guerrero de 7 días';

  @override
  String get badge7dDesc => 'Te mantuviste firme durante 7 días';

  @override
  String get badgeBudgetTitle => 'Ahorrador inteligente';

  @override
  String get badgeBudgetDesc => 'Ahorraste más de \$50';

  @override
  String get badgeMegaTitle => 'Súper ahorrador';

  @override
  String get badgeMegaDesc => 'Ahorraste más de \$200';

  @override
  String get badgeConsistencyTitle => 'Constancia';

  @override
  String get badgeConsistencyDesc => '5+ hábitos activos';

  @override
  String get locked => 'Bloqueado';

  @override
  String get unlocked => 'Desbloqueado';

  @override
  String get byTag => 'Por etiqueta';

  @override
  String get isRecurring => 'Es un habito recurrente?';

  @override
  String get eventDate => 'Fecha del evento';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get estimatedCostLabel => 'Costo estimado por recaida/duracion';

  @override
  String get relapseDialogTitle => 'Oh no! Que lo desencadeno?';

  @override
  String get relapseDialogSubtitle =>
      'Registrar tus desencadenantes te ayuda a evitarlos en el futuro.';

  @override
  String get relapseDialogHint => 'Notas opcionales...';

  @override
  String get confirmRelapse => 'Confirmar recaida';

  @override
  String get relapseSuccess => 'La racha se reinicio. No te rindas!';

  @override
  String get onboardingWelcomeTitle => 'Detén los hábitos que te frenan';

  @override
  String get onboardingWelcomeDesc =>
      'La mayoría de las apps registran lo que DEBES hacer. Avoid registra lo que debes DEJAR de hacer: los hábitos, impulsos y patrones que se interponen en tu camino. Añade lo que quieres dejar, registra cuando recaigas y construye rachas que de verdad importan.';

  @override
  String get onboardingTagsTitle => 'Organízate con etiquetas';

  @override
  String get onboardingTagsDesc =>
      'Agrupa tus hábitos por área de tu vida: Salud, Trabajo, Social. Mira de un vistazo qué parte de tu vida necesita más atención ahora mismo.';

  @override
  String get onboardingMoneyTitle => 'Cada recaída tiene un costo';

  @override
  String get onboardingMoneyDesc =>
      'Define un costo estimado por recaída, por ejemplo una cajetilla de cigarrillos o una comida para llevar. Avoid lo multiplica por tu racha para mostrarte el dinero real que has ahorrado.';

  @override
  String get onboardingRelapseTitle => '¿Recaíste? No pasa nada: regístralo';

  @override
  String get onboardingRelapseDesc =>
      'Toca Recaída para registrar qué te activó. Con el tiempo, Avoid detecta tus patrones para que puedas adelantarte a ellos. Sin juicios, solo conciencia.';

  @override
  String get onboardingBreakGamesTitle => 'Desactiva impulsos con Break Games';

  @override
  String get onboardingBreakGamesDesc =>
      'Cuando aparezca un impulso, toca Break en un avoid activo para lanzar un reinicio rápido de 60 segundos. Estos minijuegos y actividades calmantes están diseñados para interrumpir el piloto automático antes de que ocurra una recaída.';

  @override
  String get onboardingBadgesTitle => 'Consigue recompensas en el camino';

  @override
  String get onboardingBadgesDesc =>
      'Desbloquea insignias por rachas y metas de ahorro. Completa objetivos, gana XP y sube por 100 niveles a medida que tus hábitos se fortalecen.';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Omitir';

  @override
  String get help => 'Ayuda y guia';

  @override
  String get helpTitle => 'Guia de la app y preguntas frecuentes';

  @override
  String get helpWhatIsAvoidTitle => '¿Qué es Avoid?';

  @override
  String get helpWhatIsAvoidDesc =>
      'Avoid te ayuda a romper malos hábitos registrando lo que quieres DEJAR de hacer. Añade un hábito, registra cuando recaigas y anota qué lo desencadenó. Con el tiempo detectarás tus patrones, crearás rachas largas y verás el impacto real, en dinero, ánimo o tiempo, de mantenerte firme.';

  @override
  String get faq1Question => '¿Cómo agrego algo para evitar?';

  @override
  String get faq1Answer =>
      'Toca el botón + en la esquina inferior derecha. Puedes agregar un hábito recurrente, como fumar o comer comida chatarra, un evento único, como no ir a una fiesta, una persona que evitar o incluso una ubicación. Define un costo y un recordatorio opcionales para mantenerte responsable.';

  @override
  String get faq2Question => '¿Qué es una recaída y cómo la registro?';

  @override
  String get faq2Answer =>
      'Una recaída ocurre cuando cedes ante algo que intentas evitar. Toca el botón rojo Recaída en cualquier tarjeta de hábito. Puedes añadir una nota rápida sobre lo que te activó; así construyes tu historial de desencadenantes y detectas patrones con el tiempo.';

  @override
  String get faq3Question => '¿Cómo se calculan las rachas?';

  @override
  String get faq3Answer =>
      'Tu racha cuenta los días desde tu última recaída. En los hábitos recurrentes se reinicia cada vez que recaes. En los eventos únicos sigue contando hasta que archives el elemento.';

  @override
  String get faq4Question =>
      '¿Cómo funciona el seguimiento del dinero, tiempo o ánimo?';

  @override
  String get faq4Answer =>
      'Al añadir un hábito, define un costo estimado por recaída, ya sea en dinero, horas o puntos de ánimo. Avoid lo multiplica por la duración de tu racha para mostrar el total que has ahorrado al mantenerte firme.';

  @override
  String get faq5Question => '¿Qué son los objetivos y cómo los uso?';

  @override
  String get faq5Answer =>
      'Los objetivos te dan una meta concreta, como alcanzar una racha de 7 días con tu hábito más difícil. Todo el mundo recibe un objetivo generado automáticamente según el hábito en el que más recae. Los usuarios Plus también pueden crear objetivos personalizados y seguir metas de ahorro.';

  @override
  String get faq6Question => '¿Cómo funcionan el XP y los niveles?';

  @override
  String get faq6Answer =>
      'Ganas XP evitando recaídas, completando objetivos y haciendo el compromiso diario. Hay 100 niveles con títulos; los usuarios gratis avanzan hasta el nivel 20 y Plus desbloquea los 100.';

  @override
  String get faq7Question => '¿Qué es el Compromiso diario? (Plus)';

  @override
  String get faq7Answer =>
      'Los usuarios Plus ven una pantalla cada mañana para comprometerse con sus hábitos activos. Cada compromiso otorga +20 XP y crea un ritual diario alrededor de tus objetivos.';

  @override
  String get faq8Question =>
      '¿Puedo registrar personas o lugares que quiero evitar?';

  @override
  String get faq8Answer =>
      'Sí. Al añadir un hábito, elige Persona para vincularlo a un contacto de tu teléfono, o Ubicación para fijar un punto en el mapa. Es ideal para evitar personas difíciles o entornos que te disparan.';

  @override
  String get faq9Question => '¿Qué incluye Avoid Plus?';

  @override
  String get faq9Answer =>
      'Plus es una compra única que desbloquea hábitos ilimitados, historial completo de estadísticas y mapa de calor, análisis de patrones de recaída, objetivos personalizados, compromiso diario (+XP), notificaciones inteligentes según patrones, widget para la pantalla de inicio, copia de seguridad en la nube y exportación de datos.';

  @override
  String get faq10Question => '¿Mis datos se guardan en la nube?';

  @override
  String get faq10Answer =>
      'No. Avoid no procesa, recopila ni almacena los datos de tus hábitos en sus propios servidores. Tus datos permanecen en tu dispositivo. Si activas la copia de seguridad en la nube, se guardan en tu propia cuenta de iCloud o Google Drive, no en la nube de Avoid.';

  @override
  String get faq11Question => '¿Qué analíticas recopila Avoid?';

  @override
  String get faq11Answer =>
      'Avoid solo recopila analíticas básicas de uso de la app, como visitas a pantallas y toques en botones principales, para ayudar a mejorar el producto. No envía a analíticas los nombres de tus hábitos, notas de recaídas, nombres de contactos, nombres de ubicaciones ni otro contenido identificable o escrito por el usuario.';

  @override
  String get faq12Question =>
      '¿Qué son los Break Games y cuándo debería usarlos?';

  @override
  String get faq12Answer =>
      'Los Break Games son actividades cortas para interrumpir un impulso que puedes abrir desde el botón Break de un avoid activo. Duran unos 60 segundos y están pensados para distraerte, estabilizarte o redirigirte justo en el momento de riesgo antes de una recaída. Algunos juegos también guardan tus mejores marcas, y Plus o la prueba desbloquean pistas y el control del grupo de juegos aleatorios.';

  @override
  String get coachMarkAddTitle => 'Añade tu primer hábito';

  @override
  String get coachMarkAddDesc =>
      'Toca + para añadir algo que quieras dejar: un hábito recurrente, un evento único, una persona o una ubicación.';

  @override
  String get coachMarkFilterTitle => 'Encuentra tus hábitos rápido';

  @override
  String get coachMarkFilterDesc =>
      'Busca por nombre o toca una etiqueta para filtrar hábitos por categoría.';

  @override
  String get coachMarkStatsTitle => 'Sigue tu progreso';

  @override
  String get coachMarkStatsDesc =>
      'Toca el icono del gráfico para ver tus rachas, historial de ahorro e información sobre tus hábitos.';

  @override
  String get coachMarkMenuTitle => 'Ajustes y más';

  @override
  String get coachMarkMenuDesc =>
      'Abre los ajustes para cambiar el idioma, el tema y acceder a la guía de ayuda o a la sincronización en la nube.';

  @override
  String get resetTutorial => 'Restablecer tutorial';

  @override
  String get tutorialResetSuccess =>
      'Tutorial restablecido. Reinicia la app para ver la guia otra vez.';

  @override
  String get savingsSummary => 'Ahorros por tipo de elemento';

  @override
  String get navHome => 'Inicio';

  @override
  String get historyTitle => 'Historial';

  @override
  String get archivedTab => 'Archivados';

  @override
  String get slipsTab => 'Caídas';

  @override
  String get winsTab => 'Logros';

  @override
  String get addButtonLabel => 'Agregar';

  @override
  String get tapPlusToTrackFirstHabit =>
      'Toca + para registrar tu primer hábito a evitar';

  @override
  String get viewHistory => 'Ver historial';

  @override
  String get costTypeLabel => 'Tipo de costo:';

  @override
  String get costMoney => 'Dinero';

  @override
  String get costMood => 'Animo';

  @override
  String get costTime => 'Tiempo';

  @override
  String get streakLabel => 'Racha';

  @override
  String get slipButton => 'Recaida';

  @override
  String get justNow => 'Ahora mismo';

  @override
  String get sortLatest => 'Mas reciente';

  @override
  String get sortOldest => 'Mas antiguo';

  @override
  String get sortAvoidType => 'Tipo a evitar';

  @override
  String get sortCostType => 'Tipo de costo';

  @override
  String get avoidTypeLabel => 'Tipo a evitar:';

  @override
  String get associatedPerson => 'Persona asociada:';

  @override
  String get avoidLocation => 'Ubicacion a evitar:';

  @override
  String get pickOnMap => 'Elegir en el mapa';

  @override
  String get eventReminderLabel => 'Recordatorio del evento:';

  @override
  String get dailyReminderLabel => 'Hora del recordatorio diario:';

  @override
  String get setReminder => 'Establecer recordatorio';

  @override
  String get setDailyReminder => 'Establecer recordatorio diario';

  @override
  String get selectEventDateError => 'Selecciona una fecha del evento.';

  @override
  String get recentRelapsesTriggers => 'Recaidas recientes y desencadenantes';

  @override
  String get ratingDialogTitle => '¿Te gusta Avoid Todo?';

  @override
  String get ratingDialogSubtitle =>
      'Toca una estrella para valorar tu experiencia';

  @override
  String get ratingDialogNotNow => 'Ahora no';

  @override
  String get ratingDialogContinue => 'Continuar';

  @override
  String get ratingHighTitle => '¡Gracias!';

  @override
  String get ratingHighBody =>
      '¿Te importaría valorarnos? ¡Nos ayuda muchísimo!';

  @override
  String get ratingHighRateNow => 'Valorar ahora';

  @override
  String get ratingHighNoThanks => 'No, gracias';

  @override
  String get ratingLowTitle => 'Ayúdanos a mejorar';

  @override
  String get ratingLowBody => '¿Qué podemos hacer mejor?';

  @override
  String get ratingLowHint => 'Tus comentarios...';

  @override
  String get ratingLowSend => 'Enviar';

  @override
  String get ratingLowSkip => 'Omitir';

  @override
  String get ratingThanks => '¡Gracias por tus comentarios!';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get enableNotifications => 'Activar notificaciones';

  @override
  String get drawerWidget => 'Widget';

  @override
  String get homeScreenWidget => 'Widget de pantalla de inicio';

  @override
  String get homeScreenWidgetDesc =>
      'Muestra tu mejor racha en la pantalla de inicio';

  @override
  String get homeScreenWidgetPlusHint =>
      'El widget de pantalla de inicio es una funcion Plus.';

  @override
  String get addWidgetToHomeScreen => 'Anadir widget a la pantalla de inicio';

  @override
  String get addWidgetInstructions => 'Instrucciones y boton de acceso rapido';

  @override
  String get cloudSync => 'Sincronizacion en la nube';

  @override
  String get cloudSyncDesc =>
      'Copia de seguridad automatica en iCloud / Google Drive';

  @override
  String get cloudSyncPlusHint =>
      'La sincronizacion en la nube es una funcion Plus.';

  @override
  String get manageSync => 'Gestionar sincronizacion';

  @override
  String syncCloudBackupTitle(String cloudName) {
    return 'Copia de seguridad en $cloudName';
  }

  @override
  String get syncNeverSynced => 'Aún no se ha sincronizado.';

  @override
  String get syncLastSynced => 'Última sincronización:';

  @override
  String get syncUploadSuccess => '✓ Copia de seguridad subida correctamente.';

  @override
  String get syncUploadFailed =>
      'La subida falló. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get syncNoBackupFound =>
      'Aún no se encontró ninguna copia de seguridad en la nube. Toca el botón de abajo para crear una.';

  @override
  String get syncBackupFoundTitle => 'Copia de seguridad encontrada';

  @override
  String get syncRestoreWarning =>
      '⚠️ Esto sobrescribirá tus datos actuales con la copia de seguridad de la nube.\n\nSe perderán los cambios realizados desde tu última copia. ¿Seguro que quieres restaurarla?';

  @override
  String get syncUploading => 'Subiendo…';

  @override
  String get syncBackupNow => 'Hacer copia ahora';

  @override
  String get syncChecking => 'Comprobando…';

  @override
  String get syncCheckForBackup => 'Verificar y restaurar';

  @override
  String get syncHowItWorksTitle => 'Cómo funciona';

  @override
  String syncHowItWorksBody(String cloudName) {
    return '• Tus datos se guardan en tu propia cuenta de $cloudName; Avoid nunca los ve.\n• Las copias se hacen automáticamente, como máximo cada 10 minutos, después de acciones importantes.\n• Para restaurar en un dispositivo nuevo: instala Avoid, inicia sesión y toca \"Verificar y restaurar\".';
  }

  @override
  String get syncNotAvailable =>
      'La sincronizacion en la nube no esta disponible en esta plataforma.';

  @override
  String get widgetSetupTitleIos => 'iOS - Anadir widget';

  @override
  String get widgetSetupTitleAndroid => 'Android - Anadir widget';

  @override
  String get widgetColorLabel => 'Color del widget';

  @override
  String get colorForest => 'Bosque';

  @override
  String get colorMidnight => 'Medianoche';

  @override
  String get colorOcean => 'Oceano';

  @override
  String get colorPurple => 'Purpura';

  @override
  String get widgetAddButton => 'Anadir widget a la pantalla de inicio';

  @override
  String get widgetDialogOpened => 'Se abrio el dialogo del widget!';

  @override
  String get widgetLauncherHint => 'Tu lanzador te pedira donde colocarlo.';

  @override
  String get widgetFollowSteps => 'Sigue estos pasos:';

  @override
  String get widgetManualSteps =>
      'Tu lanzador no admite el boton? Pruebalo manualmente:';

  @override
  String get widgetDone => 'Listo';

  @override
  String get widgetIosStep1Title => 'Ve a tu pantalla de inicio';

  @override
  String get widgetIosStep1Desc =>
      'Pulsa Inicio o desliza hacia arriba desde cualquier app.';

  @override
  String get widgetIosStep2Title => 'Mantén pulsada una zona vacía';

  @override
  String get widgetIosStep2Desc =>
      'Mantén pulsado hasta que los iconos empiecen a moverse.';

  @override
  String get widgetIosStep3Title => 'Toca el botón +';

  @override
  String get widgetIosStep3Desc => 'En la esquina superior izquierda.';

  @override
  String get widgetIosStep4Title => 'Busca \"Avoid\"';

  @override
  String get widgetIosStep4Desc => 'Escríbelo en la barra de búsqueda.';

  @override
  String get widgetIosStep5Title => 'Selecciona el widget de Avoid';

  @override
  String get widgetIosStep5Desc =>
      'Tócalo, elige un tamaño y luego toca \"Añadir widget\".';

  @override
  String get widgetIosStep6Title => 'Pulsa Listo';

  @override
  String get widgetIosStep6Desc =>
      'En la esquina superior derecha para terminar.';

  @override
  String get widgetAndroidStep1Title => 'Ve a tu pantalla de inicio';

  @override
  String get widgetAndroidStep1Desc => 'Pulsa el botón Inicio.';

  @override
  String get widgetAndroidStep2Title => 'Mantén pulsada una zona vacía';

  @override
  String get widgetAndroidStep2Desc =>
      'Mantén pulsado un espacio vacío hasta que aparezca el modo de edición.';

  @override
  String get widgetAndroidStep3Title => 'Toca \"Widgets\"';

  @override
  String get widgetAndroidStep3Desc => 'Mira la parte inferior de la pantalla.';

  @override
  String get widgetAndroidStep4Title => 'Busca \"Avoid Todo\"';

  @override
  String get widgetAndroidStep4Desc => 'Desplázate hasta la sección de la A.';

  @override
  String get widgetAndroidStep5Title => 'Mantén pulsado y arrastra';

  @override
  String get widgetAndroidStep5Desc =>
      'Arrastra el widget a cualquier espacio vacío de tu pantalla de inicio.';

  @override
  String get plusUnlockUnlimitedAvoidsHints =>
      'Unlimited avoids, break game hints';

  @override
  String get breakGamesSectionTitle => 'Break Games';

  @override
  String get breakRandomGamePoolTitle => 'Pool aleatorio de juegos';

  @override
  String get breakGamePoolLockedSubtitle =>
      'Inicia una prueba gratis o desbloquea Plus para elegir qué Break Games aparecen al azar.';

  @override
  String get breakKeepAtLeastOneActivityEnabled =>
      'Mantén al menos una actividad de break activada.';

  @override
  String breakActivityEnabledCount(int enabledCount, int totalCount) {
    return '$enabledCount de $totalCount activados';
  }

  @override
  String get breakRandomGamePoolDescription =>
      'Elige qué actividades de break pueden salir al azar.';

  @override
  String get breakActivityDefuseTitle => 'Desactivar';

  @override
  String get breakActivityDefuseSubtitle =>
      'Baja la intensidad desactivando el momento.';

  @override
  String get breakActivityPairMatchTitle => 'Emparejar';

  @override
  String get breakActivityPairMatchSubtitle =>
      'Lleva tu mente a un pequeño reto de memoria.';

  @override
  String get breakActivityCubeResetTitle => 'Reset del cubo';

  @override
  String get breakActivityCubeResetSubtitle =>
      'Gira un pequeño cubo hasta volver a ordenarlo.';

  @override
  String get breakActivityStackSweepTitle => 'Limpia la pila';

  @override
  String get breakActivityStackSweepSubtitle =>
      'Quita las fichas expuestas hasta que la pila desaparezca.';

  @override
  String get breakActivityTriviaPivotTitle => 'Giro de trivia';

  @override
  String get breakActivityTriviaPivotSubtitle =>
      'Dale a tu mente otra cosa para masticar.';

  @override
  String get breakActivityFortuneCookieTitle => 'Galleta de la fortuna';

  @override
  String get breakActivityFortuneCookieSubtitle =>
      'Rompe la galleta y raspa las migas para revelar un pensamiento más sereno.';

  @override
  String get breakActivityZenRoomTitle => 'Sala Zen';

  @override
  String get breakActivityZenRoomSubtitle =>
      'Baja el ritmo de la escena y reinicia el tono.';

  @override
  String breakPersonalBestTime(String value) {
    return 'Mejor: $value';
  }

  @override
  String breakPersonalBestCorrect(int count) {
    return 'Mejor: $count correctas';
  }

  @override
  String get breakExitTitle => '¿Salir de este break?';

  @override
  String get breakExitBody =>
      'Esta sesión se marcará como incompleta. Siempre puedes iniciar otro break enseguida.';

  @override
  String get breakStay => 'Quedarme';

  @override
  String get breakExit => 'Salir';

  @override
  String get breakCustomizationLockedSubtitle =>
      'Inicia una prueba gratis o desbloquea Plus para usar pistas y personalización de Break Games.';

  @override
  String get breakHintStrengthTitle => 'Elegir intensidad de pista';

  @override
  String get breakHintStrengthBody =>
      '¿Quieres solo un resaltado suave o la pista completa con flechas?';

  @override
  String get breakHintStrengthSubtle => 'Un poco de ayuda';

  @override
  String get breakHintStrengthStrong => 'Mucha ayuda';

  @override
  String breakSheetTitle(String item) {
    return 'Break para \"$item\"';
  }

  @override
  String get breakThisItem => 'este elemento';

  @override
  String get breakResume => 'Reanudar';

  @override
  String get breakPause => 'Pausar';

  @override
  String get breakDefuseInstruction =>
      'Estabiliza el dial. Toca bloquear cuando la aguja entre en la zona tranquila.';

  @override
  String get breakDefuseTap => 'Toca';

  @override
  String get breakDefuseCompleteStatus =>
      'Bien. El mecanismo ya está calmado. Sigue respirando hasta que termine el minuto.';

  @override
  String breakDefuseRingsLeft(int count) {
    return 'Quedan $count anillos. Sigue el ritmo.';
  }

  @override
  String get breakDefuseWaitStatus =>
      'Espera a que la aguja cruce la ventana brillante y luego toca.';

  @override
  String get breakHintsLocked => 'Pistas bloqueadas';

  @override
  String get breakHintsOn => 'Pistas activadas';

  @override
  String get breakHintsOff => 'Pistas desactivadas';

  @override
  String get breakHintsSubtle => 'Pistas: un poco';

  @override
  String get breakHintsStrong => 'Pistas: mucho';

  @override
  String get breakPairMatchInstruction =>
      'Encuentra las parejas de emoji. Las pequeñas búsquedas de patrones ayudan mucho a romper el piloto automático.';

  @override
  String breakPairMatchProgress(int matchedCount, int totalCount) {
    return '$matchedCount de $totalCount parejas encontradas';
  }

  @override
  String get breakCubeResetInstruction =>
      'Arrastra para girar el cubo. Desliza las pegatinas visibles para mover capas.';

  @override
  String breakCubeResetProgress(
      int solvedCount, int totalCount, int twistCount) {
    return '$solvedCount de $totalCount caras resueltas en $twistCount giros';
  }

  @override
  String breakStackSweepTilesLeft(int count) {
    return 'Quedan $count fichas';
  }

  @override
  String breakTriviaCorrectInsight(String insight) {
    return 'Correcto. $insight';
  }

  @override
  String breakTriviaIncorrectInsight(String insight) {
    return 'Buen intento. $insight';
  }

  @override
  String get breakNext => 'Siguiente';

  @override
  String get breakFortuneCookieTapStatus => 'Toca la galleta para romperla.';

  @override
  String get breakFortuneCookieTapHint => 'Toca para romper';

  @override
  String get breakFortuneCookieScratchStatus =>
      'Raspa las migas para revelar el mensaje de abajo.';

  @override
  String get breakFortuneCookieRevealStatus =>
      'Bien. Deja que la frase se asiente un momento.';

  @override
  String get breakFortuneCookieFortuneLabel => 'FORTUNA';

  @override
  String get breakZenTapDrop => 'Toca una gota';

  @override
  String get breakZenFooter =>
      'Atrapa una gota cuando quieras una nueva frase. Los toques fallidos no hacen nada a propósito.';

  @override
  String get breakCheckInTitle => 'Revisa';

  @override
  String get breakOutcomeQuestion =>
      '¿Qué cambió después de este break de un minuto?';

  @override
  String get breakReplayActivity => 'Repetir actividad';

  @override
  String get breakContinueActivity => 'Seguir jugando / meditando';

  @override
  String get breakOutcomePassed => 'El impulso pasó';

  @override
  String get breakOutcomeWeaker => 'Impulso más débil';

  @override
  String get breakOutcomeStillStrong => 'Sigue fuerte';

  @override
  String get breakNeedAnotherLayer => '¿Necesitas otra capa?';

  @override
  String get breakTryAnotherBreak => 'Probar otro break';

  @override
  String get breakGoToZenRoom => 'Ir a Sala Zen';

  @override
  String get breakMessageSupport => 'Enviar mensaje al apoyo';

  @override
  String get breakTriviaData =>
      '¿Qué planeta tiene el día más corto?\nTierra\nJúpiter\nMarte\nJúpiter gira tan rápido que su día dura aproximadamente 10 horas.\n%%\n¿Cuántos corazones tiene un pulpo?\nUno\nTres\nDos\nTres. Dos para las branquias y uno para el resto del cuerpo.\n%%\n¿Cuál es el único mamífero que realmente puede volar?\nArdilla voladora\nMurciélago\nPetauro del azúcar\nLos murciélagos son los únicos mamíferos capaces de volar de forma sostenida.\n%%\n¿Qué océano es el más profundo?\nAtlántico\nPacífico\nÍndico\nLa fosa de las Marianas está en el océano Pacífico.\n%%\n¿Cuántos huesos suele tener un adulto humano?\n186\n206\n226\n206 es la cifra habitual después de que algunos huesos se fusionan en la adultez.\n%%\n¿Qué animal es conocido por dormir boca abajo?\nKoala\nMurciélago\nNutria\nLos murciélagos descansan boca abajo para despegar rápidamente.\n%%\n¿Qué gas absorben principalmente las plantas del aire?\nOxígeno\nDióxido de carbono\nHelio\nLas plantas usan dióxido de carbono durante la fotosíntesis.\n%%\n¿Qué instrumento suele tener 88 teclas?\nViolín\nPiano\nFlauta\nUn piano estándar tiene 88 teclas.\n%%\n¿Cuántos lados tiene un hexágono?\n5\n6\n8\nHexa significa seis.\n%%\n¿Qué ave suele asociarse con el envío de mensajes?\nLoro\nPaloma\nBúho\nLas palomas mensajeras se usaban para enviar mensajes a larga distancia.\n%%\n¿Cuál es el órgano más grande del cuerpo humano?\nHígado\nPiel\nPulmones\nLa piel es el órgano más grande del cuerpo.\n%%\n¿Qué pieza de ajedrez se mueve en forma de L?\nAlfil\nCaballo\nTorre\nEl caballo es la única pieza de ajedrez que se mueve en patrón de L.\n%%\n¿Cuántos continentes hay?\n5\n7\n6\nEl modelo más común cuenta siete continentes.\n%%\n¿Qué recolectan las abejas de las flores?\nPiedritas\nNéctar\nSal\nLas abejas recolectan néctar y polen de las flores.\n%%\n¿Qué mes tiene menos días?\nAbril\nFebrero\nNoviembre\nFebrero es el más corto y tiene 28 días en la mayoría de los años.\n%%\n¿En qué deporte se usa un volante?\nTenis\nBádminton\nSquash\nEl bádminton usa un volante en lugar de una pelota.\n%%\n¿Qué color obtienes al mezclar azul y amarillo?\nMorado\nVerde\nNaranja\nEl azul y el amarillo se combinan para formar verde.\n%%\n¿Qué planeta es famoso por sus anillos?\nVenus\nSaturno\nMercurio\nLos anillos de Saturno son su rasgo más reconocible.\n%%\n¿Cuántos minutos hay en dos horas?\n90\n120\n180\nDos horas equivalen a 120 minutos.\n%%\n¿Qué criatura marina tiene ocho brazos?\nCalamar\nPulpo\nEstrella de mar\nLos pulpos tienen ocho brazos; los calamares tienen diez apéndices.\n%%\n¿Cómo se llama el agua congelada?\nVapor\nHielo\nNiebla\nEl hielo es agua en estado sólido.\n%%\n¿Desde qué dirección sale el sol?\nNorte\nEste\nOeste\nEl sol parece salir por el este.\n%%\n¿Qué mamífero pasa la mayor parte de su vida en el océano?\nCamello\nBallena\nZorro\nLas ballenas son mamíferos marinos.\n%%\n¿Qué forma tiene tres lados?\nCírculo\nTriángulo\nRectángulo\nUn triángulo tiene exactamente tres lados.\n%%\n¿Qué fruta seca se convierte en una pasa?\nCiruela\nUva\nCereza\nLas pasas son uvas secas.\n%%\n¿Cuál es la estrella principal en el centro de nuestro sistema solar?\nPolaris\nEl Sol\nSirio\nEl Sol es la estrella alrededor de la cual orbitan nuestros planetas.\n%%\n¿Cuántos días tiene un año bisiesto?\n365\n366\n364\nLos años bisiestos añaden un día a febrero para un total de 366 días.\n%%\n¿Qué animal es conocido por cambiar de color para camuflarse?\nConejo\nCamaleón\nPingüino\nLos camaleones son famosos por cambiar de color.\n%%\n¿Cómo llamas a la roca fundida cuando llega a la superficie?\nMagma\nLava\nCuarzo\nBajo tierra es magma; en la superficie es lava.\n%%\n¿Qué manecilla de un reloj se mueve más rápido?\nManecilla de la hora\nManecilla de los segundos\nManecilla de los minutos\nLa manecilla de los segundos da una vuelta completa cada minuto.\n%%\n¿Qué estación viene después de la primavera en el hemisferio norte?\nInvierno\nVerano\nOtoño\nEl verano sigue a la primavera.\n%%\n¿Cuántas patas tiene una araña?\n6\n8\n10\nLas arañas son arácnidos con ocho patas.\n%%\n¿Qué océano está entre África y Australia?\nOcéano Pacífico\nOcéano Índico\nOcéano Ártico\nEl océano Índico está entre África, Asia y Australia.\n%%\n¿En qué se convierten las orugas?\nLibélulas\nMariposas\nEscarabajos\nMuchas orugas se transforman en mariposas o polillas.\n%%\n¿Qué objeto del hogar indica la temperatura?\nBrújula\nTermómetro\nBalanza\nUn termómetro mide la temperatura.\n%%\n¿Cuántas cuerdas tiene un violín estándar?\n5\n4\n6\nLos violines normalmente tienen cuatro cuerdas.\n%%\n¿Qué planeta está más cerca del Sol?\nMarte\nMercurio\nNeptuno\nMercurio es el planeta más cercano al Sol.\n%%\n¿Cuál es el punto de ebullición del agua al nivel del mar en grados Celsius?\n90\n100\n110\nAl nivel del mar, el agua hierve a 100 °C.\n%%\n¿Qué animal es famoso por construir presas?\nNutria\nCastor\nTopo\nLos castores construyen presas con ramas y barro.\n%%\n¿Cuál es lo opuesto al norte en una brújula?\nEste\nSur\nOeste\nEl sur es lo opuesto al norte.\n%%\n¿Qué forma no tiene esquinas?\nCuadrado\nCírculo\nTriángulo\nLos círculos no tienen esquinas ni bordes.\n%%\n¿Qué planeta es conocido como el planeta rojo?\nVenus\nMarte\nUrano\nMarte parece rojo por el óxido de hierro de su superficie.\n%%\n¿Cuántas horas hay en un día completo?\n12\n24\n36\nUn día completo tiene 24 horas.\n%%\n¿Con qué escribes en una pizarra negra?\nTinta\nTiza\nCrayón\nLa tiza es la herramienta clásica para escribir en una pizarra.\n%%\n¿Qué animal es el más alto en tierra?\nElefante\nJirafa\nCamello\nLas jirafas son los animales terrestres más altos.\n%%\n¿Qué sentido está más ligado a tu nariz?\nGusto\nOlfato\nTacto\nLa nariz se encarga del sentido del olfato.\n%%\n¿Qué utensilio de cocina se usa para voltear panqueques?\nBatidor\nEspátula\nCucharón\nUna espátula se usa comúnmente para voltear panqueques.\n%%\n¿Qué número viene después de 999?\n1001\n1000\n990\nDespués de 999 viene 1000.\n%%\n¿Qué planeta está más lejos del Sol?\nSaturno\nNeptuno\nTierra\nNeptuno es actualmente el planeta reconocido más lejano al Sol.\n%%\n¿Cómo llamas a una palabra que significa lo contrario de otra?\nSinónimo\nAntónimo\nAcrónimo\nUn antónimo es una palabra con significado opuesto.\n%%\n¿Qué metal es líquido a temperatura ambiente?\nHierro\nMercurio\nPlata\nEl mercurio es uno de los pocos metales líquidos a temperatura ambiente.\n%%\n¿Cuál es la sustancia natural más dura de la Tierra?\nOro\nDiamante\nCuarzo\nEl diamante es el material natural más duro.\n%%\n¿Qué tipo de sangre es conocido como donante universal?\nAB positivo\nO negativo\nA positivo\nLa sangre O negativo puede darse en emergencias a la mayoría de las personas.\n%%\n¿Cómo llamas a los animales que están activos por la noche?\nAcuáticos\nNocturnos\nMigratorios\nLos animales nocturnos están más activos durante la noche.\n%%\n¿Qué idioma tiene más hablantes nativos en todo el mundo?\nInglés\nChino mandarín\nEspañol\nEl chino mandarín tiene el mayor número de hablantes nativos.\n%%\n¿Qué país es famoso por el símbolo de la hoja de arce?\nSuecia\nCanadá\nNueva Zelanda\nLa hoja de arce es uno de los símbolos nacionales más conocidos de Canadá.\n%%\n¿Cuál es el ingrediente principal del guacamole?\nPepino\nAguacate\nGuisante\nEl guacamole se hace principalmente con aguacate machacado.\n%%\n¿Qué planeta gira más de lado que los demás?\nTierra\nUrano\nJúpiter\nUrano tiene una inclinación extrema y parece girar de lado.\n%%\n¿Cuántos dientes suele tener un adulto humano, incluyendo las muelas del juicio?\n28\n32\n30\nUna dentadura adulta completa suele tener 32 dientes.\n%%\n¿Qué desierto es el desierto cálido más grande de la Tierra?\nGobi\nSáhara\nMojave\nEl Sáhara es el desierto cálido más grande del mundo.\n%%\n¿Cómo se llama un científico que estudia las rocas?\nBiólogo\nGeólogo\nAstrónomo\nLos geólogos estudian las rocas, los minerales y la estructura de la Tierra.\n%%\n¿Qué órgano bombea sangre por el cuerpo?\nHígado\nCorazón\nRiñón\nEl corazón bombea la sangre por el sistema circulatorio.\n%%\n¿Qué fruta tiene las semillas por fuera?\nArándano\nFresa\nManzana\nLas fresas son inusuales porque tienen las semillas por fuera.\n%%\n¿Cómo se llama el proceso en el que el vapor de agua se vuelve líquido?\nEvaporación\nCondensación\nCongelación\nLa condensación ocurre cuando el vapor de agua se enfría y se convierte en líquido.\n%%\n¿Qué famosa muralla se construyó para proteger el norte de China?\nMuro de Berlín\nGran Muralla\nMuro de Adriano\nLa Gran Muralla China fue construida y ampliada durante siglos.\n%%\n¿Cuántos jugadores tiene un equipo de fútbol en el campo al mismo tiempo?\n9\n11\n10\nUn equipo de fútbol tiene 11 jugadores en el campo, incluido el portero.\n%%\n¿Qué ave no puede volar pero es famosa por vivir en la Antártida?\nGaviota\nPingüino\nHalcón\nLos pingüinos son aves que no vuelan y están muy asociadas con la Antártida.\n%%\n¿Cuánto es 12 multiplicado por 12?\n124\n144\n154\n12 por 12 es 144.\n%%\n¿Qué gas necesitan los humanos para respirar y vivir?\nNitrógeno\nOxígeno\nHidrógeno\nLos humanos dependen del oxígeno para respirar.\n%%\n¿Cuál es el planeta más grande de nuestro sistema solar?\nSaturno\nJúpiter\nNeptuno\nJúpiter es el planeta más grande de nuestro sistema solar.\n%%\n¿En qué parte del cuerpo está el fémur?\nBrazo\nPierna\nCraneo\nEl fémur es el hueso del muslo en la pierna.\n%%\n¿Qué famosa torre está inclinada en Italia?\nTorre Eiffel\nTorre de Pisa\nTorre CN\nLa Torre Inclinada de Pisa es uno de los monumentos más conocidos de Italia.\n%%\n¿Cuántos ceros hay en un millón?\n5\n6\n7\nUn millón se escribe 1.000.000.\n%%\n¿Qué animal marino es conocido por tener caparazón y moverse lentamente en tierra?\nFoca\nTortuga\nDelfín\nLas tortugas marinas tienen caparazón y se mueven lentamente en tierra.\n%%\n¿Cómo se llama la parte coloreada del ojo?\nRetina\nIris\nPupila\nEl iris es el anillo coloreado alrededor de la pupila.\n%%\n¿Qué instrumento se usa para mirar estrellas y planetas?\nMicroscopio\nTelescopio\nPeriscopio\nUn telescopio está diseñado para ver objetos lejanos en el espacio.\n%%\n¿Qué festividad es conocida por las calabazas y los disfraces?\nPascua\nHalloween\nSan Valentín\nHalloween se asocia con disfraces, dulces y calabazas.\n%%\n¿Cuánto es 100 dividido por 4?\n20\n25\n40\n100 dividido por 4 es 25.\n%%\n¿Qué animal es conocido como el rey de la selva?\nTigre\nLeón\nLobo\nAl león se le suele llamar el rey de la selva.\n%%\n¿Qué atraen los imanes?\nMadera\nHierro\nPlástico\nLos imanes atraen fuertemente el hierro y algunos otros metales.\n%%\n¿Qué día viene después del viernes?\nJueves\nSábado\nDomingo\nDespués del viernes viene el sábado.\n%%\n¿Cuál es la montaña más alta sobre el nivel del mar?\nK2\nMonte Everest\nKilimanjaro\nEl monte Everest es la montaña más alta sobre el nivel del mar.\n%%\n¿Qué insecto brilla en la oscuridad?\nHormiga\nLuciérnaga\nSaltamontes\nLas luciérnagas producen luz mediante bioluminiscencia.\n%%\n¿Cuántos meses tiene un año?\n10\n12\n14\nUn año estándar tiene 12 meses.\n%%\n¿Qué herramienta se usa para cortar papel en manualidades?\nCuchara\nTijeras\nPincel\nLas tijeras se usan comúnmente para cortar papel.\n%%\n¿Qué planeta es conocido por tener una gran tormenta roja?\nMarte\nJúpiter\nVenus\nLa Gran Mancha Roja de Júpiter es una tormenta enorme y duradera.\n%%\n¿Cuál es la función principal de las raíces en una planta?\nHacer cantar a las flores\nAbsorber agua\nAtrapar luz solar\nLas raíces ayudan a sujetar la planta y a absorber agua y nutrientes.\n%%\n¿Qué forma tiene cuatro lados iguales y cuatro ángulos rectos?\nTriángulo\nCuadrado\nÓvalo\nUn cuadrado tiene cuatro lados iguales y cuatro ángulos rectos.\n%%\n¿Qué país es famoso por las pirámides de Guiza?\nMéxico\nEgipto\nIndia\nLas pirámides de Guiza están en Egipto.\n%%\n¿Cómo llamas a la lluvia congelada que cae en bolitas?\nNiebla\nAguanieve\nVapor\nLa aguanieve es precipitación congelada que cae en pequeñas bolitas.\n%%\n¿Qué cuerpo de agua separa Europa y África cerca de España?\nCanal de la Mancha\nEstrecho de Gibraltar\nEstrecho de Bering\nEl estrecho de Gibraltar está entre el sur de España y el norte de África.\n%%\n¿Cuántas ruedas tiene una bicicleta estándar?\n1\n2\n3\nUna bicicleta estándar tiene dos ruedas.\n%%\n¿Qué animal es conocido por llevar su casa sobre la espalda?\nLagarto\nCaracol\nErizo\nUn caracol lleva su caparazón sobre la espalda.\n%%\n¿Cuál es el color principal de la clorofila?\nRojo\nVerde\nAzul\nLa clorofila es el pigmento verde que las plantas usan para captar la luz.\n%%\n¿Qué continente habitado es el más seco?\nÁfrica\nAustralia\nEuropa\nAustralia es el continente habitado más seco.\n%%\n¿Cómo llamas a un grupo de leones?\nManada\nOrgullo\nRebaño\nUn grupo de leones se llama orgullo.\n%%\n¿Qué instrumento tiene pedales y suele encontrarse en iglesias?\nTrompeta\nÓrgano\nTambor\nLos órganos de tubos suelen tener teclados y pedales.\n%%\n¿Qué ingrediente de cocina común hace que el pan suba?\nSal\nLevadura\nPimienta\nLa levadura produce gas que ayuda a que la masa del pan suba.\n%%\n¿Cuánto es 7 multiplicado por 8?\n54\n56\n58\n7 por 8 es 56.\n%%\n¿Qué parte de la Tierra está hecha principalmente de metal fundido?\nCorteza\nNúcleo\nOcéano\nEl núcleo de la Tierra está compuesto en gran parte por metal, y su núcleo externo es fundido.';

  @override
  String get breakZenFortunesData =>
      'Haz una pausa primero. El impulso no es destino.\n%%\nEl impulso hace ruido. No manda.\n%%\nDale a este momento 10 respiraciones más antes de decidir nada.\n%%\nLos pequeños desvíos cuentan. Ya interrumpiste la espiral.\n%%\nSi tu mente está en tormenta, reduce el horizonte al próximo minuto.\n%%\nNada permanente necesita decidirse dentro de una ola temporal.\n%%\nNo tienes que obedecer el primer impulso que aparezca.\n%%\nIntenta hacer este minuto más pequeño, más suave y más lento.\n%%\nPuedes retrasar el impulso sin tener que derrotarlo para siempre.\n%%\nLa victoria no es la perfección. La victoria es crear espacio.\n%%\nUn siguiente paso más calmado vale más que uno dramático.\n%%\nNota el impulso. Nómbralo. No le inventes una historia.\n%%\nTu sistema nervioso está pidiendo cuidado, no castigo.\n%%\nUna interrupción suave puede redirigir todo el momento.\n%%\nRespira como si ayudaras a un amigo, no como si te regañaras.\n%%\nSi esto se siente afilado, responde con suavidad y estructura.\n%%\nPuedes sentir incomodidad sin estar en peligro.\n%%\nEl momento es intenso. Aun así puede moverse.\n%%\nDale menos teatro al deseo y más distancia.\n%%\nUn sí aplazado a menudo se vuelve un no tranquilo.\n%%\nEl cuerpo se calma más rápido cuando dejas de discutir con él.\n%%\nElige el próximo minuto, no todo el futuro.\n%%\nRecupera el aire antes de seguir tus pensamientos.\n%%\nTu progreso está hecho de pequeñas interrupciones como esta.\n%%\nUna pausa no es debilidad. Es dirección.\n%%\nDeja que la ola pase; no tienes que construirle un hogar.\n%%\nEl impulso puede tocar la puerta. No puede mudarse.\n%%\nBaja la intensidad de este minuto y será más fácil llevarlo.\n%%\nNo vas tarde. Estás practicando la pausa en tiempo real.\n%%\nUn sistema nervioso más suave toma decisiones más sabias.\n%%\nPuedes aplazar sin negar tu humanidad.\n%%\nEl deseo quiere velocidad. Respóndele con firmeza serena.\n%%\nEsto es un punto de control, no un veredicto sobre tu carácter.\n%%\nQuédate con el cuerpo durante una respiración antes de seguir la historia.\n%%\nUn poco de espacio ahora mismo ya es progreso real.\n%%\nYa has sobrevivido a impulsos fuertes sin obedecerlos.\n%%\nLa próxima acción amable puede ser muy pequeña y aun así contar.\n%%\nLa calma suele construirse con repetición, no con revelaciones.\n%%\nInterrupciones como esta enseñan a tu cerebro una ruta nueva.\n%%\nUn minuto de distancia puede ahorrarte una hora de arrepentimiento.\n%%\nPuedes querer alivio y aun así elegir con sabiduría.\n%%\nHaz menos. Baja el ritmo. Deja que baje el calor primero.\n%%\nLa mente se aquieta cuando el cuerpo se siente más seguro.\n%%\nPuedes honrar lo que sientes sin actuarlo.\n%%\nEste momento no necesita drama; necesita espacio.\n%%\nPrueba a soltar la mandíbula, los hombros y la línea del tiempo.\n%%\nAhora estás conduciendo, aunque el giro sea suave.\n%%\nRespira bajo y lento; deja que la urgencia pierda su entrada.\n%%\nLos deseos suelen subir rápido y bajar si no se alimentan.\n%%\nEsta pausa ya está cambiando el final.\n%%\nNo necesitas un plan perfecto para dar un mejor siguiente paso.\n%%\nDale un poco de aburrimiento al impulso y a menudo se debilita.\n%%\nHay fuerza en estar menos disponible para el impulso.\n%%\nUn cuerpo en calma puede sostener una mente ruidosa con más seguridad.\n%%\nQue esto sea un reinicio, no un debate.\n%%\nEl futuro que estás protegiendo se construye en momentos exactamente como este.\n%%\nSi lo único que haces es posponer la espiral, eso también importa.\n%%\nCalma primero el sistema nervioso; el significado puede esperar.\n%%\nUna pausa sabia suele sentirse común mientras ocurre.\n%%\nTe estás enseñando que la urgencia no es autoridad.\n%%\nPequeñas decisiones limpias construyen una confianza silenciosa.\n%%\nEl alivio más rápido no siempre es el más verdadero.\n%%\nHaz de la próxima respiración toda tu tarea.\n%%\nReduce el ruido y luego decide.\n%%\nPuedes encontrarte con este momento con menos fuerza.\n%%\nEl impulso pide atención; dale observación en su lugar.\n%%\nNo hay ninguna regla que diga que debas continuar el viejo patrón.\n%%\nIncluso una desaceleración parcial es una victoria real.\n%%\nNo estás atrapado en la primera emoción.\n%%\nUna mejor decisión suele empezar con un cuerpo más lento.\n%%\nLa suavidad está permitida aquí.\n%%\nPuedes seguir con curiosidad en vez de reaccionar un minuto más.\n%%\nDeja que tu respiración marque el ritmo.\n%%\nLa tormenta en tu cabeza no tiene que convertirse en el clima de tu vida.\n%%\nLa estabilidad suele ser solo unos segundos más tranquilos repetidos.';

  @override
  String get breakFortuneCookieWisdomsData =>
      'Respira primero. El siguiente movimiento puede esperar.\n%%\nUn minuto más lento puede cambiar todo el ánimo.\n%%\nRetrasa el impulso, no tu amabilidad.\n%%\nLas pausas pequeñas también cuentan como decisiones fuertes.\n%%\nNo necesitas resolver este momento con ruido.\n%%\nBaja los hombros antes de bajar tus estándares.\n%%\nUn deseo es una visita, no un jefe.\n%%\nDale espacio a esta ola y se encogerá.\n%%\nLo suave vence a lo dramático cuando la meta es la paz.\n%%\nUna respiración calmada ya es una nueva dirección.\n%%\nPuedes querer alivio sin obedecer al impulso.\n%%\nToma la próxima decisión desde un cuerpo más suave.\n%%\nEste minuto merece paciencia, no presión.\n%%\nEl progreso silencioso sigue siendo progreso.\n%%\nNada importante mejora con prisa.\n%%\nQuédate con la respiración más tiempo que con la historia.\n%%\nUn poco de espacio ahora puede ahorrarte mucho después.\n%%\nAhora mismo estás interrumpiendo la ruta antigua.\n%%\nEl impulso es real. Tu elección también.\n%%\nUna pausa es una habilidad, no una excusa para aplazar.\n%%\nDeja que el calor baje antes de responderle.\n%%\nLos pensamientos más suaves llegan después de respiraciones más firmes.\n%%\nTienes permiso para bajar el ritmo de la escena.\n%%\nAquí ayuda más la curiosidad que la crítica.\n%%\nA tu yo futuro le gusta esta versión más tranquila de ti.\n%%\nEl primer impulso no es la verdad final.\n%%\nProtege los próximos diez minutos, no todo el año.\n%%\nUn cuerpo más estable hace promesas más sabias.\n%%\nEsta sensación puede pasar sin convertirse en acción.\n%%\nA veces lo lento es la velocidad más valiente.\n%%\nPuedes sentir incomodidad y seguir estando a salvo.\n%%\nDale al impulso menos atención y más distancia.\n%%\nUn mejor final suele empezar con una pausa.\n%%\nLa estructura amable vence a la presión dura.\n%%\nDeja que el momento se haga más pequeño antes de juzgarlo.\n%%\nEl cuerpo escucha cuando la respiración se vuelve amable.\n%%\nLos retrasos cortos construyen confianza a largo plazo.\n%%\nNo le debes una respuesta ahora mismo al deseo.\n%%\nLa paz crece en pequeñas decisiones repetidas.\n%%\nEsta pausa es una victoria real, no un marcador de posición.\n%%\nRespira bajo. Suelta. Vuelve despacio.\n%%\nHaz espacio para la calma antes de hacer espacio para la acción.\n%%\nUn reinicio suave también puede ser poderoso.\n%%\nMenos urgencia, más conciencia.\n%%\nEstás practicando libertad en piezas pequeñas.\n%%\nUna decisión más limpia puede iluminar todo el día.\n%%\nDeja que la quietud haga parte del trabajo.\n%%\nUn minuto de calma nunca se desperdicia.\n%%\nMantente firme. La ola ya está cambiando.\n%%\nMás suave no es más débil. Más suave es más sabio.';
}
