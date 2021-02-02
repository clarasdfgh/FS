# **FS** Tema 2: introducción a los sistemas operativos

>- Conocer la evolución de los Sistemas Operativos (SO) y sus principales logros
>- Funciones de un SO
>- Conocer los elementos necesarios para implementar la multiprogramación en un SO
>- Entender el concepto de proceso y su Entender el concepto de hebra
>- Conocer el uso que realiza el SO de apoyo al hardware CPU y gestión de memoria

### 1. Introducción

#### FUNCIONES DE LOS SO

Una plataforma hardware es un conjunto de recursos de procesamiento (procesador, memoria, caché, registros...) y de dispositivos E/S. 

El SO es una representación uniforme y abstracta de los recursos de un ordenador que son requeridos por aplicaciones. Es una interfaz rica entre las aplicaciones y el hardware, que permite compartir recursos y la protección de estos. Un SO es un programa que actúa como intermediario entre el user y el hardware, y no siempre ha estado ahí.

Algunas características deseables para un SO: comodidad, eficiencia y capacidad de evolución.

Algunas abstracciones de los SO:

- **Proceso:** dedicación de la CPU a un programa
- **Memoria virtual:** capacidad de RAM infinita
- **Archivo:** datos (con tipo) en memoria permanente
- **Canal:** E/S asociada a un tipo de dato
- **Shell:** potente interfaz de usuario programable

#### El SO como interfaz User/Computador

##### Abstracción

Los SO presentan al user una **máquina abstracta más fácil de programa que el hardware subyacente**. Esto se debe a que se oculta la complejidad del hardware y se da tratamiento homogeneo a diferentes objetos de bajo nivel (archivos, procesos, dispositivos...).

Un programador de aplicaciones desarrolla más facilmente una app en un lenguaje de programación de alto nivel (que accede por sí misma a la API del SO) que en lenguaje máquina (que entiende el hardware).

##### APIS para programación

Un SO suele proporcionar utilidades en las siguientes áreas: 

- **Desarrollo software:** editores de texto, compilador, enlazador, depuración de memoria y código...
- **Ejecución de programas: **cargador de programas y ejecución
- **Acceso a dispositivos E/S:** conjunto específico de instrucciones para cada dispositivo. Estos accesos se resuelven por llamadas al sistema
- **Seguridad:**
  - **Acceso al sistema:** en sistemas compartidos o públicos, el SO controla el acceso y uso de los recursos del sistema (Shell, permisos, propietarios de archivo, grupos...)
  - **Detección y respuesta a errores:** tratamiento de errores a nivel software (excepciones) y hardware (interrupciones), minimizando el impacto (ej. pantallazo azul para evitar daños mayores)
  - **Contabilidad:** estadísticas de uso de los recursos y medida del rendimiento del sistema (benchmarks)

> **Excepciones:**
>
> Evento síncrono inesperado generado por alguna condición que ocurre durante la ejecución de una instrucción (desbordamiento aritmético, dirección inválida, instrucción privilegiada...)

##### Administrador de recursos

El SO requiere de un mecanismo de control: las funciones del SO funcionan de la misma manera que el resto del software, son programas ejecutados por el procesador. Esto quiere decir que el SO cede el control y depende del procesador para volver a retomarlo.

Por tanto:

- El SO dirige el uso del procesador y del resto de los recursos
- Controla la temporización de la ejecución de programas
- Una parte del código del SO se encuentra cargada en la memoria principal (kernel, e incluso otros servicios del SO que se encuentren en uso)
  - El resto de la memoria está ocupada por programas y datos del user
- La asignación de la memoria principal la realizan conjuntamente el SO y el hardware gestor de memoria del procesador (MMU)
- El SO decide cuando un programa en ejecución puede usar un dispositivo E/S y el acceso y uso de ficheros
- **El procesador también es un recurso**, uno de los más importantes

#### EVOLUCIÓN DE LOS SO

- **40-50’s** - Procesamiento en serie de programas en lenguaje máquina
  - Entrada: tarjetas perforadas
  - Salida: impresora
- **50-60’s** - Sistemas por lotes (batches). Primer SO el monitor residente, poca interacción. Infrautilización de la CPU
- **60-70’s** - Sistemas multiprogramados interactivos. Aparece una facilidad hardware: la interrupción 
  - Grado de multiprogramacion
  - Los SO evolucionan a Tiempo Compartido
  - Los SO evolucionan a Tiempo Real
- **70-actualidad** - Aparecen los sistemas multiusuario

##### Clasificación

1. Según **modo de trabajo**
   - Por lotes (batches)
   - Interactivo
2. Según **aprovechamiento de la CPU**
   - Uniprogramado vs. Multiprogramado
   - Uniprocesador vs. Multiprocesador
3. Según **usuario**
   - Monousuario
   - Multiusuario

### 2. Componentes de un SO multiprogramado

#### TÉCNICAS E/S

Un buen SO permite un uso eficiente del procesador y de los dispositivos E/S a través de múltiples técnicas de soporte hardware:

- Modo dual de operación
- Interrupciones (evento)
- Excepciones (evento)
- Protección E/S, de memoria, de CPU...

Los primeros SO eran simples sistemas batch (monitor en memoria principal): si se dispone de memoria principal, se puede cargar más de una aplicación simultaneamente.

Es necesario tener un algoritmo de planificación o *scheduler*.

#### MULTIPROGRAMACIÓN

![image-20210113000255936](/home/clara/.config/Typora/typora-user-images/image-20210113000255936.png)

Tengamos en cuenta la siguiente tabla: describe tres trabajos con características y necesidades distintas

|                         | JOB1                     | JOB2              | JOB3              |
| ----------------------- | ------------------------ | ----------------- | ----------------- |
| **Tipo de trabajo**     | Computación pesada (CPU) | Gran cantidad E/S | Gran cantidad E/S |
| **Duración**            | 5 min                    | 15 min            | 10 min            |
| **Memoria requerida**   | 50 MB                    | 100 MB            | 75 MB             |
| **Necesita disco?**     | No                       | No                | Si                |
| **Necesita terminal?**  | No                       | Si                | No                |
| **Necesita impresora?** | No                       | No                | Si                |

A continuación, una representación visual de estos procesos en un sistema monoprogramado: el más oscuro es el JOB1, y el más claro el JOB3. Vemos como se corresponden con la información de la tabla: por ejemplo, el trabajo 1 consume mucha más CPU que los otros dos, o que la duración de todos estos procesamientos es de 5+10+15 minutos

![image-20210113001223996](/home/clara/.config/Typora/typora-user-images/image-20210113001223996.png)

Ahora, veamos esta misma ejecución sobre un sistema multiprogramado:

![image-20210113001250025](/home/clara/.config/Typora/typora-user-images/image-20210113001250025.png)

Como podemos comprobar, hay una gran optimización: en todo momento estamos aprovechando un porcentaje mucho mayor de la CPU, y la ejecución toma 15 minutos (lo que dura el proceso más largo). Una tabla comparativa de ambas ejecuciones:

