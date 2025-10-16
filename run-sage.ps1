# Script simple para ejecutar SageMath Jupyter Lab
# Uso: .\run-sage.ps1

Write-Host "🧮 Iniciando SageMath Jupyter Lab..." -ForegroundColor Cyan

# Verificar si Docker está ejecutándose
try {
    docker version | Out-Null
    Write-Host "✅ Docker está disponible" -ForegroundColor Green
}
catch {
    Write-Host "❌ Docker no está ejecutándose. Por favor, inicia Docker Desktop" -ForegroundColor Red
    Write-Host "   Presiona Enter después de iniciar Docker Desktop..."
    Read-Host
}

# Iniciar el contenedor
Write-Host "🚀 Ejecutando contenedor sagemath-numtheory..." -ForegroundColor Yellow
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ SageMath Jupyter Lab iniciado correctamente" -ForegroundColor Green
    Write-Host "🌐 Accede a: http://localhost:8809" -ForegroundColor Green
    Write-Host "📁 Directorio de trabajo: ./work" -ForegroundColor Gray
    
    # Abrir navegador
    Start-Sleep -Seconds 3
    try {
        Start-Process "http://localhost:8809"
        Write-Host "🌐 Abriendo navegador..." -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️  Copia y pega esta URL en tu navegador: http://localhost:8809" -ForegroundColor Yellow
    }
}
else {
    Write-Host "❌ Error al iniciar el contenedor" -ForegroundColor Red
}

Write-Host ""
Write-Host "Para detener el contenedor, ejecuta: docker-compose down" -ForegroundColor Gray