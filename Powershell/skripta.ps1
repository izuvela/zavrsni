function Test-Admin {
    $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(Test-Admin)) {
    echo "Morate pokrenuti skriptu kao admin!"
    exit
}

function prikaziGlavniMenu {
    clear
    echo "----------------"
    echo "1) Jedan"
    echo "2) Višestruko"
    echo "3) Kraj"
    echo "----------------"
}

function prikaziJedanMenu {
    echo "----------------"
    echo "1) Treće"
    echo "2) Natrag"
    echo "----------------"
}

function prikaziVisestrukoMenu {
    echo "----------------"
    echo "1) Četvrto"
    echo "2) Natrag"
    echo "----------------"
}

function jedanMenu {
    do{
    prikaziJedanMenu
    $opcija = Read-Host "Odaberi"
    switch($opcija){
        1 {
            echo "ovo je 3"
            
        }
        
    }
	}while($opcija -notin 2)
}

function visestrukoMenu {
    do{
    prikaziVisestrukoMenu
    $opcija = Read-Host "Odaberi"
    switch($opcija){
        1 {
            echo "ovo je 4"
            break
        }
        
    }
	}while($opcija -notin 2)
}

do{
    prikaziGlavniMenu
    $opcija = Read-Host "Odaberi"
    switch($opcija){
        1 {
            jedanMenu
        }
        2 {
            visestrukoMenu
        }

    }
}while($opcija -notin 3)



