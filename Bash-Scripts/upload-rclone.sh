#!/bin/bash

# This Script Will Take in 
# 1. A Directory to Be 7zipped and Uploaded
# 2. A Directory to Back up This Zip In
# 3. A Password

# It Will Then 7z the First Directory, Encrypting Using the Password, Copy It into Second Directory, and Upload It 
# To an Account of the User's Choice.

# BEFORE RUNNING, set the variables:
	# 'directoryToCompress'
	# 'directoryWhereStored'
	# 'pass'
	# 'rcloneAccount'
	# 'rcloneDirectory'

# Initialize variables

	# This Is the Rclone Directory Where the 7z Archive Will Be Uploaded after Being Copied to 
	directoryToCompress= #'~/Personal/OneNote'

	# This Will Be the Directory Where the 7z Archive Will Be Copied to (Perhaps to Be Backed up Physically Later)
	directoryWhereStored= #'~/Documents/_Other/OneNote/' 

	# This Is the Password That That the 7z Archive Will Be Compressed With
	pass= #''
	
	# This Is the Rclone Directory Where the 7z Archive Will Be Uploaded after Being Copied To "directoryWhereStored"
	rcloneAccount= # 'accountPlaceHolder:'
	rcloneDirectory= #'/Save\ Files/00\ Notes'

# The Archive Name Is Set Here
prefix='OneNote_'
curdate=$(date '+%y.%m.%d')
archiveName=$prefix$curdate'.7z'

# 7z The File, Encrypted with the Password, Filenames Will Be Hidden
# Move The 7z To "directoryWhereStored"
zipthis='7z a '$directoryWhereStored$archiveName' '$directoryToCompress' -p'$pass' -mhe=on'
eval $zipthis

# Upload Using Rclone, Show Progress
rcloneUpload='rclone copy '$directoryWhereStored$archiveName' '$rcloneAccount$rcloneDirectory' -P'
eval $rcloneUpload

echo --DONE--
