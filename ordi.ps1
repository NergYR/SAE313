 $Domain = "butrt1salleH33.lan"

 # OU Paths
 $OU_Ordi_AC1 = "OU=Ordi-BUTRT_Ouest-AC1,OU=BUTRT_Ouest-AC1,DC=butrt1salleH33,DC=lan"
 $OU_Ordi_RT1 = "OU=Ordi-BUTRT_Ouest-RT1,OU=BUTRT_Ouest-RT1,DC=butrt1salleH33,DC=lan"
 $OU_Groups_AC1 = "OU=Groups-BUTRT_Ouest-AC1,OU=BUTRT_Ouest-AC1,DC=butrt1salleH33,DC=lan"
 $OU_Groups_RT1 = "OU=Groups-BUTRT_Ouest-RT1,OU=BUTRT_Ouest-RT1,DC=butrt1salleH33,DC=lan"

 # Liste des ordinateurs
 $Computers = @(
     @{N=4; Name="OrdiCompta"; OU=$OU_Ordi_AC1; Group="AC-GrO-Compta1"},
     @{N=2; Name="OrdiAdmin"; OU=$OU_Ordi_AC1; Group="AC-GrO-Admins1"},
     @{N=8; Name="OrdiOther"; OU=$OU_Ordi_AC1; Group="AC-GrO-Others1"},
     @{N=20; Name="H33-PC"; OU=$OU_Ordi_RT1; Group="RT-GrO-H331"},
     @{N=4; Name="RT-PC-Prof1"; OU=$OU_Ordi_RT1; Group="RT-GrO-Profs1"},
     @{N=6; Name="RT-PC-Prof2"; OU=$OU_Ordi_RT1; Group="RT-GrO-Profs1"}
 )

 # Boucle pour créer les comptes ordinateurs
 foreach ($Computer in $Computers) {
     for ($i = 1; $i -le $Computer.N; $i++) {
         $ComputerName = "$($Computer.Name)-$i"

         # Création du compte ordinateur
         try {
             New-ADComputer -Name $ComputerName `
                            -Path $Computer.OU `
                            -DNSHostName "$ComputerName.$Domain" `
                            -Enabled $true

             Write-Host "Ordinateur $ComputerName créé avec succès dans $($Computer.OU)."
         } catch {
             Write-Host "Erreur lors de la création de l'ordinateur $ComputerName : $_"
         }

         # Ajout de l'ordinateur au groupe
         try {
             Add-ADGroupMember -Identity $Computer.Group -Members $ComputerName$
             Write-Host "Ordinateur $ComputerName ajouté au groupe $($Computer.Group)."
         } catch {
             Write-Host "Erreur lors de l'ajout de $ComputerName au groupe $($Computer.Group) : $_"
         }
     }
 }