|                               | Monoprogramado  | Multiprogramado  |
| ----------------------------- | --------------- | ---------------- |
| **Uso de la CPU**             | 20%             | 40%              |
| **Uso de la memoria**         | 33%             | 67%              |
| **Uso de disco**              | 33%             | 67%              |
| **Uso de la impresora**       | 33%             | 67%              |
| **Tiempo total**              | 30 min          | 15 min           |
| **Productividad**             | 6 trabajos/hora | 12 trabajos/hora |
| **Tiempo de respuesta medio** | 18 min          | 10 min           |

#### PROCESO

Algunas definiciones de proceso son:

- Un programa en ejecución
- Una instancia de un programa ejecutándose en un ordenador
- La entidad que se puede asignar o ejecutar en un procesador
- Una unidad de actividad caracterizada por un solo flujo de ejecución, un estado actual y un conjunto de recursos del sistema asociados

Un proceso está formado por un programa ejecutable (o binario), y los datos que requiere el SO para ejecutar el programa.

##### PCB, Process Control Block

![image-20210113002543413](/home/clara/.config/Typora/typora-user-images/image-20210113002543413.png)

El PCB es un conjunto de información que incluye:

- **Process identificator, PID**
- **Estado:** en qué situación se encuentra el proceso en cada momento
- **Prioridad:** nivel propio frente a otros procesos
- **Memoria:** dónde reside el programa y sus datos
- **Contexto de ejecución:** registros actuales del procesador
- **Estado E/S:** recursos del sistema que le han sido asignados
- **Cuota:** posibles limitaciones a los recursos

###### Típica implementación de procesos

Esta implementación del PCB nos permite ver el proceso como una **estructura de datos**:

- El estado completo del proceso en un instante dado se almacena en el **contexto**. En el contexto se almacena el contenido de los registros PC, PSW y SP
  - Esta estructura permite el desarrollo de técnicas potentes que aseguren la **coordinación y cooperación entre procesos**
  - Es necesario un algoritmo que resuelva la coordinación de procesos, llamado *dispatcher*.

Existen técnicas de planificación de la CPU. El cambio de proceso se puede dar en cualquier instante en el que SO obtiene control sobre el proceso en ejecución. El tiempo máximo de uso del procesador se denomina **quantum**.

###### Disposición de memoria

![image-20210113003743698](/home/clara/.config/Typora/typora-user-images/image-20210113003743698.png)

![image-20210113003754679](/home/clara/.config/Typora/typora-user-images/image-20210113003754679.png)

#### LA TRAZA

La traza de ejecución es un listado de la secuencia de instrucciones de programa que realiza el procesador para un proceso. 

Desde el punto de vista del procesador, se entremezclan las trazas de ejecución de los procesos y las trazas del código del SO. Esto es consecuencia de las llamadas al sistema y de la multiprogramación

#### EL MODELO CINCO ESTADOS

![image-20210113004028457](/home/clara/.config/Typora/typora-user-images/image-20210113004028457.png)

El modelo 5 estados trata de representar las actividades que el SO lleva a cabo sobre los procesos: creación, terminación, multiprogramación.

Para ello usa cinco estados:

- Ejecutando
- Preparado
- Bloqueado
- Nuevo
- Finalizado

##### Transiciones

- **Nuevo**
  - →Preparado: el PCB está creado y el programa disponible en memoria
- **Ejecutando**
  - →Finalizado: el proceso finaliza normalmente o es abortado por el SO debido a un error irrecuperable
  - →Bloqueado: el proceso solicita algo al SO así que debe esperar hasta que lo reciba
  - →Preparado: el proceso ha alcanzado el máximo tiempo de ejecución ininterrumpida (quantum)
- **Preparado**
  - →Ejecutando: el scheduler ha seleccionado al proceso para ser ejecutado
  - →Finalizado: terminación de un proceso por parte de otro
- **Bloqueado**
  - →Preparado: se ha producido el evento que hizo parar al proceso
  - →Finalizado: terminación de un proceso por parte de otro

### 3. Descripción y control de procesos

Un proceso se describe mediante el PCB: 

- **Identificadores**: del proceso, del padre del proceso, del usuario...
- **Contexto de registros del procesador**: PC, PSW, SP...
- **Información** para control del proceso: 
  - **Estado** del proceso (según modelo de 5 estados)
  - **Parámetros de planificación**
  - **Evento** que mantiene al proceso bloqueado
  - **Cómo acceder a la memoria** que aloja el programa asociado al proceso: registros base y longitud
  - **Recursos** utilizados por el proceso (dispositivos, puertos...)

#### CREACIÓN E INICIALIZACIÓN DEL PCB

1. Asignar identificador único al proceso 

2. Asignar un nuevo PCB 

3. Asignar memoria para el programa asociado

4. Inicializar:

   - **PC**: Dirección inicial de comienzo del programa 

   - **SP**: Dirección de la pila de sistema 

   - **Memoria** donde reside el programa 

     *El resto de campos se inicializan a valores por omisión*

#### CONTROL DE PROCESOS

##### 1. Cambio de proceso

Un proceso en estado *Ejecutándose* **cambia a otro estado** y un proceso en estado *Preparado* pasa a estado *Ejecutándose*: ¿Cuándo puede realizarse? Cuando el SO pueda ejecutarse y decida llevarlo a cabo. Luego solamente se hará como resultado de:

- Una **interrupción**: dispositivo ES listo o quantum timeout
- Una **excepción**: evento síncrono inesperado (ej. desbordamiento aritmético, dirección inválida, instrucción privilegiada...)
- Una **llamada** al sistema (ej. modificación del reloj)

>  **Cambio de contexto:**
>
> 1. Salvar los registros del procesador en el PCB del proceso que actualmente está en estado *Ejecutándose*. 
> 2. Actualizar el campo estado del proceso al nuevo estado al que pasa e insertar el PCB en la cola de *bloqueados* o bloqueados por eventos. 
> 3. Seleccionar un nuevo proceso del conjunto de los que se encuentran en estado *Preparado* (Scheduler).
> 4. Actualizar el estado del proceso seleccionado a *Ejecutándose* y sacarlo de la lista de *preparados*. 
> 5. Cargar los registros del procesador con la información de los registros almacenada en el PCB del proceso seleccionado.

##### 2. Cambio de modo

Se ejecuta **una rutina del SO** en el contexto del proceso que se encuentra en estado *Ejecutándose*: ¿Cuándo puede realizarse? Siempre que el SO pueda ejecutarse, luego solamente como resultado de:

- Una **interrupción**
- Una **excepción**
- Una **llamada** al sistema

> **Modos de ejecución**:
>
> 1. *Modo usuario:* el programa que se ejecuta en este modo solo tiene acceso a
>    - Un subconjunto de los registros del procesador
>    - Un subconjunto del repertorio de instrucciones máquina
>    - Un área de la memoria
> 2. *Modo kernel:* el programa que se ejecuta en este modo tiene acceso a todos los recursos de la máquina

###### ¿Cómo usa el SO los modos de ejecución?

El modo de ejecución (bit en el PSW) cambia a modo kernel, **automáticamente** por hardware, cuando se produce

