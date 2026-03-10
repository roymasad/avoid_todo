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
}
