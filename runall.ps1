$protocols = 'DoH', 'Do53', 'DoT', 'DoH3'

foreach ($p in $protocols){
    ./run.ps1 $p wl
}