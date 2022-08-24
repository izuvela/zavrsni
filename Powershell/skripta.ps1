function Test-Admin {
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

function azuriranjeImena {
    echo "-----Ažuriranje imena-----"
    $oldUsername = Read-Host -Prompt "Staro korisničko ime"
    $newUsername = Read-Host -Prompt "Novo korisničko ime"
    Rename-LocalUser -Name "$oldUsername" -NewName "$newUsername"
    if($?){
        echo "Korisnik $oldUsername je preimenovan u $newUsername."
    } else {
        echo "Greška kod ažuriranja. Pokušajte ponovno"
    }
}

function azuriranjeLozinke {
    echo "-----Ažuriranje lozinke-----"
    $username = Read-Host "Korisničko ime"
    $password = Read-Host -AsSecureString -Prompt "Nova lozinka"
    Set-LocalUser -Name "$username" -Password $password
    if($?){
        echo "Korisniku $username je ažurirana lozinka."
    } else {
        echo "Greška kod ažuriranja. Pokušajte ponovno"
    }
    
}

function azuriranjeOpisa {
    echo "-----Ažuriranje opisa-----"
    $username = Read-Host "Korisničko ime"
    $description = Read-Host "Novi opis"
    Set-LocalUser -Name "$username" -Description $description
    if($?){
        echo "Korisniku $username je ažuriran opis."
    } else {
        echo "Greška kod ažuriranja. Pokušajte ponovno"
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

function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "JSON (*.json)| *.json"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.FileName
}

#Globalne varijable
$jsonFile = ""
$jsonData = "";
$validJson = $false

function ispravnostJson {
    try {
        $Global:jsonData = Get-Content -Path $Global:jsonFile -Raw | ConvertFrom-Json -ErrorAction Stop
        #$jsonData.users.username[0] | Format-Table -HideTableHeaders
        $users = $Global:jsonData.users | Format-Table -HideTableHeaders
        if ($users) {
            $Global:validJson = $true
        } 
    } catch {
        $Global:validJson = $false
    }
    
    if ($Global:validJson) {
        Write-Host "JSON uspješno učitan!";
    } else {
       echo "Neispravni JSON! Pokušajte ponovno."
       echo "Primjer ispravnog formata:"
       echo "{"
       echo "  'users': ["
       echo "      {"
       echo "         'username': '...',"
       echo "         'password': '...'"
       echo "      },"
       echo "        ..."
       echo "   ]"
       echo "}"
    }
 
}

function kreiranjeJsonKorisnika {
    echo "-----Kreiranje JSON korisnika-----"
    foreach ($user in $Global:jsonData.users) {
        $username = $user.username
        $password = ConvertTo-SecureString "$($user.password)" -AsPlainText -Force

        New-LocalUser -Name "$username" -Password $password | Out-Null
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

function prikaziAzurirajMenu {
    echo "-----Ažuriranje korisnika-----"    
    echo "1) Ime"
    echo "2) Lozinka"
    echo "3) Opis"
    echo "4) Natrag"
    echo "----------------"
}

function azurirajMenu {
    do{
    prikaziAzurirajMenu
    $opcija = Read-Host "Odaberi"
    switch($opcija){
        1 {
            azuriranjeImena
            break
        }
        2 {
            azuriranjeLozinke
            break
        }
        3 {
            azuriranjeOpisa
            break
        }
        
    }
	}while($opcija -notin 4)
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
        3 {
            azurirajMenu
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
            $Global:jsonFile = Get-FileName ".\"
            ispravnostJson
        }
        2 {
            kreiranjeJsonKorisnika
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



