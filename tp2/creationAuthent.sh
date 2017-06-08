#!/bin/bash

tempfic="tmpAuthentCreat"
tmp="noms"
names=$(getent group info-n3p2 | cut -d : -f 4)
mygroup=$(getent passwd barbetf | cut -d : -f 1)
taille=$(getent group info-n3p2 | cut -d : -f 4 | tr ',' '\n'| wc -l) #getent group info-n3p2 | cut -d : -f 4 |  tr ',' ' '| wc -w donne la taille - 1
taille=$(($taille+1))

#Fichiers temporaires : clear au cas ou

if [ -e $tempfic ]
then
	rm -rf $tempfic
fi

if [ -e $tmp ]
then
	rm -rf $tmp
fi

#Fichiers temporaires

echo "$names">$tempfic



i=1

while [ $i -lt $taille ]
do 
	
	nom=$(cut -d , -f $i $tempfic ) #exemple : barbetf:*:1025:1005:Florian BARBET:/home/infoetu/barbetf:/bin/bash
	groupe=$(getent passwd $nom | cut -d / -f 3)
	echo $nom>$tmp
	suppr=$(grep '^[aeuioy].*' $tmp)
#	echo "--"$( getent group info-n3p2 | cut -d : -f 4 |  tr ',' '\n ' |grep $nom | grep '^[aeuioy].*')	

	./Creationnal.sh $groupe $nom | ssh root@192.168.194.31 "cat | bash" 
#   ssh root@192.168.194.31 "bash -s" -- < ./create2.sh $groupe $nom

#	====================================================================================
#	script : resume -> Creationnal.sh Ajouter 
#
# 	ssh root@192.168.194.31 groupdel $groupe > /dev/null  2>&1 
# 	ssh root@192.168.194.31	userdel -r $nom > /dev/null 2>&1
#	ssh root@192.168.194.31 addgroup $groupe > /dev/null 
#	ssh root@192.168.194.31 useradd -p $( mkpasswd $nom ) -m -G $groupe $nom > /dev/null #-m = creer un repertoire home ! 
#
#	script 
#	====================================================================================

	if [ $? = 0 ]
	then
		echo "Compte crée : $nom groupe : $groupe"
	fi
	
#	=======================================================
#
#	Bloque les utilisateurs qui ne sont pas de mon groupe !
#
#	=======================================================

	if [ $(echo $nom) != $(echo $mygroup) ]
	then
		ssh root@192.168.194.31 usermod -L $nom>/dev/null 2>&1
		if [ $? = 0 ]
		then 	
			echo "$nom est bloqué"
		fi
	fi

#	=====================================================================
#		
#	Suppression des utilisateurs ayant un login debutant avec une voyelle
#
#	=====================================================================
	if [ $(echo $suppr | wc -m ) -gt 1 ]
	then
#		echo $suppr"="$nom
		if [ $(echo "$suppr") = $(echo "$nom") ]
		then
			ssh root@192.168.194.31	userdel -r $nom > /dev/null 2>&1
			if [ $? = 0 ]
			then 	
				echo "$nom est supprimé"
			fi
		fi
	fi


	if [ -e $groupe ]
	then
		rm -rf infoetu
	fi

	i=$(($i+1))
done


if [ -e $tempfic ]
then
	rm -rf $tempfic
fi

if [ -e $tmp ]
then
	rm -rf $tmp
fi


