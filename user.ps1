 $Domain = "butrt1salleH33.lan"

 # OU Paths
 $OU_AC1 = "OU=Users-BUTRT_Ouest-AC1,OU=BUTRT_Ouest-AC1,DC=butrt1salleH33,DC=lan"
 $OU_RT1 = "OU=Users-BUTRT_Ouest-RT1,OU=BUTRT_Ouest-RT1,DC=butrt1salleH33,DC=lan"
 $OU_Groups_AC1 = "OU=Groups-BUTRT_Ouest-AC1,OU=BUTRT_Ouest-AC1,DC=butrt1salleH33,DC=lan"
 $OU_Groups_RT1 = "OU=Groups-BUTRT_Ouest-RT1,OU=BUTRT_Ouest-RT1,DC=butrt1salleH33,DC=lan"

 # Liste des utilisateurs
 $Users = @(
     @{N=4; FirstName="Alain"; LastName="Compta"; Group="AC-GrU-Compta1"; OU=$OU_AC1; GroupPath=$OU_Groups_AC1},
     @{N=2; FirstName="Bernard"; LastName="Admin"; Group="AC-GrU-Admins1"; OU=$OU_AC1; GroupPath=$OU_Groups_AC1},
     @{N=8; FirstName="Quentin"; LastName="Other"; Group="AC-GrU-Others1"; OU=$OU_AC1; GroupPath=$OU_Groups_AC1},
     @{N=15; FirstName="Mathis"; LastName="RT1-Etudiant"; Group="RT1-GrU-Etudiant1"; OU=$OU_RT1; GroupPath=$OU_Groups_RT1},
     @{N=10; FirstName="Justin"; LastName="RT2-Etudiant"; Group="RT2-GrU-Etudiant1"; OU=$OU_RT1; GroupPath=$OU_Groups_RT1},
     @{N=4; FirstName="Anna"; LastName="RT-Prof1"; Group="RT-GrU-Profs1"; OU=$OU_RT1; GroupPath=$OU_Groups_RT1},
     @{N=6; FirstName="Thomas"; LastName="RT-Prof2"; Group="RT-GrU-Profs1"; OU=$OU_RT1; GroupPath=$OU_Groups_RT1}
 )

 # Mot de passe par défaut pour tous les utilisateurs
 $DefaultPassword = ConvertTo-SecureString "Password123!" -AsPlainText -Force

 # Boucle pour créer les utilisateurs
 foreach ($User in $Users) {
     for ($i = 1; $i -le $User.N; $i++) {
         $FirstName = "$($User.FirstName)-$i"
         $LastName = "$($User.LastName)-$i"
         $SamAccountName = "$($User.FirstName)-$i"
         $DisplayName = "$FirstName $LastName"
         $UserPrincipalName = "$SamAccountName@$Domain"

         # Création de l'utilisateur
         try {
             New-ADUser -Name $DisplayName `
                        -GivenName $FirstName `
                        -Surname $LastName `
                        -SamAccountName $SamAccountName `
                        -UserPrincipalName $UserPrincipalName `
                        -Path $User.OU `
                        -AccountPassword $DefaultPassword `
                        -Enabled $true `
                        -ChangePasswordAtLogon $true

             Write-Host "Utilisateur $DisplayName créé avec succès."
         } catch {
             Write-Host "Erreur lors de la création de l'utilisateur $DisplayName : $_"
         }

         # Ajout de l'utilisateur au groupe
         try {
             Add-ADGroupMember -Identity $User.Group -Members $SamAccountName
             Write-Host "Utilisateur $DisplayName ajouté au groupe $($User.Group)."
         } catch {
             Write-Host "Erreur lors de l'ajout de $DisplayName au groupe $($User.Group) : $_"
         }
     }
 }
