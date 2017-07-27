extensions [table csv]


globals
[
  ;;El tiempo de reaccion aparente, es el incremento (tiempo + tao),
  tao

  ;;El tamaño de escala del parche
  escala

  ;;Un agente vehiculo para analizar el comportamiento
  vehiculo-rojo

  tamano-vehiculo-netlogo
  tamano-vehiculo-real
  tamano-mundo-netlogo
  tamano-mundo-real

  ;;El tamano del arreglo de frecuencias, usualmente en 60, pero hay que ver
  tamano-max-frecuencias

  ;;PAra llevar un conteo de las evaluaciones, incremento en tao
  tiempo

  ;;Para la normalizacion de los conteos de los pasajeros
  tiempo-vehiculos
  tiempo-pasajeros
  tiempo-pasajeros-tren

  ;;Para seguir ejecuntando el experimento hasta terminar
  ejecuta-experimento?

  ;;Para actualizar las medidas de los flujos del sistema
  sistema-actualiza-flujos
  sistema-densidad-temporal
  sistema-velocidad-temporal
  sistema-flujo-temporal
  sistema-entrada-temporal
  sistema-salida-temporal

  conteo-sistema-entrada-temporal
  conteo-sistema-salida-temporal
  promedio-conteo-sistema-entrada-temporal
  promedio-conteo-sistema-salida-temporal

  ;;velocidad promedio del sistema
  velocidad-promedio-vehiculos
  velocidad-promedio-vehiculos-global

  ;;Para el diagrama fundamental de pasajeros
  velocidad-promedio-pasajeros
  velocidad-promedio-pasajeros-tren
  densidad-promedio-pasajeros

  ;;A partir del numero de vehiculos podemos saber la densidad del sistema
  densidad-vehiculos
  ;;densidad-pasajeros

  densidad-promedio-pasajeros-sistema
  densidad-promedio-pasajeros-tren


  ;;Distancia mas alla de la linea de vision
  ds-infinita

  ;;Distancia de seguridad maxima o inicial
  ds-seguridad-max
  ;;La proporcion en la que se reduce la distancia de seguridad
  ds-seguridad-proporcion

  ;;Para la fucion encuentra objetos
  agente-semaforo
  agente-vehiculo

  ;;El conjunto de parches tipo vias
  vias

  ;;El parche sensor para medir los headways
  monitor-headway

  ;;Las desviaciones estandar de las frecuencias de los headways
  stddevs-frecuencias

  ;;Las desviaciones estandar de las distancias entre los trenes
  stddevs-distancias

  ;;El conjunto de parches tipo estaciones
  estaciones

  ;;Flag
  set-estaciones?

  ;;Es un subconjunto de los parches que construyen las plataformas
  plataformas

  ;;Las entradas de las plataformas
  entradas

  ;;Numero máximo de experimentos, funciona para normalizar
  #max-experimento

  ;;Experimento-actual
  #experimento

  ;;Iteraciones por cada experimento para el Diagrama Fundamental
  #max-iteraciones-experimento

  ;;Las iteraciones que dejamos pasar antes de empezar a alamacenar los datos
  #transitorios

  ;;La capacidad máxima de carga de los vehiculos
  #max-vehiculos

  ;;Numero de semaforos
  #semaforos

  ;;
  #max-pasajeros-trenes
  #max-pasajeros-estaciones
  #max-pasajeros-sistema

  ;;
  #pasajeros-salida
  #pasajeros-entrada

  ;;Para los metodos de espaciamiento
  ventana-tiempo

  pasajeros-entrada-promedio

  ;;tabla con las ds-frenado-optimas
  tabla-frenado


  ;;PAra salvar los datos en un archivo
  nombre-archivo

  ;;Listas de datos
  distancias-entre-trenes
  datos-viaje-pasajeros
  datos-espera-pasajeros
  ;;datos-salida-pasajeros
  ;;datos-entrada-pasajeros


  ;;Lista de datos para los pasajeros
  datos-pasajeros-tiempo-viaje
  datos-pasajeros-tiempo-espera
  datos-pasajeros-tiempo-estacion
  datos-pasajeros-tiempo-interestacion

  ;;Listas para los datos de los trenes tiempo generales
  datos-vehiculos-tiempo-viaje-estacion
  datos-vehiculos-tiempo-viaje-interestacion
  datos-vehiculos-tiempo-viaje-total

  ;;Listas para los tiempos locales en estacion e interestacion
  datos-vehiculos-tiempo-local-estacion
  datos-vehiculos-tiempo-local-interestacion

  ;;Los datos del headway
  headway-elemento-maximo
  headway-contador-maximo

  ;;banderas de ayuda
  bandera?
  inicializa-self-org-local-headway?

  ;;Para construir la linea
  estacion-ids
  estacion-etiquetas
  estacion-interestaciones
  estacion-llegadas
  estacion-salidas

  ;;llegadas-estacion
  ;;etiquetas-estacion

  ;;Para la creacion del archvio
  directorio-actual
  metodo-etiqueta
  archivo-etiqueta
  espaciamiento-etiqueta
  rango-lambda
  rango-estacion

  file-datos-generales
  file-datos-headway
  file-datos-pasajeros-entrada
  file-datos-pasajeros-salida

]


;;Definimos los agentes del modelo, primero su identificador en plural y posteriormente singular
breed [vehiculos vehiculo]

;;El conjunto de semaforos
breed [semaforos semaforo]

;;Agentes pasajeros
breed [pasajeros pasajero]


patches-own
[
  ;;Inicializacion para la vias
  vias?
  ;;Iniciliazación para la estacion
  estacion?
  ;;Inicializacion para los semaforos

  semaforo?
  plataforma?
  entrada?
  salida?

  ;;El anterior, ya no lo voy a utuilizar, exacto
  lambda

  ;;El id de la estacion y su etiqueta
  id-estacion
  etiqueta-estacion
  interestacion

  ;;Probabilidad de llegada de los pasajeros por estacion
  probabilidad-llegada
  probabilidad-salida
  ;;La suma acumuladade las probabilidades
  probabilidad-salida-acumulada

  ;;contamos las entradas y salidas en cada estacion
  pasajeros-entrada-contador
  pasajeros-salida-contador

  ticks-hasta-siguiente-pasajero
  terminal-inicio?
  terminal-final?

  estaciones-faltantes

  ;;Para el headway
  frecuencias
  frecuencias-tiempo
  ultimo-tren
  tiempo-desde-ultimo-tren

  antiferomona
  antiferomona-carga

  activa-antiferomona?

]


vehiculos-own
[ ;Velocidad actual del vehiculo "n" y Velocidad en el tiempo siguiente (t+tao) del vehiculo "n"
  Un1
  Un2

  ;;Posicion actual del vehiculo "n", posicion en el tiempo siguiente (t+tao) del vehiculo "n"
  Xn1
  Xn2

  ;;Posicion sobre la coordenada "y"
  Yn1

  ;;Maxima aceleracion del vehiculo "n", velocidad deseada
  An

  ;;La velocidad deseada a la que desea viajar
  Vn

  ;;La velocidad de entrada externa
  Vinput

  ;;Establecemos una velocidad critica, un umbral, el vehiculo no puede tomar un valor menor a Vcritico, o sii pero hay restricciones
  Vcritico

  ;;Frenado
  bn

  ;;tamaño del vehiculo
  Sn

  ;Aceleracion y desaceleracion
  Ga
  Gd

  ;;Distancia de seguridad para el vehiculo de ejemplo.
  ds-vehiculo

  ;;LA distancia de seguridad el agente, esta va cambiando.
  ds-seguridad

  ;;El estado del vehiculo, pueden estar abordando, de la plataforma hacia el vehiculo
  abordando?

  ;;El estado del vehiculo, pueden estar descendiendo, del vehiculo hacia la plataforma
  descendiendo?

  ;;El estado del vehiculo, partiendo de la estacion o no
  partiendo?

  ;;Para calcular el tiempo de viaje
  en-trayecto?
  en-estacion?
  en-interestacion?

  ;;para almacenar los datos
  almacena-dato-trayecto?
  almacena-dato-estacion?
  almacena-dato-interestacion?

  ;;Es para el caso default sin la necesidad de tener pasajeros
  tiempo-espera-abordaje

  ;;El numero de pasajeros
  #pasajeros

  ;;La distancia optima para frenar, esta se puede convertir en mi linea de vision dinamica
  ds-frenado-optimo

  ;;si necesitamos frenar tomamos la longitud fantasma respecto a su frenado-optimo.
  posicion-fantasma

  ;;para calcular la distancia hacia la posicion fantasma
  ds-fantasma

  ;;El momento en que se establece la posicion-fantasma
  establece-posicion-fantasma?

  ;;Tiempos del tren, estacion, interestacion, compensacion, tiempo-viaje
  tiempo-compensacion
  tiempo-estacion

  ;;Para los tiempo de viaje totales
  tiempo-viaje-vehiculo-total
  tiempo-viaje-vehiculo-estacion
  tiempo-viaje-vehiculo-interestacion

  ;;Para los tiempos de viaje locales
  tiempo-viaje-vehiculo-local-estacion
  tiempo-viaje-vehiculo-local-interestacion

  ;;Tenemos que rescatar los ids de los vehiculos que estan en mi alrededor para el algoritmo autoorganizante (version carlos)
  id-vehiculo-adelante
  id-vehiculo-atras

  antiferomona-valor

  vel-promedio
  velocidad-promedio

  vehiculo-ultima-estacion

  TE-estacion?
  TE-estacion

  TE-ascenso
  TE-descenso
  TE-abordaje
  TE-retraso
  TE-retraso?

  mis-pasajeros
  mis-pasajeros-tiempo-viaje
  mis-pasajeros-tiempo-estacion
  mis-pasajeros-tiempo-interestacion
  mis-pasajeros-tiempo-espera
  mis-pasajeros-velocidad
]


semaforos-own
[
  semaforo-tam
  semaforo-estado
  semaforo-contador
  semaforo-tiempo-verde
  semaforo-tiempo-ambar
  semaforo-tiempo-rojo
  Xn1 ;;posicion en el mundo real
]


pasajeros-own
[
  ;;delayst
  ;;delaytr
  ;;delayex

  ;;tiempo de viaje
  tiempo-viaje-pasajero

  tiempo-estacion

  ;;retraso
  tiempo-espera

  ;;numero total de estaciones por viaje
  estaciones-por-viaje

  ;;estaciones faltantes por viajar antes de salir
  estaciones-para-destino

  ;;si esta en tren o no
  en-vehiculo?

  ;;la ultima estacion
  ultima-estacion

  ;;para medir la velocidad de desplazamiento
  velocidad-pasajero

  id-vehiculo

  ;;para los pasajeros
  pasajeros-estacion-buffer
  pasajeros-estacion-tiempo-espera

]


;;Establecemos los pasajeros
to setup-pasajero-v2 [estaciones-viaje]
  ;;set delayst 0
  ;;set delaytr 0
  ;;set delayex 0

  set tiempo-viaje-pasajero 0

  set tiempo-estacion 0

  ;;Numero total de estaciones por viaje

  set estaciones-por-viaje estaciones-viaje

  ;;estaciones por viaje faltante
  set estaciones-para-destino estaciones-por-viaje

  ;;show (word "Setup-pasasajero: estaciones-para-destino:" estaciones-para-destino)

  set heading 0

  set en-vehiculo? false

  set ultima-estacion [id-estacion] of patch-here
  ;;set ultima-estacion xcor

  set label-color red

  set velocidad-pasajero 0

end

;;Establecemos los pasajeros
to setup-pasajero [posibles-estaciones-faltantes]
  ;;set delayst 0
  ;;set delaytr 0
  ;;set delayex 0

  set tiempo-viaje-pasajero 0

  set tiempo-estacion 0

  ;;Numero total de estaciones por viaje
  ;;set estaciones-por-viaje 1 + (random (posibles-estaciones-faltantes - 1))

  set estaciones-por-viaje 1 + (random (posibles-estaciones-faltantes))

  ;;estaciones por viaje faltante
  set estaciones-para-destino estaciones-por-viaje

  ;;show (word "Setup-pasasajero: estaciones-para-destino:" estaciones-para-destino)

  set heading 0

  set en-vehiculo? false

  set ultima-estacion xcor

  set label-color red

  set velocidad-pasajero 0

end

to setup-pasajero-min

    set tiempo-viaje-pasajero 0

    set tiempo-estacion 0

    set estaciones-por-viaje 0

    ;;estaciones por viaje faltante
    set estaciones-para-destino 0

    set heading 0

    set en-vehiculo? false

    set ultima-estacion 0

    set label-color black

    set label 0

    set color gray ;;GRAY antes , para la animacion es negro

    set velocidad-pasajero 0

    set pasajeros-estacion-buffer []

    set pasajeros-estacion-tiempo-espera []

end


to-report tiempo-real
  report precision ( (ticks * tao) / 60) 2
end


to-report get-id-estacion-final

  let indice-final 0
  let indice-actual ( [id-estacion] of patch-here)

  ;;show (word "indice-actual: " indice-actual " indice-final: " indice-final)
  ;;show (word "probabilidades-llegada-suma-acumulada:" [probabilidad-salida-acumulada] of patch-here)

  let estacion-aleatorio ( ([probabilidad-salida-acumulada] of patch-here) +  ( ( random-float 1 ) * (1.0 - ([probabilidad-salida-acumulada] of patch-here))))
  ;;show (word "estacion-aleatorio:" estacion-aleatorio)

  let sa [probabilidad-salida-acumulada] of patch-here

  ;;set indice-actual indice-actual + 1

  ;;Para todas las estaciones contando a partir de mi posicion-actual
  while[ indice-actual < #stations] [

    ;;show (word "INICIO: indice-actual:" indice-actual)

    ifelse (estacion-aleatorio <= sa)[
      set indice-final indice-actual
      set indice-actual #stations
    ]
    [
      set indice-actual indice-actual + 1

      set sa sa + item indice-actual estacion-salidas
      ;;show(word "sa: " sa)
    ]
  ]

  ;;show (word "indice-actual: " indice-actual " indice-final: " indice-final)
  ;;show (word "indice resta: " ( indice-final - ( [id-estacion] of patch-here)))

  report ( indice-final - ( [id-estacion] of patch-here))

end



;
;
;       let estacion-salida-id 0
;
;        show (word "estacion-aleatorio: " estacion-aleatorio)
;
;        foreach sort-by < entradas and estacion-aleatorio > [probabilidad-salida-acumulada] of patch-here
;        [ ask ?
;          [
;             show (word "caca")
;            if(estacion-aleatorio > probabilidad-salida-acumulada)[
;              show (word "id-estacion-salida" id-estacion)
;              set estacion-salida-id id-estacion
;             ]
;          ]
;        ]
;
;        show (word "estacion-aqui:" id-estacion " estacion-salida: " estacion-salida-id)


;;funcion va generando pasajeros, con el setup-passenger asignamos todos los atributos,
to nuevos-pasajeros


  ;;show (word "INICIO. El nuevo numero ticks hasta siguiente pasajeros es: " ticks-hasta-siguiente-pasajero)

  ;;si el varlos de ticks es menor que uno, entra a casos, si es 1 o cero se divide el pasajero y el nuevo se inicializa
  ifelse ticks-hasta-siguiente-pasajero <= 1[ ;;si es cero o uno

    ifelse ( ticks-hasta-siguiente-pasajero = 1 or ticks-hasta-siguiente-pasajero = 0) [

      sprout-pasajeros 1
      [
        setup-pasajero-v2 get-id-estacion-final
        ;;show (word "Dividiendo pasajero")
      ]

      ;;aumentamos el numero de pasaeros en la entrada
      set #pasajeros-entrada #pasajeros-entrada + 1

      set pasajeros-entrada-contador pasajeros-entrada-contador + 1

      ;;Lo hacemos cero para que ya no entre en el ciclo y pase directamente a cargar el nuevo tiempo
      set ticks-hasta-siguiente-pasajero  (ticks-hasta-siguiente-pasajero - 1)
    ]
    [
      ;;Si el número generado es menor que la probabilidad de llegada de la estacion_k
      ;;entonces entra la distribucion random-poisson

      let aleatorio random-float 1

      ;;show (word "aleatorio: " aleatorio " y probabilidad-llegada: " probabilidad-llegada )

      if( aleatorio < probabilidad-llegada)
      [
        ;;establecemos los ticks para generar otros a traves de un tiempo generado por una poisson
        set ticks-hasta-siguiente-pasajero random-poisson lambda-passengers
        ;;show (word "El nuevo numero ticks hasta siguiente pasajeros es: " ticks-hasta-siguiente-pasajero)
      ]
    ]
  ]

  [
    ;;decrementamos,
    set ticks-hasta-siguiente-pasajero  (ticks-hasta-siguiente-pasajero - 1)
    ;;show (word "El numero de ticks decrementado: " ticks-hasta-siguiente-pasajero)
  ]

end


to pasajeros-tiempos-estacion-viaje

  ask pasajeros[

    ;;Hay pasajeros en la estacion
    if(length pasajeros-estacion-buffer > 0)
    [
      ;;los tiempos de viaje generales
      set pasajeros-estacion-tiempo-espera map [? + 1] pasajeros-estacion-tiempo-espera
    ]
  ]

end

;;funcion va generando pasajeros, con el setup-passenger asignamos todos los atributos,
to pasajeros-arribo-buffer

  ;;show (word "INICIO. El nuevo numero ticks hasta siguiente pasajeros es: " ticks-hasta-siguiente-pasajero)

  ;;si el varlos de ticks es menor que uno, entra a casos, si es 1 o cero se divide el pasajero y el nuevo se inicializa
  ifelse ticks-hasta-siguiente-pasajero <= 1[ ;;si es cero o uno

    ifelse ( ticks-hasta-siguiente-pasajero = 1 )[ ;;or ticks-hasta-siguiente-pasajero = 0 ) [

      ;;Inicalizacion de los arreglos para pasajeros
      set pasajeros-estacion-buffer sentence pasajeros-estacion-buffer get-id-estacion-final
      set pasajeros-estacion-tiempo-espera sentence pasajeros-estacion-tiempo-espera 0

      set label length pasajeros-estacion-buffer

      ;;aumentamos el numero de pasaeros en la entrada
      set #pasajeros-entrada #pasajeros-entrada + 1

      set pasajeros-entrada-contador pasajeros-entrada-contador + 1

      ;;Vamos contando la entrada temporalmente, el "1" representa un pasajero
      set sistema-entrada-temporal sentence sistema-entrada-temporal 1

      ;;Lo hacemos cero para que ya no entre en el ciclo y pase directamente a cargar el nuevo tiempo
      set ticks-hasta-siguiente-pasajero  (ticks-hasta-siguiente-pasajero - 1)
    ]
    [
      ;;Si el número generado es menor que la probabilidad de llegada de la estacion_k
      ;;entonces entra la distribucion random-poisson

      let aleatorio random-float 1

      ;;show (word "aleatorio: " aleatorio " y probabilidad-llegada: " probabilidad-llegada )

      if( aleatorio < probabilidad-llegada)
      [
        ;;establecemos los ticks para generar otros a traves de un tiempo generado por una poisson
        set ticks-hasta-siguiente-pasajero random-poisson lambda-passengers
        ;;show (word "El nuevo numero ticks hasta siguiente pasajeros es: " ticks-hasta-siguiente-pasajero)
      ]
    ]
  ]

  [
    ;;decrementamos,
    set ticks-hasta-siguiente-pasajero  (ticks-hasta-siguiente-pasajero - 1)
    ;;show (word "El numero de ticks decrementado: " ticks-hasta-siguiente-pasajero)
  ]

end


to pasajeros-ascenso-buffer

  ;;Sihay mas pasajeros que la capacidad del tren y el retraso es mayor que el minimo tiempo de espera
  if ( #pasajeros < train-capacity ) [

    let epd 0
    let tee 0 ;;tiempo-espera-estacion

    ask pasajeros-at 0 -1[

      ;;Hay pasajeros en la estacion
      if(length pasajeros-estacion-buffer > 0)
      [
        set epd item 0 pasajeros-estacion-buffer
        set tee item 0 pasajeros-estacion-tiempo-espera

        set pasajeros-estacion-buffer remove-item 0 pasajeros-estacion-buffer
        set pasajeros-estacion-tiempo-espera remove-item 0 pasajeros-estacion-tiempo-espera

        set label length pasajeros-estacion-buffer
      ]
    ]


    if(epd > 0 )[
      ;;Lo establecemos en el arreglo, ahora tenemos un contador que nos dice el numero de estaciones para bajar
      ask vehiculos-here [
        set mis-pasajeros sentence mis-pasajeros epd
        set mis-pasajeros-tiempo-viaje sentence mis-pasajeros-tiempo-viaje tee
        set mis-pasajeros-tiempo-espera sentence mis-pasajeros-tiempo-espera tee
        set mis-pasajeros-tiempo-estacion sentence mis-pasajeros-tiempo-estacion tee
        set mis-pasajeros-tiempo-interestacion sentence mis-pasajeros-tiempo-interestacion 0
        ;;set mis-pasajeros-ultima-estacion sentence mis-pasajeros-ultima-estacion [id-estacion] of patch-here
      ]

      ;;incrementamos el numero de pasajeros en el vehiculo
      set #pasajeros #pasajeros + 1

    ]

  ]

