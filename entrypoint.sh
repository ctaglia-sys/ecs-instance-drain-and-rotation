#!/bin/bash
echo "Copy the RO aws credentials and replace entries with prefix 'zinio'"
mkdir ~/.aws
cp -r ~/.temp_aws/* ~/.aws/
sed -i 's%\[zinio-%\[%g' ~/.aws/credentials
sed -i 's%source_profile = zinio-%source_profile = %g' ~/.aws/credentials
echo "Done"
/bin/bash