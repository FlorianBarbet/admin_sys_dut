groupe=$1
nom=$2
echo "groupdel $groupe > /dev/null  2>&1 "
echo "userdel -r $nom > /dev/null 2>&1"
echo "addgroup $groupe > /dev/null"
echo "useradd -p $( mkpasswd $nom ) -m -G $groupe $nom > /dev/null"