end


;;;Si hay algun pasajero en la estación
;    if any? pasajeros-at 0 -1[
;
;      ;;board train
;      ask one-of pasajeros-at 0 -1[
;
;        ;;show (word "Sube un pasajero")
;
;        set epd estaciones-para-destino
;        set tvp tiempo-viaje-pasajero
;        set tee tiempo-estacion
;
;        ;;show (word "estaciones-para-destino:" epd)
;        ;;show (word "tiempo-viaje-pasajero:" tvp)
;        ;;show (word "tiempo-estacion:" tee)
;
;        ;;y lo matamos :)
;        die
;      ]
;
;      ;;incrementamos el numero de pasajeros
;      set #pasajeros #pasajeros + 1
;    ]
;


to-report pasajeros-estaciones-contador-general

  let contador 0

  ;;Genera nuevos pasajeros en las entradas
  foreach sort pasajeros [
    ask ? [

      set contador contador + pasajeros-estacion-conteo

    ]
  ]

  report contador

end

to-report pasajeros-vehiculos-velocidad-promedio

  let suma-acumulada 0

  ;;Genera nuevos pasajeros en las entradas
  foreach sort vehiculos [
    ask ? [

      set suma-acumulada suma-acumulada + ( sum mis-pasajeros-velocidad )

      ;;show (word "pasajeros-vehiculos-velocidad-promedio:" suma-acumulada " suma: " sum mis-pasajeros-velocidad)
    ]
  ]

  ;;show(word "pasajeros-vehiculos:" ( suma-acumulada / pasajeros-vehiculos-contador-general))

  report suma-acumulada / pasajeros-vehiculos-contador-general

end

to-report pasajeros-velocidad-promedio-general

  let suma-acumulada 0

  ;;Genera nuevos pasajeros en las entradas
  foreach sort vehiculos [
    ask ? [

      set suma-acumulada suma-acumulada + ( sum mis-pasajeros-velocidad )

    ]
  ]

  report suma-acumulada / pasajeros-contador-general

end

to-report pasajeros-vehiculos-contador-general

  let contador 0

  ;;Genera nuevos pasajeros en las entradas
  foreach sort vehiculos [
    ask ? [

      set contador contador + pasajeros-vehiculo-conteo

    ]
  ]

  report contador

end


to-report pasajeros-contador-general

  report pasajeros-vehiculos-contador-general + pasajeros-estaciones-contador-general

end


to-report pasajeros-vehiculo-conteo

  report length mis-pasajeros

end


to-report pasajeros-descenso-conteo

  report length filter [? = 0] mis-pasajeros

end

to-report pasajeros-estacion-conteo

  let buffer 0

  ask pasajeros-here [
      set buffer length pasajeros-estacion-buffer
  ]


  report buffer

end

to pasajeros-actualiza-trayecto-viaje

  ;;Si esta en la estaicon
  if( estacion? and getVelocidad = 0)
    [
      ;;Si llegue a una nueva estacion
      if( vehiculo-ultima-estacion != [id-estacion] of patch-here )
      [
        set vehiculo-ultima-estacion [id-estacion] of patch-here

        ;;Si tengo pasajeros decremento mis trayectos
        if(length mis-pasajeros > 0)[
          set mis-pasajeros map [? - 1] mis-pasajeros
        ]
      ]
    ]

end

to pasajeros-tiempos-trayecto-viaje

  if(length mis-pasajeros > 0)[

    ;;los tiempos de viaje generales
    set mis-pasajeros-tiempo-viaje map [? + 1] mis-pasajeros-tiempo-viaje

    ;;Si estamos parados en la estacion
    ifelse ( estacion? and getVelocidad = 0)
    [
      set mis-pasajeros-tiempo-estacion map [? + 1] mis-pasajeros-tiempo-estacion
    ]
    ;;Si no es tiempo interestacion
    [
      set mis-pasajeros-tiempo-interestacion map [? + 1] mis-pasajeros-tiempo-interestacion
    ]
  ]

end


