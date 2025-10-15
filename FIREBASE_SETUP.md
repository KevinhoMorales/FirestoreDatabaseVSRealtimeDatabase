# 🔥 Configuración de Firebase

## ⚠️ IMPORTANTE: Configuración Requerida

Para que la app funcione correctamente, necesitas configurar las reglas de seguridad en Firebase Console.

### 📍 **1. Firestore Database Rules**

Ve a [Firebase Console](https://console.firebase.google.com) → Tu Proyecto → Firestore Database → Rules

**Configura estas reglas:**
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

### 📍 **2. Realtime Database Rules**

Ve a [Firebase Console](https://console.firebase.google.com) → Tu Proyecto → Realtime Database → Rules

**Configura estas reglas:**
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

### 📍 **3. Habilitar Servicios**

En Firebase Console, asegúrate de que estén habilitados:

1. **Firestore Database**: 
   - Ve a Firestore Database → Crear base de datos
   - Selecciona "Modo de prueba" para desarrollo

2. **Realtime Database**: 
   - Ve a Realtime Database → Crear base de datos
   - Selecciona una ubicación (us-east1 recomendado)
   - Configura las reglas como se muestra arriba

### 🔧 **4. Verificar Configuración**

1. Descarga el `GoogleService-Info.plist` actualizado desde Firebase Console
2. Reemplaza el archivo en tu proyecto Xcode
3. Asegúrate de que el Bundle ID coincida con el de tu proyecto

### 🚀 **5. Probar la App**

Una vez configurado:
1. Ejecuta la app
2. Ve a la consola de Xcode para ver los logs
3. Intenta agregar elementos en ambas vistas
4. Verifica que aparezcan en Firebase Console

## 📝 **Logs Esperados**

Cuando funcione correctamente, verás en la consola:
- `📄 Firestore: Loaded X items`
- `📄 Realtime Database: Loaded X items`
- `✅ Firestore: Added item 'nombre'`
- `✅ Realtime Database: Added item 'nombre'`

Si hay errores, verás:
- `❌ Firestore Error: descripción del error`
- `❌ Realtime Database Error: descripción del error`

## 🆘 **Solución de Problemas**

### Error: "Permission denied"
- Verifica que las reglas de seguridad estén configuradas correctamente
- Asegúrate de que ambos servicios estén habilitados

### Error: "Network error"
- Verifica tu conexión a internet
- Asegúrate de que el `GoogleService-Info.plist` sea el correcto

### No aparecen datos
- Verifica que hayas publicado las reglas (botón "Publicar" en Firebase Console)
- Asegúrate de que el Bundle ID coincida exactamente
