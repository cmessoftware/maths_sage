# Script para ejecutar SageMath Jupyter Lab
# Autor: Script generado para facilitar el uso de SageMath con Jupyter Lab
# Puerto: 8809 (mapeado a 8888 interno del contenedor)

param(
    [switch]$Stop,
    [switch]$Restart,
    [switch]$Status,
    [switch]$Logs,
    [switch]$Shell
)

$ContainerName = "sagemath-numtheory"
$LocalPort = "8809"
$JupyterURL = "http://localhost:$LocalPort"

function Write-ColorOutput {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
}

function Test-DockerRunning {
    try {
        docker version | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Start-DockerDesktop {
    Write-ColorOutput "🐋 Iniciando Docker Desktop..." "Yellow"
    
    # Intentar iniciar Docker Desktop
    $dockerPath = "${env:ProgramFiles}\Docker\Docker\Docker Desktop.exe"
    if (Test-Path $dockerPath) {
        Start-Process $dockerPath
        Write-ColorOutput "⏳ Esperando a que Docker Desktop se inicie..." "Yellow"
        
        # Esperar hasta que Docker esté disponible (máximo 60 segundos)
        $timeout = 60
        $elapsed = 0
        while (-not (Test-DockerRunning) -and $elapsed -lt $timeout) {
            Start-Sleep -Seconds 2
            $elapsed += 2
            Write-Host "." -NoNewline
        }
        Write-Host ""
        
        if (Test-DockerRunning) {
            Write-ColorOutput "✅ Docker Desktop iniciado correctamente" "Green"
            return $true
        } else {
            Write-ColorOutput "❌ Error: Docker Desktop no pudo iniciarse en $timeout segundos" "Red"
            return $false
        }
    } else {
        Write-ColorOutput "❌ Error: Docker Desktop no encontrado en la ruta esperada" "Red"
        Write-ColorOutput "   Ruta buscada: $dockerPath" "Gray"
        return $false
    }
}

function Get-ContainerStatus {
    try {
        $status = docker ps -a --filter "name=$ContainerName" --format "{{.Status}}"
        if ($status) {
            return $status
        } else {
            return "Not found"
        }
    }
    catch {
        return "Error"
    }
}

function Show-Status {
    Write-ColorOutput "📊 Estado del contenedor SageMath:" "Cyan"
    Write-ColorOutput "   Nombre: $ContainerName" "White"
    Write-ColorOutput "   Puerto local: $LocalPort" "White"
    Write-ColorOutput "   URL: $JupyterURL" "White"
    
    $status = Get-ContainerStatus
    Write-ColorOutput "   Estado: $status" "White"
    
    if ($status -like "*Up*") {
        Write-ColorOutput "🌐 Jupyter Lab disponible en: $JupyterURL" "Green"
    }
}

function Stop-Container {
    Write-ColorOutput "🛑 Deteniendo contenedor $ContainerName..." "Yellow"
    docker stop $ContainerName
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✅ Contenedor detenido correctamente" "Green"
    } else {
        Write-ColorOutput "❌ Error al detener el contenedor" "Red"
    }
}

function Start-Container {
    Write-ColorOutput "🚀 Iniciando SageMath Jupyter Lab..." "Cyan"
    
    # Verificar si Docker está ejecutándose
    if (-not (Test-DockerRunning)) {
        Write-ColorOutput "⚠️  Docker no está ejecutándose" "Yellow"
        if (-not (Start-DockerDesktop)) {
            Write-ColorOutput "❌ No se puede continuar sin Docker" "Red"
            exit 1
        }
    }
    
    # Verificar el estado del contenedor
    $status = Get-ContainerStatus
    
    if ($status -eq "Not found") {
        Write-ColorOutput "📦 Creando y ejecutando nuevo contenedor..." "Yellow"
        docker-compose up -d
    } elseif ($status -like "*Exited*") {
        Write-ColorOutput "▶️  Iniciando contenedor existente..." "Yellow"
        docker start $ContainerName
    } elseif ($status -like "*Up*") {
        Write-ColorOutput "✅ El contenedor ya está ejecutándose" "Green"
    } else {
        Write-ColorOutput "❌ Estado del contenedor desconocido: $status" "Red"
        Write-ColorOutput "🔄 Intentando iniciar con docker-compose..." "Yellow"
        docker-compose up -d
    }
    
    if ($LASTEXITCODE -eq 0) {
        Start-Sleep -Seconds 3
        Write-ColorOutput "✅ SageMath Jupyter Lab iniciado correctamente" "Green"
        Write-ColorOutput "🌐 Accede a Jupyter Lab en: $JupyterURL" "Green"
        Write-ColorOutput "📁 Directorio de trabajo: ./work" "Gray"
        
        # Intentar abrir el navegador
        try {
            Start-Process $JupyterURL
            Write-ColorOutput "🌐 Abriendo navegador..." "Green"
        }
        catch {
            Write-ColorOutput "⚠️  No se pudo abrir el navegador automáticamente" "Yellow"
        }
    } else {
        Write-ColorOutput "❌ Error al iniciar el contenedor" "Red"
    }
}

function Show-Logs {
    Write-ColorOutput "📋 Mostrando logs del contenedor $ContainerName..." "Cyan"
    docker logs $ContainerName --tail 50 -f
}

function Enter-Shell {
    Write-ColorOutput "🐚 Accediendo al shell del contenedor $ContainerName..." "Cyan"
    Write-ColorOutput "   Usa 'exit' para salir del contenedor" "Gray"
    docker exec -it $ContainerName /bin/bash
}

# Función principal
function Main {
    Write-ColorOutput "🧮 SageMath Jupyter Lab Manager" "Magenta"
    Write-ColorOutput "================================" "Magenta"
    
    switch ($true) {
        $Status {
            Show-Status
            break
        }
        $Stop {
            Stop-Container
            break
        }
        $Restart {
            Stop-Container
            Start-Sleep -Seconds 2
            Start-Container
            break
        }
        $Logs {
            Show-Logs
            break
        }
        $Shell {
            Enter-Shell
            break
        }
        default {
            Start-Container
            Write-ColorOutput ""
            Write-ColorOutput "💡 Comandos disponibles:" "Cyan"
            Write-ColorOutput "   .\start-sagemath.ps1          # Iniciar Jupyter Lab" "Gray"
            Write-ColorOutput "   .\start-sagemath.ps1 -Stop    # Detener contenedor" "Gray"
            Write-ColorOutput "   .\start-sagemath.ps1 -Restart # Reiniciar contenedor" "Gray"
            Write-ColorOutput "   .\start-sagemath.ps1 -Status  # Ver estado" "Gray"
            Write-ColorOutput "   .\start-sagemath.ps1 -Logs    # Ver logs" "Gray"
            Write-ColorOutput "   .\start-sagemath.ps1 -Shell   # Acceder al shell" "Gray"
        }
    }
}

# Ejecutar función principal
Main