- Una **interrupción**
- Una **excepción**
- Una **llamada** al sistema

Seguidamente se ejecuta la rutina del SO correspondiente al evento producido. Finalmente, cuando termina la rutina, el hardware restaura automáticamente el modo de ejecución a **modo usuario**.

> **Cambio de modo:**
>
> 1. *El hardware automáticamente salva* como mínimo el PC + PSW y cambia a modo kernel
> 2. Determinar automáticamente la rutina del SO que debe ejecutarse y cargar el PC con su dirección de comienzo
> 3. Ejecutar la rutina. Posiblemente la rutina comience salvando el resto de registros del procesador y termine restaurando en el procesador la información de registros previamente salvada
> 4. Volver de la rutina del SO. *El hardware automáticamente restaura* en el procesador la información del PC y PSW previamente salvada

#### LLAMADAS AL SISTEMA

Es la forma en la que se comunican los programas de usuario con el SO en tiempo de ejecución. Son solicitudes al SO de petición de servicio. Modelo cliente/servidor. 

Se implementan a través de una trampa (instrucción trap 12 en ensamblador) o interrupción software. Algunos ejemplos:

- Solicitudes de E/S: manipulación de archivos y disco
- Gestión de procesos: control de procesos y comunicaciones
- Gestión de memoria: mantenimiento de la información

![image-20210113025133482](/home/clara/.config/Typora/typora-user-images/image-20210113025133482.png)

#### HEBRAS

Un proceso permite al SO Controlar la asignación de los recursos necesarios para la ejecución de programas (incluida la memoria), e intercalar la ejecución del programa con otros programas.

Una hebra es una **ejecución independiente de un proceso**: puede haber varias hebras en ejecución que pertenezcan al mismo proceso. Las hebras permiten separar los recursos del proceso con su ejecución

- La tarea se encarga de soportar todos los recursos necesarios
- Cada una de las hebras permite la ejecución del programa de forma independiente del resto de hebras

##### Hebras y el modelo 5 estados

Las hebras debido a su característica de ejecución de programas presentan cinco estados análogos al modelo de estados para procesos: ejecutando, preparado, bloqueado, nuevo y finalizado

![image-20210113025534356](/home/clara/.config/Typora/typora-user-images/image-20210113025534356.png)

##### Ventajas de las hebras

- Menor tiempo de creación de una hebra en un proceso ya creado que la creación de un nuevo proceso
- Menor tiempo de finalización de una hebra que de un proceso
- Menor tiempo de cambio de contexto (hebra) entre hebras pertenecientes al mismo proceso
- Facilitan la comunicación entre hebras pertenecientes al mismo proceso 
- Permiten aprovechar las técnicas de programación concurrente y el multiprocesamiento simétrico

### 4. Gestión básica de memoria

Tarea realizada por el SO que consiste en gestionar la jerarquía de memoria para cargar y descargar procesos hacia o desde la memoria principal. 

El dispositivo de hardware MMU (*Memory Managament Unit*) **transforma direcciones lógicas en direcciones físicas**. Con esto pretendemos:

- Ofrecer a cada proceso un espacio de memoria lógica propio
- Proporcionar protección entre los procesos
- Permitir que los procesos compartan memoria(tipos de direcciones)
- Maximizar el rendimiento del sistema.

#### REQUISITOS

- **Reubicación**: Como la memoria no es infinita, existe la necesidad de cargar en memoria solo parte de los procesos y no de forma permanente (*swap*). Las direcciones de memoria que ocupa un proceso varían de acuerdo a la disponibilidad de espacios libres
- **Protección**: No se puede permitir que los procesos accedan a las direcciones del SO ni a la de los otros procesos
- **Compartición**: Bajo la supervisión y control del sistema operativo, puede ser provechoso que los procesos compartan memoria
- **Organización Lógica**: Correspondencia entre el SO y el hardware al tratar la concepción lógica que tienen los procesos y sus datos, con la organización física de la memoria

#### CARGA ABSOLUTA Y REUBICACIÓN

- Tipos de direcciones:
  - **Físicas** (directas a memoria) o absolutas.
  - **Relativas** al origen del programa. 
  - **Lógicas**, o referencia a una localización no asignada. 
- Carga absoluta:
  - Asignar direcciones físicas al programa en tiempo de compilación
  - El programa no es reubicable
- Reubicación:
  - Capacidad de cargar y ejecutar un programa en un lugar arbitrario de la memoria

![image-20210113030833454](/home/clara/.config/Typora/typora-user-images/image-20210113030833454.png)

##### Reubicación estática

El **compilador** genera direcciones **lógicas** (relativas) de 0 a M. La decisión de dónde ubicar el programa en memoria principal se realiza en tiempo de carga.

El cargador añade la dirección base de carga a todas las referencias relativas a memoria del programa.

![image-20210113030957373](/home/clara/.config/Typora/typora-user-images/image-20210113030957373.png)

##### Reubicación dinámica

El **compilador** genera direcciones **lógicas** (relativas) de 0 a M. La traducción de direcciones lógicas a físicas se realiza en tiempo de ejecución, luego el programa está cargado con referencias relativas.

Requiere apoyo hardware.

![image-20210113031051617](/home/clara/.config/Typora/typora-user-images/image-20210113031051617.png)

#### DEFINICIONES

- **Espacio de direcciones lógico:** Conjunto de direcciones lógicas (o relativas) que utiliza un programa ejecutable
- **Espacio de direcciones físico:** Conjunto de direcciones físicas (memoria principal) correspondientes a las direcciones lógicas del programa en un instante dado
- **Mapa de memoria de un ordenador:** Todo el espacio de memoria direccionable por el ordenador. Normalmente depende del tamaño del bus de direcciones
- **Mapa de memoria de un proceso:** Estructura de datos (que reside en memoria) que indica el tamaño total del espacio de direcciones lógico y la correspondencia entre las direcciones lógicas y las físicas

#### TÉCNICAS DE ASIGNACIÓN CONTIGUA DE MEMORIA

Debido a la multiprogramación, varios procesos residen simultáneamente en MP. En cada cambio de contexto, su intercambio con HD es costoso.

- **Particiones fijas:**
  - La MP se divide en cierto nº de partes de tamaño constante: cada nuevo proceso es ubicado en una partición
  - La liberación del proceso libera la partición
  - El espacio no ocupado es inutilizable
    - Genera fragmentación interna
- **Particiones variables:** 
  - El tamaño de la partición en MP es exactamente el que el proceso solicita
    - Genera fragmentación externa, la compactación es costosa
    - Se necesita un mecanismo de relocalización

#### TÉCNICAS DE ASIGNACIÓN NO CONTIGUA DE MEMORIA

Trocear el espacio lógico en unidades más pequeñas: **páginas** (elementos de longitud fija), o **segmentos** (elementos de longitud variable). Los trozos no tienen por qué ubicarse consecutivamente en el espacio físico de memoria.

#### Paginación

- El espacio de direcciones físicas de un proceso puede ser **no contiguo** 
- La memoria física se divide en **bloques de tamaño fijo**, denominados **marcos** de página
  - El tamaño es potencia de dos, de 512 B a 8 KB
