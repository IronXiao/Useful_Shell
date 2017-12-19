# Useful_Shell
Useful shell that used to variant use

find_commit.sh
	
	find_commit.sh is a shell that used to find out specific repo commit to generate the patch and gather the source code that related to the commit.
	For example, my commit message usually start with 'PD#XYZ' which XYZ refers to the bug id ralated to a specific bug, this bug usually cause many 
git commits and pushes in different folders that use different git repository to manage of a repo repository, this shell make an easier way to find out
them ,just type command like the following and then enjoy!
     ./find_commit.sh PD#XYZ
		 
sign_apk.sh
  
	A shell script to sign a apk if you are lazy to tap a long long command,just type the following command and enjoy!
	./sign_apk.sh your_apk_full_path_name
     