to set-datos-pasajeros-tiempo [mi-indice ] ;;parametro viejos: tiempo-actual tiempo-buffer]

  set datos-pasajeros-tiempo-viaje sentence datos-pasajeros-tiempo-viaje ( precision ( (item mi-indice mis-pasajeros-tiempo-viaje * tao ) / 60) 2 )
  set datos-pasajeros-tiempo-espera sentence datos-pasajeros-tiempo-espera ( precision ( (item mi-indice mis-pasajeros-tiempo-espera * tao ) / 60) 2 )
  set datos-pasajeros-tiempo-estacion sentence datos-pasajeros-tiempo-estacion ( precision ( (item mi-indice mis-pasajeros-tiempo-estacion * tao ) / 60) 2 )
  set datos-pasajeros-tiempo-interestacion sentence datos-pasajeros-tiempo-interestacion ( precision ( (item mi-indice mis-pasajeros-tiempo-interestacion * tao ) / 60) 2 )

  ;;if(tiempo-actual > tiempo-buffer)[
    if(length datos-pasajeros-tiempo-viaje > (train-capacity * #trains) )[

    ;;show (word "tiempo-actual" tiempo-actual " tiempo-buffer:" tiempo-buffer " sera removido:" item 0 datos-pasajeros-tiempo-viaje)

    set datos-pasajeros-tiempo-viaje remove-item 0 datos-pasajeros-tiempo-viaje
    set datos-pasajeros-tiempo-espera remove-item 0 datos-pasajeros-tiempo-espera
    set datos-pasajeros-tiempo-estacion remove-item 0 datos-pasajeros-tiempo-estacion
    set datos-pasajeros-tiempo-interestacion remove-item 0 datos-pasajeros-tiempo-interestacion

  ]

end

to pasajeros-descenso-buffer

  ;;Si es mayor que cero significa que alguien tiene que bajar
  if(pasajeros-descenso-conteo > 0)[

    let indice 0;
    let longitud length mis-pasajeros

    while[ indice < longitud] [

      ifelse ( item indice mis-pasajeros = 0)[

        ;;show (word "Baja un pasajero")

        ;;contador del tren
        set #pasajeros #pasajeros - 1

        set #pasajeros-salida #pasajeros-salida + 1

        ;;Establecemos los datos para las graficas con el rango de un viaje, es decir, usamos 40 minutos para crear dinamicamente
        ;;el tamaño de los arreglos que almacenan los datos y despues de 40 minutos empieza a quitar el primer elemento, o sea el mas viejo.
        ;;Creo que es mejor manejar la capacidad del tren por el numero de trenes, usamos la maxima capacidad de carga del sistema para mantener
        ;;un promedio de los tiempo de viaje.
        ;;funcion vieja: set-datos-pasajeros-tiempo indice (precision ( (ticks * tao) / 60) 2) 40
        set-datos-pasajeros-tiempo indice
        ;;set datos-pasajeros-tiempo-viaje sentence datos-pasajeros-tiempo-viaje ( precision ( (item indice mis-pasajeros-tiempo-viaje * tao ) / 60) 2 )
        ;;set datos-pasajeros-tiempo-espera sentence datos-pasajeros-tiempo-espera ( precision ( (item indice mis-pasajeros-tiempo-espera * tao ) / 60) 2 )
        ;;set datos-pasajeros-tiempo-estacion sentence datos-pasajeros-tiempo-estacion ( precision ( (item indice mis-pasajeros-tiempo-estacion * tao ) / 60) 2 )
        ;;set datos-pasajeros-tiempo-interestacion sentence datos-pasajeros-tiempo-interestacion ( precision ( (item indice mis-pasajeros-tiempo-interestacion * tao ) / 60) 2 )

        ;;show (word "datos-pasajeros-tiempo-viaje:" datos-pasajeros-tiempo-viaje)
        ;;show (word "datos-pasajeros-tiempo-espera:"datos-pasajeros-tiempo-espera)
        ;;show (word "datos-pasajeros-tiempo-estacion:"datos-pasajeros-tiempo-estacion)
        ;;show (word "datos-pasajeros-tiempo-interestacion:"datos-pasajeros-tiempo-interestacion)


        ;;como si fuera el "die"
        set mis-pasajeros remove-item indice mis-pasajeros
        set mis-pasajeros-tiempo-espera remove-item indice mis-pasajeros-tiempo-espera
        set mis-pasajeros-tiempo-viaje remove-item indice mis-pasajeros-tiempo-viaje
        set mis-pasajeros-tiempo-estacion remove-item indice mis-pasajeros-tiempo-estacion
        set mis-pasajeros-tiempo-interestacion remove-item indice mis-pasajeros-tiempo-interestacion

        ;;establecemos el contador de salida en el parche de "entrada", solo para facilitar el uso
        ask patch-at 0 -1 [
          set pasajeros-salida-contador pasajeros-salida-contador + 1

          ;;Vamos contando la entrada temporalmente, el "1" representa un pasajero
          set sistema-salida-temporal sentence sistema-salida-temporal 1

        ]

        ;;y salimos del ciclo
        set indice longitud

      ]
      [
        set indice indice + 1
      ]
    ]
  ]

end

to ascenso-pasajeros

  ;;Sihay mas pasajeros que la capacidad del tren y el retraso es mayor que el minimo tiempo de espera
  if ( #pasajeros < train-capacity ) [

    ;;Si hay algun pasajero en la estación
    if any? pasajeros-at 0 -1[

      ;;board train
      ask one-of pasajeros-at 0 -1[

        ;;show (word "Sube un pasajero")

        fd 1
        hide-turtle
        ;;crea un link con el tren, para que se mueva junto con el tren, tie = "amarrar, atar"
        create-link-from one-of vehiculos-here [ tie ]

        set id-vehiculo item 0 ([who] of vehiculos-here)

        ;;show (word "abordo el vehiculo:" id-vehiculo)
        ;;Este pasajero ya se encuentra en el tren
        set en-vehiculo? true
      ]

      ;;incrementamos el numero de pasajeros
      set #pasajeros #pasajeros + 1
    ]
  ]

end




to descenso-pasajeros

  if any? pasajeros-here with [estaciones-para-destino <= 0]
  [

    ;;show (word "Baja un pasajero")

    ;;atributo del tren
    ;;set descendiendo? true

    ;;Uno por uno van bajando, cada tick representa una persona menos
    ask one-of pasajeros-here with [estaciones-para-destino <= 0][
      ;;quitamos el link y avanzamos a la plataforma de salida, y die
      salida-del-vehiculo

    ]

    ;;bajamos un pasajero, en exit-train se elimina el link con los otros pasajeros
    set #pasajeros #pasajeros - 1
  ]

end





to setup-semaforos

  set #semaforos #stations

  set-default-shape semaforos "dot"

  ;;show (word "numero-estaciones: " numero-estaciones )

  create-semaforos #semaforos
  [
    set color red
    set semaforo-tam 1
    set semaforo-estado "rojo"
    set semaforo-contador 0
  ]

end

to setup-semaforos-equidistantes

  setup-semaforos

  ;;espaciamiento equitativo entre las estaciones
  ;;let espaciamiento floor( (tamano-mundo - 1) / #estaciones )

  ;;set estaciones patches with [ pxcor mod espaciamiento = 0 and pycor = 2 and pxcor != 0]

  ;;set estaciones patches with [ pxcor mod espaciamiento = floor (espaciamiento / 2) and pycor = 2 and pxcor != 0]


  let espaciamiento (tamano-mundo-netlogo - 1) /  #semaforos
  ;;show ( word "#semaforos: " #semaforos )
  ;;show ( word "espaciamiento:" espaciamiento)

  let x-actual floor( espaciamiento / 2 )

  foreach sort-by < semaforos
  [ ask ?
    [
      setxy  (floor(x-actual) + 1) 2.0
      set Xn1 xcor * escala
      set x-actual x-actual + espaciamiento
      ;;set label (who - #vehiculos + 1)
      ;;show (word "Coordenada Semaforo: " xcor " , " ycor )
    ]
  ]

end

to setup-semaforos-linea-1

  setup-semaforos

  let coordx ( list )

  foreach sort estaciones
  [
    ask ? [  set coordx lput pxcor coordx ]
  ]

  let indice 0

  foreach sort-by < semaforos
  [ ask ?
    [
      setxy ( (item indice coordx) + 1)  2.0
      set Xn1 xcor * escala
      ;;set x-actual x-actual + espaciamiento
      ;;set label (who - #vehiculos + 1)
      ;;show (word "Coordenada Semaforo: " xcor " , " ycor )
      set indice indice + 1
    ]
  ]

end


to setup-monitor

  ;;es un monitor para los headways, si le pongo "patches with [ ...]" me regresa una lista cuando
  ;;obtengo sus atributos, no deseo una lista de listas.
  set monitor-headway patch 66 2

  ask monitor-headway [
    set pcolor 23

    ask patch-at 0 -1 [
      set pcolor 25
    ]

    ask patch-at 0 1 [
      set pcolor 25
    ]
  ]

end

to setup-vias

  set vias patches with [pycor = 2]

  ask vias [
    set vias? true
    set pcolor gray - 1
  ]
end


;;La distancia interestación esta dada en metros.
;;let interestacion ( list  1320 762 611 595 703 478 866 698 745 382 445 458 409 793 645 501 973 1158 1262 0)
;;let etiquetas ( list  "1-PAN" "2-ZAR" "3-GOM" "4-BOU" "5-BAL" "6-MOC" "7-SAN" "8-CAN" "9-MER" "10-PIN" "11-ISA" "12-SAL" "13-BAL" "14-CUA" "15-INS" "16-SEV" "17-CHA" "18-JUA" "19-TAC" "20-OBS" )

to setup-estaciones-linea-1

  ;;A partir de la longitud de renglons establecemos la cantidad de estaciones
  set #stations length estacion-ids

  ;; Cada parche equivale a 150m, entonces (5*150) = 750m, en el archivo defino como primer segmento interestacion 750
  ;;divido en entre la escala de 150m
  let posicion-inicial 10 ;;( round ( ( item 0 estacion-interestaciones ) / escala ))

  ;;show (word "posicion-inicial: " posicion-inicial )

  ;;posiciona la estacion (segun el parche) a partir de la coordenadax,
  let coordenadax posicion-inicial;
  let coordenaday 2 ;;fija

  let indice 0;

  ;;Transformar el sistema de coordenadas a parches
  while[ indice < #stations] [

    ;;show (word "Etiqueta: " item indice etiquetas )
    ask patches with [ pxcor = coordenadax and pycor = coordenaday] [ set estacion? true
                                                                      set id-estacion          item indice estacion-ids
                                                                      set etiqueta-estacion    item indice estacion-etiquetas
                                                                      set interestacion        item indice estacion-interestaciones
                                                                      set probabilidad-llegada item indice estacion-llegadas
                                                                      set probabilidad-salida  item indice estacion-salidas
                                                                      ]

    ask patches with [ pxcor = ( coordenadax + 1) and pycor = (coordenaday + 2)] [
      set plabel-color black
      set plabel item indice estacion-etiquetas ]


    ;; la escala es 150 m
    let interestacion-conv (round ( ( item indice estacion-interestaciones ) / escala ) )

    set coordenadax ( coordenadax + interestacion-conv + 1)

    ;;show (word "Inter-original: " item indice estacion-interestaciones "  Interestacion:" interestacion-conv  " *escala:" (interestacion-conv * escala) " Coordenada x: " coordenadax )

    set indice indice + 1
  ]


  setup-estaciones

end


to setup-estaciones-equidistantes

  ;;espaciamiento equitativo entre las estaciones
  let espaciamiento ( tamano-mundo-netlogo - 1 ) / #stations
  ;;show ( word "tamano-mundo" tamano-mundo ) ;;es de 101, por es le restamos 1 por el toro
  ;;show ( word "max-pxcor: " max-pxcor) ;; es de tamaño 100,
  ;;show ( word "#estaciones: " #estaciones )
  ;;show ( word "espaciamiento:" espaciamiento )

  ;;set estaciones patches with [ pxcor mod espaciamiento = floor (espaciamiento / 2)  and pycor = 2 ]


  let x-actual floor ( espaciamiento / 2 )
  ;;show ( word "x-actual: " x-actual)

  while [ x-actual < max-pxcor] [
    ask patches with [ pxcor = floor(x-actual) and pycor = 2] [ set estacion? true]
    set x-actual x-actual + espaciamiento
  ]

  setup-estaciones

end


;;Establece los parches "estaciones", los colores, cual es el inicio y el final
to setup-estaciones

  set estaciones patches with [ estacion? ]

  let indice (#stations - 1)

  let suma-aux 0
  let copia-id 0

  ;;para cada estacion, establece dentro de los atributos el numero de estaciones faltantes
  ;;eso se pasa al random para generar un numero aleatorio entre [0,estaciones-faltantes]
  foreach sort estaciones [
      ask ? [

        set suma-aux ( suma-aux + probabilidad-salida)
        set copia-id id-estacion

        ask patch-at 0 -1 [
          set estaciones-faltantes indice
          ;; la suma acumulada
          set probabilidad-salida-acumulada suma-aux

          set id-estacion copia-id

          ;;show (word "Estaciones-faltantes: " estaciones-faltantes)
          set indice indice - 1
        ]
      ]
    ]


  ask estaciones [
    set estacion? true
    set terminal-inicio? false
    set terminal-final? false


    ask patch-at 0 1[
      set pcolor blue
      set plataforma? true
      set salida? true
    ]
    ask patch-at 0 -1 [
      set pcolor (sky + 3)
      set plataforma? true
      set entrada? true
    ]
    ask patch-at 1 1 [
      set pcolor blue
    ]
    ask patch-at 1 -1 [
      set pcolor (sky + 3)
    ]
  ]

  ask estaciones with-min [ id-estacion] [ set terminal-inicio? true ]
  ask estaciones with-max [ id-estacion] [ set terminal-final? true ]


  ;;PAra las plataformas, observa la "s" de platforms
  set plataformas patches with [ plataforma? ]

  ;;variable globlar "entrances" se le asigna "un valor" creo que es un objeto con coordenadas pycor
  set entradas plataformas with [ pycor = 1]


end


to setup-llegada-pasajeros-linea-1

  ;;Llegadas estación de 7 a 10 hrs
  ;;let llegadas-estacion ( list  46000 21000 12000 4000 2500 3420 21000 700 700 700 700 700 700 700 700 700 700 700 700 0)

  ;;
  let suma-acumulada 0;

  let indice 0;

  while[ indice < #stations] [
    set suma-acumulada suma-acumulada + item indice estacion-llegadas;;llegadas-estacion
    set indice indice + 1
  ]

  ;;show ( word "suma-total: " suma-acumulada )

  set indice 0

  foreach sort entradas
  [
    ask ?
    [
      ;;normaliza respecto al maximo (para quela probabilidad sea 1, 0.2, 0.3, etc...
      set probabilidad-llegada ( precision  ( ( item indice estacion-llegadas) / (item 0 estacion-llegadas) ) 3 )
      ;;Establece las probabilidades con la suma-acumulada, la suma debe ser 1 de entrada pero rendondea
      ;;set probabilidad-llegada ( precision  ( ( item indice llegadas-estacion ) / suma-acumulada ) 3 )
      ;;show (word "prob-llegada:" probabilidad-llegada )

      set indice indice + 1
    ]
  ]

  ;;Verificacion Suma = 1
;  let sumax 0
;
;  foreach sort entradas
;  [
;    ask ?
;    [
;      set sumax sumax + probabilidad-llegada
;      show (word "Etiqueta:" etiqueta-estacion " Prob-llegada: " probabilidad-llegada )
;    ]
;  ]
;
;  show (word "SUMA total: " sumax )

end


to setup-llegada-pasajeros

  foreach sort entradas
  [
    ask ?
    [
      ;;Cada entrada tiene su propia distribución,
      set lambda random-poisson lambda-passengers

      ;;cota inferior
      if lambda < 4[
        set lambda 4
      ]

      ;;set plabel lambda
    ]
  ]

  show (word "Entradas:" [lambda] of entradas)

  ;;ask entradas with-max [pxcor][set lambda 0]

  ;;foreach sort entradas
  ;;[
   ;; ask ?
   ;; [
      ;;Cada entrada tiene su propia distribución,
      ;;show (word "lambda:" lambda)
    ;;]
  ;;]

end



to setup

  clear-all

  random-seed 34 ;;23 ;;timer

  reset-timer

  set directorio-actual "C:\\Users\\seminarista\\Desktop\\Gipps_Final_EstanciaMetro"

  set sistema-actualiza-flujos update-measures

  set sistema-densidad-temporal []
  set sistema-velocidad-temporal []
  set sistema-flujo-temporal []
  set sistema-entrada-temporal []
  set sistema-salida-temporal []

  ;;Para los conteos temporales en las entradas, o sea los flujos por minuto
  set conteo-sistema-entrada-temporal 0
  set conteo-sistema-salida-temporal 0

  set promedio-conteo-sistema-entrada-temporal []
  set promedio-conteo-sistema-salida-temporal []

  set datos-pasajeros-tiempo-viaje []
  set datos-pasajeros-tiempo-espera []
  set datos-pasajeros-tiempo-estacion []
  set datos-pasajeros-tiempo-interestacion []

  set datos-vehiculos-tiempo-viaje-estacion []
  set datos-vehiculos-tiempo-viaje-interestacion []
  set datos-vehiculos-tiempo-viaje-total []

  set datos-vehiculos-tiempo-local-estacion []
  set datos-vehiculos-tiempo-local-interestacion []

  set file-datos-generales []
  set file-datos-headway []
  set file-datos-pasajeros-entrada []
  set file-datos-pasajeros-salida []

  ;;Flag
  set ejecuta-experimento? true

  ;;El tamaño del arreglo de frecuencias
  set tamano-max-frecuencias 500

  set headway-elemento-maximo 0
  set headway-contador-maximo 0


  ;;Establece el paso para todos los vehiculos
  set tao 0.666;;0.1 ;;0.66 ;;0.01

  ;;tamaño del parche simulado
  set escala 150 ;;150

  ;;el tamaño del vehiculo es igual al tamaño del parche para simplificar los espacios
  set tamano-vehiculo-real 150

  ;;Establece el tamaño del mundo
  set tamano-vehiculo-netlogo tamano-vehiculo-real / escala

  ;;Netlogo considera un unidad más es decir el vehiculo puede estar parado en el intervalo [0, max-pxcor + 1 )
  set tamano-mundo-netlogo max-pxcor

  ;;El tamaño del mundo real segun la escala
  set tamano-mundo-real tamano-mundo-netlogo * escala

  ;;Valores para controlar la distancia de seguridad y la proporcion de reducción en caso de que se viole la distancia de seguridad
  set ds-seguridad-max 1.0 * tamano-vehiculo-real
  set ds-seguridad-proporcion 0.9

  set #max-vehiculos floor( (tamano-mundo-real ) / (tamano-vehiculo-real + ds-seguridad-max) )
  ;;show (word "#max-vehiculos: " #max-vehiculos "tamano-vehiculos" tamano-vehiculo)

  ;;Vision de seguridad es un parametro de la interfaz, el rango adecuado es de 15 a 20
  set ds-infinita ( line-of-vision * escala ) + 1

  ;;Segun la cifra normal son 1530 para metros de 9 vagones, 150 metros aproximadamente.
  ;;Cotas superiores sobre los pasajeros
  ;;set #max-pasajeros-trenes #vehiculos * train-capacity
  ;;set #max-pasajeros-estaciones #estaciones  * capacidad-estacion
  ;;set #max-pasajeros-sistema #max-pasajeros-trenes + #max-pasajeros-estaciones

  set #pasajeros-salida 0
  set #pasajeros-entrada 0

  ;;Establecemos la densidad-actual a partir del numero de vehiculos que se definen en la interfaz
  set densidad-vehiculos #trains / #max-vehiculos

  ;;La velocidad promedio sirve para los diagramas fundamentales
  set velocidad-promedio-vehiculos 0
  set velocidad-promedio-pasajeros 0
  set velocidad-promedio-pasajeros-tren 0

  ;;PAra el algoritmo del Self-Org-Vel
  set velocidad-promedio-vehiculos-global 0

  set densidad-promedio-pasajeros-sistema 0
  set densidad-promedio-pasajeros-tren 0

  set #max-iteraciones-experimento iterations ;;1500 ;;3000 ;; 30,000*(tao)/60/60 = 5.5 horas
  set #transitorios transitory
  ;;El indice para graficar los experimientos
  set #experimento 0


  set tiempo 0
  set tiempo-pasajeros 0
  set tiempo-pasajeros-tren 0
  set tiempo-vehiculos 0

  set ventana-tiempo 100

  set pasajeros-entrada-promedio n-values ventana-tiempo [0]

  set agente-semaforo nobody
  set agente-vehiculo nobody

  ;;inicializa los atributos de los parches
  ask patches [
      set vias? false
      set estacion? false
      set semaforo? false
      set plataforma? false
      set entrada? false
      set salida? false
      set pcolor white
      set ticks-hasta-siguiente-pasajero -1

      ;;Para el headway
      set frecuencias []
      set frecuencias-tiempo []
      set ultimo-tren -1
      set tiempo-desde-ultimo-tren 0

      set antiferomona 0
      set antiferomona-carga 0
      set activa-antiferomona? false
  ]

  ;;Esto se pinta primero por que es la base y sobre esta se pinta los demas
  if grid? [
    setup-cuadricula
  ]

  ;;Despues pintamos las vias
  setup-vias

  ;;El monitor para los headways
  setup-monitor

  ;;Establce la tabla de frenado respecto a los valores que vamos a utilizar de frenado b=-1.15
  setup-tabla-frenado


  if ( vehicle-distribution = "stations" ) [
    set #trains #stations
  ]


  ;;Establece las propiedades de los vehiculos, y los vehiculos de control azul y rojo
  setup-vehiculos

  ;;Para hacer el experimento con el tren rojo
  actualiza-velocidad-rojo

  ;;Cargamos los datos de la linea, con esa informacion establecemos los atributos de las estaciones
  setup-carga-archivo-linea

  set set-estaciones? true

  if set-estaciones?[

    ;;posiciona-estaciones-linea-1
    ;;posiciona-estaciones-equidistantes
    setup-estaciones-linea-1
    setup-semaforos-linea-1
    setup-llegada-pasajeros-linea-1

  ]

  set-default-shape pasajeros "person"

  foreach sort entradas [
    ask ? [

      sprout-pasajeros 1
      [
        setup-pasajero-min
      ]
    ]
  ]



  ;;Inicialización de las listas para graficar histogramas y mas...
  setup-listas

  set lambda-passengers lambda-max

  if(set-experiment = "space-cdmx")[
    set rango-lambda lambda-passengers
    set rango-estacion (word "_E" ETAboard-min "-" ETAboard-max "-" ETAboard-noise)
    ;;show (word "max-experimento: " #max-experimento)
  ]

  if(set-experiment = "space-lambda-pass")[
    set rango-estacion ""
    set rango-lambda (word lambda-max "-" lambda-min )
    ;;set lambda-llegada-pasajeros 50
    ;;show (word "max-experimento: " #max-experimento)
  ]

  if(set-experiment = "none")[
    set #max-experimento 0
  ]

  ;;Methods
  ifelse(method = "self-organization-II")[
    set metodo-etiqueta "SOII"
  ]
  [
    ifelse(method = "default")[
      set metodo-etiqueta "DF"
    ]
    [
      if(method = "general-cdmx")[
        set metodo-etiqueta "MX"
        set archivo-etiqueta (word archivo-etiqueta "-" ETAboard-min "-" ETAboard-max "-" ETAboard-noise )
      ]
    ]
  ]

  ifelse(vehicle-distribution = "accumulated")[
    set espaciamiento-etiqueta "ACU"
  ]
  [
    if(vehicle-distribution = "equidistant")[
      set espaciamiento-etiqueta "EQUI"
    ]

  ]


  set nombre-archivo  ( word  metodo-etiqueta "_"
                              archivo-etiqueta "_"
                              #trains espaciamiento-etiqueta
                              "_L" rango-lambda
                              rango-estacion
                              "_" #max-iteraciones-experimento
                              "_" #transitorios
                              "_t" tao
                             ;; "_e" escala
                              "_v" train-speed
                              "_a" train-acceleration
                              "_f" train-braking
                              "_c" train-capacity ".txt" )

  if(set-file?)[

    ifelse file-exists? nombre-archivo
    [
      ;;user-message (word "Existe el archivo:" nombre-archivo ", lo desea eliminar?")

      ifelse user-yes-or-no? ( word "Existe el archivo:" nombre-archivo ", lo desea eliminar y crear")
      [
        show ("Archivo eliminado y creado nuevamente  ")
        file-delete nombre-archivo
        file-open nombre-archivo
      ]
      [
        show ("archivo abierto para escritura")
        file-open nombre-archivo
      ]
    ]
    [
      file-open nombre-archivo
      show ( word "archivo creado:" nombre-archivo)
    ]
  ]

  set bandera? true
  set inicializa-self-org-local-headway? true

  reset-ticks

end



to setup-tabla-frenado

  set tabla-frenado table:make

  set-current-directory directorio-actual

  file-open "ds_frenado_bn1_15.txt"

  let cadena ""
  let elemento1 ""
  let elemento2 ""
  let posicion 0

  while [ not file-at-end?]
  [

    set cadena file-read-line

    set posicion position " " cadena
    set elemento1 substring cadena  0 posicion
    set elemento2 substring cadena ( posicion + 1 ) (length cadena)

    ;;show (word "cadena:" cadena " posicion-vacia:" posicion " e1:" elemento1 " e2:" elemento2 )

    table:put tabla-frenado (read-from-string elemento1) (read-from-string elemento2)
  ]

  ;;print tabla-frenado

  file-close

end


to setup-carga-archivo-linea

  file-close-all ;;Close any files open from last run

  set-current-directory directorio-actual

  set archivo-etiqueta metro-line

  file-open word archivo-etiqueta ".txt"

  set estacion-ids []
  set estacion-etiquetas []
  set estacion-interestaciones []
  set estacion-llegadas []
  set estacion-salidas []

  while [ not file-at-end? ] [

    let renglon csv:from-row file-read-line

    set estacion-ids             sentence estacion-ids             item 0 renglon
    set estacion-etiquetas       sentence estacion-etiquetas       item 1 renglon
    set estacion-interestaciones sentence estacion-interestaciones item 2 renglon
    set estacion-llegadas        sentence estacion-llegadas        item 3 renglon
    set estacion-salidas         sentence estacion-salidas         item 4 renglon
  ]

;  show (word "estacion-ids: "             estacion-ids)
;  show (word "estacion-etiquetas: "       estacion-etiquetas)
;  show (word "estacion-interestaciones: " estacion-interestaciones)
;  show (word "estacion-llegadas: "        estacion-llegadas)
;  show (word "estacion-salidas: "         estacion-salidas)

   show (word "load metro line ... ")

  file-close

end



to setup-init

  clear-turtles
  ;;clear-all-plots

  ;;setup

  reset-timer

  reset-ticks

  ;;Establece las propiedades de los vehiculos, y los vehiculos de control azul y rojo
  setup-vehiculos

  ;;if set-estaciones?
  ;;[
  ;;  setup-estaciones
  ;;  setup-semaforos
  ;;]

  if set-estaciones?[
    setup-estaciones-linea-1
    setup-semaforos-linea-1
    setup-llegada-pasajeros-linea-1
  ]

  ;;Los matamos y luego los creamos
  ask pasajeros [
    die
  ]


  foreach sort entradas [
    ask ? [

      sprout-pasajeros 1
      [
        setup-pasajero-min
      ]
    ]
  ]

  ;;imprime-estado

  setup-listas

  clear-all-plots

  reset-ticks

end


to actualiza-velocidad-rojo
  ask vehiculo-rojo
  [
    set Vinput red-train-speed
  ]
end


to setup-vehiculos

  if #trains > tamano-mundo-netlogo
  [
    user-message (word "Hay muchos vehiculos en el camino. Por favor decrementa el numero de vehiculos."
                       (world-width + 1) " y presiona el botón SETUP otra vez.")
    stop
  ]

  set-default-shape turtles "train passenger car"

  ;;se crean en orden aleatorio, a partir de una semilla aleatoria
  create-vehiculos #trains [
    set color orange
    set heading  90

    ;;Tamaño del vehiculo
    set Sn tamano-vehiculo-real
    set size tamano-vehiculo-netlogo

    ;;La velocidad actual y la siguiente
    set Un1 0
    set Un2 0

    ;;Maxima aceleracion, Velocidad deseada, frenado máximo
    set An train-acceleration ;; random-normal aceleracion-a varianza-aa
    set Vn train-speed   ;; random-normal velocidad-a  varianza-va
    ;;show (word "Velocidad deseada Vn: " Vn)
    ;;show (word "Aceleracion An; " An)

    set bn train-braking ;;-1.15
    ;;set bn frenado-a
    ;;set bn (- 2.0 ) * An ;;como se inicializa en el articulo de Gipps

    set Vinput Vn
    set Vcritico tao * An

    ;;Aceleración y desaceleracion
    set Ga 0
    set Gd 0

    ;;Por ejemplo id=1; enfrete tengo a id=0
    set id-vehiculo-adelante (who - 1) mod #trains
    ;;Por ejemplo id=1; atras tento a id=2
    set id-vehiculo-atras (who + 1) mod #trains

    ;;set label (who + 1)

    ;;Establecemos la distnacia de seguridad en un principio es la maximia
    set ds-seguridad ds-seguridad-max

    set ds-vehiculo 0

    set posicion-fantasma 0

    set ds-fantasma ds-infinita

    set establece-posicion-fantasma? false

    ifelse ( Vn > Vcritico) [
      ;;El valor optimo de frenado, esta distancia garantiza el frenado seguro
      set ds-frenado-optimo table:get tabla-frenado Vn
    ]
    [
      set ds-frenado-optimo 0
    ]


    set abordando? false
    set partiendo? false

    set #pasajeros 0

    ;;Los tiempos totales de viaje
    set tiempo-viaje-vehiculo-total 0
    set tiempo-viaje-vehiculo-estacion 0
    set tiempo-viaje-vehiculo-interestacion 0

    ;;Los tiempos locales estacion e interestacion
    set tiempo-viaje-vehiculo-local-estacion 0
    set tiempo-viaje-vehiculo-local-interestacion 0

    set almacena-dato-trayecto? false
    set almacena-dato-estacion? false
    set almacena-dato-interestacion? false

    set en-estacion? false
    set en-trayecto? false
    set en-interestacion? false

    set antiferomona-valor 0

    set vel-promedio 0

    set velocidad-promedio n-values 180 [ train-speed ]

    ;;Inicializamos los tiempos de permanencia en la estacion
    set tiempo-estacion 0
    set tiempo-compensacion false

    set TE-estacion? true
    set TE-estacion 0
    set TE-ascenso 0
    set TE-descenso 0
    set TE-abordaje 0
    set TE-retraso 0
    set TE-retraso? true


    set mis-pasajeros []
    set mis-pasajeros-tiempo-viaje []
    set mis-pasajeros-tiempo-estacion []
    set mis-pasajeros-tiempo-interestacion[]
    set mis-pasajeros-tiempo-espera []
    set mis-pasajeros-velocidad []

    set vehiculo-ultima-estacion -1
  ]

  separa-vehiculos


  ;;Establecemos los autos para modificar sus atributos
  set vehiculo-rojo vehiculo 0

  ;;Establecemos la aceleracion máxima, la velocidad deseada y el frenado más severo
  ask vehiculo-rojo
  [
    set color red
  ]

end




;;Como estan ligados los pasajeros al tren, entonces hay que borrar el vinculo, mostramos la tortuga, y avanza 1
to salida-del-vehiculo
  ask my-in-links [ die ]
  show-turtle
  fd 1

  ;;establecemos el contador de salida en el parche de "entrada", solo para facilitar el uso
  ask patch-at 0 -2 [
    set pasajeros-salida-contador pasajeros-salida-contador + 1
  ]


end


to separa-vehiculos


  if ( vehicle-distribution = "stations" ) [

    set #trains #stations

    ;;respecto a las estaciones, aunque hayamos creado más vehiculos, posiciona uno en cada estacion,
    let espaciamiento (tamano-mundo-netlogo - 1) / #stations
    ;;show ( word "Metodo estaciones, #vehiculos: " #vehiculos )
    ;;show ( word "Metodo estaciones, espaciamiento:" espaciamiento)

    let x-actual floor (espaciamiento / 2)

    foreach sort-by > vehiculos
    [ ask ?
      [

        ;;Establecemos la posicion en la escala Netlogo
        setxy ( floor( x-actual ) - 1 ) 2.0

        ;;Despues en la escala del modelo
        set xn1 xcor * escala

        ;;show (word "Coordenada vehiculo:" xactual )
        set x-actual x-actual + espaciamiento
      ]
    ]
  ]

  if ( vehicle-distribution = "equidistant" ) [

    ;;respecto a las estaciones, aunque hayamos creado más vehiculos, posiciona uno en cada estacion,
    let espaciamiento (tamano-mundo-real) / #trains
    ;;show ( word "Metodo equidistante, #vehiculos: " #vehiculos )
    ;;show ( word "Metodo equidistante, espaciamiento:" espaciamiento)

    let x-actual 0

    foreach sort-by > vehiculos
    [ ask ?
      [
        set Xn1 x-actual
        set Yn1 2

        setxy (Xn1 / escala) Yn1

        set x-actual x-actual + espaciamiento
        ;;show (word "Coordenada inicio vehiculo X:" xactual )
      ]
    ]
  ]


  if ( vehicle-distribution = "accumulated" ) [

    ;;respecto a las estaciones, aunque hayamos creado más vehiculos, posiciona uno en cada estacion,
    ;;let espaciamiento (tamano-mundo-real) / #vehiculos
    ;;show ( word "Metodo equidistante, #vehiculos: " #vehiculos )
    ;;show ( word "Metodo equidistante, espaciamiento:" espaciamiento)

    let x-actual 0

    foreach sort-by > vehiculos
    [ ask ?
      [
        ;;show (word "ask?" ? " who " who)

        set Xn1 x-actual
        set Yn1 2

        setxy (Xn1 / escala) Yn1

        set x-actual x-actual + (tamano-vehiculo-real * 2.2)
        ;;show (word "Coordenada inicio vehiculo X:" xactual )
      ]
    ]
  ]

end



to itera-densidad-pasajeros-transitorios

  ;;El promedio llegada pasajeros es lambda
  ifelse(lambda-passengers >= lambda-min)
  [
    ;;show (word "LAMBDA:" lambda-pasajeros " TIEMPO:" tiempo )

    ;;Si se cumplio el numero de iteraciones del experimento, almacenamos los datos
    ifelse(tiempo < #max-iteraciones-experimento)
    [

      if (method = "general-cdmx")[
        method-general-cdmx
      ]

      if(method = "self-organization-II")[
        method-self-organization-II
        actualiza-vias-antiferomonas

        if (inicializa-self-org-local-headway?)[
          ;;inicializa los datos del headway
          ask monitor-headway [
            set frecuencias []
            set frecuencias-tiempo []
            set ultimo-tren -1
            set tiempo-desde-ultimo-tren 0
          ]

          set inicializa-self-org-local-headway? false
          ;;show(word "inicializa-headway")
        ]
      ]


      set velocidad-promedio-vehiculos-global velocidad-promedio-vehiculos-global + mean [Un1] of vehiculos


      if (tiempo > #transitorios)[

        set velocidad-promedio-vehiculos velocidad-promedio-vehiculos + mean [Un1] of vehiculos
        set tiempo-vehiculos tiempo-vehiculos + 1

        if (pasajeros-contador-general > 0)[
          ;;De entrada lo aumentamos por que viene en 1
          set tiempo-pasajeros tiempo-pasajeros + 1

          if( pasajeros-vehiculos-contador-general > 0)
          [
            set densidad-promedio-pasajeros-tren densidad-promedio-pasajeros-tren + ( pasajeros-vehiculos-contador-general )
            set velocidad-promedio-pasajeros-tren velocidad-promedio-pasajeros-tren + (pasajeros-vehiculos-velocidad-promedio)

            set tiempo-pasajeros-tren tiempo-pasajeros-tren + 1
            ;;show (word "pasajeros:densidad-pasajeros-sistema-en-tren:" ( count pasajeros with [en-vehiculo? = true]))
            ;;show (word "pasajeros:suma-densidad-pasajeros-promedio-en-tren:" (densidad-promedio-pasajeros-en-tren / tiempo-pasajeros ) )
          ]

          ;;show (word "tiempo-pasajeros:" tiempo-pasajeros " **************")
          ;;show (word "vel-pasajeros-todos:" (mean [velocidad-pasajero] of pasajeros) " vel-pasajeros-tren:" velocidad-promedio-pasajeros-tren)
          set velocidad-promedio-pasajeros velocidad-promedio-pasajeros + ( pasajeros-velocidad-promedio-general)
          ;;show (word "pasajeros:velocidad-promedio:" mean [velocidad-pasajero] of pasajeros )
          ;;show (word "pasajeros:suma-promedio-velocidad-promedio:" (velocidad-promedio-pasajeros / tiempo-pasajeros) )  ;;si normalizo respecto al tiempo pierdo la cantidad de
          ;;pasajeros, y los que estan en velocidad cero?, creo que hay que normalizar respecto al total de pasajeros que hay en un tiempo especifico, pero, si viene de un
          ;;historico, mmmmmmm, entonces el promedio respecto a todos los pasajeros, y despues entre todas la mediciones, que es el tiempo, ajaaa!

          set densidad-promedio-pasajeros-sistema densidad-promedio-pasajeros-sistema + (pasajeros-contador-general )
          ;;show (word "pasajeros:densidad-pasajeros-sistema:" (count pasajeros))
          ;;show (word "pasajeros:suma-densidad-promedio-sistema: " (densidad-promedio-pasajeros-sistema  / tiempo-pasajeros) )

          ;;Para almacenar los datos del flujo cada x minutos


          ;;Ya estamos transformando sistema-actualiza-flujos, para que cada numero de ticks (tiempo) actualicemos en funcion de minutos
          if(tiempo mod sistema-actualiza-flujos = 0)[

            ;;show (word "Actualizacion flujos:" sistema-actualiza-flujos " tiempo-real:" tiempo-real "tiempo" tiempo " ticks" ticks)

            set sistema-velocidad-temporal sentence sistema-velocidad-temporal ( pasajeros-velocidad-promedio-general * 3.6) ;; (km/hr)
            set sistema-densidad-temporal sentence sistema-densidad-temporal pasajeros-contador-general ;;(pasajeros / km)
            set sistema-flujo-temporal sentence sistema-flujo-temporal ((pasajeros-velocidad-promedio-general * 3.6) * (pasajeros-contador-general)) ;;(pasajeros/hr)

           ;;Se cumple el minuto entonces borro los datos,
            set conteo-sistema-entrada-temporal length sistema-entrada-temporal
            set sistema-entrada-temporal []

            set conteo-sistema-salida-temporal length sistema-salida-temporal
            set sistema-salida-temporal []

            set promedio-conteo-sistema-entrada-temporal sentence promedio-conteo-sistema-entrada-temporal conteo-sistema-entrada-temporal
            set promedio-conteo-sistema-salida-temporal sentence promedio-conteo-sistema-salida-temporal conteo-sistema-salida-temporal


            ;;Contamos los pasajeros que se encuentran esperando las estaciones
            ;;set sistema-entrada-temporal sentence sistema-entrada-temporal pasajeros-estaciones-contador-general

            ;;show(word "Pasajeros-velocidad-promedio-general:" pasajeros-velocidad-promedio-general " Pasajeros-contador-general:" pasajeros-contador-general)

            if(length sistema-flujo-temporal > 60)[
              set sistema-velocidad-temporal remove-item 0 sistema-velocidad-temporal
              set sistema-densidad-temporal remove-item 0 sistema-densidad-temporal
              set sistema-flujo-temporal remove-item 0 sistema-flujo-temporal
            ]

          ]


        ];;Cierra if (count pasajeros > 0 )

      ];;Cierra (tiempo > transitorios)

      set tiempo tiempo + 1 ;;incrementa el tiempo general

    ]
    ;;Si terminamos las iteraciones entonces desplegamos la información
    [

      ;;Para los pasajeros del sistema (todos)
      let VPP  ( velocidad-promedio-pasajeros / tiempo-pasajeros);;#max-iteraciones-experimento)
      let DPPS (densidad-promedio-pasajeros-sistema / tiempo-pasajeros)

      ;;Para los pasajeros que estan en el tren
      let VPPT ( velocidad-promedio-pasajeros-tren / tiempo-pasajeros-tren)
      let DPPT ( densidad-promedio-pasajeros-tren /  tiempo-pasajeros-tren)

      ;;Estoy considerando la velocidad promedio de todos los pasajeros, será que solo debo considerar a los del tren?
      let FPS ( DPPS * VPP )  ;;flujo-pasajeros-sistema

      let FPT ( DPPT * VPPT ) ;;flujo-pasajeros-tren

      ;;Para los vehiculos
      let VPV (velocidad-promedio-vehiculos / tiempo-vehiculos ) ;;(#max-iteraciones-experimento - #transitorios)) ;;Velocidad Promedio Vehiculos
      let FV (densidad-vehiculos * VPV) ;;flujo-vehiculos

      ;;show (word "L:" lambda-llegada-pasajeros " FPS:" FPS " VPS:" VPP  " DPS:" DPPS " FPT:" FPT " VPT:" VPPT " DPT:" DPPT " #PS:" #pasajeros-salida " FV:" FV " VV:" VPV " DV:" densidad-vehiculos " DatosViajeP:" mean datos-viaje-pasajeros " DatosEsperaP:" mean datos-espera-pasajeros )
      let aux-datos ( word lambda-passengers " " FPS " " VPP  " " DPPS " " FPT " " VPPT " " DPPT " " #pasajeros-salida " " FV " " VPV " " densidad-vehiculos
        " " mean datos-pasajeros-tiempo-viaje " " mean datos-pasajeros-tiempo-estacion " " mean datos-pasajeros-tiempo-interestacion )

      show(word aux-datos)


      ;;Creamos las listas de salida y entrada de las estaciones
      let lista-contador-entrada []
      let lista-contador-salida []

      foreach sort entradas [
        ask ? [
          set lista-contador-entrada sentence lista-contador-entrada pasajeros-entrada-contador
          set lista-contador-salida sentence lista-contador-salida pasajeros-salida-contador
        ]
      ]

      let aux-entrada (word "Entrada-contador:" lista-contador-entrada)
      show (word aux-entrada)

      let aux-salida (word "Salida-contador:" lista-contador-salida)
      show (word aux-salida)

      let aux-headway (word [frecuencias] of monitor-headway)
      show (word aux-headway)

      set file-datos-generales sentence file-datos-generales aux-datos
      set file-datos-headway sentence file-datos-headway aux-headway
      set file-datos-pasajeros-entrada sentence file-datos-pasajeros-entrada aux-entrada
      set file-datos-pasajeros-salida sentence file-datos-pasajeros-salida aux-salida

      ;;Inicializamos el contador nuevamente
      set tiempo 0

      ;;inicializamos todo otra vez
      set velocidad-promedio-vehiculos-global 0

      set velocidad-promedio-vehiculos 0

      set velocidad-promedio-pasajeros 0
      set velocidad-promedio-pasajeros-tren 0

      set densidad-promedio-pasajeros-sistema 0
      set densidad-promedio-pasajeros-tren 0

      set #experimento #experimento + 1
      set lambda-passengers lambda-passengers - 1

      set #pasajeros-entrada 0
      set #pasajeros-salida 0

      set tiempo-vehiculos 0
      set tiempo-pasajeros 0
      set tiempo-pasajeros-tren 0

      set datos-pasajeros-tiempo-viaje []
      set datos-pasajeros-tiempo-espera []
      set datos-pasajeros-tiempo-estacion []
      set datos-pasajeros-tiempo-interestacion []


      ;;incializa graficas, vehiculos, estaciones, semaforos
      setup-init
    ]
  ]
  [

    if(set-file?)[

      foreach file-datos-generales [ file-print (word ?)]
      foreach file-datos-headway [file-print (word ?)]
      foreach file-datos-pasajeros-entrada [file-print (word ?)]
      foreach file-datos-pasajeros-salida [file-print (word ?)]
    ]

    file-close
    show(word "Se crea el archivo y fin")

    set ejecuta-experimento? false

  ]


end

;;Rango superior para ETAboard-max-local-sup 200
;;Rango inferior para ETAboard-max-local-inf 20
;;Rango superior para ETAboard-min-local-sup 200
;;Rango inferior para ETAboard-min-local-inf 20
;;Crea un cuadrado de [20,200] x [20,200] = ETAboard-min-local x ETAboard-max-local
to itera-cdmx-transitorios

  ;;cota inferior y superior
  let ETAboard-min-local-inf 15
  let ETAboard-max-local-sup 200


  ;;El promedio llegada pasajeros es lambda
  ifelse(ETAboard-min >= ETAboard-min-local-inf) ;; and ETAboard-max-local >= ETAboard-min-local)
  [
    ;;Si se cumplio el numero de iteraciones del experimento, almacenamos los datos
    ifelse(tiempo < #max-iteraciones-experimento)
    [
      ifelse (method = "general-cdmx")[
        method-general-cdmx
      ]
      [
        show (word "Select the method: general-cdmx")
      ]

      set velocidad-promedio-vehiculos-global velocidad-promedio-vehiculos-global + mean [Un1] of vehiculos


      if (tiempo > #transitorios)[

        set velocidad-promedio-vehiculos velocidad-promedio-vehiculos + mean [Un1] of vehiculos
        set tiempo-vehiculos tiempo-vehiculos + 1

        if (pasajeros-contador-general > 0)[
          ;;De entrada lo aumentamos por que viene en 1
          set tiempo-pasajeros tiempo-pasajeros + 1

          if( pasajeros-vehiculos-contador-general > 0)
          [
            set densidad-promedio-pasajeros-tren densidad-promedio-pasajeros-tren + ( pasajeros-vehiculos-contador-general )
            set velocidad-promedio-pasajeros-tren velocidad-promedio-pasajeros-tren + (pasajeros-vehiculos-velocidad-promedio)

            set tiempo-pasajeros-tren tiempo-pasajeros-tren + 1
            ;;show (word "pasajeros:densidad-pasajeros-sistema-en-tren:" ( count pasajeros with [en-vehiculo? = true]))
            ;;show (word "pasajeros:suma-densidad-pasajeros-promedio-en-tren:" (densidad-promedio-pasajeros-en-tren / tiempo-pasajeros ) )
          ]

          ;;show (word "tiempo-pasajeros:" tiempo-pasajeros " **************")
          ;;show (word "vel-pasajeros-todos:" (mean [velocidad-pasajero] of pasajeros) " vel-pasajeros-tren:" velocidad-promedio-pasajeros-tren)
          set velocidad-promedio-pasajeros velocidad-promedio-pasajeros + ( pasajeros-velocidad-promedio-general)
          ;;show (word "pasajeros:velocidad-promedio:" mean [velocidad-pasajero] of pasajeros )
          ;;show (word "pasajeros:suma-promedio-velocidad-promedio:" (velocidad-promedio-pasajeros / tiempo-pasajeros) )  ;;si normalizo respecto al tiempo pierdo la cantidad de
          ;;pasajeros, y los que estan en velocidad cero?, creo que hay que normalizar respecto al total de pasajeros que hay en un tiempo especifico, pero, si viene de un
          ;;historico, mmmmmmm, entonces el promedio respecto a todos los pasajeros, y despues entre todas la mediciones, que es el tiempo, ajaaa!

          set densidad-promedio-pasajeros-sistema densidad-promedio-pasajeros-sistema + (pasajeros-contador-general )
          ;;show (word "pasajeros:densidad-pasajeros-sistema:" (count pasajeros))
          ;;show (word "pasajeros:suma-densidad-promedio-sistema: " (densidad-promedio-pasajeros-sistema  / tiempo-pasajeros) )

          ;;Para almacenar los datos del flujo cada x minutos


          ;;Ya estamos transformando sistema-actualiza-flujos, para que cada numero de ticks (tiempo) actualicemos en funcion de minutos
          if(tiempo mod sistema-actualiza-flujos = 0)[

            ;;show (word "Actualizacion flujos:" sistema-actualiza-flujos " tiempo-real:" tiempo-real "tiempo" tiempo " ticks" ticks)

            set sistema-velocidad-temporal sentence sistema-velocidad-temporal ( pasajeros-velocidad-promedio-general * 3.6) ;; (km/hr)
            set sistema-densidad-temporal sentence sistema-densidad-temporal pasajeros-contador-general ;;(pasajeros / km)
            set sistema-flujo-temporal sentence sistema-flujo-temporal ((pasajeros-velocidad-promedio-general * 3.6) * (pasajeros-contador-general)) ;;(pasajeros/hr)

           ;;Se cumple el minuto entonces borro los datos,
            set conteo-sistema-entrada-temporal length sistema-entrada-temporal
            set sistema-entrada-temporal []

            set conteo-sistema-salida-temporal length sistema-salida-temporal
            set sistema-salida-temporal []

            set promedio-conteo-sistema-entrada-temporal sentence promedio-conteo-sistema-entrada-temporal conteo-sistema-entrada-temporal
            set promedio-conteo-sistema-salida-temporal sentence promedio-conteo-sistema-salida-temporal conteo-sistema-salida-temporal


            ;;Contamos los pasajeros que se encuentran esperando las estaciones
            ;;set sistema-entrada-temporal sentence sistema-entrada-temporal pasajeros-estaciones-contador-general

            ;;show(word "Pasajeros-velocidad-promedio-general:" pasajeros-velocidad-promedio-general " Pasajeros-contador-general:" pasajeros-contador-general)

            if(length sistema-flujo-temporal > 60)[
              set sistema-velocidad-temporal remove-item 0 sistema-velocidad-temporal
              set sistema-densidad-temporal remove-item 0 sistema-densidad-temporal
              set sistema-flujo-temporal remove-item 0 sistema-flujo-temporal
            ]

          ]


        ];;Cierra if (count pasajeros > 0 )

      ];;Cierra (tiempo > transitorios)

      set tiempo tiempo + 1 ;;incrementa el tiempo general

    ]
    ;;Si terminamos las iteraciones entonces desplegamos la información
    [

      ;;Para los pasajeros del sistema (todos)
      let VPP  ( velocidad-promedio-pasajeros / tiempo-pasajeros);;#max-iteraciones-experimento)
      let DPPS (densidad-promedio-pasajeros-sistema / tiempo-pasajeros)

      ;;Para los pasajeros que estan en el tren
      let VPPT ( velocidad-promedio-pasajeros-tren / tiempo-pasajeros-tren)
      let DPPT ( densidad-promedio-pasajeros-tren /  tiempo-pasajeros-tren)

      ;;Estoy considerando la velocidad promedio de todos los pasajeros, será que solo debo considerar a los del tren?
      let FPS ( DPPS * VPP )  ;;flujo-pasajeros-sistema

      let FPT ( DPPT * VPPT ) ;;flujo-pasajeros-tren

      ;;Para los vehiculos
      let VPV (velocidad-promedio-vehiculos / tiempo-vehiculos ) ;;(#max-iteraciones-experimento - #transitorios)) ;;Velocidad Promedio Vehiculos
      let FV (densidad-vehiculos * VPV) ;;flujo-vehiculos

      ;;show (word "L:" lambda-llegada-pasajeros " FPS:" FPS " VPS:" VPP  " DPS:" DPPS " FPT:" FPT " VPT:" VPPT " DPT:" DPPT " #PS:" #pasajeros-salida " FV:" FV " VV:" VPV " DV:" densidad-vehiculos " DatosViajeP:" mean datos-viaje-pasajeros " DatosEsperaP:" mean datos-espera-pasajeros )
      let aux-datos ( word lambda-passengers " " FPS " " VPP  " " DPPS " " FPT " " VPPT " " DPPT " " #pasajeros-salida " " FV " " VPV " " densidad-vehiculos
        " " mean datos-pasajeros-tiempo-viaje " " mean datos-pasajeros-tiempo-estacion " " mean datos-pasajeros-tiempo-interestacion )

      show(word aux-datos)


      ;;Creamos las listas de salida y entrada de las estaciones
      let lista-contador-entrada []
      let lista-contador-salida []

      foreach sort entradas [
        ask ? [
          set lista-contador-entrada sentence lista-contador-entrada pasajeros-entrada-contador
          set lista-contador-salida sentence lista-contador-salida pasajeros-salida-contador
        ]
      ]

      ;;let aux-entrada (word "Entrada-contador:" lista-contador-entrada)
      ;;show (word aux-entrada)

      ;;let aux-salida (word "Salida-contador:" lista-contador-salida)
      ;;show (word aux-salida)

      ;;show (word "ETAboard-min-local:" ETAboard-min-local " ETAboard-max-local: " ETAboard-max-local)

      let aux-headway (word ETAboard-min " " ETAboard-max " " map int [frecuencias] of monitor-headway)
      show (word aux-headway)


      set file-datos-generales sentence file-datos-generales aux-datos
      set file-datos-headway sentence file-datos-headway aux-headway
      ;;set file-datos-pasajeros-entrada sentence file-datos-pasajeros-entrada aux-entrada
      ;;set file-datos-pasajeros-salida sentence file-datos-pasajeros-salida aux-salida

      ;;Inicializamos el contador nuevamente
      set tiempo 0

      ;;inicializamos todo otra vez
      set velocidad-promedio-vehiculos-global 0

      set velocidad-promedio-vehiculos 0

      set velocidad-promedio-pasajeros 0
      set velocidad-promedio-pasajeros-tren 0

      set densidad-promedio-pasajeros-sistema 0
      set densidad-promedio-pasajeros-tren 0

      set #experimento #experimento + 1

      set #pasajeros-entrada 0
      set #pasajeros-salida 0

      set tiempo-vehiculos 0
      set tiempo-pasajeros 0
      set tiempo-pasajeros-tren 0

      set datos-pasajeros-tiempo-viaje []
      set datos-pasajeros-tiempo-espera []
      set datos-pasajeros-tiempo-estacion []
      set datos-pasajeros-tiempo-interestacion []

      ;;incializa graficas, vehiculos, estaciones, semaforos
      setup-init
      ;;setup

      random-seed ( ETAboard-min + ETAboard-max )

      ;;show (word "ETA-min:" ETAboard-min-local "ETA-max: " ETAboard-max-local)

      ;;Si el tiempo maximo es menor que el tiempo minimo (no se puede)
      ifelse( ( ETAboard-max - 10) < ETAboard-min)[
        set ETaboard-max ETAboard-max-local-sup
        set ETAboard-min EtAboard-min - 2
      ][
      set ETAboard-max ETAboard-max - 10
      ]



    ]

  ]
  [

    if(set-file?)[

      foreach file-datos-generales [ file-print (word ?)]
      foreach file-datos-headway [file-print (word ?)]
      ;;foreach file-datos-pasajeros-entrada [file-print (word ?)]
      ;;foreach file-datos-pasajeros-salida [file-print (word ?)]
    ]

    file-close
    show(word "Se crea el archivo y fin")

    set ejecuta-experimento? false

  ]





end





to-report getVelocidad


  ifelse(Un1 >= 0 )[
    report Un1
  ]
  [
    set Un1 0
    report Un1
  ]

end



to metodo-default-con-pasajeros

  ;;Analizamos todos los agentes reactivos, autonomos, o sea los vehiculos
  foreach sort vehiculos
  [
    ask ?
    [
      set tiempo-viaje-vehiculo-total tiempo-viaje-vehiculo-total + 1
      set label #pasajeros

      ;;1. Calculamos la velocidad respecto a los objetos, aqui tenemos un agente-semaforo o un agente-vehiculo
      procesa-objetos5


      ;;Si parte el vehiculo entonces tenemos que poner el estado del semaforo en rojo (para el siguiente)
      if (partiendo?)[
        ask agente-semaforo [
          set semaforo-estado "rojo"
          set color red
        ]

        set partiendo? false
      ]

      ;;Se actualizan los tiempos del viaje en estacion y trayecto
      pasajeros-tiempos-trayecto-viaje
      pasajeros-actualiza-trayecto-viaje

      ;;estoy "parado" en la estación, es decir tengo velocidad cero, Un1 = 0
      if ( estacion? and getVelocidad = 0) [

        set en-estacion? true
        set tiempo-estacion tiempo-estacion + 1

        ;;PROCESO: DESCENDIENDO VEHICULO A PLATAFORMA
        ;;Aqui se tiene que bajar el pasajero, por que su contador de estaciones ya es cero (incluso puede ser menor que cero),
        ;;por que no bajo en la estacion anterior que le correspondia
        ifelse (pasajeros-descenso-conteo >  0) [

          ;;show (word "Tren: tenemos pasajeros para descender")
          ;;atributo del tren
          set descendiendo? true

          ;;el vagon tiene 4 puertas
          pasajeros-descenso-buffer
          pasajeros-descenso-buffer
          pasajeros-descenso-buffer
          pasajeros-descenso-buffer

        ]

        ;;PROCESO: ABORDANDO PLATAFORMA A VEHICULO
        [
          ;;No baja ningun pasajero en esta estacion
          set descendiendo? false
          ;;show (word "descendiendo?" descendiendo? )

          let pasajeros-en-estacion 0

          ask patch-at 0 -1 [
            ;;Todos son potenciales para subir, todos desean subir
            set pasajeros-en-estacion ( pasajeros-estacion-conteo )
          ]


          ifelse ( pasajeros-en-estacion = 0 )
          [
            set partiendo? true
          ]
          [
            ;;show (word "ABORDANDO ...4 puertas")
            pasajeros-ascenso-buffer
            pasajeros-ascenso-buffer
            pasajeros-ascenso-buffer
            pasajeros-ascenso-buffer

            ;;Partimos si ya llegamos a la capacidad maxima
            if ( #pasajeros >= train-capacity) [
              set partiendo? true
            ]

          ]
        ]


        ;;A partir de los tiempos de espera se establece partiendo como true, hacemos semaforo en verde
        if(partiendo?) [
          set tiempo-estacion 0
          set en-estacion? false

          ask agente-semaforo [
            set color green
            set semaforo-estado "verde"
          ]
        ]
      ];; Termina en estacion?=true y velicidad cero

      if(length mis-pasajeros > 0)[
        set mis-pasajeros-velocidad n-values length mis-pasajeros [un1]
        ;;show (word "mis-pasajeros-velocidad:" mis-pasajeros-velocidad);
      ]
    ];;Cierra ask
  ];;cierra for sort vehiculos

   ;;Genera nuevos pasajeros en las entradas
  foreach sort pasajeros [
    ask ? [
      pasajeros-arribo-buffer

    ]
  ]

  ;;Actualizamos los contadores de viaje
  pasajeros-tiempos-estacion-viaje

end







to vehiculos-tiempos-trayecto-viaje

  ifelse(terminal-inicio? = true and en-estacion?)[
    set en-trayecto? true
    ;;show (word "en-trayecto: inicia")
  ]
  [
    if(terminal-final? = true and partiendo?)[
      ;;Esto es por la inicializacion y que no cuente trayectos incompletos
      if(en-trayecto? = true)[
        set en-trayecto? false
        set almacena-dato-trayecto? true
      ]

      ;;show (word "en-trayecto: termina")
    ]
  ]

  ifelse(en-trayecto?)[
    set tiempo-viaje-vehiculo-total tiempo-viaje-vehiculo-total + 1
    ;;show (word "Tiempo-viaje-tren:" tiempo-viaje-vehiculo-total)

    if(en-estacion?)[
      set tiempo-viaje-vehiculo-estacion tiempo-viaje-vehiculo-estacion + 1
      set tiempo-viaje-vehiculo-local-estacion tiempo-viaje-vehiculo-local-estacion + 1
      ;;show (word "tiempo-estacion-vehiculo: " tiempo-viaje-vehiculo-estacion )
      set almacena-dato-estacion? true

      if(almacena-dato-interestacion?)[

        ;;if(tiempo-viaje-vehiculo-local-interestacion <
        ;;show (word "local-interestacion:" tiempo-viaje-vehiculo-local-interestacion)
        set datos-vehiculos-tiempo-local-interestacion sentence datos-vehiculos-tiempo-local-interestacion (precision ( (tiempo-viaje-vehiculo-local-interestacion * tao)  ) 2 )
        set tiempo-viaje-vehiculo-local-interestacion 0
        set almacena-dato-interestacion? false
      ]
    ]

    if(en-interestacion?)[
      set tiempo-viaje-vehiculo-interestacion tiempo-viaje-vehiculo-interestacion + 1
      set tiempo-viaje-vehiculo-local-interestacion tiempo-viaje-vehiculo-local-interestacion + 1
      ;;show (word "tiempo-interestacion: " tiempo-viaje-vehiculo-interestacion)

      set almacena-dato-interestacion? true

      if(almacena-dato-estacion?)[
        ;;show (word "local-estacion:" tiempo-viaje-vehiculo-local-estacion)
        set datos-vehiculos-tiempo-local-estacion sentence datos-vehiculos-tiempo-local-estacion (precision ( ( tiempo-viaje-vehiculo-local-estacion * tao) ) 2 )
        set tiempo-viaje-vehiculo-local-estacion 0
        set almacena-dato-estacion? false
      ]

    ]
  ]

  [

    if(almacena-dato-trayecto?)[
      ;;show (word "**almacena-trayecto****")
      ;;show (word "Tiempo-viaje-tren:" tiempo-viaje-vehiculo-total)
      ;;show (word "tiempo-estacion-vehiculo: " tiempo-viaje-vehiculo-estacion )
      ;;show (word "tiempo-interestacion: " tiempo-viaje-vehiculo-interestacion)

      set datos-vehiculos-tiempo-viaje-estacion sentence datos-vehiculos-tiempo-viaje-estacion (precision ((tiempo-viaje-vehiculo-estacion * tao)  ) 2 )
      set datos-vehiculos-tiempo-viaje-interestacion sentence datos-vehiculos-tiempo-viaje-interestacion (precision ( (tiempo-viaje-vehiculo-interestacion * tao )  ) 2 )
      set datos-vehiculos-tiempo-viaje-total sentence datos-vehiculos-tiempo-viaje-total (precision ( (tiempo-viaje-vehiculo-total * tao)  ) 2 )

      set tiempo-viaje-vehiculo-total 0
      set tiempo-viaje-vehiculo-estacion 0
      set tiempo-viaje-vehiculo-interestacion 0

      set almacena-dato-trayecto? false
    ]
  ]



end



;;Método con la unificacion de tiempos para el ascenso y descenso, es la implementación del algortimo
;;que se presento al final de la candidatura. Tiene un headway auto-organizante, y tiempo de permanencia en
;;estación relativo al tiempo de ascenso y descenso efectivo y las antiferomonas.
to method-self-organization-II

  ;;Analizamos todos los agentes reactivos, autonomos, o sea los vehiculos
  foreach sort vehiculos
  [
    ask ?
    [

      set label #pasajeros

      ;;Calculamos la velocidad respecto a los objetos, aqui tenemos un agente-semaforo o un agente-vehiculo
      procesa-objetos5

      ;;Calculamos la velocidad promedio den ventana de 20 minutos (1800*(2/3))
      ;;set velocidad-promedio sentence velocidad-promedio ( ( [Un1] of vehiculo id-vehiculo-atras + Un1 + [Un1] of vehiculo id-vehiculo-adelante ) / 3.0 )
      set velocidad-promedio sentence velocidad-promedio ( ([Un1] of vehiculo id-vehiculo-atras ))

      if (length velocidad-promedio > 1800)[
        set velocidad-promedio remove-item 0 velocidad-promedio
      ]

      ;;Si parte el vehiculo entonces tenemos que poner el estado del semaforo en rojo (para el siguiente)
      if (partiendo?)[
        ask agente-semaforo [
          set semaforo-estado "rojo"
          set color red
        ]

        set partiendo? false

        if(getVelocidad > 0)[
          set en-estacion? false
          set en-interestacion? true

          set tiempo-estacion  0
          set TE-estacion? true
          set TE-estacion 0
          set TE-descenso 0
          set TE-ascenso 0
          set TE-retraso 0
          set TE-retraso? true
        ]
      ]

      ;;Se actualizan los tiempos del viaje en estacion y trayecto
      pasajeros-tiempos-trayecto-viaje
      pasajeros-actualiza-trayecto-viaje

      ;;estoy "parado" en la estación, es decir tengo velocidad cero, Un1 = 0
      if ( estacion? and getVelocidad = 0) [

        ;;bandera para indentificar la poscion sobre la via
        set en-estacion? true
        set en-interestacion? false

        if(TE-estacion?)[

          ;;El peso que se le puede dar a los procesos
          let carga 1.0
          set TE-descenso ( ceiling ( pasajeros-descenso-conteo / 4) * ( carga ) ) ;;vamos a quitar la tao

          ;;if ( who = 0)[
          ;;  show (word "TE-descenso:" Te-descenso " Pasajeros-descenso-conteo:" pasajeros-descenso-conteo)
          ;;]

          let TE-ascenso-aux 0

          ask patch-at 0 -1 [
            ;;Todos son potenciales para subir, todos desean subir
            set TE-ascenso-aux ( ceiling ( pasajeros-estacion-conteo / 4 ) * ( carga ) )
          ]

          set TE-ascenso TE-ascenso-aux

          ;;Calcula el estimado de los tiempos, se divide entre 4 por las cuatro puertas que se modelan
          let ETAboard ( TE-descenso + TE-ascenso )
          ;;show (word "ETDescenso:" ETDescenso " ETAscenso:" ETAscenso)

          ;;Acotamos el tiempo de abordaje, ETAboard-max es el maximo tiempo que podria tener un descenso, asi
          ;;garantizamos que bajen todos.
          ifelse(ETAboard > 30 )[
            set ETAboard 30  ;; upper bound
            ;;beep
          ]
          [
            if(ETAboard < 5)[
              set ETAboard 5 ;; lower bound
            ]
          ]

          set TE-estacion ETAboard ;;+ tao ;;+ (2 * tao)  ;;Un segundo y medio mas, la mitad por la inicialización y la otra mitad de "colchon numerico"
          set TE-estacion? false
        ]

        if(who = 0)[
          ;;show (word "tiempo-estacion:" tiempo-estacion)
        ]

        ifelse((tiempo-estacion * tao ) <= TE-estacion or tiempo-compensacion)[

          ifelse(tiempo-estacion * tao <= TE-descenso)[
            ;;if(who = 0)[
            ;;  show (word "tiempo-estacion: " (tiempo-estacion * tao) " descendiendo-cuantos-faltan:" pasajeros-descenso-conteo )
            ;;]

            ;;Descenso de un pasajero de forma aleatoria, pero en cuatro puertas
            pasajeros-descenso-buffer
            pasajeros-descenso-buffer
            pasajeros-descenso-buffer
            pasajeros-descenso-buffer

            ;;if(who = 0)[
            ;;  show (word "tiempo-estacion:" (tiempo-estacion * tao) " descendiendo-cuantos-faltan-ahora:" pasajeros-descenso-conteo )
            ;;]

          ][

          if(who = 0)[
            ;;show (word "ascenso-pasajeros")
          ]
          ;;Aborda un pasajero con la nueva version de la funcion, aquí esta el contador
          pasajeros-ascenso-buffer
          pasajeros-ascenso-buffer
          pasajeros-ascenso-buffer
          pasajeros-ascenso-buffer
          ]

          set tiempo-compensacion false

;          if (bandera? and who = 0) [
;            show (word "*********mis-pasajeros: " mis-pasajeros)
;            ;show (word "         mis-pasajeros-tiempo-viaje: " mis-pasajeros-tiempo-viaje)
;            ;show (word "         mis-pasajeros-tiempo-estacion: " mis-pasajeros-tiempo-estacion)
;            ;show (word "         mis-pasajeros-tiempo-interestacion: " mis-pasajeros-tiempo-interestacion)
;            ;
;            set bandera? false
;          ]


        ]
        ;;Si ya se termino el tiempo
        [

          let ds-vehiculo-atras ( (Xn1 - ([Xn1] of vehiculo id-vehiculo-atras + [Sn] of vehiculo id-vehiculo-atras)) ) mod tamano-mundo-real
          ;;show (word "Mi id: " who  ", id-vehiculo-atras: " id-vehiculo-atras " distancia-vehiculo-atras:" ds-vehiculo-atras)

          let ETArrival ( ds-vehiculo-atras / (mean velocidad-promedio) )
          ;;show (word "ETArrival-afuera:" ETArrival)

;          let auto-headway 0
;
;          if(length [frecuencias] of monitor-headway > 0)[
;            set auto-headway min [frecuencias] of monitor-headway
;          ]
;
;          ;;Se acota el tiempo estimado de arrivo.
;          if( ETArrival >= auto-headway  )
;          [
;
;            ;;if(who = 0 or who = 1)[
;            ;;show (word "Se acota ** ETArrival:" ETArrival " auto-headway:" auto-headway)
;            ;;]
;
;            ;;set contadorAUTO contadorAUTO + 1
;            ;;show (word "contadorAUTO:" contadorAUTO)
;
;            set ETArrival auto-headway
;
;          ]
;          ;;[
;          ;;  set contadorETA contadorETA + 1
;          ;;  show (word "contadorETA:" contadorETA)
;          ;;]

          ;;let mi-antiferomona-adelante [antiferomona] of patch-at 1 0
          ;;let mi-antiferomona-atras [antiferomona] of patch-at -1 0

          let mi-antiferomona [antiferomona] of patch-at 1 0
          ;;let mi-antiferomona ( (mi-antiferomona-adelante + mi-antiferomona-atras) / 2.0 )

          ;;show (word "antiferomona-atras: " mi-antiferomona-atras "  antiferomona-adelante: " mi-antiferomona-adelante " mi-antiferomona: " mi-antiferomona)
          ;;let mi-feromona antiferomona-valor

          ;;show (word "mi-antiferomona" mi-antiferomona " ETArrival: " ETArrival)

          ifelse ( (mi-antiferomona * tao) >= ETArrival )
          [

;            if(TE-retraso?)[
;              set TE-retraso ( tiempo-estacion * tao ) + random-poisson ETAboard-noise-local
;              show(word "Set-Retraso:" TE-retraso)
;              set TE-retraso? false
;            ]
;
;            ifelse(tiempo-estacion * tao <= TE-retraso)[
;              show (word "Retraso:" tiempo-estacion )
;            ]
;            [
;              set partiendo? true
;            ]

            set partiendo? true

            if(who = 0 or who = 1)[
              ;;show (word "PARTO por antiferomona:" mi-antiferomona)
            ]

          ]
          [
            set tiempo-compensacion true;
            ;;show (word "Tiempo-compensacion:" tiempo-compensacion)
          ]
        ];; Termina else



        ;;A partir de los tiempos de espera se establece partiendo como true, hacemos semaforo en verde
        if(partiendo?) [

          set en-estacion? false
          set en-interestacion? true

          set tiempo-estacion  0
          set tiempo-compensacion false
          set TE-estacion? true
          set TE-estacion 0
          ;;Para ayuda
          set bandera? true

          ask agente-semaforo [
            set color green
            set semaforo-estado "verde"
          ]
        ]

        ;;se consume (2/3) de segundo.
        set tiempo-estacion ( tiempo-estacion + 1 )

      ];; Termina en estacion?=true y velocidad cero*************************

      if(length mis-pasajeros > 0)[
        set mis-pasajeros-velocidad n-values length mis-pasajeros [un1]
        ;;show (word "mis-pasajeros-velocidad:" mis-pasajeros-velocidad);
      ]

      vehiculos-tiempos-trayecto-viaje

    ];; Cierra ask ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ];; Cierra for sort vehiculos ;;;;;;;;;;;;;;;;;

  ;;Genera nuevos pasajeros en las entradas
  foreach sort pasajeros [
    ask ? [
      pasajeros-arribo-buffer

    ]
  ]

  ;;Actualizamos los contadores de viaje
  pasajeros-tiempos-estacion-viaje

  ;;show (word "pasajeros-estaciones-conteo-general:" pasajeros-estaciones-contador-general )
  ;;show (word "pasajeros-vehiculos-conteo-general:" pasajeros-vehiculos-contador-general )


end





;;Método con la unificacion de tiempos para el ascenso y descenso, es la implementación del algortimo
;;que se presento al final de la candidatura. Tiene un headway auto-organizante, y tiempo de permanencia en
;;estación relativo al tiempo de ascenso y descenso efectivo y las antiferomonas.
to method-general-cdmx

  ;;Analizamos todos los agentes reactivos, autonomos, o sea los vehiculos
  foreach sort vehiculos
  [
    ask ?
    [

      set label #pasajeros

      ;;1. Calculamos la velocidad respecto a los objetos, aqui tenemos un agente-semaforo o un agente-vehiculo
      procesa-objetos5

      ;;Si parte el vehiculo entonces tenemos que poner el estado del semaforo en rojo (para el siguiente)
      if (partiendo?)[
        ask agente-semaforo [
          set semaforo-estado "rojo"
          set color red
        ]

        if(getVelocidad > 0)[
          set en-estacion? false
          set en-interestacion? true
          set tiempo-estacion  0
          set TE-estacion? true
          set TE-estacion 0

          set TE-descenso 0
          set TE-ascenso 0
          set TE-retraso 0

        ]

        set partiendo? false
      ]


      ;;Se actualizan los tiempos del viaje en estacion y trayecto
      pasajeros-tiempos-trayecto-viaje
      pasajeros-actualiza-trayecto-viaje

      ;;estoy "parado" en la estación, es decir tengo velocidad cero, Un1 = 0
      if ( estacion? and getVelocidad = 0) [

        ;;bandera para indentificar la poscion sobre la via
        set en-estacion? true
        set en-interestacion? false

        ;;Calculamos el Tiempo Estimado de Abordaje con la primera iteracion
        if(TE-estacion?)[

          ;;El peso que se le puede dar a los procesos
          let carga 1.0
          set TE-descenso ( ceiling ( pasajeros-descenso-conteo / 4) * (  carga ) )

          ;;if ( who = 0)[
          ;;  show (word "TE-descenso:" Te-descenso " Pasajeros-descenso-conteo:" pasajeros-descenso-conteo)
          ;;]

          let TE-ascenso-aux 0

          ask patch-at 0 -1 [
            ;;Todos son potenciales para subir, todos desean subir
            set TE-ascenso-aux ( ceiling ( pasajeros-estacion-conteo / 4 ) * (  carga ) )
          ]

          set TE-ascenso TE-ascenso-aux

          ;;Calcula el estimado de los tiempos, se divide entre 4 por las cuatro puertas que se modelan
          let ETAboard ( TE-descenso + TE-ascenso )
          ;;show (word "ETDescenso:" ETDescenso " ETAscenso:" ETAscenso)

          ;;let ETAboard-max-local 140 ;;segundos
          ;;let ETAboard-min-local 22 ;;segundos
          ;;let ETAboard-noise-local 30 ;;segundos

          ;;Mas o menos funciona: 100,24,15 ->
          ;;(100,45,5) correlacion 0.8213
          ;;(255,19,36) correlacion-evento=0.6977; correlacion-general=0.8986
          ;;(140,22,36) correlacion-evento=; correlacion-general=0.8795
          ;;(117,24,29) correlacion-evento=; correlacion-general=0.86101
          ;;(81,21,11) correlacion-evento=; correlacion-general=
          ;;Mejor (140,22,36) con velocidad 13 y 16 trenes = 0.8951; considerando los ultimos 300

          ;;Acotamos el tiempo de abordaje, ETAboard-max es el maximo tiempo que podria tener un descenso, asi
          ;;garantizamos que bajen todos.
          ifelse(ETAboard > ETAboard-max)[
            set ETAboard ETAboard-max
            ;;set ETAboard ETDescenso
            ;;beep
          ]
          [
            if(ETAboard < ETAboard-min )[
              set ETAboard ETAboard-min
              ;;show (word "ETAboard 0 y 8: ")
            ]
          ]
          ;;show (word "Poisson: " rpoisson )
          ;;Se establece el tiempo-estimado-estacion = tiempo-estimado de abordaje + ruido distribuido poisson 10;
          set TE-estacion ETAboard ;;+ rpoisson

          set TE-retraso TE-estacion + random-poisson ETAboard-noise ;;son se

          ;;show (word "T-estacion: " TE-estacion)
          set TE-estacion? false

        ]


        ;;show (word "TEAbordaje:" TEAbordaje " Descenso: " (ETDescenso / 4) "  Ascenso:" (ETAscenso / 4) "  ETAboard:" ETAboard)
        ;;show (word "tiempo-estacion:" tiempo-estacion)

        ifelse((tiempo-estacion * tao ) <= TE-estacion)[


          ifelse(tiempo-estacion * tao <= TE-descenso)[
            ;;Descenso de un pasajero de forma aleatoria, pero en cuatro puertas
            pasajeros-descenso-buffer
            pasajeros-descenso-buffer
            pasajeros-descenso-buffer
            pasajeros-descenso-buffer
          ]
          [
            ;;Aborda un pasajero con la nueva version de la funcion, aquí esta el contador
            pasajeros-ascenso-buffer
            pasajeros-ascenso-buffer
            pasajeros-ascenso-buffer
            pasajeros-ascenso-buffer
          ]

;          if (bandera? and who = 0) [
;            show (word "*********mis-pasajeros: " mis-pasajeros)
;            ;show (word "         mis-pasajeros-tiempo-viaje: " mis-pasajeros-tiempo-viaje)
;            ;show (word "         mis-pasajeros-tiempo-estacion: " mis-pasajeros-tiempo-estacion)
;            ;show (word "         mis-pasajeros-tiempo-interestacion: " mis-pasajeros-tiempo-interestacion)
;            set bandera? false
;          ]

        ]
        ;;Si ya se termino el tiempo
        [
          ifelse(tiempo-estacion * tao <= TE-retraso)[
            ;;show (word "Retraso:" tiempo-estacion )
          ]
          [
            set partiendo? true
          ]
        ];; Termina else


        ;;A partir de los tiempos de espera se establece partiendo como true, hacemos semaforo en verde
        if(partiendo?) [
          ;;Para ayuda
          set bandera? true

          ask agente-semaforo [
            set color green
            set semaforo-estado "verde"
          ]
        ]

        ;;se consume (2/3) de segundo.
        set tiempo-estacion ( tiempo-estacion + 1 )

      ];; Termina en estacion?=true y velocidad cero

      if(length mis-pasajeros > 0)[
        set mis-pasajeros-velocidad n-values length mis-pasajeros [un1]
        ;;show (word "mis-pasajeros-velocidad:" mis-pasajeros-velocidad);
      ]

      ;;calcula los tiempos de viaje o de trayecto
      vehiculos-tiempos-trayecto-viaje

    ];; Cierra ask ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ];; Cierra for sort vehiculos ;;;;;;;;;;;;;;;;;

  ;;Genera nuevos pasajeros en las entradas
  foreach sort pasajeros [
    ask ? [
      pasajeros-arribo-buffer

    ]
  ]

  ;;Actualizamos los contadores de viaje
  pasajeros-tiempos-estacion-viaje

  ;;show (word "pasajeros-estaciones-conteo-general:" pasajeros-estaciones-contador-general )
  ;;show (word "pasajeros-vehiculos-conteo-general:" pasajeros-vehiculos-contador-general )


end





;;Método con la unificacion de tiempos para el ascenso y descenso, es la implementación del algortimo
;;que se presento al final de la candidatura. Tiene un headway auto-organizante, y tiempo de permanencia en
;;estación relativo al tiempo de ascenso y descenso efectivo y las antiferomonas.
to metodo-demanda-pasajeros

  ;;Analizamos todos los agentes reactivos, autonomos, o sea los vehiculos
  foreach sort vehiculos
  [
    ask ?
    [
      set tiempo-viaje-vehiculo-total tiempo-viaje-vehiculo-total + 1
      set label #pasajeros

      ;;1. Calculamos la velocidad respecto a los objetos, aqui tenemos un agente-semaforo o un agente-vehiculo
      procesa-objetos5

      set vel-promedio vel-promedio +  ( ( [Un1] of vehiculo id-vehiculo-atras + Un1 + [Un1] of vehiculo id-vehiculo-adelante ) / 3.0 )
      ;;show (word "vel-promedio: " vel-promedio " entre tick:" ticks " : " (vel-promedio / (ticks + 1)))

      ;;show (word "Antiferomona-tren: " antiferomona-valor)
      ;;show (word "Antiferomona-ambiente:" antiferomona)

      ;;Si parte el vehiculo entonces tenemos que poner el estado del semaforo en rojo (para el siguiente)
      if (partiendo?)[
        ask agente-semaforo [
          set semaforo-estado "rojo"
          set color red
        ]

        set partiendo? false
      ]

      ;;estoy "parado" en la estación, es decir tengo velocidad cero, Un1 = 0
      if ( estacion? and getVelocidad = 0) [

        ;;bandera para indentificar "algo"
        set en-estacion? true

        ;;El peso que se le puede dar a los procesos
        let carga 1.0

        let ETDescenso ( (count pasajeros-here with [estaciones-para-destino <= 0]) * tao * carga)
        let ETAscenso  ( (count pasajeros-at 0 -1) * tao * carga )

        ;;Calcula el estimado de los tiempos, se divide entre 4 por las cuatro puertas que se modelan
        let ETAboard (( ETDescenso + ETAscenso ) / 4.0);


        ;;Acotamos los tiempos
        ifelse(ETAboard > ETAboard-max)[
          set ETAboard ETAboard-max
          ;;set ETAboard ETDescenso
          ;;beep
        ]
        [
          if(ETAboard = 0)[
            set ETAboard 3;
          ]
        ]

        ;;Calculamos el Tiempo Estimado de Abordaje con la primera iteracion
        if(TE-estacion?)[
          set TE-estacion ETAboard + (2 * tao) ;;Un segundo y medio mas, la mitad por la inicialización y la otra mitad de "colchon numerico"
          set TE-estacion? false
        ]


;        if (bandera? and who = 0) [
;            ask pasajeros-here[
;              show (word "*********************estaciones-para-destino:" estaciones-para-destino)
;              ]
;            set bandera? false
;        ]

        ;;se consume (2/3) de segundo.
        set tiempo-estacion ( tiempo-estacion + tao )



        ;;show (word "TEAbordaje:" TEAbordaje " Descenso: " (ETDescenso / 4) "  Ascenso:" (ETAscenso / 4) "  ETAboard:" ETAboard)
        ;;show (word "tiempo-estacion:" tiempo-estacion)

        ifelse(tiempo-estacion <= TE-estacion or tiempo-compensacion)[

          ;;Descenso de un pasajero de forma aleatoria, pero en cuatro puertas
          descenso-pasajeros
          descenso-pasajeros
          descenso-pasajeros
          descenso-pasajeros

          ;;Aborda un pasajero con la nueva version de la funcion, aquí esta el contador
          ascenso-pasajeros
          ascenso-pasajeros
          ascenso-pasajeros
          ascenso-pasajeros


          set tiempo-compensacion false


        ]
        ;;Si ya se termino el tiempo
        [

            set partiendo? true

        ];; Termina else



        ;;A partir de los tiempos de espera se establece partiendo como true, hacemos semaforo en verde
        if(partiendo?) [
          set tiempo-estacion  0
          set tiempo-compensacion false
          set en-estacion? false
          set TE-estacion? true
          set TE-estacion 0
          ;;Para ayuda
          set bandera? true

          ask agente-semaforo [
            set color green
            set semaforo-estado "verde"
          ]
        ]


      ];; Termina en estacion?=true y velocidad cero

      ;;Ya al final de preguntarle a un tren
      foreach sort pasajeros [
        ask ? [
          if (en-vehiculo?)[
            set velocidad-pasajero [un1] of vehiculo id-vehiculo
          ]
        ]
      ]

    ];;Cierra ask
  ];;cierra for sort vehiculos

  ;;Ahora si hay estaciones establecidas, crea la dinamica de los pasajeros
  if(set-estaciones?)[

    ;;Genera nuevos pasajeros en las entradas
    foreach sort entradas [
      ask ? [
        nuevos-pasajeros ;;estaciones-faltantes
      ]
    ]

    ;;Dinamica del pasajero
    foreach sort pasajeros [
      ask ? [
        go-pasajero
      ]
    ]
  ]

end







to actualiza-vias-antiferomonas ;;self-org-local

 ;;show (word "Actualiza-self-org")

 foreach sort vehiculos
   [
     ask ?
     [

       ;;show (word "quien?:" who " Un1:" Un1 " antiferomona:" antiferomona " antiferomona-valor:" antiferomona-valor)

       if Un1 > 0[

         if ([antiferomona] of patch-here > 0)[
           set antiferomona-valor [antiferomona] of patch-here
           ;;show (word "antiferomona-valor:" antiferomona-valor)
         ]
         ;;Si estoy entrando a una region con un valor de antiferomona, lo almaceno, por que despues lo voy a borrar,
         ;;esto me sirve para saber cual es el valor que tenia si tengo que pararme
         ;;ifelse([antiferomona] of patch-here > 0 and almacena-feromona?)[
         ;;  set antiferomona-valor [antiferomona] of patch-here
         ;;  set almacena-feromona? false
         ;; ]
         ;; [
         ;;set antiferomona 0
         ;; ]
       ]
     ]
   ]


  ;;inicio-feromona true

  ask vias[

;;Algoritmo 1. para la inicialización, se activa siempre  y cuando pase un tren
;    if(count vehiculos-here > 0 and activa-antiferomona? = false )[
;      set activa-antiferomona? true
;    ]
;
;    ifelse(activa-antiferomona?)[
;
;      ifelse(count vehiculos-here = 0)[
;        set antiferomona (antiferomona + ( tao * 1.0))
;      ]
;      [
;        set antiferomona 0
;      ]
;
;    ]
;    ;;Si activa-antiferomona = false
;    [
;          set antiferomona 0
;    ]

;;Algoritmo 2. Se incrementa la feromona al arrancar la simulación
    ;;Si no hay vehiculos sobre la la via entones incrementa la feromona
    ifelse ( count vehiculos-here = 0 ) [
      set antiferomona (antiferomona + 1.0 )  ;;( tao * 1.0 ) )

      ;;set antiferomona (antiferomona + ( tao * antiferomona-carga ) )
      ;;if(antiferomona >
      ;;set antiferomona-carga 1 ;;antiferomona-carga + 0.01
    ]
    [
      ;;si no, no crece la antriferomona
      set antiferomona 0
      ;;set antiferomona-carga 0
    ]

    ;;Probablemente los tiempos llegan a feromona = 100 o 120, para tener la gama de verde
    ;;debe estar entre [0,10]
    ;;set pcolor green + 5 + (antiferomona / 15)
    ;;show (word "pcolor-antiferomona: " pcolor )

  ];;ask vias

    ask estaciones [

      ifelse(antiferomona = 0 )[
        set pcolor 4
      ][
        set pcolor green + 5 + ( ( antiferomona + 4 ) / 30)
      ]
    ]

end






to go

  actualiza-velocidad-rojo

  ;;Show grid for debug, is slow ....
  ;;if muestra-cuadricula? [ setup-cuadricula ]

  ask vias [
    set pcolor gray - 1
  ]

  ask monitor-headway [
    set pcolor 23

    ask patch-at 0 -1 [
      set pcolor 25
    ]

    ask patch-at 0 1 [
      set pcolor 25
    ]
  ]


  ;;Experiment, varying parameter space (Tmin, Tmax, Lambda_delay)
  ifelse(set-experiment = "space-cdmx")[
    if(ejecuta-experimento?)[
      itera-cdmx-transitorios
    ]
  ]

  [
  ;;show (word "Experiment, varying lambda parameter space )
  ifelse(set-experiment = "space-lambda-pass")[
    if(ejecuta-experimento?)[
      itera-densidad-pasajeros-transitorios
    ]
  ]
  [
    if(set-experiment = "none")[

      if (method = "general-cdmx")[
        method-general-cdmx
      ]

      if(method = "self-organization-II")[
        method-self-organization-II
        actualiza-vias-antiferomonas

        if (inicializa-self-org-local-headway?)[
          ;;inicializa los datos del headway
          ask monitor-headway [
            set frecuencias []
            set frecuencias-tiempo []
            set ultimo-tren -1
            set tiempo-desde-ultimo-tren 0
          ]

          set inicializa-self-org-local-headway? false
          show(word "inicializa-headway")
        ]
      ]

    ]
  ]
  ]

  actualiza-listas

  if(graph?)[
    actualiza-monitores-interfaz
  ]

;  ;;Simulado falla mecanica despues de 2:00 hrs de servicio, se
;  ;;para el tren 1 (rojo) durante 15 minuntos y después reinicia el servicio
;  ifelse( tiempo-real > 120 and tiempo-real < 135)
;  [
;    show (word "Tren rojo parado")
;
;    set velocidad-rojo 0
;
;  ]
;  [
;    set velocidad-rojo 13
;     show (word "Tren rojo avanza")
;  ]

  tick

end


;;inicializa la listas
to setup-listas

  set pasajeros-entrada-promedio n-values ventana-tiempo [0]

  set distancias-entre-trenes []

  ;;para los datos de los pasajeros
  set datos-viaje-pasajeros []
  set datos-espera-pasajeros []
  ;;set datos-salida-pasajeros []
  ;;set datos-entrada-pasajeros []

  ;;para los datos de los vehiculos
  set datos-vehiculos-tiempo-viaje-estacion []
  set datos-vehiculos-tiempo-viaje-interestacion []
  set datos-vehiculos-tiempo-viaje-total []

  ;;Para los datos locales de los vehiculos
  set datos-vehiculos-tiempo-local-estacion []
  set datos-vehiculos-tiempo-local-interestacion []

  ;;inicializa los datos del headway
  ask monitor-headway [
    set frecuencias []
    set frecuencias-tiempo []
    set ultimo-tren -1
    set tiempo-desde-ultimo-tren 0
  ]

  ;;La desviación estandar de las frecuencias
  set stddevs-frecuencias []

  ;;La desviación estandar de las distancias
  set stddevs-distancias []

end



to actualiza-listas
  ;;set passenger-avgs replace-item (ticks mod avg-range) passenger-avgs (count passengers-on entrances)
  set pasajeros-entrada-promedio replace-item (ticks mod ventana-tiempo) pasajeros-entrada-promedio (count pasajeros-on entradas)
  ;;ventana velocidad-promedio-pasajeros
  ;;set vpp-tiempo replace-item (ticks mod pp-ventana) vpp-tiempo velocidad-promedio-pasajeros
  ;;set dpp-tiempo replace-item (ticks mod pp-ventana) dpp-tiempo densidad-promedio-pasajeros


  ;;Calcula los headways
  if(update-graphs > 0)[

    ask monitor-headway [

      ;;Si hay un vehiculo aqui, entonces guardamos el identificador,
      ;;el proceso es el siguiente:
      ;;Entra el agente al parche, hasta que lo "sensa", guarda identificador,
      ifelse any? vehiculos-here [

        ;;show (word "siii hay tren:" [who] of one-of vehiculos-here " ultimo-tren:" ultimo-tren)

        ;;Entra solo una vez, cuando el arriva un nuevo tren al parche y tiene el registro del anterior,
        ;;despues hacemos el "id" del ultimo-tren el que arrivó, y ya no se cumplira la condición.
        if ( ([who] of one-of vehiculos-here) != ultimo-tren ) [

          ;;empieza a almacenar cuando hay identificadores validos.
          if ( ultimo-tren >= 0 ) [
            ;;show (word "almacena la frecuencia")
            set frecuencias sentence frecuencias ( precision  ( ( tiempo-desde-ultimo-tren * tao ) )  2 )
            set frecuencias-tiempo sentence frecuencias-tiempo tiempo-real
            ;;show (word "tiempo-real:" tiempo-real)

            if(length frecuencias > tamano-max-frecuencias)[
              set frecuencias remove-item 0 frecuencias
            ]
          ]

          set ultimo-tren [who] of one-of vehiculos-here
          set tiempo-desde-ultimo-tren 0
        ]
        ;;cuenta dentro del parche, antes no lo tenia, me como tiempo....
        ;;set tiempo-desde-ultimo-tren (tiempo-desde-ultimo-tren + 1)
      ]

      [
        ;;show (word "no hay tren")
        ;;show (word "tiempo-desde-ultimo-tren:" tiempo-desde-ultimo-tren)
        set tiempo-desde-ultimo-tren (tiempo-desde-ultimo-tren + 1)
      ]
    ]
  ]

  ;;calculamos los datos acumulados cada 100 ticks = (100 * tao) = (100*(2/3)) = 1.1 min
  if (update-graphs > 0) and (ticks mod update-graphs = 0)[

    ;;Primero calculamos las distancias entre los trenes, agregamos a la lista cada (ticks mod actualiza-histo)
    foreach sort vehiculos
    [
      ask ?
      [
        let ds-vehiculo-adelante ( ([Xn1] of vehiculo id-vehiculo-adelante - (Xn1 + Sn)) ) mod tamano-mundo-real

        set distancias-entre-trenes sentence distancias-entre-trenes round ds-vehiculo-adelante

      ]
    ]

    ;;Calculamos la desviación estandar de la lista de distancias
    if length distancias-entre-trenes >= 2[
      set stddevs-distancias sentence stddevs-distancias standard-deviation distancias-entre-trenes
    ]

    ;;Calculas la desviación estandar de la lista de headways.
    if (length [frecuencias] of monitor-headway) >= 2 [
      set stddevs-frecuencias sentence stddevs-frecuencias standard-deviation [frecuencias] of monitor-headway
    ]


    ;;set datos-salida-pasajeros sentence datos-salida-pasajeros #pasajeros-salida
    ;;set datos-entrada-pasajeros sentence datos-entrada-pasajeros #pasajeros-entrada

    ;;set stddevs-capacities sentence stddevs-capacities standard-deviation capacities
  ]


end

to get-headway-datos

;;let ordenado map round ( sort [frecuencias] of monitor-headway )

let ordenado ( sort [frecuencias] of monitor-headway )

let indice 0
let contador 1

;;show (word "ordendado" ordenado)

;;show (word "desviacion-estandar" standard-deviation ordenado )
;;show ( word "desviacion-estandar" standard-deviation [1 1 1 1 1 1 1 1 1 1 2] )

while[ indice < length ordenado ]
[

  let elemento-actual item indice ordenado
  let elemento-siguiente item ( (indice  + 1) mod (length ordenado) ) ordenado

  ;;show (word "elemento-actual:" elemento-actual " elemento-siguiente:" elemento-siguiente)

  ifelse( elemento-actual = elemento-siguiente ) [
    set contador (contador + 1)
    ;;show (word "son iguales:" contador)
  ]
  [
    ;;Si el contador actual es mayor que el anterior maximo entonces hemos encontrado un nuevo elemento maximo
    ifelse( headway-contador-maximo < contador)[
      set headway-elemento-maximo elemento-actual
      set headway-contador-maximo contador
      ;;show (word "establecemos el contador-maximo")
      set contador 1
    ]
    [
      ;;Si no, no sirve e incializamos el contador
      set contador 1
    ]
  ]

  ;;show (word "lput" item indice ordenado)
  set indice (indice + 1)
]

;;show (word "elemento-maximo:" max ordenado)
;;show (word "elemento-minimo:" min ordenado)
;;show (word "elemento-mas-repetido:" elemento-maximo " repetido:" contador-maximo)

end



to actualiza-monitores-interfaz

  if(tiempo > #transitorios)
  [
    ;;Grafica velocidad de vehiculos
    ;;set-current-plot "Average vehicle speed"
    ;;set-current-plot-pen "average"
    ;;plot mean [Un1] of vehiculos

    ;;esto fue para generar la serie y graficar
    ;;show (word (ticks * tao) " " [Un1] of vehiculo-rojo)

    ;;set-current-plot-pen "accumulated"
    ;;if(tiempo-vehiculos > 0)[
    ;;  plot ((velocidad-promedio-vehiculos) / tiempo-vehiculos)
    ;;]

    ;;Grafica velocidad de pasajeros
    ;;set-current-plot "Average passenger speed"
    ;;set-current-plot-pen "average-system"

    ;;if (pasajeros-contador-general > 0)[
    ;;  plot pasajeros-velocidad-promedio-general

      ;;mean [velocidad-pasajero] of pasajeros
    ;;]

    ;;set-current-plot-pen "accumulated-system"
    ;;if (pasajeros-contador-general > 0)[
    ;;  if(tiempo-pasajeros > 0)[
    ;;    plot (velocidad-promedio-pasajeros / tiempo-pasajeros)
    ;;  ]
    ;;]

    ;;set-current-plot-pen "accumulated-train"
    ;;if( pasajeros-vehiculos-contador-general > 0) [
    ;;  if(tiempo-pasajeros-tren > 0 )[
    ;;    plot ( velocidad-promedio-pasajeros-tren / tiempo-pasajeros-tren)
    ;;  ]
    ;;]

    ;;Grafica Densidad pasajeros
    ;;set-current-plot "#pasajeros"

    ;;set-current-plot-pen "conteo-en-sistema"
    ;;if(pasajeros-contador-general > 0)[
    ;;  plot (pasajeros-contador-general)
    ;;]

    ;;set-current-plot-pen "conteo-en-tren"
    ;;if(pasajeros-contador-general > 0 )[
    ;;  plot (pasajeros-vehiculos-contador-general)
    ;;]

    ;;set-current-plot-pen "promedio-acumulado-sistema"
    ;;if(pasajeros-contador-general > 0 )[
    ;;  if(tiempo-pasajeros > 0)[
    ;;    plot (densidad-promedio-pasajeros-sistema  / tiempo-pasajeros)
    ;;  ]
    ;;]

    ;;set-current-plot-pen "promedio-acumulado-tren"
    ;;if(pasajeros-contador-general > 0 )[
    ;;  if(tiempo-pasajeros > 0 )[
    ;;    plot (densidad-promedio-pasajeros-tren / tiempo-pasajeros)
    ;;  ]
    ;;]

  ];;cierra transitorio

  if(sistema-flujo-temporal != [] )[
    ;;set-current-plot "System Flow"
    ;;set-current-plot-pen "internal"
    ;;plotxy mean sistema-densidad-temporal mean sistema-flujo-temporal
    ;;plotxy ticks mean sistema-flujo-temporal
  ]


  if (datos-pasajeros-tiempo-viaje != [])[
    ;;Grafica Viaje
    set-current-plot "Travel Time Passengers"
    set-current-plot-pen "travel"
    plotxy ticks  mean datos-pasajeros-tiempo-viaje
    set-current-plot-pen "station"
    plotxy ticks mean datos-pasajeros-tiempo-estacion
    set-current-plot-pen "interstation"
    plotxy ticks mean datos-pasajeros-tiempo-interestacion
    set-current-plot-pen "delay"
    plotxy ticks mean datos-pasajeros-tiempo-espera

    ;;show(word "longitud datos-pasajeros-tiempo-viaje:" length datos-pasajeros-tiempo-viaje)

    ;;show (word "datos-pasajeros-tiempo-viaje:" datos-pasajeros-tiempo-viaje)
    ;;show (word "datos-pasajeros-tiempo-espera:"datos-pasajeros-tiempo-espera)
    ;;show (word "datos-pasajeros-tiempo-estacion:"datos-pasajeros-tiempo-estacion)
    ;;show (word "datos-pasajeros-tiempo-interestacion:"datos-pasajeros-tiempo-interestacion)

  ]

  ; plot histograms
  if (update-graphs > 0) and (ticks mod update-graphs = 0)[

    if datos-pasajeros-tiempo-espera != [][
      set-current-plot "Passengers Waiting Station"
      set-current-plot-pen "default"
      histogram datos-pasajeros-tiempo-espera
    ]

    ;;tiempo estacion local
    if datos-vehiculos-tiempo-local-estacion != [][
      set-current-plot "Trains Time Station"
      set-current-plot-pen "default"
      histogram datos-vehiculos-tiempo-local-estacion
    ]

    ;;tiempo interestacion local
    if datos-vehiculos-tiempo-local-interestacion != [][
      set-current-plot "Trains Time Interstation"
      set-current-plot-pen "default"
      histogram datos-vehiculos-tiempo-local-interestacion
    ]

    if datos-vehiculos-tiempo-viaje-estacion != [][
      ;;set-current-plot "Trains trip time station"
      ;;set-current-plot-pen "default"
      ;;histogram datos-vehiculos-tiempo-viaje-estacion
    ]

    if datos-vehiculos-tiempo-viaje-interestacion != [][
      ;;set-current-plot "Trains trip time interstation"
      ;;set-current-plot-pen "default"
      ;;histogram datos-vehiculos-tiempo-viaje-interestacion
    ]

    if datos-vehiculos-tiempo-viaje-total != [][
      ;;set-current-plot "Trains trip time travel"
      ;;set-current-plot-pen "station"
      ;;plotxy ticks mean datos-vehiculos-tiempo-viaje-estacion
      ;;set-current-plot-pen "interstation"
      ;;plotxy ticks mean datos-vehiculos-tiempo-viaje-interestacion
      ;;set-current-plot-pen "total"
      ;;plotxy ticks mean datos-vehiculos-tiempo-viaje-total

    ]


    if (promedio-conteo-sistema-entrada-temporal != [] and promedio-conteo-sistema-salida-temporal != [] )[
      set-current-plot "Passengers Flow"
      ;;set-current-plot-pen "entrance"
      ;;plotxy ticks conteo-sistema-entrada-temporal
      set-current-plot-pen "entrance-mean"
      plotxy ticks mean promedio-conteo-sistema-entrada-temporal

      ;;sum [pasajeros-estacion-conteo] of entradas

      ;;set-current-plot-pen "exit"
      ;;plotxy ticks conteo-sistema-salida-temporal
      set-current-plot-pen "exit-mean"
      plotxy ticks mean  promedio-conteo-sistema-salida-temporal
    ]


    ;;Histograma de distancias entre los trenes
    set-current-plot "Intertrain Distance"
    set-current-plot-pen "default"
    histogram distancias-entre-trenes

    ;;Histograma de headways entre los trenes
    set-current-plot "Headway Distribution";;"Intertrain Frequencies"
    set-current-plot-pen "default"
    ask monitor-headway [
      histogram frecuencias
    ]

    ;;Grafica de la desviación estandar de las distnacias entre los trenes
    if ( length distancias-entre-trenes >= 2) [
      set-current-plot "Intertrain Distances Std Deviation"
      set-current-plot-pen "default"
      plotxy ticks standard-deviation distancias-entre-trenes

      if length stddevs-distancias > 0[
        set-current-plot-pen "avg"
        plotxy ticks  mean stddevs-distancias
      ]
    ]

    ;;Grafica de la desviación estandar de los headways
    ask monitor-headway [

      if (length frecuencias >= 2) [
        set-current-plot "Headway Std Deviation"
        set-current-plot-pen "default"
        plotxy ticks  standard-deviation frecuencias
      ]

      if (length stddevs-frecuencias > 0) [
        set-current-plot-pen "avg"
        plotxy ticks mean stddevs-frecuencias
      ]
    ]

  ]



end


;;Son los posibles casos de los pasajeros, cuanto esta en la salida, es decir ya bajo del vehiculo,
;;cuando esta en la entrada, se prepara para abordar,
;;cuando esta en el tren
to go-pasajero-estacion

  if entrada?
  [
    ;;por cada tick aumentamos el tiempo
    set tiempo-viaje-pasajero tiempo-viaje-pasajero + 1

    set tiempo-estacion tiempo-estacion + 1
    ;;set delayst delayst + 1
    set label count pasajeros-here
  ]

end


to go-pasajero

  ;;por cada tick aumentamos el tiempo
  set tiempo-viaje-pasajero tiempo-viaje-pasajero + 1

  ;;si esta en el parche con bandera exit=true, muere despues
  if salida?
  [
    set #pasajeros-salida #pasajeros-salida + 1

    set datos-viaje-pasajeros sentence datos-viaje-pasajeros ( precision ( (tiempo-viaje-pasajero * tao) / 60) 2 )
    set datos-espera-pasajeros sentence datos-espera-pasajeros ( precision ( (tiempo-espera * tao) / 60) 2 )
    ;;show (word "datos viaje pasajeros:" datos-viaje-pasajeros)

    ;;set data-wait-passengers sentence data-wait-passengers delay
    ;;set data-entrances sentence data-entrances delayst
    ;;set data-trains sentence data-trains delaytr
    ;;set data-exits sentence data-exits delayex
    die
  ]

  ifelse entrada?
  [
    set tiempo-espera tiempo-espera + tao
    ;;set delayst delayst + 1
    set label count pasajeros-here
  ]

  [
    set label ""
  ]

  ;;Si el pasajero esta en el tren y el tren esta en una estacion
  ifelse en-vehiculo?
  [
    ;;show (word "Esta la persona " who ": en el vehiculo")
    ifelse estacion?
    [
      ;;show (word "go-pasajero, esta la persona " who ": en el vehiculo y en la estacion " pxcor)

      ;;Esto en modo continuo es un poco forzado, voy llegando a la estacion con un pxcor(anterior), cuando ocupo el parche con mas de .5,
      ;;entonces consideramos que estoy en estacion? = true, entonces entramos al caso "else" decrementamos
      ifelse ultima-estacion = pxcor
      [
        set tiempo-espera tiempo-espera + 1

        ifelse estaciones-para-destino = 0
        [
          ;;set delayex delayex + 1
        ]
        [
          ;;set delaytr delaytr + 1
        ]
      ]

      [
        set ultima-estacion pxcor
        set estaciones-para-destino estaciones-para-destino - 1
        ;;show (word "go-pasajero, estaciones-para-destino:" estaciones-para-destino)
        ;ready to exit when stations-to-destination <= 0, see exit-train procedure
      ]
    ]
    [
      ;;otro caso que aun no lo tengo considerado
    ]
  ]
  [
    ;;show (word "Pasajero en plataforma")
  ]


end

to mensaje [ mi-mensaje ]
  show (word "********************************************************************")
  show (word "********** " mi-mensaje " **********")
  show (word "********************************************************************")
end





to-report Gipps-vehiculo [ mi-agente-vehiculo mi-ds-vehiculo]

  let velocidad 0

  ifelse mi-ds-vehiculo >= 0.0
  [
    set Ga Ga-velocidad
    set Gd Gd-velocidad-vehiculo mi-agente-vehiculo mi-ds-vehiculo

    ;Si la parte de la aceleración es menor que la parte de la desaceleracion
    ifelse  Ga < Gd
    [
      set velocidad Ga
      ;;***show (word "Caso 4 vehiculo enfrente = se aplica Ga por que Ga: " Ga " < Gd: " Gd)
    ]

    ;;En el caso contrario
    [
      set velocidad Gd
      ;;***show (word "Caso 4 vehiculo enfrente = se aplica Gd por que Ga: " Ga " > Gd: " Gd)
    ]
  ]

  ;; Caso de emergencia estoy violando la distancia de seguridad
  [
    show (word "********************************************************************************************************")
    show (word "En vehiculo = frenado de Emergencia, velocidad cero! ")
    show (word "********************************************************************************************************")
    beep
    ;;set Un2 0
    ;;Set Un1 0
  ]

  report velocidad

end

to-report Gipps-semaforo [ mi-agente-semaforo mi-distancia-semaforo ]

  let velocidad 0

  ifelse mi-distancia-semaforo >= 0
  [
    ;;Si hay un auto calculamos las dos, tenemos que ver como se comporta para decidir
    set Ga Ga-velocidad
    set Gd Gd-velocidad-objeto mi-distancia-semaforo

    ;Si la parte de la aceleración es menor que la parte de la desaceleracion
    ifelse  Ga < Gd
    [
      set velocidad Ga
      ;;show (word "Caso 3 Semaforo rojo = se aplica Ga por que Ga: " Ga " < Gd: " Gd)
    ]
    [
      set velocidad Gd
      ;;show (word "Gipss-semaforo: desacelera-frena")
    ]
  ]

  ;;Entonces ya me pase el semaforo, que hago, me lo paso con velocidad Ga-velocidad?
  [
    ;;***show (word "********************************************************************************************************")
    ;;***show (word "Caso 3 Semaforo rojo = Me paso el semaforo, ni modo ")
    ;;***show (word "********************************************************************************************************")

    set Ga Ga-velocidad
    set velocidad Ga
  ]

  report velocidad

end


to-report Gipps-compara [ mi-vehiculo dist-vehiculo mi-semaforo dist-semaforo ]

  let velocidad 0
  let vel1 0
  let vel2 0

  set vel1 ( Gipps-vehiculo mi-vehiculo dist-vehiculo )

  set vel2 Gipps-semaforo mi-semaforo dist-semaforo

  ifelse (vel1 < vel2)
  [
    set velocidad vel1
    ;;show (word "FUNC Gipps-compara: se escogio Gipps-vehiculo")
  ]
  [
    set velocidad vel2
    ;;show (word "FUNC Gipps-compara: se escogio Gipps-semaforo")
  ]

  report velocidad
end



to procesa-objetos5
  ;;show (word "FUNC: procesa-objetos4")

  ;;Encuentra el primer conjunto de objetos enfrente del agente
  set agente-semaforo encuentra-semaforo 1
  set agente-vehiculo encuentra-vehiculo 1

  set ds-vehiculo 0 ;;CON MODULO
  let ds-semaforo 0 ;;CON MODULO

  let ds-vehiculo-netlogo 0 ;;sin modulo
  let ds-semaforo-netlogo 0 ;;sin modulo

  let ds-vehiculo-real 0 ;;sin modulo
  let ds-semaforo-real 0 ;;sin modulo

  ;;show (word "agente-semaforo:" agente-semaforo)
  ;;show (word "agente-vehiculo:" agente-vehiculo)

  ifelse(agente-semaforo = nobody)[
    set ds-semaforo ds-infinita
  ]
  [
    ;;Calculamos la distancia y despues tenemos que normalizar o sacar el modulo, el auto puede estar en la celda n "viendo" en las celdas 0,1,2, ..., max-vision
    set ds-semaforo-netlogo establece-distancia [xcor] of agente-semaforo xcor size
    set ds-semaforo-real    establece-distancia [Xn1] of agente-semaforo Xn1  Sn

    ;;show ( word " Netlogo(ds-semaforo) => semaforo(xcor):" [xcor] of agente-semaforo " ,  vehiculo(xcor):" xcor " , vehiculo(Sn):" size  ", d(vehiculo,semaforo)=" ds-semaforo-netlogo)
    ;;show ( word "    Real(ds-semaforo) => semaforo(Xn1):" [Xn1] of agente-semaforo " ,  vehiculo(Xn1):" Xn1 " , vehiculo(Sn):" Sn  ", d(vehiculo,semaforo)=" ds-semaforo-real)

    set ds-semaforo ds-semaforo-netlogo mod tamano-mundo-netlogo
    ;;show ( word "ds-semaforo-normalizado-netlogo: " ds-semaforo )

    set ds-semaforo ds-semaforo-real mod tamano-mundo-real
    ;;show ( word "ds-semaforo-normalizado-real: " ds-semaforo )
  ]


  ifelse(agente-vehiculo = nobody)[
    set ds-vehiculo ds-infinita
  ]
  [
    ;;OJO: la escala se maneja solo en la escala real, para conversion solo afecta a la ds-seguridad.
    set ds-vehiculo-netlogo establece-distancia ([xcor] of agente-vehiculo - ds-seguridad / escala) xcor size
    set ds-vehiculo-real    establece-distancia  ([Xn1] of agente-vehiculo - ds-seguridad ) Xn1 Sn

    ;;show ( word " Netlogo(ds-vehiculo) => vehiculo-enfrente(xcor):" [xcor] of agente-vehiculo " ,  vehiculo(xcor):" xcor " , vehiculo(Sn):" size  ", d(vehiculo,vehiculo-enfrente)=" ds-vehiculo-netlogo)
    ;;show ( word "    Real(ds-vehiculo) => vehiculo-enfrente(Xn1):" [Xn1] of agente-vehiculo " ,  vehiculo(Xn1):" Xn1 " , vehiculo(Sn):" Sn  ", d(vehiculo,vehiculo-enfrente)=" ds-vehiculo-real)

    set ds-vehiculo ds-vehiculo-netlogo mod tamano-mundo-netlogo
    ;;show ( word "ds-vehiculo-normalizado-netlogo: " ds-vehiculo )

    set ds-vehiculo ds-vehiculo-real mod tamano-mundo-real
    ;;show ( word "ds-vehiculo-normalizado-real: " ds-vehiculo )
  ]


  if (ds-semaforo-netlogo < 0 and ds-semaforo-netlogo > -1) [
    ;;mensaje "VERIFICADOR SEMAFORO = distancia semaforo negativa! [-1,0]"
    ;;show(word "distancia-real:" ds-semaforo-netlogo )
  ]

  ;;Solo verifica a los que tengan una ds-seguridad menor a la permitida
  if(ds-seguridad < ds-seguridad-max)[
    ;;Si la distancia actual es mayor que mi ds-seguridad actual entonces hay oportunidad de establecerla
    if (ds-vehiculo-real > ds-seguridad)
    [
      let ds-diferencia ds-vehiculo-real - ds-seguridad
      set ds-seguridad ds-seguridad + ds-diferencia
      ;;set ds-seguridad ds-seguridad-max
      ;;show (word "ds-vehiculo-real: " ds-vehiculo-real " ds-seguridad:" ds-seguridad " ds-diferencia:" ds-diferencia)
    ]
  ]

  if (ds-vehiculo-real < 0 and ds-vehiculo-real > (-1.0 * ds-seguridad)) [
    beep
    ;;mensaje "VERIFICADOR vehiculo = distancia vehiculo negativa! [-0.5, 0.0]"

    set ds-seguridad ds-seguridad * ds-seguridad-proporcion
    ;;show (word "ds-seguridad recalculada: " ds-seguridad)

    ;;recalcular
    set ds-vehiculo-real establece-distancia ([Xn1] of agente-vehiculo - ds-seguridad) xn1 Sn
    ;;show ( word " ds-vehiculo = Xn1 of agente-vehiculo : " ([xcor] of agente-vehiculo - ds-seguridad) " ,  mi-vehiculo.xn1: " xn1 " , vehicuo.Sn:" Sn " = " ds-vehiculo)

    set ds-vehiculo ds-vehiculo-real mod tamano-mundo-real
    ;;show ( word "Otra vez: ds-vehiculo-normalizado: " ds-vehiculo )
  ]

  ;;Creo que esto es por el modulo
  if(ds-vehiculo > tamano-mundo-real ) [
    beep
    mensaje "COLISION"
  ]


  ;;;;;;;;;;;;;;;;;;;;;;;;;  PARA LOS CAMBIOS(+) DE VELOCIDAD  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Si hay cambio de velocidad mayor a la actual, entonces ...
  if ( Vinput > Vn )[
    show (word "Se esta incrementando la velocidad, establecemos la nueva velocidad con el frenado optimo")

    ;;Si Velocidad actual Vn es mayor a la velocidad critica, podemos ...
    ifelse ( Vinput > Vcritico) [
      ;;establecer la nueva velocidad sin problemas
      set Vn Vinput

      ;;actualizamos el valor optimo de frenado, esta distancia garantiza el frenado seguro
      set ds-frenado-optimo table:get tabla-frenado Vn
    ]
    ;;Si Vn esta dentro la zona critica, establecemos los valores para que queden dentro del limite de la zona critica,
    ;;son valores muy pequeños que los podemos "saltar" alrededor de (0 a 2.6) m / s, 9.36 km/h
    [
      set Vn precision ( (An * tao) + 0.1 ) 1
      set Vinput Vn
      set ds-frenado-optimo table:get tabla-frenado Vn

      ;;para que el usuario no pueda escoger valores entre [0,Vcritico]
      set red-train-speed Vn
    ]
  ]

  ;;;;;;;;;;;;;;;;;;;;;;;;;  PARA LOS CAMBIOS(-) DE VELOCIDAD  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Externamente se disminuye la velocida
  if(Vinput < Vn)[

    show (word "Se esta disminuyendo la velocidad")

    ;;Si mi velocidad deseada es superior a mi velocidad actual, la puedo establecer, aprovecho que esta por arriba
    ;;el caso facil
    ifelse (Vinput >= Un1)[

      ;;Cae el caso del cero tambien, ok.
      set Vn Vinput

      ;Si Vn es mayor que Vcritico entonces podemos establecerun valor de frenado
      ifelse ( Vn > Vcritico) [
        ;;El valor optimo de frenado, esta distancia garantiza el frenado seguro
        set ds-frenado-optimo table:get tabla-frenado Vn
      ]
      ;;Si es menor que Vcritico entonces hay que establecer la velocidad a cero
      [
        set ds-frenado-optimo table:get tabla-frenado precision ( (An * tao) + 0.1 ) 1
        set Vn 0
        set red-train-speed 0
      ]

      ;;inicializamos la posicion fantasma para cambios siguientes
      set establece-posicion-fantasma? false
      set posicion-fantasma 0
    ]
    [
      ;;if(Vinput < Un1)
      ;;Si es mayor que mi velocidad actual y deseo frenar entonces aplico gipps fantasma
      if ( not establece-posicion-fantasma?)[
        set posicion-fantasma Xn1 + Sn + ds-frenado-optimo
        set establece-posicion-fantasma? true
      ]
    ]
  ]

  ifelse(establece-posicion-fantasma?)[
    set ds-fantasma establece-distancia posicion-fantasma Xn1  Sn
  ]
  [
    set ds-fantasma ds-infinita
  ]




  ;;CASO O: No hay ningun objeto, ni semaforo, ni vehiculo, puedo fluir libremente.
  if( ds-semaforo >= ds-infinita and ds-vehiculo >= ds-infinita)
  [
    ;;show ( word "CASO 0: NADIE")
    set Ga Ga-velocidad      ;;Gipps de forma libre, solo aplica la ecuacion "Ga"
    set Un2 Ga

    if(ds-fantasma < ds-infinita)[
      let vel-fantasma Gd-velocidad-objeto ds-fantasma
      set Gd vel-fantasma
      if ( Un2 > vel-fantasma )[
        set Un2 vel-fantasma
      ]
    ]
  ]

  ;;CASO 1: No hay semaforo pero si hay vehiculo
  if( ds-semaforo >= ds-infinita and ds-vehiculo < ds-infinita )
  [
    ;;show ( word "CASO 1: Vehiculo")
    set Un2 Gipps-vehiculo agente-vehiculo ds-vehiculo

    if(ds-fantasma < ds-infinita)[
      let vel-fantasma Gd-velocidad-objeto ds-fantasma
      if ( Un2 > vel-fantasma )[
        set Un2 vel-fantasma
      ]
    ]
  ]

  ;;CASO 2.Hay Semaforo es lo que me interesa, puedo calcular distancias infinitas donde esta el vehiculo
  if( ds-semaforo < ds-infinita )
  [

    if ( [semaforo-estado] of agente-semaforo = "verde")
    [
      ifelse (ds-vehiculo >= ds-infinita)
      [
        ;;show ( word "CASO 2.1: Semaforo en verde y vehiculo con ds-infinita")
        set Un2 Ga-velocidad  ;;Gipps de forma libre, solo aplica la ecuacion "Ga"

        if(ds-fantasma < ds-infinita)[
          let vel-fantasma Gd-velocidad-objeto ds-fantasma
          if ( Un2 > vel-fantasma )[
            set Un2 vel-fantasma
          ]
        ]
      ]
      [
        ;;show ( word "CASO 2.1: Semaforo en verde y vehiculo enfrente")
        set Un2 Gipps-vehiculo agente-vehiculo ds-vehiculo

        if(ds-fantasma < ds-infinita)[
          let vel-fantasma Gd-velocidad-objeto ds-fantasma
          if ( Un2 > vel-fantasma )[
            set Un2 vel-fantasma
          ]
        ]
      ]

    ]

    if ( [semaforo-estado] of agente-semaforo = "ambar" )
    [
      ifelse (ds-vehiculo >= ds-infinita)
      [
       show ( word "CASO 2.2: Semaforo en ambar y vehiculo con ds-infinita")

        set Un2 Ga-velocidad  ;;Gipps de forma libre, solo aplica la ecuacion "Ga"

        if(ds-fantasma < ds-infinita)[
          let vel-fantasma Gd-velocidad-objeto ds-fantasma
          if ( Un2 > vel-fantasma )[
            set Un2 vel-fantasma
          ]
        ]
      ]
      [
        ifelse ( ds-semaforo < 1.0 * escala and ds-semaforo > 0.2 * escala)
        [
          ;;show (word "CASO 2.2.1: semaforo en ambar en región critica y vehiculo enfrente")
          set Un2 Gipps-compara agente-vehiculo ds-vehiculo agente-semaforo ds-semaforo

          if(ds-fantasma < ds-infinita)[
            let vel-fantasma Gd-velocidad-objeto ds-fantasma
            if ( Un2 > vel-fantasma )[
              set Un2 vel-fantasma
            ]
          ]
        ]
        [
          ;;show ( word "CASO 2.2.2: Semaforo en ambar y vehiculo enfrente")
          set Un2 Gipps-vehiculo agente-vehiculo ds-vehiculo

          if(ds-fantasma < ds-infinita)[
            let vel-fantasma Gd-velocidad-objeto ds-fantasma
            if ( Un2 > vel-fantasma )[
              set Un2 vel-fantasma
            ]
          ]
        ]
      ]
    ]

    if ( [semaforo-estado] of agente-semaforo = "rojo" )
    [
      ifelse (ds-vehiculo >= ds-infinita)
      [
        ;;show ( word "CASO 2.3.1: Semaforo en rojo y no hay vehiculo, ds-vehiculo: " ds-vehiculo " ds-semaforo: " ds-semaforo )
        set Un2 Gipps-semaforo agente-semaforo ds-semaforo

        if(ds-fantasma < ds-infinita)[
          let vel-fantasma Gd-velocidad-objeto ds-fantasma
          if ( Un2 > vel-fantasma )[
            set Un2 vel-fantasma
          ]
        ]
      ]
      [
        ;;show ( word "CASO 2.3.2: Semaforo en rojo y vehiculo")
        set Un2 Gipps-compara agente-vehiculo ds-vehiculo agente-semaforo ds-semaforo

        if(ds-fantasma < ds-infinita)[
          let vel-fantasma Gd-velocidad-objeto ds-fantasma
          if ( Un2 > vel-fantasma )[
            set Un2 vel-fantasma
          ]
        ]
      ]
    ]
  ]

  ;;Calculamos la nueva posicion del vehiculo "n"
  set Xn2 Xn1 + 0.5 * (Un1 + Un2) * tao

  ;;Ahora el valor de la aceleración actual será la siguiente
  set Un1 Un2

  ;;Ahora la posicion actual será la siguiente (preparamos para el siguiente calculo)
  set Xn1 Xn2 mod tamano-mundo-real

  ;;Establecemos la coordenada (x,y) del agente,
  setxy Xn1 / escala  ycor

end








;;Calcula el espacimiento (distnacia) entre dos vehiculos.
;;coord-X2 es la coordenada del objeto de enfrente,
;;coord-X1 es la coordenada del objeto actual
;;longitud-vehiculo es la dimenension del objeto actual
to-report establece-distancia[ coord-x2 coord-x1 longitud-vehiculo ]
  report coord-x2 - ( coord-x1 + longitud-vehiculo )
end



to-report encuentra-semaforo [ n ]

  ifelse n <= line-of-vision
  [
    ;;Para pintar
    if line-of-vision?
    [
      let parche-enfrente patch-ahead n
      ;; X pertence [xinf, xsup], n pertenece [1,20] o [1,objeto-encontrado]
      ;;Normalizacion: (X - xinf) / (xsup - xinf)
      ;;Incremento: Normalización*escalamiento + posicion
      ;;(escalamiento, rango-de-color) = (5,91)
      ask parche-enfrente [ set pcolor ( ( n -  1 ) / (line-of-vision - 1) * 5 ) + 61 ]

      ask patch-here [ set pcolor white]
    ]

    ifelse any? semaforos-on patch-ahead n ;;!= nobody
    [
       ;;***show (word "Funcion encuentra-semaforo: encontro semaforo en la posicion: " n )

       ;let parche-final patch-ahead n

       ;ask parche-final [ set pcolor red ]

       ;;Hay que guardar el lugar donde lo encontro, por que si es semaforo verde, me conviene ver donde esta el siguiente, por que no voy a tomar la distancia de este sino del siguiente
       ;;Si cambia a ambar, entonces ya es igual, considero la distnacia del semaforo, y analizo, o si es rojo igual la del semaforo.

       report one-of semaforos-on patch-ahead n

    ]

    [
       report encuentra-semaforo (n + 1)
    ]
  ]

  [
     ;show (word "F(encuentra-objetos) = no encontro el auto")
     report nobody
  ]

end




to-report encuentra-vehiculo [ n ]

  ifelse n <= line-of-vision
  [
    ;;Para pintar
    if line-of-vision?
    [
      let parche-enfrente patch-ahead n
      ;; X pertence [xinf, xsup], n pertenece [1,20] o [1,objeto-encontrado]
      ;;Normalizacion: (X - xinf) / (xsup - xinf)
      ;;Incremento: Normalización*escalamiento + posicion
      ask parche-enfrente [ set pcolor ( ( n -  1 ) / (line-of-vision - 1) * 5 ) + 91 ]
    ]

    ifelse any? vehiculos-on patch-ahead n ;;!= nobody
    [
       ;;****show (word "Funcion encuentra-vehiculo-recursivo: encontro vehiculo en la posicion: " n )

       ;let parche-final patch-ahead n

       ;ask parche-final [ set pcolor red ]

       ;;Hay que guardar el lugar donde lo encontro, por que si es semaforo verde, me conviene ver donde esta el siguiente, por que no voy a tomar la distancia de este sino del siguiente
       ;;Si cambia a ambar, entonces ya es igual, considero la distnacia del semaforo, y analizo, o si es rojo igual la del semaforo.

       if( count vehiculos-on patch-ahead n > 1)
       [
         ;;***show (word "*********************************************************************" )
         ;;***show (word "encuentra-vehiculo: numero de vehiculos en el parche " n " : " count vehiculos-on patch-ahead n )
         ;;***show (word "*********************************************************************" )
       ]

       report one-of vehiculos-on patch-ahead n

    ]

    [
       report encuentra-vehiculo (n + 1)
    ]
  ]

  [
     ;show (word "F(encuentra-objetos) = no encontro el auto")
     report nobody
  ]

end



to-report Ga-velocidad

  let acelera 0

  ifelse ( Vn > 0 )
  [
    ;;Verificar si hay raices negativas
    ifelse (Un1 >= -0.025 * Vn)
    [
      ;;***show (word "Ga-funcion: Un1: " Un1 " Vn: " Vn " condicion: Un1 >= -0.025 * V0 => " Un1 " >= " (-0.025 * Vn) )
      set acelera Un1 + 2.5 * An * tao * (1.0 - Un1 / Vn) * sqrt (0.025 + Un1 / Vn)
      ;show (word "Ga-funcion: acelera:" acelera )
    ]
    [
      ;;Estamos en unz zona donde va a salir una raiz imaginaria, asignamos Un1 en la frontera, a ver que pasa
      ;set Un1 (-0.025 * Vn)
      ;set acelera Un1 + 2.5 * An * tao * (1.0 - Un1 / Vn)
      show (word "******************************************************************************************")
      show (word "Estamos en una zona límite en Ga-funcion, NO hacemos Un1=-0.025*Vn = " Un1)
      show (word "******************************************************************************************")
    ]
  ]
  [
    set acelera 0.0
  ]

  report acelera

end




;;La parte de la desaceleracion
to-report Gd-velocidad-vehiculo [ vehiculo-adelante vehiculo-distancia]
  ;show (word "Funcion Gd-velocidad-vehiculo")

  let bgorro -3.0

  ;;la velocidad del vecino
  let Unvecino [Un1] of vehiculo-adelante

  let baux (([bn] of vehiculo-adelante - 3.0) / 2)

  ;;set bgorro   [bn]  of car-ahead  ;;el frenado mas severo que tiene que ser "calculado" por el vehiculo "n"
  if (baux < -3.0)
  [
    set bgorro baux
    ;show (word "bgorro: " bgorro " fue menor que -3.0 ")
  ]

  let discriminante bn ^ 2 * tao ^ 2 - bn * ( 2.0 * vehiculo-distancia - Un1 * tao - ( Unvecino ^ 2 / bgorro) )

  report ( bn * tao + sqrt(discriminante) )

end


to-report Gd-velocidad-objeto [ mi-distancia ]

  let desacelera 0

  let discriminante bn ^ 2 * tao ^ 2 - bn * ( 2.0 * mi-distancia - Un1 * tao )  ;;Hacemos velocidad Un-1 = 0, por que el semaforo esta inmovil

  ;;show (word "FUNC Gd-velocidad-objeto, disciminante: " discriminante " , mi-distancia: " mi-distancia)

  ;;ifelse( distancia-seguridad * parametro-control >= Un1) ;;Mejor vemos cuando es mayo a cero simplmente evaluando
  ifelse (discriminante >= 0)
  [
    ;;show (word "Funcion Gd-velocidad-vehiculo-semaforo: zona estable")
    set desacelera bn * tao + sqrt(discriminante)
  ]

  ;;Entonces discriminante < 0
  [

    show (word "************************************************************")
    show (word "Funcion Gd-velocidad-objeto: zona inestable discriminante < 0 ")
    show (word "************************************************************")
    beep

    ;;set discriminante bn ^ 2 * tao ^ 2 - bn * ( 2.0 * cero - Un1 * tao )

    ;;Mantento mi velocidad
    set desacelera Un1

    ;;show (word "Funcion Gd-velocidad-vehiculo-semaforo: **inestable < cinturon < estable ; ** desacelera: " desacelera)

    ;;set desacelera 0.0
  ]

  report desacelera

end



to setup-cuadricula

  let indice 0

  while [indice < max-pxcor] [

    ask patches with [ pxcor mod 2 = indice and pycor mod 2 = indice mod 2]
      [ set pcolor 9]

    set indice indice + 1
  ]

end

@#$#@#$#@
GRAPHICS-WINDOW
631
64
1933
144
-1
-1
9.863
1
10
1
1
1
0
1
0
1
0
130
0
4
1
1
1
ticks
30.0

BUTTON
632
11
706
51
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
708
11
782
51
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
491
220
615
253
red-train-speed
red-train-speed
0
30
13
.1
1
NIL
HORIZONTAL

SWITCH
12
329
153
362
grid?
grid?
1
1
-1000

SLIDER
313
146
485
179
line-of-vision
line-of-vision
5
20
20
1
1
NIL
HORIZONTAL

SLIDER
491
109
615
142
train-speed
train-speed
0
23
13
.1
1
NIL
HORIZONTAL

SLIDER
491
146
615
179
train-acceleration
train-acceleration
0
5
3.8
.1
1
NIL
HORIZONTAL

SLIDER
491
183
615
216
train-braking
train-braking
-5
-0.1
-1.15
.01
1
NIL
HORIZONTAL

BUTTON
784
11
856
51
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
160
146
307
179
#trains
#trains
1
22
16
1
1
NIL
HORIZONTAL

SWITCH
12
292
153
325
line-of-vision?
line-of-vision?
1
1
-1000

SLIDER
160
109
307
142
#stations
#stations
1
30
20
1
1
NIL
HORIZONTAL

CHOOSER
12
205
153
250
vehicle-distribution
vehicle-distribution
"equidistant" "accumulated"
0

CHOOSER
12
109
153
154
set-experiment
set-experiment
"space-cdmx" "space-lambda-pass" "none"
1

CHOOSER
12
157
153
202
method
method
"general-cdmx" "self-organization-II"
1

SLIDER
160
183
307
216
lambda-passengers
lambda-passengers
1
50
5
1
1
NIL
HORIZONTAL

SLIDER
313
109
485
142
train-capacity
train-capacity
0
180
180
1
1
NIL
HORIZONTAL

MONITOR
12
60
84
105
world (m)
tamano-mundo-real
5
1
11

MONITOR
89
60
159
105
scale (m)
escala
5
1
11

MONITOR
164
60
228
105
tao (seg)
tao
5
1
11

MONITOR
311
60
407
105
safe-distance (m)
ds-seguridad-max
5
1
11

MONITOR
232
60
308
105
train-size (m)
tamano-vehiculo-real
17
1
11

MONITOR
631
467
760
512
#passengers-exit
#pasajeros-salida
17
1
11

MONITOR
631
421
760
466
#passengers-entrance
#pasajeros-entrada
17
1
11

BUTTON
456
22
566
55
close-file
file-close\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
329
22
453
55
set-file?
set-file?
1
1
-1000

MONITOR
410
59
498
104
optimal-brake
ifelse-value any? turtles\n  [   [ds-frenado-optimo] of vehiculo-rojo ]\n  [  0 ]
17
1
11

SLIDER
160
294
359
327
update-graphs
update-graphs
0
90
90
1
1
timesteps
HORIZONTAL

PLOT
1236
145
1482
328
Intertrain Distance
distance (meters)
frequency
0.0
2500.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" ""

PLOT
1190
329
1482
510
Travel Time Passengers
ticks
time-travel (min)
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"travel" 1.0 0 -16777216 true "" ""
"station" 1.0 0 -7500403 true "" ""
"interstation" 1.0 0 -723837 true "" ""
"delay" 1.0 0 -2674135 true "" ""

MONITOR
1054
375
1189
420
max-travel-time (min)
max datos-pasajeros-tiempo-viaje
17
1
11

MONITOR
1054
421
1189
466
min-travel-time (min)
min datos-pasajeros-tiempo-viaje
17
1
11

PLOT
1483
329
1710
510
Passengers Waiting Station
waiting-time (min)
Frecuency
0.0
30.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" ""

MONITOR
1054
329
1189
374
average-travel-time (min)
mean datos-pasajeros-tiempo-viaje
5
1
11

SWITCH
12
253
153
286
graph?
graph?
0
1
-1000

SLIDER
216
22
326
55
transitory
transitory
0
30000
0
100
1
NIL
HORIZONTAL

MONITOR
631
145
760
190
simulation-time (min)
tiempo-real
2
1
11

PLOT
1483
145
1710
328
Intertrain Distances Std Deviation
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""
"avg" 1.0 0 -13345367 true "" ""

PLOT
761
145
1007
328
Headway Distribution
headway (seconds)
frequency
40.0
250.0
0.0
5.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" ""

PLOT
1008
145
1235
328
Headway Std Deviation
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""
"avg" 1.0 0 -13345367 true "" ""

MONITOR
491
303
620
348
max-headway (seg)
max [frecuencias] of monitor-headway
5
1
11

MONITOR
631
191
760
236
max-headway (min)
(max [frecuencias] of monitor-headway) / 60
2
1
11

MONITOR
491
257
620
302
mean-headway (seg)
mean [frecuencias] of monitor-headway
2
1
11

MONITOR
631
237
760
282
mean-headway (min)
(mean [frecuencias] of monitor-headway) / 60
2
1
11

MONITOR
631
283
760
328
std-dev-headway (min)
(standard-deviation [frecuencias] of monitor-headway) / 60
4
1
11

SLIDER
106
22
213
55
iterations
iterations
0
150000
100000
1000
1
NIL
HORIZONTAL

SLIDER
160
220
307
253
lambda-min
lambda-min
1
50
1
1
1
NIL
HORIZONTAL

SLIDER
160
257
307
290
lambda-max
lambda-max
1
50
6
1
1
NIL
HORIZONTAL

CHOOSER
12
10
104
55
metro-line
metro-line
"L1CDMX" "LHOMO20" "LHOMO15"
0

SLIDER
159
329
359
362
update-measures
update-measures
1
90
90
1
1
timesteps
HORIZONTAL

PLOT
761
329
1053
512
Passengers Flow
time
passengers/ min
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"entrance-mean" 1.0 0 -7500403 true "" ""
"exit-mean" 1.0 0 -955883 true "" ""

MONITOR
631
329
760
374
entrance (pass/min)
#pasajeros-entrada / precision ( (ticks * tao) / 60) 2
2
1
11

MONITOR
631
375
760
420
exit (pass/min)
#pasajeros-salida / precision ( (ticks * tao) / 60) 2
2
1
11

PLOT
1711
145
1933
328
Trains Time Station
time (seconds)
frequency
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" ""

PLOT
1711
329
1933
509
Trains Time Interstation
time (sec)
frequency
30.0
200.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" ""

MONITOR
491
349
620
394
mean-time-station (seg)
mean datos-vehiculos-tiempo-local-estacion
3
1
11

SLIDER
313
183
485
216
ETAboard-max
ETAboard-max
20
200
80
1
1
NIL
HORIZONTAL

SLIDER
313
220
485
253
ETAboard-min
ETAboard-min
10
40
24
1
1
NIL
HORIZONTAL

SLIDER
313
257
485
290
ETAboard-noise
ETAboard-noise
0
12
3
1
1
NIL
HORIZONTAL

MONITOR
1054
467
1189
512
average waiting-time (min)
mean datos-pasajeros-tiempo-espera
5
1
11

@#$#@#$#@
## WHAT IS IT?

This code models the dynamic of a single line of metro systems using a set of real data
of Mexico City Metro, the Gipps' car-following model to characterize the flow of the trains and two methods to regulate the headway.

The first regulatory method, "general-cdmx" (CDMX), models the dynamic of Mexico City Metro, and the second, "self-organization-II" (SOMII) uses the antipheromone concept to increment the performance of the line.

The model shows how the self-organization method can adjust the headway in the station with local information.


## HOW TO USE IT

Click on the SETUP button to set up the file of the metro line, in this case is L1CDMX. Set the #trains to 16. Choose the regulatory method, "self-organization-II" or "general-cdmx". Finally, choose the vehicle distribution: "equidistant" or "accumulated".

Click on the GO (continuousloop) button to start the trains moving.

The "trains acceleration" slider controls the rate at which trains accelerate (speed up) when there are no cars ahead controlled by the Gipps' Model.

The headway distribution was considered as an indicator to measure the performance of public transportation systems. The SOMII shows that with appropriate local interaction rules, it is possible to regulate the headway globally and adaptively.



## HOW TO CITE

If you mention this model in a publication, we ask that you include these citations for the model itself and for the NetLogo software:

- Carreon, G. (2017). NetLogo Public Transportation System Simulator. Universidad Nacional Autónoma de México. México.


- Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

[CC BY-NC-SA 3.0](http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

semaforo
false
0
Circle -7500403 true true 0 0 300

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

train passenger car
false
0
Polygon -7500403 true true 15 206 15 150 15 135 30 120 270 120 285 135 285 150 285 206 270 210 30 210
Circle -16777216 true false 240 195 30
Circle -16777216 true false 210 195 30
Circle -16777216 true false 60 195 30
Circle -16777216 true false 30 195 30
Rectangle -16777216 true false 30 140 268 165
Line -7500403 true 60 135 60 165
Line -7500403 true 60 135 60 165
Line -7500403 true 90 135 90 165
Line -7500403 true 120 135 120 165
Line -7500403 true 150 135 150 165
Line -7500403 true 180 135 180 165
Line -7500403 true 210 135 210 165
Line -7500403 true 240 135 240 165
Rectangle -16777216 true false 5 195 19 207
Rectangle -16777216 true false 281 195 295 207
Rectangle -13345367 true false 15 165 285 173
Rectangle -2674135 true false 15 180 285 188

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
setup
repeat 180 [ go ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
