$cb = Get-Clipboard
# Write-Output $cb
# Write-Output $cb.Length
# Write-Output $cb.GetType()

function test-func {
    $p = $args[0].Replace('"', '')
    Write-Output $p
}

if($cb.GetType().Name -eq "Object[]") {
    foreach($a in $cb) {
        if($a.Length -ne 0) {
            test-func $a
        }
    }
} else {
    test-func $cb
}