- El espacio lógico de un proceso se divide conceptualmente en bloques del mismo tamaño, denominados **páginas**
  - Los marcos de página contendrán páginas de los procesos 

*Calcular: nº máximo de páginas, nº máximo de marcos y tamaño de la página.*

> Las direcciones lógicas, que son las que genera la CPU, se convierten a los valores número de página (p) y desplazamiento dentro de la página (d)
>
> ![image-20210113031532124](/home/clara/.config/Typora/typora-user-images/image-20210113031532124.png)
>
> Las direcciones físicas contienen el número de marco (m, dirección base del marco donde está almacenada la página) y desplazamiento (d) m d
>
> ![image-20210113031541298](/home/clara/.config/Typora/typora-user-images/image-20210113031541298.png)

- Cuando la CPU genere una dirección lógica será necesario traducirla a la dirección física correspondiente
  - La tabla de páginas mantiene información necesaria para realizar dicha traducción
- Existe una tabla de páginas por proceso
  - Tabla de marcos de página, usada por el SO, contiene información sobre cada marco de página

##### Tabla de paǵinas

- Una entrada por cada página del proceso:
  -  Número de marco (dirección base del marco) en el que está almacenada la página si está en memoria principal
  - Modo de acceso autorizado a la página (bits de protección)
  - Otros bits adicionales: de presencia, modificación...

![image-20210113124158900](/home/clara/.config/Typora/typora-user-images/image-20210113124158900.png)

##### Implementación

- La tabla de páginas y la lista de marcos libres se mantienen en MP
- El registro base de la tabla de páginas (RBTP) apunta a la tabla de páginas. Suele almacenarse en el PCB del proceso
- En este este esquema, cada acceso a una instrucción o dato requiere dos accesos a memoria, **uno a la tabla de páginas y otro a memoria**

###### Buffer de Traducción Adelantada, TLB

#### Segmentación

Esquema de organización de memoria que soporta mejor la visión de memoria del usuario. Un programa es una colección de unidades lógicas segmentos. *Ej. procedimientos, funciones, pila, tabla de símbolos, matrices...*

![image-20210113125111771](/home/clara/.config/Typora/typora-user-images/image-20210113125111771.png)

##### Tabla de segmentos

Una dirección lógica es una tupla tal que `<numero de segmento, desplazamiento>`

La tabla de segmentos aplica direcciones bidimensionales definidas por el usuario en direcciones físicas de una dimensión. Cada entrada de la tabla contiene los siguientes elementos:

- Registro base: memoria
- Registro límite: tamaño o longitud del segmento
- Información de protección, presencia, modificación…

![image-20210113124802495](/home/clara/.config/Typora/typora-user-images/image-20210113124802495.png)

##### Implementación

- La Tabla de Segmentos, y la lista de segmentos libres se mantienen 

- El PCB del proceso almacena:

  - Registro Base de la Tabla de Segmentos (RBTS): apunta a la dirección de inicio de la tabla de segmentos 

  - Registro Longitud de la Tabla de Segmentos (RLTS): indica el número de segmentos del proceso

    Una dirección lógica `<s,d>` es legal si: `s < R`
    

```
PAGINACIÓN:
	- dirección física: nº marco * tamaño página + despl
	- dirección lógica: (nº página, despl)
	
SEGMENTACIÓN:
	- dirección física: base + despl, 
								donde despl < tamaño segmento
	- dirección lógica: (nº segmento, despl)
```



# FS Tema 3: compilación y enlazado de programas

> - Justificar la existencia de los lenguajes de programación
> - Conocer el proceso de traducción
> - Diferenciar entre compilación e interpretación
> - Identificar los elementos que intervienen en la gestión de memoria
> - Conocer las necesidades de memoria de los procesos
> - Conocer el proceso de enlazado de programas
> - Conocer las diferencias entre enlace estático y dinámico
> - Reconocer diferentes tipos de bibliotecas

### 1. Lenguajes de programación

Un lenguaje de programación es un conjunto de símbolos (y reglas para combinarlos) que se usa para expresar algoritmos. Los lenguajes de programación...

- Son independientes de la arquitectura física del ordenador
- Al ser de alto nivel, utilizan notaciones más cercanas a las habituales del ámbito en el que se usan
- Una sentencia de un lenguaje de alto nivel se traduce en múltiples instrucciones en lenguaje máquina
- Necesitan de un proceso de traducción a código interpretable por el procesador
- Cuentan con estándares de portabilidad (ej. *ANSI*), que les permiten que el lenguaje máquina producido sea ejecutable en múltiples arquitecturas o plataformas
- Permiten la definición de variables, funciones, procedimientos, clases...
- Ofrecen funciones aritmético-lógicas, de manejo de texto, de manejo de ficheros...
- Existen ciertos convenios de notación, comentarios, tabulación... para mejorar la legibilidad del código

![image-20210113130322843](/home/clara/.config/Typora/typora-user-images/image-20210113130322843.png)

![image-20210113130339987](/home/clara/.config/Typora/typora-user-images/image-20210113130339987.png)

### 2. Construcción de traductores

Traductor es un programa que recibe como entrada un texto en un lenguaje de programación concreto y produce, como salida, un texto en lenguaje máquina equivalente

> - **Entrada**: lenguaje fuente, define una máquina virtual
> - **Salida**: lenguaje máquina, define una máquina real

Existen dos aproximaciones al concepto de traducción: compilación, e interpretación. Java es un lenguaje que combina compilación e interpretación y por eso es multiplataforma.

#### COMPILADOR

Traduce la especificación de entrada a **lenguaje máquina incompleto** y con instrucciones máquina incompletas. Requiere de un complemento denominado **ensamblador**.

![image-20210113131112337](/home/clara/.config/Typora/typora-user-images/image-20210113131112337.png)

El **enlazador** (linker) realiza el enlazado de los programas completando las instrucciones máquina necesarias. Añade rutinas binarias de funcionalidades no programadas directamente en el programa fuente (bibliotecas), y genera un programa ejecutable para la máquina real.

La compilación es un proceso lento que se realiza en dos fases: análisis del código fuente, y síntesis del objeto.

#### INTÉRPRETE

El intérprete lee un programa fuente escrito para una máquina virtual y realiza la traducción de manera interna. Cada instrucción es cargada y ejecutada una a una para la máquina real.

No se genera ningún programa objeto equivalente al descrito en el programa fuente.

![image-20210113144118775](/home/clara/.config/Typora/typora-user-images/image-20210113144118775.png)

Un intérprete es útil en las siguientes situaciones:

- El programador trabaja en un entorno interactivo y se desean obtener los resultados de la ejecución de una instrucción antes de ejecutar la siguiente
- El programador ejecuta en escasas ocasiones y el tiempo de ejecución no es importante 
- Las instrucciones del lenguaje tienen una estructura simple y pueden ser analizadas fácilmente 
- Cada instrucción será ejecutada una sola vez

