# 📱 Lista de Contactos - Firebase Demo

Una aplicación SwiftUI moderna que demuestra la implementación de CRUD (Create, Read, Update, Delete) usando tanto **Firebase Firestore** como **Firebase Realtime Database**, permitiendo comparar ambas tecnologías en una interfaz elegante.

## 🚀 Características Principales

### ✨ Funcionalidades
- **📋 Gestión completa de contactos** con nombre y número de teléfono
- **🔄 Sincronización en tiempo real** entre dispositivos
- **⚡ Doble implementación**: Firestore y Realtime Database
- **🎨 Interfaz moderna** con SwiftUI y animaciones suaves
- **⚠️ Alertas de confirmación** para acciones críticas
- **💾 Persistencia automática** de datos

### 🛡️ Seguridad y UX
- **Alertas de confirmación** antes de eliminar contactos
- **Validación de formularios** con campos requeridos
- **Manejo de errores** con logs detallados
- **Animaciones fluidas** para mejor experiencia de usuario

## 📁 Estructura del Proyecto

```
FirestoreDatabaseVSRealtimeDatabase/
├── ContentView.swift              # Vista principal con navegación
├── FirestoreView.swift            # Vista para Firestore CRUD
├── FirestoreViewModel.swift       # Lógica de negocio para Firestore
├── RealtimeView.swift             # Vista para Realtime Database CRUD
├── RealtimeViewModel.swift        # Lógica de negocio para Realtime Database
├── FirestoreDatabaseVSRealtimeDatabaseApp.swift  # Punto de entrada de la app
├── Assets.xcassets/               # Recursos visuales
└── GoogleService-Info.plist       # Configuración de Firebase
```

## 🏗️ Arquitectura

### MVVM (Model-View-ViewModel)
- **Model**: `FirestoreItem` y `RealtimeItem` (estructuras de datos)
- **View**: SwiftUI Views (`FirestoreView`, `RealtimeView`, `ContentView`)
- **ViewModel**: Clases que manejan la lógica de negocio y comunicación con Firebase

### Firebase Integration
- **Firestore**: Base de datos NoSQL con documentos
- **Realtime Database**: Base de datos en tiempo real con estructura JSON
- **Observadores en tiempo real** para sincronización automática

## 🔧 Configuración Requerida

### 1. Firebase Setup
Antes de ejecutar la app, necesitas configurar Firebase:

1. **Crear proyecto en [Firebase Console](https://console.firebase.google.com)**
2. **Agregar app iOS** con bundle identifier: `com.devlokos.firestoredatabasevsrealtimedatabase`
3. **Descargar `GoogleService-Info.plist`** y agregarlo al proyecto
4. **Habilitar servicios**:
   - Firestore Database
   - Realtime Database

### 2. Reglas de Seguridad

#### Firestore Database Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /items/{document} {
      allow read, write: if true;
    }
  }
}
```

#### Realtime Database Rules
```json
{
  "rules": {
    "items": {
      ".read": true,
      ".write": true
    }
  }
}
```

### 3. Dependencias SPM
La app usa Swift Package Manager para manejar las dependencias de Firebase:

- `FirebaseCore`
- `FirebaseFirestore`
- `FirebaseDatabase`

## 📱 Cómo Usar la App

### 🏠 Pantalla Principal
- **Navegación elegante** entre Firestore y Realtime Database
- **Diseño moderno** con gradientes y iconos
- **Información clara** sobre cada base de datos

### 📋 Gestión de Contactos

#### ➕ Agregar Contacto
1. Toca el botón **"+"** en la esquina superior derecha
2. Completa el **nombre del contacto**
3. Agrega el **número de teléfono** (opcional)
4. Toca **"Agregar"** para guardar

#### ✏️ Editar Contacto
1. Toca el botón **lápiz** junto al contacto
2. **Confirma** la acción en la alerta
3. Modifica los datos en el formulario
4. Toca **"Guardar"** para actualizar

#### 🗑️ Eliminar Contacto
1. Toca el botón **basura** junto al contacto
2. **Confirma** la eliminación en la alerta
3. El contacto se elimina inmediatamente

### 🔄 Sincronización en Tiempo Real
- Los cambios se reflejan **instantáneamente** en todos los dispositivos
- **No requiere recarga** manual de datos
- **Conexión automática** al abrir la app

## 🎨 Diseño y UI

### 🎯 Características Visuales
- **Gradientes modernos** en fondos
- **Cards elevadas** para cada contacto
- **Iconos intuitivos** para acciones
- **Colores temáticos**: Azul para Firestore, Verde para Realtime
- **Animaciones suaves** para transiciones

### 📱 Componentes Reutilizables
- `AddFirestoreContactSheet` / `AddContactSheet`
- `EditFirestoreContactSheet` / `EditContactSheet`
- `FirestoreItemRow` / `RealtimeItemRow`
- `EmptyStateView`

## 🔍 Comparación de Bases de Datos

### 🔵 Firestore Database
- **Tipo**: Documento NoSQL
- **Estructura**: Colecciones → Documentos → Campos
- **Ventajas**: 
  - Consultas complejas
  - Escalabilidad automática
  - Offline support avanzado
- **Uso**: Ideal para aplicaciones complejas con relaciones de datos

### 🟢 Realtime Database
- **Tipo**: Base de datos JSON en tiempo real
- **Estructura**: Árbol JSON jerárquico
- **Ventajas**:
  - Sincronización ultra-rápida
  - Menor latencia
  - Más simple para datos simples
- **Uso**: Perfecto para datos en tiempo real como chats o colaboración

## 🐛 Debugging y Logs

La app incluye logs detallados para facilitar el debugging:

```
✅ Firestore: Added contact 'Juan Pérez'
📄 Firestore: Loaded 3 items
❌ Realtime Database Add Error: Permission denied
```

### 📊 Logs Disponibles
- **Operaciones exitosas**: ✅
- **Carga de datos**: 📄
- **Errores**: ❌
- **Advertencias**: ⚠️

## 🚀 Ejecutar el Proyecto

### Requisitos
- **Xcode 15+**
- **iOS 26.0+**
- **Cuenta de Firebase** configurada

### Pasos
1. **Clonar** o descargar el proyecto
2. **Abrir** `FirestoreDatabaseVSRealtimeDatabase.xcodeproj`
3. **Configurar** Firebase (ver sección de configuración)
4. **Seleccionar** simulador iOS
5. **Ejecutar** (⌘+R)

## 📚 Tecnologías Utilizadas

- **SwiftUI**: Framework de UI moderna de Apple
- **Firebase Firestore**: Base de datos NoSQL
- **Firebase Realtime Database**: Base de datos en tiempo real
- **Combine**: Framework para programación reactiva
- **MVVM**: Patrón de arquitectura
- **Swift Package Manager**: Gestión de dependencias

## 🤝 Contribuir

1. **Fork** el proyecto
2. **Crea** una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. **Push** a la rama (`git push origin feature/AmazingFeature`)
5. **Abre** un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👨‍💻 Autor

**Kevinho Morales**
- GitHub: [@kevinhomorales](https://github.com/kevinhomorales)

## 🙏 Agradecimientos

- **Firebase Team** por las excelentes herramientas
- **Apple** por SwiftUI y el ecosistema iOS
- **Comunidad Swift** por el apoyo continuo

---

### 📞 Contacto

¿Preguntas o sugerencias? ¡No dudes en contactarme!

**¡Disfruta explorando las diferencias entre Firestore y Realtime Database!** 🎉