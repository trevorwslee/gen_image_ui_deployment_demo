
while ($true) {
    # 1. Prompt the user for input
    $Response = Read-Host "Renew gen-image-ui Docker deployment. Do you want to continue? (Y/N)"

    # 2. Check the response (ignoring case)
    if ($Response -ieq 'Y') {
        Write-Host "Proceeding with the script..." -ForegroundColor Green
        break # Exits the while loop to continue the rest of the script
    }
    elseif ($Response -ieq 'N') {
        Write-Host "Exiting script as requested." -ForegroundColor Yellow
        Exit # Terminates the entire PowerShell script execution
    }
    else {
        # 3. Handle invalid input
        Write-Host "Invalid entry. Please type 'Y' or 'N' only." -ForegroundColor Red
    }
}

docker compose down
docker compose pull
docker compose up -d

docker image prune -f

docker compose logs -f