No conviene un intérprete si las instrucciones del lenguaje son complejas, los programas son parte del modo de producción y requieren velocidad o si las instrucciones se ejecutan frecuentemente

#### Tabla comparativa

| Compilador                                                   | Intérprete                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Tiene como salida un único lenguaje objeto                   | Tiene como salida instrucciones traducidas                   |
| El rendimiento en la ejecución del programa compilado (la salida) es más rápido que interpretado | El rendimiento (del intérprete) se somete al rendimiento de analizar la traducción una a una |
| La salida puede depender de la arquitectura                  | Tiende a ser más portable e independiente de la arquitectura |
| No requiere del programa fuente porque el programa objeto es ejecutable. Oculta el código fuente | Se requiere del lenguaje fuente para su ejecución. Más seguro |
| Los errores sintácticos y semánticos se detectan antes de la ejecución del programa objeto | Se detectan los errores en la ejecución del programa. Permite detectar e informar mejor de los errores |
| Tiene menos flexibilidad en el uso de la memoria para el programa objeto | Es más flexible para que el programa pueda usar la memoria   |

#### ESQUEMA DE TRADUCCIÓN

1. Partimos de un programa fuente, L
2. El analizador **sintáctico** verifica léxico y sintaxis. 
   - Comprueba las reglas de producción (P) en función de G
   - La complejidad de la verificación sintáctica depende del tipo de gramática que define el lenguaje
3. El analizador **semántico** verifica la validez del significado. Si es válido, tenemos un conjunto de instrucciones, i_L
4. El generador de código traduce i_L, T
5. La salida es un programa objeto en L

##### Gramáticas

Una gramática libre de contexto G es una 4-tupla (N, T, P, S). Las sentencias de un lenguaje se dan mediante el conjunto de todas las producciones gramaticales. Se dice que L(G) es un lenguaje generado por una gramática.

**`G={Vn, Vt, P, S}`**

- Vn es un conjunto de símbolos no terminales
- Vt es el conjunto de símbolos terminales
- P es el conjunto de producciones
- S es el símbolo inicial

![image-20210113202731023](/home/clara/.config/Typora/typora-user-images/image-20210113202731023.png)

> Una construcción válida en el lenguaje anterior: `if a=9 then bb3 = 8`
>
> Una construcción no válida: `+a = o`

Una gramática es ambigua cuando admite más de un árbol sintáctico para una misma secuencia de símbolos de entrada. Tiene que ver, por ejemplo, con la precedencia de operadores o con el uso de los paréntesis. 

![image-20210113202854283](/home/clara/.config/Typora/typora-user-images/image-20210113202854283.png)

### 3. Fases de la traducción

![image-20210113202937658](/home/clara/.config/Typora/typora-user-images/image-20210113202937658.png)

#### ANÁLISIS LÉXICO

Procesa los caracteres de la entrada del programa fuente y produce como salida una secuencia de tokens.

Un **token** es un conjunto de lexemas con una misión sintáctica y tipo.

Un **lexema** o palabra es una secuencia de caracteres del alfabeto con significado propio

Un **patrón** es una especificación del código fuente para el analizador léxico, de forma que se pueden tomar los lexemas de un token

![image-20210113203242315](/home/clara/.config/Typora/typora-user-images/image-20210113203242315.png) 

Usualmente el lenguaje define estos tokens:

- Uno por cada palabra reservada (if, do, while...)
- Tokens para los operadores (individuales o agrupados)
- Un token que representa todos los identificadores, tanto de variables como de argumentos
- Uno o más tokens que representan las constantes
- Tokens para cada signo de puntuación

> **Error léxico:**
>
> Cuando el carácter de la entrada no tenga asociado a ninguno de los patrones disponibles en nuestra lista de tokens. Ej: carácter extraño en la formación de una palabra reservada como `whi¿le`

##### Especificación de tokens mediante expresiones regulares

Las expresiones regulares identifican un patrón de símbolos del alfabeto como pertenecientes a un token determinado. Los elementos utilizados son:

1. `*`: Cero o más veces
2. `+`: Una o más veces
3. `?`: Cero o una vez
4. `|a|b|c|d|...|z` = `[a-z]`

Dada la gramática o su diagrama de transiciones asociado, los patrones que van a definir a los tokens son:

![image-20210113203715414](/home/clara/.config/Typora/typora-user-images/image-20210113203715414.png)

#### ANÁLISIS SINTÁCTICO

Las gramáticas ofrecen beneficios considerables tanto para los que diseñan lenguajes como para los que diseñan los traductores.

- Una gramática proporciona una especificación sintáctica precisa de un lenguaje de programación
- A partir de ciertas clases gramaticales, es posible construir de manera automática un analizador sintáctico (YACC)
- Permite revelar ambigüedades sintácticas y puntos problemáticos en el diseño del lenguaje
- Una gramática permite que el lenguaje pueda evolucionar o se desarrolle de forma iterativa agregando nuevas construcciones

El análisis sintáctico analiza las secuencias de tokes y comprueba que son correctas sintácticamente. Representa la estructura del código fuente. A partir de una secuencia de tokens, el analizador nos devuelve:

- Si la secuencia es correcta: existe un conjunto de reglas gramaticales aplicables a los tokens para comprobar su validez

- El orden en el que hay que aplicar las construcciones de la gramática para obtener la secuencia de entrada (árbol sintáctico)

  ![image-20210113222613615](/home/clara/.config/Typora/typora-user-images/image-20210113222613615.png)

> **Error sintáctico: **
>
> Si no se encuentra un árbol sintáctico para una secuencia de entrada, entonces la secuencia de entrada es incorrecta sintácticamente

#### ANÁLISIS SEMÁNTICO

La semántica de un lenguaje de programación es el significado dado a las distintas construcciones sintácticas

El significado está ligado a la estructura sintáctica de las sentencias.

Durante la fase de análisis semántico se producen errores cuando se detectan construcciones sin un significado correcto:

- Variables sin declarar
- Tipo incompatible
- Llamada a procedimientos incorrectos
- Llamada a un procedimento con argumentos incorrectos

> **Error semántico:**
>
> Cuando la sintaxis del código es correcta pero el significado no es el que se pretendía se produce un error semántico. El compilador no detecta los errores semánticos. 
>
> Ej: el identificador no está previamente declarado: `da¿ta`

#### GENERACIÓN DE CÓDIGO

- Es más rápido construir compiladores para otros programas
  - **Entrada**: árbol semántico
  - **Salida**: código intermedio simple (casi lenguaje máquina) 
- Optimización de código intermedio:
- Solo optimizaciones independientes del lenguaje (varios saltos, bucles, expresiones comunes…)
  - **Entrada**: código intermedio poco eficiente
  - **Salida**: código intermedio mejorado

![image-20210113230853840](/home/clara/.config/Typora/typora-user-images/image-20210113230853840.png)

La última fase genera un archivo con un código en lenguaje objeto (generalmente lenguaje máquina) con el mismo significado que el texto fuente (traducción). Incluye la optimización del código objeto.

![image-20210113230925483](/home/clara/.config/Typora/typora-user-images/image-20210113230925483.png)

