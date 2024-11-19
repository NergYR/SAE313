 $Domain = "DC=butrt1salleH33,DC=lan"  # Remplacez par le chemin LDAP de votre domaine.

 # Définir les OUs principales
 $TopLevelOUs = @("BUTRT_Ouest-AC1", "BUTRT_Ouest-RT1")

 # Sous-OUs pour chaque département
 $SubOUs = @("Users", "Ordi", "Groups")  # Les mêmes pour ACX et RTX

 # Créer les Top-Level OUs
 foreach ($TopLevelOU in $TopLevelOUs) {
     # Créer la Top-Level OU avec protection contre suppression
     New-ADOrganizationalUnit -Name $TopLevelOU -Path $Domain -ProtectedFromAccidentalDeletion $true

     # Créer les sous-OUs
     foreach ($SubOU in $SubOUs) {
         $FullPath = "OU=$TopLevelOU,$Domain"
         New-ADOrganizationalUnit -Name "$SubOU-$TopLevelOU" -Path $FullPath -ProtectedFromAccidentalDeletion $true
     }
 }

 # Afficher la structure créée
 Write-Host "Structure des OUs créée avec succès !"
