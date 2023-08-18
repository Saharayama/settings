while (1) {
    Start-Sleep -m 500
    if ($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -match $MAIN_WINDOW_TITLE })) {
        $wait_count++
        if ($wait_count -eq 20) {
            Write-Output "Timed out. Couldn't find the window."
            pause
            exit
        }
    }
    else {
        Start-Sleep -m 1000
        $hwnd = (Get-Process | Where-Object { $_.MainWindowTitle -match $MAIN_WINDOW_TITLE })[0].MainWindowHandle
        break
    }
}
