# Scripts de PowerShell para SageMath Jupyter Lab

Este directorio contiene scripts de PowerShell para facilitar la gestión del contenedor SageMath con Jupyter Lab.

## 📋 Scripts Disponibles

### 🚀 Scripts Principales

#### `run-sage.ps1` (Recomendado para uso básico)
Script simple para iniciar SageMath Jupyter Lab:
```powershell
.\run-sage.ps1
```

#### `stop-sage.ps1`
Script para detener el contenedor:
```powershell
.\stop-sage.ps1
```

#### `start-sagemath.ps1` (Script avanzado)
Script completo con múltiples opciones:
```powershell
# Iniciar Jupyter Lab
.\start-sagemath.ps1

# Ver estado del contenedor
.\start-sagemath.ps1 -Status

# Detener contenedor
.\start-sagemath.ps1 -Stop

# Reiniciar contenedor
.\start-sagemath.ps1 -Restart

# Ver logs del contenedor
.\start-sagemath.ps1 -Logs

# Acceder al shell del contenedor
.\start-sagemath.ps1 -Shell
```

## 🌐 Acceso a Jupyter Lab

Una vez iniciado el contenedor, Jupyter Lab estará disponible en:
- **URL:** http://localhost:8809
- **Directorio de trabajo:** `./work`
- **Sin contraseña:** El token está deshabilitado para facilitar el acceso

## 📁 Estructura del Proyecto

```
maths_sage/
├── docker-compose.yml      # Configuración de Docker
├── run-sage.ps1           # Script simple para iniciar
├── stop-sage.ps1          # Script para detener
├── start-sagemath.ps1     # Script avanzado con opciones
├── work/                  # Directorio de notebooks (montado en el contenedor)
└── jupyter/               # Configuración de Jupyter (montado en el contenedor)
```

## 🔧 Requisitos

- **Docker Desktop** instalado y ejecutándose
- **PowerShell** (incluido en Windows)
- Permisos para ejecutar scripts de PowerShell

## ⚙️ Configuración Inicial

Si es la primera vez que ejecutas scripts de PowerShell, puede que necesites habilitar la ejecución:

```powershell
# Ejecutar como administrador (una sola vez)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🐛 Solución de Problemas

### Docker no está ejecutándose
Si obtienes errores relacionados con Docker:
1. Inicia Docker Desktop manualmente
2. Espera a que aparezca el icono en la bandeja del sistema
3. Ejecuta el script nuevamente

### Puerto 8809 ocupado
Si el puerto está ocupado, puedes cambiar el puerto en `docker-compose.yml`:
```yaml
ports:
  - "127.0.0.1:NUEVO_PUERTO:8888"
```

### Contenedor no inicia
1. Verifica que Docker Desktop esté ejecutándose
2. Ejecuta: `docker-compose down` y luego `.\run-sage.ps1`
3. Revisa los logs: `.\start-sagemath.ps1 -Logs`

## 📚 Notebooks Incluidos

El directorio `work/` contiene varios notebooks de ejemplo:
- `aata_primes.ipynb` - Teoría de números y primos
- `sage_elementary_number_theory.ipynb` - Teoría elemental de números
- `sage_rings.ipynb` - Anillos en SageMath
- `sage_crt_avanzado.ipynb` - Teorema chino del resto avanzado

## 🤝 Contribuir

Para agregar nuevos notebooks o mejorar los scripts:
1. Coloca los notebooks en el directorio `work/`
2. Los cambios se reflejarán automáticamente en el contenedor

---

**Nota:** Los scripts manejan automáticamente el inicio de Docker Desktop si no está ejecutándose, pero es recomendable iniciarlo manualmente para un mejor control.