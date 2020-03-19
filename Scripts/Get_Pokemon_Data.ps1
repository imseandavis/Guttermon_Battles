# Pokemon Stealer
# Version 1.3
# By Sean Davis

#NOTES
#
# Thumbnail URL = "https://images.alexonsager.net/pokemon/1.png"
# Fused Image URL = "https://images.alexonsager.net/pokemon/fused/1/1.1.png" Pokemon1_ID/Pokemon1_ID.Pokemon2_ID.png
#
# HTML Element ID Tags
# Fused Name: pk_name
# Fused Image: pk_img
# Pokemon1 Image: pic1
# Pokemon2 Image: pic2
#
# $SiteInfo = Invoke-WebRequest -URI https://pokemon.alexonsager.net/1/1
# $Pokemon1Name = $SiteInfo.AllElements | where{$_.id -match "select1"}
# $Pokemon1Image = ($SiteInfo.AllElements | where{$_.id -match "pic1"}).src
# $Pokemon2Name = $SiteInfo.AllElements | where{$_.id -match "select2"}
# $Pokemon2Image = ($SiteInfo.AllElements | where{$_.id -match "pic2"}).src
# $FusionName = ($SiteInfo.AllElements | where{$_.id -match "pk_name"}).innerText
# $FusionImage = ($SiteInfo.AllElements | where{$_.id -match "pk_img"}).src


function Download-BasePokemon
{
	#Base Pokemon Images Will Be Saved As: Name.png
	#Example: Mew.png
	
	#Init Variables
	$PokemonID = 1
	$Max_Pokemon = 151	
	$PokemonImageFilePath = "C:\Pokemon_Images\Base_Pokemon"
	$PokemonImageBaseURL = "https://pokemon.alexonsager.net/"

	#Create Folder If It Doesn't Exist
	If (!(Test-Path $PokemonImageFilePath))
	{
		New-Item -Type Directory -Path $PokemonImageFilePath | Out-Null
	}
	
	#Loop Through Every Basic Pokemon And Download It's Image
	Do
	{	
		#Download Site Info For Each Pokemon
		$SiteInfo = Invoke-WebRequest -URI $($PokemonImageBaseURL + $PokemonID + "/" + $PokemonID)
		$PokemonName = (($SiteInfo.AllElements | where{$_.id -match "select1"}).outerhtml -split('OPTION')| Where {$_ -like "*selected value*"}).split(">")[1].split("<")[0]
		$Pokemon1ImageURL = ($SiteInfo.AllElements | where{$_.id -match "pic1"}).src

		Write-Host "Downloading Image For Pokemon: $PokemonID - $PokemonName"

		#Download The Image For Current Pokemon Fusion
		(New-Object System.Net.WebClient).DownloadFile("$Pokemon1ImageURL", $($PokemonImageFilePath + "\" + $PokemonID + "_" + $PokemonName + ".png"))
				
		Write-Host "Current Pokemon Downloaded: $Pokemon_Count"
		
		#Increment PokemonID By 1
		$PokemonID++
	}
	While ($PokemonID -lt $Max_Pokemon)
}

function Download-FusionPokemon
{
	# Init Variables
	$Pokemon1 = 1
	$Pokemon2 = 1
	$Pokemon_Count = 0
	$Max_Pokemon = 151
	$TotalPokemonFusions = 22801
	$PokemonImageFilePath = "C:\Pokemon_Images\Fusion_Pokemon"
	$PokemonFusionSiteBaseURL = "https://pokemon.alexonsager.net/"
	$PokemonImageBaseURL = "https://images.alexonsager.net/pokemon/fused/"

	#Notify User This Will Take An Hour or So
	Write-Warning "This may take up to a couple of hours depending on the speed of your internet."
	
	#Create Folder If It Doesn't Exist
	If (!(Test-Path $PokemonImageFilePath))
	{
		New-Item -Type Directory -Path $PokemonImageFilePath | Out-Null
	}

	#Loop Through Every Pokemon Fusion Combination And Download It's Image
	Do
	{
		#Download Site Info For Each Pokemon
		$SiteInfo = Invoke-WebRequest -URI $($PokemonFusionSiteBaseURL + $Pokemon1 + "/" + $Pokemon2)
		$FusionName = ($SiteInfo.AllElements | where{$_.id -match "pk_name"}).innerText
		$FusionImage = ($SiteInfo.AllElements | where{$_.id -match "pk_img"}).src

		Write-Host "Downloading Fusion Image For: $Pokemon1 and $Pokemon2 - $FusionName"
		
		#Download The Image For Current Pokemon Fusion
		(New-Object System.Net.WebClient).DownloadFile($($PokemonImageBaseURL + "$Pokemon1/$Pokemon1" + "." + $Pokemon2 + ".png"), $($PokemonImageFilePath + "\$Pokemon1" + "_" + $Pokemon2 + "_" + "$FusionName.png"))
		
		#Successfully Downloaded, Increment The Counter
		$Pokemon_Count++
		
		Write-Host "Current Pokemon Downloaded: $Pokemon_Count"
		
		#Increment The Pokemon
		If ($Pokemon2 -eq $Max_Pokemon)
		{
			$Pokemon2 = 0
			$Pokemon1++
		}
		
		#Increment Fusion Mate By 1
		$Pokemon2++
	}
	While ($Pokemon_Count -lt $TotalPokemonFusions)
}
