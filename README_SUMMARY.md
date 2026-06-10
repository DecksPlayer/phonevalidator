# Aplicación de Validación y Selección Internacional de Números de Teléfono

Esta aplicación provee una solución robusta para la validación, selección y formateo de números de teléfono a nivel global, soportando múltiples países e idiomas. El núcleo del sistema se centra en validar la estructura telefónica contra patrones regulatorios específicos de cada país.

## 📱 Funcionalidades Principales

1.  **Validación Avanzada:** Utiliza el patrón único asociado a un `Country` específico para determinar si un número ingresado es válido, considerando la lógica de prefijos y códigos de área.
2.  **Detección Automática de País:** Capacidad para recibir un número completo y sugerir o confirmar automáticamente el país de origen analizando el código de marcado inicial.
3.  **Localización (i18n):** Soporte extensivo para múltiples idiomas mediante la gestión de nombres de países (`countries_names_en.dart`, `countries_names_es.dart`, etc.).
4.  **Experiencia de Usuario (UX):** Está diseñada modularmente con varias vistas dedicadas, lo que permite integrarla en diversos contextos de interfaz de usuario:
    *   Selección interactiva de país y código.
    *   Visualización concisa del resumen del número.
    *   Auto-detección mientras el usuario escribe.

## ⚙️ Arquitectura Técnica (Basado en `lib/src/`)

La lógica se apoya en las siguientes capas:

*   **Modelos (`models/`):** Define la estructura de un país y su información asociada.
*   **Controladores (`controllers/phone_validator.dart`):** Contiene la clase principal `PhoneValidator`, encargada del estado, los métodos de chequeo (`checkPhonePattern`, etc.) y la emisión de notificaciones de validez en tiempo real (`ValueNotifier`).
*   **Vistas (`view/`):** Módulos reutilizables para manejar diferentes flujos de entrada (ej: `phone_country_input.dart`, `phone_auto_detect_view.dart`).

## ✨ Resumen del Flujo de Trabajo Típico

1.  El usuario interactúa con un componente de selección (ej: `PhoneCountryInputView`).
2.  Al seleccionar o ingresar datos, el controlador (`PhoneValidator`) recibe el número y el contexto del país.
3.  Se ejecuta la lógica de validación contra los patrones definidos, actualizando el estado de validez disponible para consumir por las vistas.

---
*Este resumen fue generado analizando la estructura de archivos y la lógica central de validación de números en el proyecto.*