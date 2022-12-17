$protocols = 'DoH', 'DoH3'

foreach ($p in $protocols){
    ./run.ps1 $p wd
}