#!/bin/bash

menu1Func(){

dialog --menu ' JOURNAL : ' 30 40 5 1 'Create a new user'  2 "Login" 3 "Quit" 2> .answer
choice="$(cat .answer)"
}

menu2Func(){

	dialog --menu 'Journal : ' 40 40 5 1 'Create a new journal' 2 "Read your old memories" 3 "Edit your journal"  4 "Delete a journal" 5 "Exit" 2> .answer
	choice="$(cat .answer)"	
}


login(){

dialog --inputbox "Enter your username please..." 8 40 2>.answer
loginName="$(cat .answer)"

dialog --title "PASSWORD" --passwordbox "Enter your password please" 10 30 2> .answer

loginPass="$(cat .answer)"

rm .answer

echo $(grep -w $loginName .userinfo.txt)>.login.awk
awk '{ print $1 }' .login.awk>.returnName.txt
checkLoginName="$(cat .returnName.txt)"
awk '{ print $2 }' .login.awk>.returnPass.txt
checkPass="$(cat .returnPass.txt)"

rm .login.awk .returnName.txt .returnPass.txt
 

echo $loginPass | md5sum> .loginhashpass.txt
awk '{ print $1 }' .loginhashpass.txt>.loginpass.txt
loginPass="$(cat .loginpass.txt)"

rm .loginpass.txt .loginhashpass.txt


if ([ "$loginName" == "$checkLoginName" ] && [ "$loginPass" == "$checkPass" ]);
then
menu2Func
case $choice in
	1)

dialog --title "CALENDAR" --calendar "Please choose a date to create a journal" 0 0 16 5 2018 2>.date

awk -F"/" '{ print $1"."$2"."$3 }' .date>.ndate

ndate="$(cat .ndate)"
rm .date .ndate
cd .logs
cd ."$loginName"
vim $ndate

;;
2)  
	

	dialog --title 'INFO' --msgbox ' Please enter date of the journal that you want to read ' 20 50

       	dialog --title "CALENDAR" --calendar "Please choose a date to read a journal" 0 0 16 5 2018 2>.redate

	awk -F"/" '{ print $1"."$2"."$3 }' .redate>.rdate
	rdate="$(cat .rdate)"
	rm .redate .rdate
	cd .logs
	cd ."$loginName"
	#more $rdate
	
	#readlink -f $rdate

	dialog --title "READ" --textbox "$(readlink -f "$rdate")" 30 50
	
	;;
3)		


	dialog --title 'INFO' --msgbox ' Please enter date of the journal that you want to edit ' 20 50
	

       	dialog --title "CALENDAR" --calendar "Please choose a date to edit a journal" 0 0 16 5 2018 2>.eddate

	awk -F"/" '{ print $1"."$2"."$3 }' .eddate>.edate

	edate="$(cat .edate)"
	rm .edate .eddate
	cd .logs
	cd ."$loginName"
	vim $edate

	;;

4) 
		
	dialog --title 'INFO' --msgbox ' Please enter date of the journal that you want to delete ' 20 50

       	dialog --title "CALENDAR" --calendar "Please choose a date to edit a journal" 0 0 16 5 2018 2>.dedate

	awk -F"/" '{ print $1"."$2"."$3 }' .dedate>.ddate
	ddate="$(cat .ddate)"
	rm .dedate .ddate
	cd .logs
	cd ."$loginName"
	rm "$ddate"

	;;
*)
	exit;;
esac



else
	dialog --title "WARNING" --msgbox "Wrong Username or Password" 15 25
fi



# echo Girilen id $loginName eşleşmesi gereken id $checkLoginName girilen pass $loginPass eşleşmesi gereken $checkPass


}

#################################################################

Fusername(){

	dialog --inputbox "Enter your username please..." 8 40 2>.answer
	username="$(cat .answer)"

	echo $(grep -w $username .userinfo.txt)>.awk.awk
	awk '{ print $1 }' .awk.awk>.g.txt
       checkwith="$(cat .g.txt)"
	rm .g.txt .awk.awk
	
x=1
	while [ $x -eq 1 ] 
       	do

if [ "$username" == "$checkwith" ]
then
	dialog --title ' ERROR MESSAGE ' --msgbox ' THE USERNAME ALREADY EXIST' 7 33
Fusername
else

	Fpassword
	x=0
fi
	done

	
}

#################################################################

Fpassword(){

	dialog --title 'INFO' --msgbox 'You are goig to enter your password TWO TIMES \You are not going to be able to see characters of your password \PLEASE DO NOT PANIC :) ' 15 50

	dialog --title "PASSWORD" --passwordbox "Enter your password please" 10 30 2> .p1
	pass1="$(cat .p1)"


	dialog --title 'PASSWORD' --passwordbox "Re-Enter your password please" 10 30 2> .p2
	pass2="$(cat .p2)"

	rm .p1 .p2
#if [ "$pass1" != "$pass2" ]
#then

 while [ "$pass1" != "$pass2" ]

 do

	 dialog --title  ' ERROR ' --msgbox 'The entered passwords did not matched ' 10 20

         dialog --title "PASSWORD" --passwordbox "Enter your password please" 10 30 2> .p1
         pass1="$(cat .p1)"

	 dialog --title 'PASSWORD' --passwordbox "Re-Enter your password please" 10 30 2> .p2
	 pass2="$(cat .p2)"

rm .p1 .p2
	 
 done

 #else
 

 	echo $pass1|md5sum>.phash
	passHash="$(cat .phash)"
	rm .phash
	echo $username $passHash>>.userinfo.txt
	

        cd .logs
        mkdir ."$username"
	cd ..

  dialog --title 'INFO' --msgbox 'The user has been created successfully' 10 20
#fi


   dialog --title "LOGIN?" --yesno "Would you like to login ? " 20 50
respond=$?


case $respond in
	0)
 	login
		;;
	1) exit
		;;
	
esac  
}


####### MAIN ######


menu1Func

case $choice in
	1)

Fusername

		;;

	2)
		login
		;;
	3)
		exit
		;;
	*)
		exit;
	esac
