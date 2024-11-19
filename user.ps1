 $Domain = "DC=butrt1salleH33,DC=lan"

 # Définir les données des utilisateurs
 $Users = @(
     @{ N = 4; Prenom = "Alain";  Nom = "Compta";  samAccountName = "Compta";  OU = "Users-AC1"; Group = "AC-GrU-Compta1" },
     @{ N = 2; Prenom = "Bernard"; Nom = "Admin";   samAccountName = "Admin";   OU = "Users-AC1"; Group = "AC-GrU-Admins1" },
     @{ N = 8; Prenom = "Quentin"; Nom = "Other";   samAccountName = "Other";   OU = "Users-AC1"; Group = "AC-GrU-Others1" },
     @{ N = 15; Prenom = "Mathis"; Nom = "RT1-Etudiant"; samAccountName = "RT1-Etudiant"; OU = "Users-RT1"; Group = "RT1-GrU-Etudiant1" },
     @{ N = 10; Prenom = "Justin"; Nom = "RT2-Etudiant"; samAccountName = "RT2-Etudiant"; OU = "Users-RT1"; Group = "RT2-GrU-Etudiant1" },
     @{ N = 4; Prenom = "Anna";   Nom = "RT-Prof1"; samAccountName = "RT-Prof1"; OU = "Users-RT1"; Group = "RT-GrU-Profs1" },
     @{ N = 6; Prenom = "Thomas"; Nom = "RT-Prof2"; samAccountName = "RT-Prof2"; OU = "Users-RT1"; Group = "RT-GrU-Profs1" }
 )

 # Parcourir chaque définition et créer les utilisateurs
 foreach ($User in $Users) {
     for ($i = 1; $i -le $User.N; $i++) {
         # Générer les propriétés utilisateur
         $FullName = "$($User.Prenom)-$i $($User.Nom)-$i"
         $SamAccountName = "$($User.samAccountName)-$i"
         $OUPath = "OU=$($User.OU),DC=butrt1salleH33,DC=lan"
         $GroupName = $User.Group

         try {
             # Créer l'utilisateur
             New-ADUser -Name $FullName `
                        -GivenName "$($User.Prenom)-$i" `
                        -Surname "$($User.Nom)-$i" `
                        -SamAccountName $SamAccountName `
                        -UserPrincipalName "$SamAccountName@$($Domain -replace 'DC=', '').$($Domain -replace 'DC=', '')" `
                        -Path $OUPath `
                        -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) `
                        -Enabled $true `
                        -ChangePasswordAtLogon $true `
                        -PasswordNeverExpires $false

             Write-Host "Utilisateur $FullName créé avec succès." -ForegroundColor Green

             # Ajouter l'utilisateur au groupe
             Add-ADGroupMember -Identity $GroupName -Members $SamAccountName
             Write-Host "Utilisateur $FullName ajouté au groupe $GroupName." -ForegroundColor Cyan
         }
         catch {
             Write-Host "Erreur lors de la création de $FullName ou ajout au groupe : $($_.Exception.Message)" -ForegroundColor Red
         }
     }
 }
