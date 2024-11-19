 $Domain = "DC=butrt1salleH33,DC=lan"  # Remplacez par votre domaine.

 # Chemin LDAP de l'OU cible
 $OUPath_RTX = "OU=Groups-BUTRT_Ouest-RT1,OU=BUTRT_Ouest-RT1,$Domain"

 # Définir les groupes à créer
 $GroupsRTX = @(
     @{ Name = "RT-GrO-H331";       Description = "Ordinateurs de la salle TP H33";           Scope = "DomainLocal"; Type = "Security" },
     @{ Name = "RT-GrO-Profs1";     Description = "Ordinateurs des professeurs RT";          Scope = "DomainLocal"; Type = "Security" },
     @{ Name = "RT1-GrU-Etudiant1"; Description = "Utilisateurs Étudiants RT1";              Scope = "DomainLocal"; Type = "Security" },
     @{ Name = "RT2-GrU-Etudiant1"; Description = "Utilisateurs Étudiants RT2";              Scope = "DomainLocal"; Type = "Security" },
     @{ Name = "RT-GrU-Profs1";     Description = "Utilisateurs Professeurs RT";             Scope = "Global";      Type = "Security" }
 )

 # Créer les groupes
 foreach ($Group in $GroupsRTX) {
     try {
         # Créer le groupe
         New-ADGroup -Name $Group.Name `
                     -GroupScope $Group.Scope `
                     -GroupCategory $Group.Type `
                     -Description $Group.Description `
                     -Path $OUPath_RTX
         # Protéger contre la suppression accidentelle
         $GroupDN = "CN=$($Group.Name),$OUPath_RTX"
         Set-ADObject -Identity $GroupDN -ProtectedFromAccidentalDeletion $true
         Write-Host "Groupe $($Group.Name) créé avec succès."
     }
     catch {
         Write-Host "Erreur lors de la création du groupe $($Group.Name) : $($_.Exception.Message)" -ForegroundColor Red
     }
 }
