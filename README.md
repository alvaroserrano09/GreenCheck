# GreenCheck 🌱

**GreenCheck** es una aplicación educativa multiplataforma (Android y Web) desarrollada con Flutter. Está diseñada para facilitar la creación, gestión y resolución de tests por parte de profesores y estudiantes, con un enfoque en la experiencia de usuario y la eficiencia educativa.

## ✨ Funcionalidades principales

- Registro e inicio de sesión de estudiantes mediante autenticación con Supabase.
- Creación, edición y almacenamiento de tests por parte del profesorado.
- Resolución de tests con retroalimentación inmediata.
- Visualización de resultados.
- Interfaz intuitiva adaptada a dispositivos móviles y web.

## 🛠️ Tecnologías utilizadas

- **Flutter**: Framework principal para desarrollo multiplataforma.
- **Dart**: Lenguaje principal del proyecto.
- **Riverpod**: Gestión de estado reactiva y escalable.
- **Supabase**: Backend completo con autenticación, base de datos PostgreSQL y almacenamiento.

## 🚀 Instalación y ejecución

1. Clona este repositorio:

   ```bash
   git clone https://github.com/tuusuario/greencheck.git
   cd greencheck
   ```

2. Instala las dependencias:

   ```bash
   flutter pub get
   ```

3. Configura tu entorno Supabase:

   - Crea un proyecto en [Supabase](https://supabase.com/).
   - Configura las tablas necesarias para usuarios, tests, preguntas y respuestas.
   - Añade tus credenciales (`SUPABASE_URL` y `SUPABASE_ANON_KEY`) en un archivo seguro, por ejemplo:

     ```dart
     const supabaseUrl = 'https://xxx.supabase.co';
     const supabaseAnonKey = 'tu_clave_anonima';
     ```

4. Ejecuta la aplicación:

   ```bash
   flutter run
   ```

   Para ejecutarla en la web:

   ```bash
   flutter run -d chrome --web-port 3000
   ```

```


