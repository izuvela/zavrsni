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
    echo "1) Pregled svih računa na računalu"
    echo "2) Kreiranje računa"
    echo "3) Ažuriranje računa"
    echo "4) Brisanje računa"
    echo "5) Natrag"
    echo "----------------"
}

function prikaziVisestrukoMenu {
    echo "----------------"
    echo "1) Odabir JSON-a"
    echo "2) Kreiranje korisnika iz JSON-a"
    echo "3) Brisanje korisnika iz JSON-a"
    echo "4) Natrag"
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
	}while($opcija -notin 5)
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
	}while($opcija -notin 4)
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