![image-20210113230936629](/home/clara/.config/Typora/typora-user-images/image-20210113230936629.png)

### 4. Modelos de memoria de un proceso

Elementos responsables de la gestión de memoria: 

- Lenguaje de programación 
- Compilador 
- Enlazador 
- Sistema operativo 
- MMU – Memory Management Unit

##### Niveles de gestión de memoria y operaciones

La gestión del mapa de memoria de un proceso va desde la generación del ejecutable a su carga en memoria. La gestión es relativa a los tipos de objetos necesarios para un programa, su ciclo de vida, bibliotecas... 

- **Nivel de procesos:** reparto de memoria entre los procesos. Responsabilidad del SO
  - Operaciones: creación, eliminación, duplicado
- **Nivel de regiones:** distribución del espacio asignado a un proceso a las regiones del mismo. Gestionado por el SO
  - Operaciones: creación, eliminación, duplicado
- **Nivel de zonas: **reparto de una región entre las diferentes zonas (nivel estático, dinámico, de pila y dinámico de heap) de ésta. Gestionado por el lenguaje de programación con soporte del SO
  - Operaciones: reserva, liberación, redimensión 

##### Necesidades de memoria en un proceso

- Tener un espacio lógico independiente
- Espacio protegido del resto de procesos
- Posibilidad de compartir memoria
- Soporte a diferentes regiones
- Facilidades de depuración
- Uso de un mapa amplio de memoria
- Uso de diferentes tipos de objetos de memoria
- Persistencia de datos
- Desarrollo modular
- Carga dinámica de módulos

#### OBJETOS DE MEMORIA

- **Datos estáticos:** existen durante toda la vida del programa
  - Constantes vs variables 
  - Con vs sin valor inicial (ver PIC)
- **Datos dinámicos asociados a la ejecución de una función:** se almacenan en la pila.
  - Registro de activación
  - Variables locales
  - Parámetros de función
  - Dirección de retorno
- **Datos dinámicos controlados por el programa** - ***heap***

#### POSITION INDEPENDENT CODE - PIC

Un fragmento de código cumple esta propiedad si puede ejecutarse en cualquier parte de la memoria. Es necesario que todas sus referencias a instrucciones o datos no sean absolutas sino relativas a un registro, por ejemplo, contador de programa.

### 5. Ciclo de vida de un programa

A partir de un código fuente, un programa debe pasar por varias fases antes de poder ejecutarse:

1. Preprocesado
2. Compilación
3. Ensamblado
4. Enlazado
5. Carga y ejecución

![image-20210113233404685](/home/clara/.config/Typora/typora-user-images/image-20210113233404685.png)

El **compilador** genera código objeto y calcula cuánto espacio ocupan los distintos tipos de dato

1. Asigna direcciones a los símbolos estáticos, y resuelve las referencias de forma absoluta o relativa
2. Las referencias a símbolos dinámicos se resuelven mediante **direccionamiento relativo a la pila ** para datos relacionados a la invocación de funciones, o con **direccionamiento indirecto** para el heap. No necesitan reubicación al no aparecer en el archivo objeto
3. Genera la tabla de símbolos e información de depuración si se solicita

![image-20210113233659915](/home/clara/.config/Typora/typora-user-images/image-20210113233659915.png)

![image-20210113233808574](/home/clara/.config/Typora/typora-user-images/image-20210113233808574.png)

El **enlazador** debe agrupar los archivos objeto de la aplicación y bibliotecas, y resolver las referencias estáticas entre ellos. Puede realizar reubicaciones dependiendo del esquema de gestión de memoria utilizado

1. Resuelve los śimbolos externos usando la tabla de símbolos
2. Agrupa las regiones de similares los diferentes módulos (código, datos inicializados, sin inicializar...)
3. Realiza reubicación de módulos: transforma las referencias dentro de un módulo a referencias dentro de regiones
4. Realiza reubicación de regiones: transforma direcciones de una región en direcciones del mapa del proceso

![image-20210113234056710](/home/clara/.config/Typora/typora-user-images/image-20210113234056710.png)

Durante la **carga y ejecución** se da la reubicación del proceso. Hay tres formas según el esquema de gestión de memoria:

1. El cargador copia el programa en memoria sin modificarlo. La MMU es la encargada de realizar la reubicación en tiempo de ejecución
2. En paginación, el hardware es capaz de reubicar los procesos en ejecución, por lo que el cargador lo carga sin modificar
3. Si no usamos hardware de reubicación, la reubicación se realiza en la carga 

##### Diferencia entre archivos objeto y archivos ejecutables

Los archivos objeto (resultado de la compilación) y ejecutable (resultado del enlazado) son muy similares en cuanto a contenidos. Sus diferencias son:

- En el ejecutable la cabecera del archivo contiene el punto de inicio del mismo, es decir, la primera nstrucción que se cargará en el PC
- En cuanto a las regiones, sólo hay información de reubicación si ésta se ha de realizar en la carga

![image-20210113235135261](/home/clara/.config/Typora/typora-user-images/image-20210113235135261.png)

#### SECCIONES DE UN ARCHIVO

- **.text** - Instrucciones: compartida por todos los procesos que ejecutan el mismo binario
  - Permisos: r y w. Es de las regiones más afectada por la optimización realizada por parte del compilador
- **.bss** – **Block Started by Symbol**: datos no inicializados y variables estáticas. El archivo objeto almacena su tamaño pero no los bytes necesarios para su contenido
- **.data** – Variables globales y estáticas inicializadas 
  - Permisos: r y w 
- **.rdata** – Constantes o cadenas literales 
- **.reloc** – Información de reubicación para la carga
- **Tabla de símbolos** – Información necesaria (nombre y dirección) para localizar y reubicar definiciones y referencias simbólicas del programa. Cada entrada representa un símbolo
- **Registros de reubicación** – información utilizada por el enlazador para ajustar los contenidos de las secciones a reubicar

### 6. Bibliotecas

Una biblioteca es una colección de objetos relacionados entre sí. Favorecen la modularidad y reusabilidad del código. Según su enlazado, existen:

- **Bibliotecas estáticas:** se enlazan con el programa en la compilación (.a)
- **Bibliotecas dinámicas:** se enlazan en ejecución (.so)

![image-20210113235810769](/home/clara/.config/Typora/typora-user-images/image-20210113235810769.png)

![image-20210113235821722](/home/clara/.config/Typora/typora-user-images/image-20210113235821722.png)

![image-20210113235829635](/home/clara/.config/Typora/typora-user-images/image-20210113235829635.png)

##### Bibliotecas dinámicas: inconvenientes

- El código de la biblioteca está en todos los ejecutables que la usan, lo que desperdicia disco y memoria
- Si actualizamos las bibliotecas, debemos recompilar el programa para que se beneficie de la nueva versión

Las bibliotecas dinámicas se integran en ejecución, para ello ya se ha realizado la reubicación de módulos. La diferencia con un ejecutable es que tienen tabla de símbolos, información de reubicación y no tiene punto de entrada.

Las bibliotecas dinámicas pueden ser:

