# !/bin/bash
echo "--------------------------"
echo "User Name: JihwanKim"
echo "Student Number: 12183475"
echo "[  MENU  ]"
echo "1. Get the data of the movie identified by a specific'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item’"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’"
echo "4. Delete the ‘IMDb URL’ from ‘u.item'"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 'user id'from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

stop="N"
until [ $stop = "Y" ]
do
	read -p "Enter your choice [ 1-9 ] " choice
	case $choice in
		1)	echo""
			read -p "Please enter 'movie id' (1~1682):" id
			echo""
			cat u.item | awk -v id=$id -F '|' '$1==id {print $0}'
			echo""
			;;			

		2) 	echo""
			read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" ans
			echo""
			if [ "$ans" = "y" ]
				then 
					 cat u.item | awk -F '|' '$7==1 {print $1" "$2}' | head
					 echo""
			fi
			;;

		3)	echo""
			sum=0
			read -p "Please enter 'movie id' (1~1682):" id
			echo""
			cat u.data | awk -v id=$id '$2==id {print $3}' | awk -v sum=$sum '{sum+=$1} END {print sum/NR}'
			echo""
			;;

		4) 	echo""
			read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" ans
			echo""
			if [ "$ans" = "y" ]
				then 
					 cat u.item | head | sed 's/http[^|]*//'
					 echo""
			fi
			;;

		5) 	echo""
			read -p "Do you want to get the data about users from 'u.user'?(y/n):" ans
			echo""
			if [ "$ans" = "y" ]
				then 
					 cat u.user | awk -F '|' '{print "user " $1 " is " $2 " years old " $3 " " $4 }' | head | sed -E 's/M/male/g' | sed -E 's/F/female/g'
					 echo""
			fi
			;;

		6)	echo""
			read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" ans
			echo""
			if [ "$ans" = "y" ]
				then
					cat u.item | tail | sed -e 's/Jan/01/' -e 's/Feb/02/' -e 's/Mar/03/' -e 's/Apr/04/' -e 's/May/05/' -e 's/Jun/06/' -e 's/Jul/07/' -e 's/Aug/08/' -e 's/Sep/09/' -e 's/Oct/10/' -e 's/Nov/11/' -e 's/Dec/12/' | sed 's/\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9]\{4\}\)/\3\2\1/g'
					echo""
			fi
			;;

		7)	echo""
			read -p "Please enter 'user id' (1~943):" id
			echo""
			cat u.data | awk -v id=$id '$1==id {print $2}' | sort -n | tr '\n' '|' | sed 's/|$//'
			cat u.data | awk -v id=$id '$1==id {print $2}' | sort -n  | head > tmp
			echo ""
			echo ""
			while read mid; do
				cat u.item | awk -F '|' -v mid=$mid '$1==mid {print $1 "|" $2}'
			done < tmp
			rm tmp
			echo""
			;;

		8)	echo""
			read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" ans
			echo""
			if [ "$ans" = "y" ]
				then
					# save the people's id who's matched with condition 
					cat u.user | awk -F '|' '$2>=20 && $2 <=29 && $4=="programmer" {print $1}' > tmp1
					# save the u.data's rows that has id on tmp1 file.
					while read id; do
						cat u.data | awk -v id=$id '$1==id {print $0}' >>tmp2
					done < tmp1
					#tmp2 file has a row of u.data which matched with condition
					#so we should get moive id list from tmp2, and delete the duplication
					cat tmp2 | awk '{print $2}' > tmp3
					sort -u -n tmp3 >tmp4 
					#tmp4 has a sorted, not duplicated list of movies matched with condiiton,
					#so wh should read tmp4 line by line and get rating on tmp2
					while read mid; do
						sum=0
						echo -n "$mid "
						cat tmp2 | awk -v mid=$mid '$2==mid {print $3}' | awk -v sum=$sum '{sum+=$1} END {print " " sum/NR}'
					done < tmp4
					rm tmp1 tmp2 tmp3 tmp4
					echo""
			fi
			;;

		9)	echo "Bye!"
			echo""
			stop="Y"
			;;

		*)	echo "Error: Invalid option..."
			;;
	esac
done

