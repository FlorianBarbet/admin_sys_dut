groupe=$1
nom=$2
groupdel $groupe > /dev/null  2>&1
userdel -r $nom > /dev/null 2>&1
addgroup $groupe > /dev/null
useradd -p $( mkpasswd $nom ) -m -G $groupe $nom > /dev/null