- **Bibliotecas compartidas de carga dinámica** – la reubicación se realiza en tiempo de enlazado
- **Bibliotecas compartidas enlazadas dinámicamente** – el enlazado se realiza en ejecución

# FS Tema 4: sistemas de archivos, introducción a las bases de datos

> - Conocer los conceptos básicos de archivo, registro, campo, directorio y estructura jerárquica de archivos
> - Conocer los distintos tipos de organización interna de archivos
> - Comprender los problemas inherentes a la gestión de archivos frente al uso de una base de datos
> - Conocer las características de una base de datos
> - Conocer el concepto de sistema de gestión de base de datos y las funciones que debe cumplir
> - Diseñar y construir una base de datos sencilla con MS Access

### 1. Organización de datos

#### EVOLUCIÓN

- **60s:** Se utilizaban ficheros para almacenar datos quedando representadas las relaciones entre ellos a través de referencias simbólicas y/ o en algunos casos físicas. La información es estática
- **70s:** aparece la organización de datos: sistemas manejadores de archivos. La información se vuelve dinámica
- **80s:** aparecen los primeros Sistemas de Gestión de Bases de Datos (SGBD)
- **90s:** *Data Warehouse*

#### LOS DATOS

Los datos son una representación interna de la información. Los tipos de dato en memoria principal son:

- **Tipos base:** entero, real, lógico, carácter, enumerado, subrango... 
- **Estructuras de datos (combinados):** vectores, cadenas de caracteres, registros, listas enlazadas, árboles...
- **Datos permanentes (no en MP):** archivos. Su organización puede ser:
  - **Secuencial:** lectura/escritura consecutiva
  - **Indexada:** el índice te da un acceso a la zona del registro i 
  - **Encadenada:** cada registro tiene un puntero al siguiente 
  - **Directa:** la ubicación se obtiene de una función

Los manejadores de archivos presentan varios problemas:

- Redundancia de datos 
- Inconsistencia de la información 
- Dependencia de programas 
- Rigidez de búsqueda 
- Confidencialidad y Seguridad

#### CONCEPTO Y ESTRUCTURA DE LAS BASES DE DATOS

Una base de datos es un conjunto de datos integrados, con redundancia controlada y una estructura que sigue fielmente las reglas del sistema objeto que modela. Garantiza **independencia de datos**, **integridad**, **seguridad** y **confidencialidad**.

El SGBD cuenta con programas, procedimientos y lenguajes que permitirán a los diferentes usuarios describir, recuperar y manipular los datos almacenados en la base de datos.

La capa software tiene como objetivo proporcionar al user una vista abstracta de la información y darle un medio para recuperarla de forma eficiente.

![image-20210113020855845](/home/clara/.config/Typora/typora-user-images/image-20210113020855845.png)

##### Características de una base de datos

Una base de datos permite: 

- Insertar, modificar y manipular la información almacenada en la base de datos
- La consulta de la información almacenada
- La integridad de los datos: que la inserción y actualización de datos no provoque el mal funcionamiento de los datos ya almacenados
- Asegurar la privacidad de los datos: acceso o no a diferentes datos según tipo de usuario (**ACL, Access Control List**)
- Disponer de técnicas de respaldo y recuperación de errores que aseguren la seguridad de los datos si en algún momento se produjera un fallo

### 2. Abstracción de la información

- **Nivel físico:** describe las formas de almacenamiento físico de los datos
- **Nivel conceptual o lógico:** describe cuáles van a ser los datos y las relaciones que existen entre ellos
- **Nivel de vista:** describe los datos que ve un determinado usuario o grupo de usuarios

![image-20210113021115216](/home/clara/.config/Typora/typora-user-images/image-20210113021115216.png)

#### EL ADMINISTRADOR DE LA BASE DE DATOS

- Decide el contenido de la base de datos
- Decide la estructura de almacenamiento y la estrategia de acceso
- Define los controles de autorización y procedimientos de validación
- Define una estrategia de respaldo y recuperación tras posible fallos del sistema
- Controla el rendimiento y utilización de la base de datos
- Responde a los cambios de requerimientos

#### DDL Y DML

##### DDL (Data Definition Language)

Provee de los medios necesarios para definir los datos con precisión, especificando las distintas estructuras que contendrán la información de la base de datos.

##### DML (Data Modification Language)

Lenguaje mediante el cual se realizan dos funciones bien diferentes en la gestión de los datos: 

- La definición del nivel externo o de usuario de los datos
- La manipulación de los datos; es decir, la inserción, el borrado, la modificación y recuperación de los datos almacenados en la base de datos

### 3. Modelos de datos

Conjunto de herramientas conceptuales capaces de describir los datos, sus relaciones, su semántica y sus posibles limitaciones o restricciones. 

> **Cardinalidad:**
>
> Número de entidades que se pueden relacionar con otra entidad a través de una relación

#### MODELO JERÁRQUICO

- **Datos:** registros
- **Relaciones:** ligas
- **Cardinalidad:** restringido a 1:1 y 1:N

![image-20210113021626545](/home/clara/.config/Typora/typora-user-images/image-20210113021626545.png)

#### MODELO EN RED

- **Datos:** registros
- **Relaciones:** ligas
- **Cardinalidad: **todas

![image-20210113021646502](/home/clara/.config/Typora/typora-user-images/image-20210113021646502.png)

#### MODELO RELACIONAL

> **Tabla:** 
>
> Estructura bidimensional formada por una sucesión de registros del mismo tipo.

- **Datos:** tablas
  - Filas: registros
  - Columnas: campos o atributos
- **Relaciones:** tablas (inclusión en otro campo (clave foránea))
- **Cardinalidad: **todas

#### ![image-20210113021949113](/home/clara/.config/Typora/typora-user-images/image-20210113021949113.png)

Restricciones: 

- Todos los registros de una tabla son del mismo tipo
- Si se desea almacenar registros diferentes, se deberán usar tablas distintas
- Cada columna se identifica mediante un nombre de columna
- No se permite la existencia de dos campos (columnas) con el mismo nombre
- En ninguna tabla se permite la duplicación de registros
- El orden de los registros en la tabla es indiferente
- En cualquier momento se pueden recuperar los registros en un orden particular

### 4. Modelo E/R

> *"Los datos deberían relacionarse mediante interrelaciones naturales, lógicas, inherentes a los datos, más que mediante punteros físicos."* [Codd]

Una **entidad** tiene existencia propia, cada instancia debe poder distinguirse de las demás, y todas las instancias de una entidad deben tener las mismas características

Un **atributo** es una característica descriptiva de una entidad. El **dominio de un atributo** son los valores apropiados a un atributo.

#### CARACTERÍSTICAS

- Superclave: atributos que pueden servir para identificar unívocamente la entidad
- Llave/clave candidata: superllave mínima
- Llave/clave primaria: superllave seleccionada
- Llave externa, clave foránea o clave ajena
- Relación: Grado de una relación
- Tipo de correspondencia
  - Uno a uno (1:1)
  - Uno a muchos (1:N)
  - Muchos a muchos (N:M)
- Atributos asociados a una relación

