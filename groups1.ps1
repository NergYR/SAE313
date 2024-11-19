
 $Domain = "DC=butrt1salleH33,DC=lan"  # Remplacez par le chemin LDAP de votre domaine.

 # Emplacement des groupes dans l'OU Groups-ACX
 $OUPath_ACX = "OU=Groups-AC1,OU=BUTRT_Ouest-AC1,$Domain"

 # Définir les groupes à créer
 $Groups = @(
     @{ Name = "AC-GrO-Compta1";  Description = "Ordinateurs du personnel travaillant dans la comptabilité";       Scope = "DomainLocal"; Type = "Security" },
     @{ Name = "AC-GrO-Admins1";  Description = "Ordinateurs des administrateurs réseau";                          Scope = "DomainLocal"; Type = "Security" },
     @{ Name = "AC-GrO-Others1";  Description = "Ordinateurs des employés";                                       Scope = "DomainLocal"; Type = "Security" },
     @{ Name = "AC-GrU-Compta1";  Description = "Utilisateurs travaillant dans la comptabilité";                   Scope = "Global";      Type = "Security" },
     @{ Name = "AC-GrU-Admins1";  Description = "Utilisateurs administrateurs du réseau";                         Scope = "Global";      Type = "Security" },
     @{ Name = "AC-GrU-Others1";  Description = "Les autres employés";                                            Scope = "DomainLocal"; Type = "Security" }
 )

 # Boucle pour créer les groupes
 foreach ($Group in $Groups) {
     # Créer le groupe avec les propriétés définies
     New-ADGroup -Name $Group.Name `
                 -GroupScope $Group.Scope `
                 -GroupCategory $Group.Type `
                 -Description $Group.Description `
                 -Path $OUPath_ACX

     # Activer la protection contre la suppression accidentelle (après la création)
     $GroupDN = "CN=$($Group.Name),$OUPath_ACX"
     Set-ADObject -Identity $GroupDN -ProtectedFromAccidentalDeletion $true
 }

 # Afficher un message de confirmation
 Write-Host "Tous les groupes ont été créés avec succès dans l'OU Groups-AC1 et protégés contre la suppression accidentelle !"
