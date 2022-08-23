﻿function Test-Admin {
    $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(Test-Admin)) {
    echo "Morate pokrenuti skriptu kao admin!"
    exit
}

function sviRacuni {
    echo "Names and descriptions"
    Get-LocalUser | Format-Table -Property Name, Description -HideTableHeaders
}

function kreiranjeKorisnika {
    echo "-----Kreiranje korisnika-----"
    $username = Read-Host -Prompt "Korisničko ime"
    $password = Read-Host -Prompt "Lozinka" -AsSecureString
    $description = Read-Host -Prompt "Opis"

    if($description -eq ""){
        #New-LocalUser -Name "$username" -Password $password | Format-Table -Property Name -HideTableHeaders
        New-LocalUser -Name "$username" -Password $password | Out-Null

        if($?){
            echo "Korisnik $username kreiran bez opisa."
        } else {
            echo "Greška kod kreiranja korisnika."
        }
        Add-LocalGroupMember -Group "Administrators" -Member "$username"
        if($?){
            echo "Korisnik $username dodan kao admin."
        } else {
            echo "Greška kod dodavanja imena u grupu."
        }
    } else {
        New-LocalUser -Name "$username" -Password $password -Description "$description" | Out-Null
        if($?){
            echo "Korisnik $username kreiran."
        } else {
            echo "Greška kod kreiranja korisnika."
        }
        Add-LocalGroupMember -Group "Administrators" -Member "$username"
        if($?){
            echo "Korisnik $username dodan kao admin."
        } else {
            echo "Greška kod dodavanja imena u grupu."
        }
    }
}

function brisanjeKorisnika {
    echo "-----Brisanje korisnika-----"
    $username = Read-Host -Prompt "Korisničko ime"
    if($username -eq $env:USERNAME) {
        echo "Ne možete izbrisati trenutno korištenog korisnika!"
        break
    }
    Remove-LocalUser -Name "$username"
    if($?){
        echo "Korisnik $username je izbrisan."
    } else {
        echo "Greška kod brisanja. Pokušajte ponovno"
    }
}

function prikaziGlavniMenu {
    clear
    echo "Skripta za provođenje CRUD operacija nad jednim ili više korisničkih računa"
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
            sviRacuni
            break
        }
        2 {
            kreiranjeKorisnika
            break
        }
        4 {
            brisanjeKorisnika
            break
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