#### ELEMENTOS DE UN DIAGRAMA E/R

- Rectángulos etiquetados: conjuntos de entidades
- Elipses etiquetadas: cada uno de los atributos que identifican a las entidades
- Rombos etiquetados: relaciones que unen a las entidades
- Doble elipse o subrayado: clave primaria  
- Cardinalidad:
  - 1:N representa la cardinalidad uno a muchos
  - N:1 representa la cardinalidad muchos a uno
  - 1:1 representa la cardinalidad uno a uno
  - N:M representa la cardinalidad muchos a muchos

![image-20210113023340403](/home/clara/.config/Typora/typora-user-images/image-20210113023340403.png)



# FS Tema 5: generación y depuración de aplicaciones

> - Conocer las implicaciones de las plataformas hardware y software
> - Conocer el proceso de depuración
> - Descubrir las posibilidades que los entornos integrados, como utilidades de sistema, me permiten de cara a la generación de programas y su depuración

### 1. Plataformas

Son una combinación de hardware y/o software utilizadas para ejecutar aplicaciones software.

Dependiendo de la plataforma, el software puede clasificarse como:

- Dependiente de la plataforma en la que se desarrolla y ejecuta, bien sea por hardware, SO o máquina virtual
- Multiplataforma, cuando el software es implementado y operado en varias plataformas
  - Se pueden ejecutar o bien en tantas plataformas como existan (independiente de plataforma), o bien en un puñado de ellas

### 2. Entornos de desarrollo software

![image-20210113012357124](/home/clara/.config/Typora/typora-user-images/image-20210113012357124.png)

Antes de las IDEs, la preparación de programas se realizaba mediante una cadena de operaciones: cada una de las herramientas debía invocarse manualmente por separado

- El editor es un simple editor de texto
- El **compilador** traduce cada fichero de código fuente a fichero objeto
- El **montador** (linker, builder, loader) combina varios ficheros objeto para generar un fichero ejecutable
- El **depurador** maneja información en términos de lenguaje máquina

#### IDEs

Las IDEs son entornos de programación que combinan las herramientas anteriores, con algunos añadidos:

- El editor cuenta con una orientación al lenguaje de programación usado: reconoce y maneja ciertos elementos sintácticos
- El depurador no presenta la información en lenguaje máquina, sino en el lenguaje fuente
- El editor está bien integrado con las demás herramientas (con ayudas como llevarnos a los puntos que dan error del código)

Los objetivos de una IDE son:

- Maximizar la productividad del programador; todo el desarrollo se lleva a cabo bajo la misma aplicación
- Reducir las tareas de configuración
- Acelerar el aprendizaje de lenguajes de programación, analizando el código y dándonos pistas sobre errores léxicos, sintácticos...
- Aprender otras IDEs rápidamente, ya que integran herramientas similares

Algunas categorías en las que podemos dividir las IDEs son:

- Entornos centrados en un lenguaje

  - Inter)Lisp, Delphi, Visual C++, Visual Age, Eclipse, Visual Studio .NET 

    Entornos especiales: Ada, Smalltalk, Component Pascal

- Entornos orientados a la estructura

  - The Cornell Program Synthesizer (subconjunto de PL/I), Mentor (Pascal), Gandalf (intenta ser un entorno de desarrollo completo, para todo el ciclo de vida)

- Entornos basados en la combinación de herramientas

  - Emacs, Vim, Gvim, Med, SciTE, jEdit, Android Studio (Eclipse)

### 3. Técnicas de depuración de programas

La depuración es una actividad compleja que tiene como objetivo solventar los errores cometidos en el diseño y codificación de un programa.

- Incrementa la productividad encontrando y solucionando errores de forma rápida y efectiva
- Mejora la calidad del programa eliminando y previniendo errores
- Mejora lenguajes de programación y herramientas, identificando errores estáticamente y detectando el incumplimiento de invariables de forma dinámica

Al escribir un programa nos equivocamos, y es difícil detectar los errores visualmente. El proceso de depuración requiere:

1. Detectar la existencia de un error (hay errores que pueden no ser detectados jamás)
2. Aislar la fuente del error
3. Identificar la causa
4. Determinar solución
5. Aplicar solución
6. Comprobación

Este proceso es lento y engorroso: los depuradores pretenden facilitar esta tarea. Algunos de los errores a los que nos enfrentamos son:

- **Errores sintácticos:** por ejemplo, `ERROR: ; expected`. Estos errores son errores detectados durante la fase de compilación o la de enlazado. 

  Imprimen un mensaje de error y no generan el código objeto correspondiente

  - **Warnings:** no son errores sintácticos, pero son algo "sospechoso". Los debemos tratar como errores a no se que comprendamos y valorar por qué se han producido

- **Errores de ejecución: **por ejemplo, exceder el rango de un vector `(SEGMENTATION FAULT)` o realizar una operación de división por cero. 

  Este tipo de errores ocurren durante la ejecución de un programa y frecuentemente implica que dicho programa aborte.

- **Errores lógicos:** por ejemplo, bucles que se ejecutan más veces de las que deberían.

> Siempre hay que recordar que un programa sin errores de compilación no tiene por qué ser correcto

#### ANÁLISIS ESTÁTICO DEL CÓDIGO

Es el proceso de evaluar el software sin ejecutarlo. La idea es que, en base al código fuente, podamos obtener un mejor código sin alterar la semántica original.

Se nos dan sugerencias para mejorar nuestro código. La tarea principal de un analizador de código es encontrar partes del código que puedan:

- Reducir el rendimiento
- Provocar errores en el software
- Complicar el flujo de datos
- Tener una excesiva complejidad
- Suponer un problema en la seguridad

Existen dos tipos de analizadores: automáticos (como en las IDES) y manuales (programadores), son complementarios:

- El análisis automático se centra únicamente en facetas de más bajo nivel como la sintaxis y la semántica del código, funcionando este análisis en cualquier tipo de aplicación
- El análisis manual se ocupa de facetas de más alto nivel como, por ejemplo, la estructura de nuestra aplicación o su manera de trabajar con otros elementos externos como las librerías

#### TESTS

Son una serie de procesos que permiten verificar y comprobar que el software cumple con los objetivos y con las exigencias para las que fue creado. Su misión es la de encontrar errores antes de que el software final sea utilizado por los usuarios.

Los diferentes tipos de test se centran en distintas facetas del software:

- Test unitario

- Test funcional

- Test de integración

- Test de carga

- Test de regresión

  Etc...

#### PROFILING

Se encarga de analizar el rendimiento del software mientras éste se encuentra en ejecución determinando qué recursos son utilizados en cada momento por las distintas partes del software. Identifica qué partes del código implican una mayor carga para el sistema, para poder obrar en consecuencia y aplicar cambios.

Los tipos de profilers son:

- **Flat profilers:** calculan el tiempo promedio de las llamadas
- **Profiler de grafo de llamadas:** muestran los tiempos de llamada y las frecuencias de las funciones, así como las cadenas de llamadas en que participan basadas en el destinatario de la llamada
- **Profiler de uso:** muestran el uso de la Memoria Principal o la CPUg