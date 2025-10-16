# Script para detener SageMath Jupyter Lab
# Uso: .\stop-sage.ps1

Write-Host "🛑 Deteniendo SageMath Jupyter Lab..." -ForegroundColor Yellow

docker-compose down

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Contenedor detenido correctamente" -ForegroundColor Green
}
else {
    Write-Host "❌ Error al detener el contenedor" -ForegroundColor Red
}

# Mostrar estado
Write-Host ""
Write-Host "📊 Estado de contenedores Docker:" -ForegroundColor Cyan
docker ps -a --filter "name=sagemath-numtheory"