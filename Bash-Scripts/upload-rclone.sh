#!/bin/bash

# This Script Will Take in 
# 1. A Directory to Be 7zipped and Uploaded
# 2. A SubDirectory WITHIN the first Directory to be 7zipped
# 3. A Directory to Back up This Zip In
# 4. A Password

# It Will Then 
# 7z the First Directory, Encrypting Using the Password, Copy It into Second Directory, and Upload It 
# To an Account of the User's Choice.

# BEFORE RUNNING, set the variables:
	# 'directoryToCompress'
	# 'directoryWhereStored'
	# 'SubDirectoryToCompress'
	# 'pass'
	# 'rcloneAccount'
	# 'rcloneDirectory'

# Initialize variables

	# This Is the Directory that will be Compressed 
	directoryToCompress='INITIALIZE THIS!' #'~/Personal/OneNote'

	# This Is the Directory that will be Compressed Twice, leave a trailing slash!, inherits from directoryToCompress!
	SubDirectoryToCompress=$directoryToCompress'INITIALIZE THIS!' #'0X ../P/J/'

	# This Will Be the Directory Where the 7z Archive Will Be Copied to (Perhaps to Be Backed up Physically Later)
	directoryWhereStored='INITIALIZE THIS!' #'~/Documents/_Other/OneNote/' 

	# This Is the Password That That the 7z Archive Will Be Compressed With
	pass='INITIALIZE THIS!' #''
	subPass='INITIALIZE THIS!' #''
	
	# This Is the Rclone Directory Where the 7z Archive Will Be Uploaded after Being Copied To "directoryWhereStored"
	rcloneAccount='INITIALIZE THIS!' #'accountPlaceHolder:'
	rcloneDirectory='INITIALIZE THIS!' #'/Save\ Files/00\ Notes'

# The Archive Name Is Set Here
prefix='OneNote_'
curdate=$(date '+%y.%m.%d')
archiveName=$prefix$curdate'.7z'
subArchiveName='JRL.7z'

# Compress the SubDirectory
zipsub='7z a "'$SubDirectoryToCompress$subArchiveName'" "'$SubDirectoryToCompress'*" -p'$subPass
eval $zipsub

# Delete files that were just compressed
del='rm "'$SubDirectoryToCompress'"*.txt'
eval $del

# 7z The File, Encrypted with the Password, Filenames Will Be Hidden
# Move The 7z To "directoryWhereStored"
zipthis='7z a '$directoryWhereStored$archiveName' '$directoryToCompress' -p'$pass' -mhe=on'
eval $zipthis

# Upload Using Rclone, Show Progress
rcloneUpload='rclone copy '$directoryWhereStored$archiveName' '$rcloneAccount$rcloneDirectory' -P'
eval $rcloneUpload

# Got to SubDir and uncompress, then delete the 7z file
unzip='7z x "'$SubDirectoryToCompress$subArchiveName'" -o"'$SubDirectoryToCompress'" -p'$subPass
eval $unzip
del2='rm "'$SubDirectoryToCompress'"*.7z'
eval $del2

echo --DONE--
