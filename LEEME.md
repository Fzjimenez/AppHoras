# Bitácora de horas

## Probar en tu computadora

1. Instalá Node.js 24 LTS y extraé el ZIP en una carpeta de trabajo.
2. Desde esa carpeta, ejecutá `node iniciar.mjs`.
3. Abrí http://127.0.0.1:8080 y creá la primera cuenta administradora.
4. Entrá en **Equipo → Crear cuenta** para dar de alta a cada ingeniero. Entregale su usuario y la contraseña temporal. Al ingresar deberá elegir su propia contraseña.

El programa incluye sus dependencias. Las cuentas, horas y la plantilla se guardan en `datos/bitacora.sqlite`. Las horas ingresadas en la versión alojada y las de esta instalación pertenecen a bases independientes.

## Uso en el equipo

El acceso local escucha en la interfaz de loopback. Para trabajar desde varias computadoras, ejecutá una instancia del servidor detrás de un proxy inverso con HTTPS. Mantené el puerto interno accesible únicamente desde ese proxy. Las variables se leen al iniciar el proceso.

| Variable | Valor |
| --- | --- |
| `PORT` | Puerto interno, por defecto 8080. |
| `BITACORA_HOST` | Dirección de escucha, por defecto 127.0.0.1. En un contenedor puede ser 0.0.0.0. |
| `BITACORA_ORIGIN` | URL HTTPS de acceso del equipo, por ejemplo https://horas.empresa.example. El proxy debe conservar la cabecera Origin del navegador. |
| `BITACORA_DATA` | Carpeta persistente y escribible para la base SQLite. Por defecto, datos junto a iniciar.mjs. |
| `BITACORA_SETUP_KEY` | Clave privada de instalación de al menos 24 caracteres para crear el primer administrador desde una dirección HTTPS. Guardala como secreto en el servidor. Se puede retirar tras la configuración. |

Podés crear la primera cuenta desde loopback antes de configurar el proxy. Si la base está vacía al arrancar detrás del proxy, configurá la clave de instalación e ingresala en el formulario inicial. El acceso posterior se realiza con usuario y contraseña de Bitácora.

La instalación distribuida incluye un Dockerfile para alojarla como contenedor con Node.js 24. Conectá un volumen persistente y escribible por el usuario del contenedor (UID 1000) a `/app/datos`. Al actualizar, conservá esa carpeta y reemplazá el programa. Para una copia de seguridad consistente, detené el proceso antes de copiar la carpeta completa o usá el mecanismo de backup en línea de SQLite. Ejecutá una sola instancia con la base local.

## Registrar y consultar horas

- **Registro de horas** guarda fecha, inicio, fin, cliente y tarea. Se calcula la duración en minutos y se rechazan los horarios que se superponen para el mismo ingeniero. Para una jornada que cruza medianoche, registrá dos tramos. El primero puede finalizar a las 00:00.
- El resumen semanal abarca de lunes a domingo y usa la fecha de Costa Rica. Podés seleccionar un día del gráfico y editar tus propios registros.
- **Informes** ofrece filtros por semana, mes, mes anterior, 30 o 60 días y fechas personalizadas. Los ingenieros ven sus propios registros. Los administradores pueden filtrar todo el equipo.
- **Clientes** permite agregar clientes al selector. La primera cuenta inicializa el catálogo con Ministerio de Hacienda.
- **Equipo** permite crear cuentas y restablecer contraseñas temporales. Un restablecimiento cierra las sesiones de esa cuenta.
- **Plantilla PDF** acepta un membrete de una página de hasta 5 MB. El centro debe estar libre para el contenido. Configurá los márgenes en milímetros y descargá una muestra. El PDF puede ser vertical u horizontal.
- **Exportar PDF** incluye todos los registros filtrados. Cuando hay varios ingenieros, incluye una hoja consolidada y el detalle de cada uno.

La pantalla de acceso muestra una semana de ejemplo. Esos registros ilustran el gráfico y se mantienen separados de la base de horas del equipo.
